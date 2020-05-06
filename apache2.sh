#!/bin/bash

programa="apache2"
pacote=$(which "$programa")

pergunta(){
    echo "O que você deseja fazer? Instalar(i) e/ou Desistalar(d) e/ou Nada(n)"
    read pergunta    
    case "$pergunta" in
        i|i)
            echo "Ok. Instalando o programa($1)."
            sudo apt install $1 curl -y
            echo "Consedendo permissão de Rewrite ao $1"
            sudo a2enmod rewrite
            echo "Reiniciando o $1"
            sudo systemctl $1 restart
            sudo /etc/init.d/$1 restart
            echo "Alterando arquivos de configurações do $1"
            sudo sed -i 's/AllowOverride None/AllowOverride All/g' /etc/$1/$1.conf
            echo "Adicionando o caminho da pasta public_html dentro da pasta de usuário nas configurações do $1"

            caminho_pwd=$PWD
            # Filtrando resultado do Caminho do Usuário
            home=$(echo ${caminho_pwd} | tr "/" " " | awk '{print $1}')
            user=$(echo ${caminho_pwd} | tr "/" " " | awk '{print $2}')

            linha="<Directory /home/$user/servidor/public_html/>
                   Options Indexes FollowSymLinks
                   AllowOverride All
                   Require all granted
                   </Directory>"
            sudo echo "$linha" >> /etc/$1/$1.conf
            echo "Excluindo o arquivo 000-default.conf do $1"
            sudo rm -rf /etc/$1/sites-available/000-default.conf
            echo "<VirtualHost *:80>" >> /etc/$1/sites-available/000-default.conf
            echo "#ServerName www.exemplo.com" >> /etc/$1/sites-available/000-default.conf
            echo "#ServerAlias exemplo.com" >> /etc/$1/sites-available/000-default.conf
            echo "ServerAdmin webmaster@localhost" >> /etc/$1/sites-available/000-default.conf
            echo "DocumentRoot /home/$user/servidor/public_html" >> /etc/$1/sites-available/000-default.conf
            echo "ErrorLog /home/$user/servidor/logs/error.log" >> /etc/$1/sites-available/000-default.conf
            echo "Customlog /home/$user/servidor/logs/access.log combined" >> /etc/$1/sites-available/000-default.conf
            echo "</VirtualHost>" >> /etc/$1/sites-available/000-default.conf
            sudo systemctl apache2 reload
            sudo systemctl apache2 restart
            echo "Criando Pasta Servidor na pasta do Usuário($user)."

            verifyuser=$(grep -w ^$user /etc/passwd | cut -d: -f 1)

            if [ -z $verifyuser ];
            then
                echo "O usuário ($user) não existe!"
                echo "A pasta servidor não será criada!"
                exit
            else
                echo "Usuário ($user) existe. Continue...."
                echo "Adicionando o usuário ($user) ao grupo www-data"
                sudo usermod -a -G www-data $user
                sudo id $user
                sudo groups $user
                caminho=/home/$user/servidor
                echo "Verificando se a pasta servidor já existe."
                if [ ! -d "$caminho" ];
                then
                    echo "Pasta (servidor) não existe."
                    echo "Criando pasta (servidor)."
                    sudo mkdir /home/$user/servidor
                    echo "Criando pasta public_html dentro da pasta servidor"
                    sudo mkdir /home/$user/servidor/public_html
                    echo "Criando pasta logs dentro da pasta servidor"
                    sudo mkdir /home/$user/servidor/logs
                    echo "Mudando o dono da pasta do servidor"
                    sudo chown $user:www-data /home/$user/servidor -R
                    echo "Consedendo permissões a pasta servidor"
                    sudo chmod 755 /home/$user/servidor -R
                    sudo chmod 755 /home/$user/servidor/public_html -R
                    sudo chmod 755 /home/$user/servidor/logs -R
                    echo "Consedendo permissão a todas as pasta  e subpastas servidor"
                    sudo find /home/$user/servidor/ -type d -exec chmod -R 775 {} \;
                    echo "Consedendo permissão a todos os arquivos das pastas e subpastas do servidor"
                    sudo find /home/$user/servidor/ -type f -exec chmod -R 664 {} \;
                else
                    echo "O caminho da pasta 'servidor' já existe"
                    echo "Mudando o dono da pasta do servidor"
                    sudo chown $user:www-data /home/$user/servidor -R
                    echo "Consedendo permissões a pasta servidor"
                    sudo chmod 755 /home/$user/servidor -R
                    sudo chmod 755 /home/$user/servidor/public_html -R
                    sudo chmod 755 /home/$user/servidor/logs -R
                    echo "Consedendo permissão a todas as pasta  e subpastas servidor"
                    sudo find /home/$user/servidor/ -type d -exec chmod -R 775 {} \;
                    echo "Consedendo permissão a todos os arquivos das pastas e subpastas do servidor"
                    sudo find /home/$user/servidor/ -type f -exec chmod -R 664 {} \;
                fi ## End Verifica Caminho
            fi ## Fim Verifica Usuário
        ;;
        d|D)
            echo "Ok. Desistalando o programa($1)"
        ;;
        *)
            echo "OK. Nada será feito."
    esac

}

if [ -n "$pacote" ];
then
    echo "O programa ($programa) já está instalado."
    $pacote
    pergunta "$programa"
else
    echo "O programa ($programa) ainda não está instalado."
    $pacote
    pergunta "$programa"
fi