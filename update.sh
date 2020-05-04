#!/bin/bash

echo "Iniciando a atualização da lista de pacotes dos programas!"
sudo apt update -y
echo "Lista de Pacote de programas obtida."
echo "Inciando o Download e Instalação dos pacotes para atualização dos programas!"
sudo apt upgrade -y
echo "Download e Instalação dos pacotes dos programas concluido."
echo "Iniciando a atualização do Sistema"
sudo apt dist-upgrade -y
echo "Atualização do sistema concluída."
echo "Corrigindo possíveis problemas e erros na atualização."
sudo apt install -f
echo "Correções efetuadas."
echo "Removendo pacotes que não são mais necessários."
sudo apt autoremove -y
sudo apt autoclean -y
echo "É recomendavel reiniciar o sistema para as atualizações obterem efeito."
echo -n "Você deseja reiniciar o sistema? [s/n] "
read resposta
case "$resposta" in
    s|S)
        echo "Ok. Reiniciando o Sistema Agora...."
        sudo reboot
    ;;
    n|N)
        echo "Ok. O sistema não será reiniciado..."
    ;;
    *)
        echo "OK. Nada feito..."
esac