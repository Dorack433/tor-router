#!/bin/bash
set -euo pipefail

# INÍCIO INSTALAÇÃO TOR HIDDEN SERVICE ORIGINAL DO TOR PROJECT
# Versão adaptada para Debian 13 (trixie)

echo "=================================================================="
echo "INSTALAÇÃO TOR - TOR PROJECT OFICIAL"
echo "Adaptado para Debian 13 (trixie)"
echo "Versão Original: $(lsb_release -ds 2>/dev/null || echo 'desconhecida')"
echo "=================================================================="
echo ""
echo "ATENÇÃO: Este script instalará o Tor dos repositórios oficiais do Tor Project"
echo "Visite https://support.torproject.org/apt/ para verificar atualizações"
echo ""
read -p "Pressione Enter para continuar ou Ctrl+C para cancelar..."

# Checar se lsb_release existe
if ! command -v lsb_release >/dev/null; then
    echo "Instalando lsb-release..."
    sudo apt update
    sudo apt install -y lsb-release
fi

DEBIAN_VERSION=$(lsb_release -c | awk '{print $2}')
if [ "$DEBIAN_VERSION" != "trixie" ]; then
    echo "⚠️  AVISO: Este sistema parece ser '$DEBIAN_VERSION', não 'trixie'"
    read -p "Continuar mesmo assim? (s/N): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Ss]$ ]] || exit 1
fi

echo ""
echo "📦 Instalando dependências iniciais..."
sudo apt update
sudo apt install -y apt-transport-https curl gnupg ca-certificates

echo ""
echo "🔑 Adicionando repositório do Tor Project..."
sudo mkdir -p /usr/share/keyrings

if [ ! -f /usr/share/keyrings/tor-archive-keyring.gpg ]; then
    echo "Baixando chave GPG do Tor Project..."
    curl -fsSL https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc \
        | sudo gpg --dearmor -o /usr/share/keyrings/tor-archive-keyring.gpg
    sudo chmod 644 /usr/share/keyrings/tor-archive-keyring.gpg
else
    echo "✔️  Chave já existe — pulando download."
fi

echo ""
echo "📝 Configurando repositório..."
sudo tee /etc/apt/sources.list.d/tor.list >/dev/null <<EOF
deb [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org trixie main
deb-src [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org trixie main
EOF

echo ""
echo "🔄 Atualizando pacotes..."
sudo apt update

echo ""
echo "⬇️  Instalando Tor..."
sudo apt install -y tor deb.torproject.org-keyring tor-geoipdb torsocks nyx

echo ""
echo "📁 Criando backup de /etc/tor..."
sudo cp -r /etc/tor "/etc/tor.backup.$(date +%Y%m%d_%H%M%S)"

echo ""
echo "📋 Status do serviço Tor:"
if ! sudo systemctl status tor --no-pager -l; then
    echo "⚠️  O serviço pode não ter iniciado ainda. Verifique logs com:"
    echo "    sudo journalctl -u tor -xe"
fi

echo ""
echo "🔧 Configuração principal: /etc/tor/torrc"
echo "Para hidden services:"
echo "   sudo nano /etc/tor/torrc"
echo ""
echo "Comandos úteis:"
echo "  sudo systemctl start tor"
echo "  sudo systemctl stop tor"
echo "  sudo systemctl restart tor"
echo "  sudo systemctl enable tor"
echo "  nyx  # monitorar"
echo ""
echo "⚠️  IMPORTANTE:"
echo "1. Faça backup do torrc antes de alterar"
echo "2. Guia oficial: https://community.torproject.org/onion-services/"
echo "3. Logs: journalctl -u tor"
echo "=================================================================="
