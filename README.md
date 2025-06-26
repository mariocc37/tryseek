# tryseek v0.1
![image](https://github.com/user-attachments/assets/9262b088-4a02-445c-ae3c-41454814db94)

Scanner simples e rápido para descobrir hosts ativos e serviços vulneráveis em uma sub-rede.

## ⚙️ Funcionalidades

- Ping sweep (varredura de IPs ativos)
- Detecção de serviços comuns por porta
- Identificação basica de servidor web via HTTP header
- Whois da rota
- User-Agent aleatório (evita bloqueio simples)

## 📦 Requisitos

- `bash`
- `dig`, `whois`, `nc`, `figlet`, `curl`

##
## 🔧 INSTALAÇÃO

## 🐧 Linux (Debian, Kali, Ubuntu)
```
sudo apt update
sudo apt install -y dnsutils whois figlet curl
```
## 📱 Termux (Android)
```
pkg update && pkg upgrade -y
pkg install -y dnsutils whois figlet curl
```

## 🚀 Uso

```bash
./tryseek.sh dominio.com 1 10
```

## 📝 Exemplo

```bash
./tryseek.sh exemplo.com 1 10
```

## 📁 Arquivo `userAgent.txt`

Mais de 300 user-agents, por exemplo:

```
Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.94 Chrome/37.0.2062.94 Safari/537.36
Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36
Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko
Mozilla/5.0 (Windows NT 6.1; WOW64; rv:40.0) Gecko/20100101 Firefox/40.0
Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/600.8.9 (KHTML, like Gecko) Version/8.0.8 Safari/600.8.9
Mozilla/5.0 (iPad; CPU OS 8_4_1 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12H321 Safari/600.1.4
```

## ⚠️ Aviso

Esta ferramenta é apenas para fins educacionais e de testes em ambientes autorizados.
**Use com responsabilidade!**
