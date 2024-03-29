#!/bin/sh

ABSOLUTE_FILENAME=`readlink -e "$0"`
DIRECTORY=`dirname "$ABSOLUTE_FILENAME"`
IP=`wget -qO- ipv4.icanhazip.com`
INSTALL_ROOT="/opt/mtprotoproxy"
gitlink="https://github.com/alexbers/mtprotoproxy.git"
SECRET=$1

finish() {
cd $DIRECTORY

echo "MTProxy " > check_file.cfg

echo "\n¡La instalación de MTProxy se completó con éxito! Tu enlace de conexión:\nhttps://t.me/proxy?server=${IP}&port=1443&secret=dd${SECRET}\n"

exit 0
}

generate() {

if [ -n "$SECRET" ]; then

SECRET=$SECRET; else

SECRET=`head -c 16 /dev/urandom | xxd -ps`

fi

if [ -z `echo $SECRET | grep -x '[[:xdigit:]]\{32\}'` ]; then

    echo "El secreto debe ser una clave de 32 caracteres que contenga únicamente caracteres HEX."

exit 1

fi
} 

install() {

echo ====================================================================================
echo ==START INSTALLING MTPROXY=====START INSTALLING MTPROXY=====START INSTALLING MTPROXY
echo ====================================================================================

generate

CONFIG="PORT = 1443\nUSERS = {\"tg\":  \"${SECRET}\"}"

writing(){

cd $INSTALL_ROOT

rm config.py

echo "$CONFIG" > config.py
}

#MTProxy setup
cd /opt

sudo mkdir $INSTALL_ROOT

sudo chown $USER $INSTALL_ROOT

git clone -b master $gitlink

writing

sudo cp $DIRECTORY/MTProxy.service /etc/systemd/system/

sudo systemctl daemon-reload && sudo systemctl restart MTProxy.service && sudo systemctl enable MTProxy.service

finish
}

preinstall() {
sudo apt-get update -y

sudo apt-get -y install htop git

install
}

checkinstallation() {
if [ -e $DIRECTORY/check_file.cfg ]; then
if grep -q "MTProxy" check_file.cfg; then
echo "MTProxy ya está instalado en su servidor. Instalación cancelada (para restablecer los datos de instalación, ingrese el comando: rm check_file.cfg)"

exit 1
else
if grep -q "SOCKS" check_file.cfg; then
install
else
preinstall
fi
fi
else
preinstall
fi
}

checkinstallation
