#!/bin/bash
# =============================================================================
# sync.sh
# Export Drupal config, commit changes, and push to GitHub
# Usage: bash scripts/sync.sh "Your commit message"
# =============================================================================

set -e

COMMIT_MSG="${1:-"Sync: local changes $(date '+%Y-%m-%d %H:%M')"}"

echo ""
echo "=============================="
echo "  Drupal → GitHub Sync"
echo "=============================="
echo ""

# Must be in the project root
if [ ! -f "composer.json" ]; then
  echo "ERROR: Run this script from the project root directory."
  exit 1
fi

echo "[1/4] Exporting Drupal configuration..."
ddev drush config:export -y
echo "      Config exported to config/sync/"

echo ""
echo "[2/4] Checking git status..."
if [ -z "$(git status --porcelain)" ]; then
  echo "      Nothing to commit — working tree is clean."
  exit 0
fi
git status --short

echo ""
echo "[3/4] Staging and committing..."
git add .
git commit -m "$COMMIT_MSG

Co-Authored-By: Claude <noreply@anthropic.com>"

echo ""
echo "[4/4] Pushing to GitHub..."
git push origin main

echo ""
echo "  Done! Changes pushed to:"
echo "  https://github.com/sufideen/drupal-training-portal"
echo ""
