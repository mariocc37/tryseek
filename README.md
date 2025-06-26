# TrySeek v0.1

Scanner simples e rápido para descobrir hosts ativos e serviços vulneráveis em uma sub-rede.

## ⚙️ Funcionalidades

- Ping sweep (varredura de IPs ativos)
- Detecção de serviços comuns por porta
- Identificação básica de servidor web via HTTP header
- Whois da rota
- User-Agent aleatório (evita bloqueio simples)

## 📦 Requisitos

- `bash`
- `dig`, `whois`, `nc`, `figlet`, `curl`

## 🐧 Linux (Debian, Kali, Ubuntu)
```
sudo apt update
sudo apt install -y dnsutils whois netcat figlet curl
```
## 📱 Termux (Android)
```
pkg update
pkg install -y dnsutils whois netcat figlet curl
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

Inclua alguns user-agents, por exemplo:

```
Mozilla/5.0 (Windows NT 10.0; Win64; x64)
Mozilla/5.0 (Linux; Android 10; SM-G975F)
curl/7.68.0
```

## ⚠️ Aviso

Esta ferramenta é apenas para fins educacionais e de testes em ambientes autorizados.
**Use com responsabilidade!**
