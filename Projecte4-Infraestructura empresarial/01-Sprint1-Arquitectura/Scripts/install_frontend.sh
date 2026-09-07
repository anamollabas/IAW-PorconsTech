#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f .env ]]; then
  echo "❌ No s'ha trobat el fitxer .env"
  exit 1
fi

source .env

WORKDIR="/home/ubuntu/iaw-practica-lamp"
WEBROOT="/var/www/html"

echo "▶ Descarregant l'aplicació..."
rm -rf "$WORKDIR"
git clone --depth 1 "$APP_REPO" "$WORKDIR"

if [[ ! -f "$WORKDIR/src/config.php" ]]; then
  echo "❌ No s'ha trobat src/config.php."
  exit 1
fi

echo "▶ Desplegant src/ en Apache..."
sudo rm -f "$WEBROOT/index.html"
sudo cp -a "$WORKDIR/src/." "$WEBROOT/"

CONFIG="$WEBROOT/config.php"

echo "▶ Configurant la connexió amb la BD..."
sudo sed -i -E \
  "s|define\\('DB_HOST',[[:space:]]*'[^']*'\\);|define('DB_HOST', '${DB_PRIVATE_IP}');|" \
  "$CONFIG"
sudo sed -i -E \
  "s|define\\('DB_NAME',[[:space:]]*'[^']*'\\);|define('DB_NAME', '${DB_NAME}');|" \
  "$CONFIG"
sudo sed -i -E \
  "s|define\\('DB_USER',[[:space:]]*'[^']*'\\);|define('DB_USER', '${DB_USER}');|" \
  "$CONFIG"
sudo sed -i -E \
  "s|define\\('DB_PASSWORD',[[:space:]]*'[^']*'\\);|define('DB_PASSWORD', '${DB_PASSWORD}');|" \
  "$CONFIG"

echo "▶ Ajustant propietari i permisos..."
sudo chown -R ubuntu:www-data "$WEBROOT"
sudo find "$WEBROOT" -type d -exec chmod 775 {} \;
sudo find "$WEBROOT" -type f -exec chmod 664 {} \;

echo "▶ Comprovant sintaxi de config.php..."
php -l "$CONFIG"

echo "✅ Aplicació desplegada."
echo "Obri en el navegador: http://IP_PUBLICA_WEB"
