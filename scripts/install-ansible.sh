#!/bin/sh

# Hide warnings, we'll use aptitude instead of apt later
apt update -y 2>/dev/null | grep packages | cut -d '.' -f 1
apt install -y aptitude 2>/dev/null | grep packages | cut -d '.' -f 1

aptitude install -y bash python3 python3-pip
python3 -m pip install --upgrade pip wheel setuptools
# Disable rust due to https://github.com/pyca/cryptography/issues/5776
python3 -m pip install ansible==${ANSIBLE_VERSION}



