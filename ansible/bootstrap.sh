#!/usr/bin/env bash
set -e

PYTHON="python3.9"

sudo apt-get update -y
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install -y ${PYTHON} "${PYTHON}-distutils"
curl https://bootstrap.pypa.io/get-pip.py | ${PYTHON}
${PYTHON} -m pip install --upgrade pip setuptools wheel
${PYTHON} -m pip install -r /vagrant/requirements.txt
mkdir ~/bin && curl -fsSL https://goss.rocks/install | GOSS_VER=v0.3.6 GOSS_DST=~/bin sh
sudo cp /vagrant/ansible.cfg /etc/ansible.cfg
export PATH="~/bin:$PATH"
