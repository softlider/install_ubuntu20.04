#!/bin/bash

programa="mariadb-server mariadb-client"
pacote=$(which "$programa")

pergunta(){
    echo "O que você deseja fazer? Instalar(i) e/ou Desistalar(d) e/ou Nada(n) "
    read pergunta    
    case "$pergunta" in
        i|I)
            echo "Ok. Instalando o programa($1)."
            sudo apt install -y software-properties-common $1
            echo "Executando o arquivo de configuração do $1"
            sudo mysql_secure_installation
        ;;
        d|D)
            echo "Ok. Desistalando o programa($1)"
            sudo apt remove --purge $1 -y
            echo "removendo pasta do mysql"
            sudo rm -rf /etc/mysql
            sudo rm -rf /usr/bin/mysql
            sudo rm -rf /usr/bin/mariadb
            echo "Removendo pacotes não utilizados mais."
            sudo apt autoremove -y
            sudo apt autoclean -y
            which mysql mariadb $1
        ;;
        *)
            echo "OK. Nada será feito."
    esac ## Fim do case pergunta
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