#!/bin/bash

programa="apache2"
pacote=$(dpkg -l | grep "$programa")

caminho_pwd=$PWD
# Filtrando resultado do Caminho do Usuário
home=$(echo ${caminho_pwd} | tr "/" " " | awk '{print $1}')
user=$(echo ${caminho_pwd} | tr "/" " " | awk '{print $2}')

if [ -n "$pacote" ]
then
    echo "O programa ($programa) já está instalado!"
    exit
else
    echo "O programa ($programa) ainda não está instalado!"
    echo "Instalando Programa!"
    sudo apt install apache2 curl -y
    echo "Consedendo permissão de Rewrite ao Apache2"    
    sudo a2enmod rewrite
    echo "Reiniciando o Apache2"
    sudo systemctl apache2 restart
    sudo /etc/init.d/apache2 restart
    echo "Aterando arquivos de Configuração do Apache2"
    sudo sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf
    echo "Adicionando Caminho da Pasta public_html dentro da Pasta de Usuário nas configurações do Apache2"
    linha="<Directory /home/$user/public_html/>
           Options Indexes FollowSymLinks
           AllowOverride All
           Require all granted
           </Directory>"
    
    caminho_pwd=$PWD
    # Filtrando resultado do Caminho do Usuário
    home=$(echo ${caminho_pwd} | tr "/" " " | awk '{print $1}')
    user=$(echo ${caminho_pwd} | tr "/" " " | awk '{print $2}')
        
    echo "$linha" >> /etc/apache2/apache2.conf
    echo "Excluindo o arquivo 000-default.conf do Apache2"
    sudo rm -rf /etc/apache2/sites-available/000-default.conf
    echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/000-default.conf
    echo "#ServerName www.exemplo.com" >> /etc/apache2/sites-available/000-default.conf
    echo "#ServerAlias exemplo.com" >> /etc/apache2/sites-available/000-default.conf
    echo "ServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/000-default.conf
    echo "DocumentRoot /home/$user/public_html" >> /etc/apache2/sites-available/000-default.conf
    echo "ErrorLog /home/$user/public_html/logs/error.log" >> /etc/apache2/sites-available/000-default.conf
    echo "Customlog /home/$user/public_html/logs/access.log combined" >> /etc/apache2/sites-available/000-default.conf
    echo "</VirtualHost>" >> /etc/apache2/sites-available/000-default.conf
    sudo systemctl apache2 reload
    sudo systemctl apache2 restart
    echo "Criando Pasta public_html na Pasta do Usuário"
    verificauser=$(grep -w ^$user /etc/passwd | cut -d: -f 1)
    if [ -z $verificauser ];
    then
        echo "O usuário ($user) não exite!"
        echo "Pasta public_html não criada!"
        exit
    else
        echo "Usuário Existe!Continuando...."
        caminho=/home/$user/public_html
        echo "Verificando a pasta public_html já existe"
        if [ ! -d "$caminho" ];
        then
            echo "Pasta não existe!"
            echo "Criando Pasta!"
            sudo mkdir /home/$user/public_html
            echo "Consedendo Permissões a public_html"
            sudo chmod 7777 /home/$user/public_html -R
            sudo chown $user:$user /home/$user/public_html -R
            echo "Criando Pasta de Logs"
            sudo mkdir /home/$user/public_html/logs
            echo "Consedendo Permissões a pasta de logs"
            sudo chmod 7777 /home/$user/public_html/logs -R
            sudo chown $user:$user /home/$user/public_html/logs -R
            echo "O caminho da Pasta 'public_html' foi criado com Sucesso!"
        else
            echo "O caminho da Pasta 'public_html' já existe"
            echo "Consedendo Permissões a public_html"
            sudo chmod 7777 /home/$user/public_html -R
            sudo chown $user:$user /home/$user/public_html -R
            echo "Criando Pasta de Logs"
            sudo mkdir /home/$user/public_html/logs
            echo "Consedendo Permissões a pasta de logs"
            sudo chmod 7777 /home/$user/public_html/logs -R
            sudo chown $user:$user /home/$user/public_html/logs -R
        fi
    fi
fi
