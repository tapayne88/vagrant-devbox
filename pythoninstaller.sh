#!/bin/bash

echo "Running Python 2.7.5 installer"

VAGRANT_HOME=/home/vagrant

sudo apt-get update
sudo apt-get -y install libsqlite3-dev zlib1g-dev libncurses5-dev libgdbm-dev libbz2-dev libreadline5-dev libssl-dev libdb-dev

cd $VAGRANT_HOME

curl -kLO http://www.python.org/ftp/python/2.7.5/Python-2.7.5.tgz
tar -xzf Python-2.7.5.tgz
cd Python-2.7.5

./configure --with-pydebug
make -j2
sudo make install
