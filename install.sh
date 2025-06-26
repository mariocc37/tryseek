#!/bin/bash

echo "Iniciando instalação das dependências..."

# Lista de pacotes necessários
packages=(dig whois netcat figlet curl)

# Atualiza os repositórios
sudo apt update

# Instala os pacotes
for pkg in "${packages[@]}"; do
    echo "Instalando: $pkg"
    sudo apt install -y "$pkg"
done

echo "Instalação concluída!"