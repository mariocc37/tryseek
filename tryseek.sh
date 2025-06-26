#!/usr/bin/env bash

#===============================================================================================#
# Scanner simples e rápido para descobrir hosts ativos e serviços vulneráveis em uma sub-rede.  #
# Autor: Marioc37                                                                               #
#===============================================================================================#

# Argumentos
host="$(dig +short $1 | tail -n1 | cut -d '.' -f1-3)"
ic="$2"
icc="$3"
ho=$(dig +short $1 | tail -n1)
route=$(whois $ho | grep -iE "route:" | cut -d':' -f2 | xargs)
# TOP 24 PORTAS
declare -A portv=(
    [21]="ftp"            # login anônimo, senhas em texto puro
    [22]="ssh"            # alvo comum de força bruta
    [23]="telnet"         # inseguro, sem criptografia
    [25]="smtp"           # relay aberto, spam
    [53]="dns"            # DNS amplification, zone transfer
    [110]="pop"           # senhas em texto puro
    [135]="msrpc"         # ataques DCOM, Enum
    [139]="NetBios"       # enumeração, exploits SMBv1
    [143]="imap"          # credenciais fracas, texto puro
    [161]="SNMP"          # vazamento de dados, default community strings
    [445]="smb"           # exploits como EternalBlue, ransomware
    [993]="imaps"         # IMAP seguro, mas pode ter falhas de TLS
    [995]="pop3s"         # POP seguro, mas requer TLS forte
    [1433]="mssql"        # ataques via credenciais padrão ou SQL injection
    [2049]="NFS"          # vazamento de arquivos, exec remoto
    [3306]="mysql"        # bruteforce, vulnerabilidades RCE
    [3389]="rdp"          # alvo de ransomware, credenciais fracas
    [5432]="postgresql"   # senhas fracas, RCE
    [5900]="vnc"          # sem senha, acesso gráfico remoto inseguro
    [6379]="redis"        # sem autenticação, RCE via config maliciosa
    [700]="bbs"           # antigo, potencial RCE
    [8080]="http-alt"     # versões vulneráveis de Tomcat, etc
    [8443]="https-alt"    # painéis admin expostos
    [10000]="webmin"      # falhas RCE conhecidas
)

if [ "$1" == "" ]
then
        figlet -f standard "TRYSEEK"
        echo "Mode de uso:"
        echo "[$0] + IP/Dominio 10 (Numero de host a testar)"
else
        figlet -f standard "TRYSEEK"
        echo -e "\e[31mv.0.1 | use com responsabilidade! obrigado.\e[0m\n"
        ser=$(curl -s -I -w 1 -A $(shuf -n1 userAgent.txt) $1 | grep -iE "Server" | cut -d ':' -f2 | xargs)
        echo -e "[!] $1 > $route | $ser"
        echo -e "[!] Host $ic-$icc [Test]\n"


        for ((i_ip=$ic; i_ip<=$icc; i_ip++)); do
                res=$(ping -i 1 -c 1 -w 1 "$host.$i_ip" | grep "64 bytes" | cut -d ' ' -f4 | cut -d ':' -f1)
        if [ -n "$res" ]; then
                web=$(curl -s -I -w 1 -A $(shuf -n1 userAgent.txt) http://$res:80 | grep -iE "Server" | awk -F': ' '{print $2}' | tr -d '\r')

                # caso nao seja encontrado servidor web defina como vazio
                [ -z "$web" ] && web="\e[31m[Off: check]\e[0m"

                # verificar sevidor aberto em cada host ativo do ping
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
