#!/bin/bash

echo "Instalando programas básicos"
echo "Os seguinte programas serão instalandos: unrar, gimp, vlc, inkscape, curl, filezilla, gdebi, gparted, ssh, audacity, net-tools, snapd"
sudo apt install -y unrar gimp vlc inkscape curl filezilla gdebi gparted git ssh audacity net-tools snapd
echo "Configurando o GIT"
sudo git config --global user.name "softlider"
sudo git config --global user.email "webmaster@softlider.com.br"
echo "Corrigindo possíveis problemas"
sudo apt install -f -y
echo "Executando limpeza de sistema"
sudo apt autoremove -y
sudo apt autoclean -y
echo "Programas básicos instalados."
