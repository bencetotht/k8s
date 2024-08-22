#!/bin/bash

INSTALL_CUDA=true
INSTALL_CONDA=false

# base packages
sudo apt update && sudo apt install vim btop python3.12 python3.12-venv git -y

# setting up CUDA
cd /tmp && wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.44-1_amd64.deb && sudo dpkg -i cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
sudo apt update && sudo apt install cuda -y

# python env
mkdir -p ~/code && cd ~/code && python3 -m venv .venv
source .venv/bin/activate
pip3 install numpy pandas matplotlib scikit-learn tensorflow keras torch nltk