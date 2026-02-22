#!/bin/bash
# =============================================================================
# ddev-quickstart.sh
# Creates and starts a fresh Drupal training site with DDEV
# Usage: bash scripts/ddev-quickstart.sh
# =============================================================================

set -e

SITE_NAME="drupal-training-portal"
ADMIN_USER="admin"
ADMIN_PASS="Admin1234!"
SITE_LABEL="Drupal Training Portal"

echo ""
echo "=============================================="
echo "  Drupal Training Portal — DDEV Quick Start"
echo "=============================================="
echo ""

# Check dependencies
command -v ddev   >/dev/null 2>&1 || { echo "ERROR: ddev not found. See docs/01-beginner/02-install-ddev.md"; exit 1; }
command -v composer >/dev/null 2>&1 || { echo "ERROR: composer not found. Install from https://getcomposer.org"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "ERROR: docker not found. Install Docker Desktop first."; exit 1; }

echo "[1/5] Checking Docker is running..."
docker ps >/dev/null 2>&1 || { echo "ERROR: Docker is not running. Start Docker Desktop first."; exit 1; }
echo "      Docker OK"

echo ""
echo "[2/5] Starting DDEV..."
ddev start

echo ""
echo "[3/5] Installing Composer dependencies..."
ddev composer install

echo ""
echo "[4/5] Checking if Drupal is already installed..."
if ddev drush status --field=bootstrap 2>/dev/null | grep -q "Successful"; then
  echo "      Drupal already installed. Importing config and clearing cache..."
  ddev drush config:import -y 2>/dev/null || true
  ddev drush cr
else
  echo "      Installing Drupal..."
  ddev drush site:install standard \
    --db-url=mysql://db:db@db/db \
    --site-name="$SITE_LABEL" \
    --site-mail="admin@training.local" \
    --account-name="$ADMIN_USER" \
    --account-pass="$ADMIN_PASS" \
    --yes
  echo "      Importing configuration..."
  ddev drush config:import -y 2>/dev/null || echo "      (No config to import yet — this is expected on first run)"
  ddev drush cr
fi

echo ""
echo "[5/5] Done!"
echo ""
echo "  Site URL:   https://${SITE_NAME}.ddev.site"
echo "  Admin URL:  https://${SITE_NAME}.ddev.site/user/login"
echo "  Username:   ${ADMIN_USER}"
echo "  Password:   ${ADMIN_PASS}"
echo ""
echo "  Run 'ddev launch' to open the site in your browser."
echo "  Run 'ddev launch /admin' to open the admin panel."
echo ""
echo "  Next step: docs/01-beginner/04-drupal-admin-tour.md"
echo ""
