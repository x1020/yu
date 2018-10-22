#!/bin/bash
# Instalando PPA no Ubuntu
sudo add-apt-repository ppa:yubico/stable
sudo apt-get update
sudo apt-get install libpam-u2f pamu2fcfg gedit -y

clear

echo "Criando a pasta na sua HOME"
mkdir ~/.config/Yubico

echo ""

echo "Jogando sua chave dentro da pasta criada,
Por Favor, Coloque o dedo na chave"
pamu2fcfg > ~/.config/Yubico/u2f_keys

echo ""

echo "Inserindo o PAM dentro do diretorio/arquivo"
sudo sed -i 's/@include common-auth/& \nauth       required   pam_u2f.so/' /etc/pam.d/sudo

sudo sed -i 's/@include common-auth/& \nauth       required   pam_u2f.so debug debug_file=\/var\/log\/pam_u2f.log/' /etc/pam.d/lightdm

################################################

sudo touch /var/log/pam_u2f.log

sudo touch /etc/udev/rules.d/80-yubilock.rules
sudo chmod 666 /etc/udev/rules.d/80-yubilock.rules
sudo echo "ACTION==\"remove\", ATTRS{idVendor}==\"1050\", RUN+=\"/bin/loginctl lock-sessions\"" > /etc/udev/rules.d/80-yubilock.rules

sudo chmod 644 /etc/udev/rules.d/80-yubilock.rules

sudo udevadm control --reload

echo "Reinicie o Sistema"
