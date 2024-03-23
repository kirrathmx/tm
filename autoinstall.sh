#!/bin/sh
echo '\tUPDATING'
sudo apt update && sudo apt install -y git 1> /dev/null 2> /dev/null

echo '\n--------------------------------------'
echo '\tCLONING'
echo '--------------------------------------\n'
cd /etc/VpsPackdir/
git clone https://github.com/kirrathmx/tm; cd /etc/VpsPackdir/tm 1> /dev/null 2> /dev/null

sudo chmod ugo+x install.sh && sudo chmod ugo+x socks_install.sh && sudo chmod ugo+x set_AD_TAG.sh 1> /dev/null 2> /dev/null

echo '\n--------------------------------------'
echo '\tCONFIGURE MTPROXY'
echo '--------------------------------------\n'

./install.sh
