#!/bin/sh
ABSOLUTE_FILENAME=`readlink -e "$0"`
DIRECTORY=`dirname "$ABSOLUTE_FILENAME"`
IP=`wget -qO- digitalresistance.dog/myIp`
INSTALL_ROOT="/opt/tgsocksproxy"
gitlink="https://github.com/alexbers/tgsocksproxy.git"
LOGIN=$1
PASSWORD=$2

finish() {
cd $DIRECTORY
echo "SOCKS " > check_file.cfg
echo "¡La instalación de SOCKS5 se completó con éxito! Tu enlace de conexión:\nhttps://t.me/socks?server=${IP}&port=1080&user=${LOGIN}&pass=${PASSWORD}"
}

generate() {
if [ -n "$LOGIN" ]
then
LOGIN=$LOGIN
else
LOGIN=`tr -dc A-Za-z0-9 < /dev/urandom | head -c 5 | xargs`
fi

if [ -n "$PASSWORD" ]
then
PASSWORD=$PASSWORD
else
PASSWORD=`tr -dc A-Za-z0-9 < /dev/urandom | head -c 7 | xargs`
fi
}

install() {
echo =========================================================================================================================================================================================
echo ==========START INSTALLING PROXY====================START INSTALLING PROXY====================START INSTALLING PROXY=====================================================================
echo =========================================================================================================================================================================================
generate

CONFIG="PORT = 1080\nUSERS = {\"${LOGIN}\": \"${PASSWORD}\"}"

writing(){
cd $INSTALL_ROOT
rm config.py
echo "$CONFIG" > config.py
}

#SOCKS5 setup
cd /opt
sudo mkdir $INSTALL_ROOT
sudo chown $USER $INSTALL_ROOT
git clone $gitlink
writing
sudo cp $DIRECTORY/SOCKS5.service /etc/systemd/system/
sudo systemctl daemon-reload && sudo systemctl restart SOCKS5.service && sudo systemctl enable SOCKS5.service
finish
}

preinstall() {
#downloading
sudo apt-get update -y
sudo apt-get -y install htop git
install
}

checkinstallation() {
if [ -e $DIRECTORY/check_file.cfg ]; then
if grep -q "SOCKS" check_file.cfg; then
echo "SOCKS5 ya está instalado en su servidor. Instalación cancelada (para restablecer los datos de instalación, ingrese el comando: rm check_file.cfg)"
exit 1
else
if grep -q "MTProxy" check_file.cfg; then
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
