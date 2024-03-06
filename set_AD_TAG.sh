#!/bin/sh

AD_TAG=$1

cd /opt/mtprotoproxy

if [ -n "$AD_TAG" ]; then

AD_TAG=$AD_TAG; else

echo "Error! No ingresaste AD_TAG (./set_AD_TAG.sh <AD_TAG>)"

exit 1

fi

CONFIG=`cat /opt/mtprotoproxy/config.py`

TRUE_CONFIG="${CONFIG}\nAD_TAG = \"${AD_TAG}\""

if [ -z `echo $AD_TAG | grep -x '[[:xdigit:]]\{32\}'` ]; then

    echo "AD_TAG debe ser una clave de 32 caracteres que contenga solo caracteres HEX"

	exit 1
else

sudo echo "$TRUE_CONFIG" > config.py
sudo systemctl restart MTProxy.service
fi
