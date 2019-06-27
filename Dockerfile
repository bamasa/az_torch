FROM nvidia/cuda:9.0-base-ubuntu16.04
MAINTAINER Vladislav Belavin <belavin@phystech.edu>

# basic setup
# SHELL ["/bin/bash", "-c"]

# update
RUN apt-get -y update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    apt-get -y update && \
    apt-get install -y --no-install-recommends --allow-change-held-packages apt-utils curl \
    bzip2 gcc git wget g++ build-essential libc6-dev make pkg-config \
    libcudnn7 libnccl2 libnccl-dev && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN curl -O https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /root/miniconda && rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH /root/miniconda/bin:$PATH

RUN conda update -n base conda && pip install --upgrade pip && conda install python=3.6 && \
    conda config --add channels conda-forge && \
    conda install -y pip numpy scipy jupyter matplotlib tqdm pandas tqdm psutil Cython numpy pyyaml setuptools cmake cffi typing && \
    conda install torchvision cudatoolkit=9.0 pytorch -c pytorch && \
    conda clean --all -y && \
    rm -rf ~/.cache/pip

ADD torch_mnist.py /
ENTRYPOINT python torch_mnist.py
