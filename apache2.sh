#!/bin/bash

programa="apache2"
pacote=$(which "$programa")

function pergunta(){
    echo "O que você deseja fazer? Instalar(i) e/ou Desistalar(d) e/ou Nada(n)"
    read pergunta    
    case "$pergunta" in
        i|i)
            echo "Ok. Instalando o programa($1)."
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
    which "$pacote"
    pergunta() "$programa"
else
    echo "O programa ($programa) ainda não está instalado."
    pergunta() "$programa"
fi