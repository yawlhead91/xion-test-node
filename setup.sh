#/bin/bash
##
sudo apt-get update
sudo apt-get -y upgrade

#install docker 
apt install docker.io

# install go 1:19
wget https://dl.google.com/go/go1.19.linux-amd64.tar.gz
sudo tar -xvf go1.19.linux-amd64.tar.gz
sudo mv go /usr/local

echo "GOROOT=/usr/local/go" >> ~/.profile
echo "GOPATH=$HOME/go" >> ~/.profile
echo "PATH=$GOPATH/bin:$GOROOT/bin:$PATH" >> ~/.profile
source ~/.profile

mkdir -p $GOPATH/src/github.com/burnt-labs
cd $GOPATH/src/github.com/burnt-labs

# clone repo 
git clone https://github.com/burnt-labs/xion.git
# make binary
cd xion && make install

xiond version
