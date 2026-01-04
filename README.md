# TOR ROUTER OTIMIZADO

Um script automatizado para **rotear TODO o tráfego da sua máquina pela rede Tor**, sem configurações manuais complexas.

> 🔐 Ideal para quem deseja privacidade adicional, com foco em simplicidade e automação.

---

## 🚀 CARACTERÍSTICAS

* ✅ **Roteamento completo** — todo o tráfego passa pela rede Tor
* ✅ **Otimizado** — configuração automatizada e rápida
* ✅ **Sem serviço** — roda como script, não como serviço do sistema
* ✅ **Fácil uso** — comandos simples: `tor-router` e `parar-tor-router`
* ✅ **Portátil** — execute de qualquer lugar no terminal
* ✅ **Baseado no projeto original** — Créditos: **Edu4rdSHL/tor-router**

---

## 📋 PRÉ-REQUISITOS

### 1️⃣ Sistema Operacional

* Debian **13 (trixie)** ou superior
* Ubuntu **22.04+** ou derivados
* Tor instalado (ou use o script de instalação incluído)

### 2️⃣ Dependências

* `tor` (daemon)
* `iptables`
* `curl` **ou** `wget`

---

## 🔧 INSTALAÇÃO RÁPIDA

### ▶️ Opção 1 — Instalação Completa (Recomendada)

```bash
# 1. Clone ou baixe os scripts
git clone https://github.com/seu-usuario/tor-router-otimizado.git
cd tor-router-otimizado

# 2. Torne os scripts executáveis
chmod +x instala_tor.sh tor-router parar-tor-router

# 3. Instale o Tor (se necessário)
sudo ./instala_tor.sh

# 4. Instale os scripts no sistema
sudo cp tor-router parar-tor-router /usr/local/bin/

# 5. Verifique a instalação
which tor-router
which parar-tor-router
```

### ▶️ Opção 2 — Instalação Manual

```bash
# 1. Instale o Tor primeiro (se necessário)
sudo chmod +x instala_tor.sh
sudo ./instala_tor.sh

# 2. Configure os scripts
sudo chmod +x tor-router parar-tor-router
sudo cp -r tor-router parar-tor-router /usr/local/bin/

# Alternativa: instalar no PATH global
sudo cp tor-router parar-tor-router /bin/
```

---

## 🎯 COMO USAR

### ➤ Iniciar o roteamento Tor

```bash
sudo tor-router
# ou
sudo ./tor-router
# ou (recomendado)
sudo tor-router --check
```

### ➤ Parar o roteamento

```bash
sudo parar-tor-router
# ou
sudo ./parar-tor-router
```

### ➤ Verificar status

```bash
curl --socks5 127.0.0.1:9050 https://check.torproject.org
curl --socks5 127.0.0.1:9050 https://ipinfo.io/ip
```

---

## ⚙️ O QUE O SCRIPT FAZ

Quando você executa **tor-router**, ele:

* Inicia o Tor (se necessário)
* Configura o `iptables` para rotear todo o tráfego
* Define DNS para usar Tor (porta **9053**)
* Bloqueia vazamentos de DNS
* Bloqueia tráfego fora do Tor
* Protege IPv6
* Aplica regras de entrada/saída seguras

Quando executa **parar-tor-router**, ele:

* Remove regras do firewall
* Restaura DNS original

---

## 🛠️ DEPURAÇÃO

### 1️⃣ Verificar Tor

```bash
sudo systemctl status tor
sudo journalctl -u tor -f
```

### 2️⃣ Sem conexão após ativar

```bash
sudo tor-router --test
sudo iptables -L -n -v
```

### Comandos úteis

```bash
netstat -tulpn | grep 9050
sudo iptables -S
tor-router --check-dns
parar-tor-router && curl https://ipinfo.io/ip
```

---

## 📁 ESTRUTURA DO PROJETO

```
tor-router-otimizado/
├── instala_tor.sh
├── tor-router
├── parar-tor-router
├── README.md
├── config/
│   ├── torrc.example
│   └── iptables-rules
└── logs/
```

---

## 🔄 RESTAURAR CONFIGURAÇÕES

```bash
sudo parar-tor-router
sudo rm /usr/local/bin/tor-router /usr/local/bin/parar-tor-router
sudo iptables-restore < ~/iptables-backup.bak

sudo rm /etc/resolv.conf
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```

---

## 🤝 CONTRIBUIÇÃO

* Abra issues
* Envie PRs
* Sugira melhorias
* Teste em novas distros

---

## 📝 CRÉDITOS & LICENÇA

* Baseado em: **Edu4rdSHL/tor-router**
* Adaptado para: **Debian 13/Ubuntu modernos**
* Licença: **MIT** (ver `LICENSE`)

---

## ⚠️ DISCLAIMER

> ESTE SOFTWARE É FORNECIDO “COMO ESTÁ”.
> O USO DO TOR **NÃO GARANTE ANONIMATO COMPLETO**.
> Use com responsabilidade e respeite as leis locais.
> **Não utilize para atividades ilegais.**

---

## 🌐 LINKS ÚTEIS

* Documentação oficial do Tor
* Projeto Tor original
* Guia de segurança Tor
* Teste de conexão Tor

---

## ⭐ DICA

Adicione aliases ao seu `~/.bashrc`:

```bash
alias tor-on='sudo tor-router'
alias tor-off='sudo parar-tor-router'
alias tor-check='curl --socks5 127.0.0.1:9050 https://check.torproject.org'
```

---

**Happy anonymous browsing! 🕵️‍♂️**

---

Se quiser, posso:

✔ transformar em inglês
✔ adaptar para GitHub Pages
✔ adicionar imagens e badges
✔ incluir seção de FAQ ou segurança avançada
