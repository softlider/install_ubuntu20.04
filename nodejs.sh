#!/bin/bash

echo "Adicionando repositório do nodejs"
sudo curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
echo "Instalando nodejs lts"
sudo apt install -y nodejs
echo "Verificando a versão do nodejs"
sudo node -v
echo "Verificando a versão do npm"
sudo npm -v
echo "Verificando a versão do npx"
sudo npx -v