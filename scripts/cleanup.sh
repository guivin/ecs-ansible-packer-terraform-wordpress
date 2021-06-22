#!/bin/sh

/usr/bin/yes | python3 -m pip uninstall ansible
aptitude remove -y python3-pip
