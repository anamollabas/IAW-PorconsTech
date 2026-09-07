#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f .env ]]; then
  echo "❌ No s'ha trobat el fitxer .env"
  exit 1
fi

# shellcheck disable=SC1091
source .env

echo "▶ Actualitzant paquets..."
sudo apt update

echo "▶ Instal·lant Apache, PHP, MySQL Client i utilitats..."
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
  apache2 \
  php \
  libapache2-mod-php \
  php-mysql \
  mysql-client \
  git \
  netcat-openbsd

echo "▶ Activant Apache..."
sudo systemctl enable --now apache2

echo "▶ Comprovant Apache i PHP..."
sudo systemctl is-active --quiet apache2
php -v | head -n 1

echo "✅ Frontend preparat."
