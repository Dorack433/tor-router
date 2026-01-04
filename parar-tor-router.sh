#!/bin/bash
set -euo pipefail

echo
echo "Parando tor-router e restaurando firewall básico"
echo "Este script restaura configurações padrão de rede e Tor."
echo

# --- DESATIVAR NETWORKMANAGER (temporário) -------------------------

echo "Desativando rede temporariamente..."
sudo systemctl stop NetworkManager || true
sudo nmcli networking off || true
echo

# --- KERNEL / SYSCTL -----------------------------------------------

echo "Aplicando configurações seguras de kernel..."

sudo sysctl -w net.ipv4.ip_forward=0
sudo sysctl -w net.ipv4.tcp_syncookies=1
sudo sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
sudo sysctl -w net.ipv4.conf.all.forwarding=0
sudo sysctl -w net.ipv4.conf.all.log_martians=1
sudo sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
sudo sysctl -w net.ipv4.conf.all.rp_filter=1
sudo sysctl -w net.ipv4.conf.all.accept_redirects=0
sudo sysctl -w net.ipv4.conf.all.send_redirects=0
sudo sysctl -w net.ipv4.conf.all.accept_source_route=0
sudo sysctl -w net.ipv4.icmp_echo_ignore_all=1
echo

# --- RESET IPTABLES ------------------------------------------------

echo "Limpando regras existentes..."
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -F
sudo iptables -X

echo "Aplicando firewall básico..."
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -m state --state INVALID -j DROP
sudo iptables -A INPUT -m state --state NEW -j DROP
echo

# --- RESTAURAR TOR -------------------------------------------------

echo "Restaurando torrc original (se existir backup)..."
if [ -f /etc/tor/torrc.bak2 ]; then
    sudo cp -f /etc/tor/torrc.bak2 /etc/tor/torrc
    echo "torrc restaurado."
else
    echo "⚠️ Nenhum backup encontrado: /etc/tor/torrc.bak2"
fi

echo "Parando serviço Tor..."
sudo systemctl stop tor.service || true
echo

# --- REATIVAR REDE -------------------------------------------------

echo "Reativando rede..."
sudo nmcli networking on || true
sudo systemctl start NetworkManager || true
sudo systemctl enable NetworkManager || true
echo

# --- LISTAR REGRAS -------------------------------------------------

echo "############################ IPTABLES FILTER ############################"
sudo iptables -t filter -S
echo
echo "############################ IPTABLES NAT ###############################"
sudo iptables -t nat -S
echo
echo "############################ IPTABLES MANGLE ############################"
sudo iptables -t mangle -S
echo
echo "############################ IPTABLES RAW ###############################"
sudo iptables -t raw -S
echo
echo "FIM — tor-router parado e firewall restaurado."
