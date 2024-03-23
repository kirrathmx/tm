#!/bin/sh

sudo apt update && sudo apt install -y git

echo '\n--------------------------------------'
echo '\tCLONING'
echo '--------------------------------------\n'
cd /etc/VpsPackdir/
git clone https://github.com/kirrathmx/tm; cd /etc/VpsPackdir/tm

sudo chmod ugo+x install.sh && sudo chmod ugo+x socks_install.sh && sudo chmod ugo+x set_AD_TAG.sh

echo '\n--------------------------------------'
echo '\tCONFIGURE MTPROXY'
echo '--------------------------------------\n'

./install.sh
