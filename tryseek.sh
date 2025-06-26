#!/usr/bin/env bash

# Scanner simples e rápido para descobrir hosts ativos e serviços vulneráveis em uma sub-rede.
# Autor: Marioc37

# ========== Detecta sistema e define comando de instalação ==========
if command -v pkg &>/dev/null; then
    INSTALADOR="pkg install -y"
    SISTEMA="Termux"
elif command -v apt &>/dev/null; then
    INSTALADOR="sudo apt install -y"
    SISTEMA="Kali/Ubuntu"
else
    echo "[✘] Sistema não suportado."
    exit 1
fi

echo "[*] Ambiente detectado: $SISTEMA"
echo "[*] Verificando dependências..."

# ========== Lista de dependências ==========
dependencias=(dig whois curl figlet nc)

# ========== Verifica e instala ==========
for cmd in "${dependencias[@]}"; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "[!] $cmd não encontrado. Instalando..."
        $INSTALADOR "$cmd"
    else
        echo "[✔] $cmd encontrado."
    fi
done

clear
# Argumentos
host="$(dig +short $1 | tail -n1 | cut -d '.' -f1-3)"
ic="$2"
icc="$3"
ho=$(dig +short $1 | tail -n1)
route=$(whois $ho | grep -iE "route:" | cut -d':' -f2 | xargs)

# portas a testar
declare -A portv=(
    [21]="ftp"
    [22]="ssh"
    [23]="telnet"
    [25]="smtp"
    [53]="dns"
    [110]="pop"
    [135]="msrpc"
    [139]="NetBios"
    [143]="imap"
    [161]="SNMP"
    [445]="smb"
    [993]="imaps"
    [995]="pop3s"
    [1433]="mssql"
    [2049]="NFS"
    [3306]="mysql"
    [3389]="rdp"
    [5432]="postgresql"
    [5900]="vnc"
    [6379]="redis"
    [700]="bbs"
    [8080]="http-alt"
    [8443]="https-alt"
    [10000]="webmin"
)

if [ "$1" == "" ]
then
    figlet -f standard "TRYSEEK"
    echo "Modo de uso:"
    echo "[$0] + IP/Dominio 10 (Numero de host a testar)"
else
    figlet -f standard "TRYSEEK"
    echo -e "\e[31mv.0.1 | use com responsabilidade! obrigado.\e[0m\n"
    ser=$(curl -s -I -w 1 -A "$(shuf -n1 userAgent.txt)" $1 | grep -iE "Server" | cut -d ':' -f2 | xargs)
    echo -e "[!] $1 > $route | $ser"
    echo -e "[!] Host $ic-$icc [Test]\n"

    for ((i_ip=$ic; i_ip<=$icc; i_ip++)); do
        res=$(ping -i 1 -c 1 -w 1 "$host.$i_ip" | grep "64 bytes" | cut -d ' ' -f4 | cut -d ':' -f1)
        if [ -n "$res" ]; then
            web=$(curl -s -I -w 1 -A "$(shuf -n1 userAgent.txt)" http://$res:80 | grep -iE "Server" | awk -F': ' '{print $2}' | tr -d '\r')
            [ -z "$web" ] && web="\e[31m[Off: check]\e[0m"
            port="21 22 23 25 53 110 135 139 143 161 445 993 995 1433 2049 3306 3389 5432 5900 6379 700 8080 8443 10000"
            for ports in $port; do
                res_nc=$(nc -z -v -w 1 $res $ports 2>&1 | grep -i "open")
                if [ -n "$res_nc" ]; then
                    nome_servico=${portv[$ports]:-"unknown"}
                    echo -e "[+] $res > $web\e[31m:\e[0m $ports ($nome_servico) [ON]"
                fi
            done
        fi
    done
fi
