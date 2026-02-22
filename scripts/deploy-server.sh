#!/bin/bash
# =============================================================================
# deploy-server.sh
# Run this script ON the production server (GoDaddy, AWS, or GCP)
# after a git pull to apply all changes.
# Usage: bash scripts/deploy-server.sh
# =============================================================================

set -e

DRUPAL_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DRUSH="$DRUPAL_ROOT/vendor/bin/drush"
WEB_USER="www-data"   # Change to "apache" on CentOS/RHEL

echo ""
echo "======================================"
echo "  Drupal Production Deployment"
echo "  $(date)"
echo "======================================"
echo ""
echo "  Drupal root: $DRUPAL_ROOT"
echo ""

cd "$DRUPAL_ROOT"

echo "[1/6] Pulling latest code from GitHub..."
git pull origin main
echo "      Pull complete."

echo ""
echo "[2/6] Installing/updating Composer dependencies..."
composer install --no-dev --optimize-autoloader --no-interaction
echo "      Composer done."

echo ""
echo "[3/6] Running database updates..."
sudo -u "$WEB_USER" "$DRUSH" updatedb --yes
echo "      Database updates done."

echo ""
echo "[4/6] Importing configuration..."
sudo -u "$WEB_USER" "$DRUSH" config:import --yes
echo "      Config imported."

echo ""
echo "[5/6] Rebuilding caches..."
sudo -u "$WEB_USER" "$DRUSH" cache:rebuild
echo "      Caches cleared."

echo ""
echo "[6/6] Checking site status..."
sudo -u "$WEB_USER" "$DRUSH" status --fields=drupal-version,php-version,db-status,bootstrap

echo ""
echo "  Deployment complete: $(date)"
echo ""
