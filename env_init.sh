#/bin/sh

# install dependencies for building iproute2
sudo apt update
DEBIAN_FRONTEND=noninteractive sudo apt upgrade -y
sudo apt install -y bison flex clang gcc llvm libelf-dev bc libssl-dev tmux trace-cmd

# update iproute2
sudo apt install -y pkg-config bison flex make gcc
cd /tmp
wget https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.5.0.tar.gz
tar -xzvf ./iproute2-5.5.0.tar.gz
cd ./iproute2-5.5.0

sudo make && sudo make install

cd ..

# P4 all (cf. https://p4.org/p4/getting-started-with-p4.html)
# P4 complier(cf. https://github.com/p4lang/p4c/blob/master/README.md)
## prepare
sudo apt-get install -y cmake g++ git automake libtool libgc-dev bison flex \
libfl-dev libgmp-dev libboost-dev libboost-iostreams-dev \
libboost-graph-dev llvm pkg-config python python-scapy python-ipaddr python-ply python3-pip tcpdump \
build-essential autoconf libtool curl git

wget https://dl.google.com/go/go1.14.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.14.linux-amd64.tar.gz
echo "export PATH=\$PATH:/usr/local/go/bin" >> /home/vagrant/.bashrc
echo "export GOPATH=\$HOME/go" >> /home/vagrant/.bashrc
echo "export PATH=\$PATH:\$GOPATH/bin" >> /home/vagrant/.bashrc

export PATH=$PATH:/usr/local/go/bin

git clone https://github.com/grpc/grpc.git
cd grpc
git checkout tags/v1.17.2
git submodule update --init

cd third_party/protobuf/
./autogen.sh
./configure
make -j4
sudo make install
sudo ldconfig
cd ../..
# mkdir -p cmake/build
# cd cmake/build
# cmake ../..
make -j4
sudo make install
sudo ldconfig

## build&install
git clone --recursive https://github.com/p4lang/p4c.git
cd p4c
mkdir build
cd build
cmake ..
make -j4
make -j4 check
sudo make install

# PI
sudo apt install -y libjudy-dev libreadline-dev valgrind libtool-bin libboost-dev libboost-system-dev libboost-thread-dev
git clone https://github.com/p4lang/PI.git
cd PI
git submodule update --init
./autogen.sh
./configure --with-proto --without-internal-rpc --without-cli --without-bmv2
sudo make -j4
sudo make install

# P4 runtime (cf. https://github.com/p4lang/behavioral-model)
git clone https://github.com/p4lang/behavioral-model.git
cd behavioral-model/
./install_deps.sh
./autogen.sh
./configure --with-pi 
make -j4
sudo make install
sudo ldconfig

## SimpleSwitchGrpc
cd targets/simple_switch_grpc
./autogen.sh
./configure --with-thrift
make -j4
sudo make install
sudo ldconfig