# docker run -i -t -p 8888:8888 continuumio/anaconda3 /bin/bash -c "/opt/conda/bin/conda install jupyter -y --quiet && mkdir /opt/notebooks && /opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser"
FROM continuumio/miniconda3
RUN apt update
RUN apt upgrade -y

# basic system libs
RUN apt install -y procps
RUN apt install -y git
RUN apt install -y vim
RUN apt install -y nano

# network tools
RUN apt install -y net-tools
RUN apt install -y iputils-ping
RUN apt install -y wget
RUN apt install -y curl
RUN apt install -y netcat
RUN apt install -y telnet

# update conda
RUN conda update conda -y
RUN conda install -c conda-forge scipy -y
RUN conda install -c conda-forge matplotlib -y
RUN conda install -c conda-forge numpy -y

# install jupyter
RUN conda install -c conda-forge jupyter -y
RUN conda install -c conda-forge jupyterlab -y

# update all packages
RUN conda update -c conda-forge --all -y

# configure user env
WORKDIR /root
RUN mkdir scripts
RUN echo "jupyter notebook --notebook-dir=/root/notebooks --ip='*' --port=8888 --no-browser --allow-root" > ./scripts/run_notebook
RUN echo "jupyter lab --notebook-dir=/root/notebooks --ip='*' --port=8888 --no-browser --allow-root" > ./scripts/run_lab
RUN chmod 777 ./scripts/run_notebook
RUN chmod 777 ./scripts/run_lab
RUN mkdir notebooks
RUN echo "export PATH=\$PATH:/root/scripts/" >> .bashrc
RUN echo "alias ll='ls -la'" >> .bashrc