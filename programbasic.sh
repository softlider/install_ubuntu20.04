#!/bin/bash

echo "Instalando programas básicos"
echo "Os seguinte programas serão instalandos: unrar, gimp, vlc, inkscape, curl, filezilla, gdebi, gparted, ssh, audacity, net-tools"
sudo apt install -y unrar gimp vlc inkscape curl filezilla gdebi gparted git ssh audacity net-tools 
echo "Corrigindo possíveis problemas"
sudo apt install -f -y
echo "Executando limpeza de sistema"
sudo apt autoremove -y
sudo apt autoclean -y
echo "Programas básicos instalados."
