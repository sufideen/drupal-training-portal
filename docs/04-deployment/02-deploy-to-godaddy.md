# Lesson 2 (Deployment) — Deploy to GoDaddy Shared Hosting

## What You Will Learn
- How to configure GoDaddy cPanel hosting for Drupal
- How to push your local site to GoDaddy via Git and SFTP
- How to set up the database and file permissions
- How to keep local and GoDaddy in sync

## Why This Matters
GoDaddy shared hosting is often the first production environment for
small organisations and training sites. It is affordable and accessible,
though it has limits compared to cloud platforms.

---

### 👁 Visual — See It

```
GODADDY DEPLOYMENT ARCHITECTURE

Your Machine (DDEV)
        │
        │  git push → GitHub
        │
        ▼
GitHub (sufideen/drupal-training-portal)
        │
        │  SSH into GoDaddy server
        │  git pull origin main
        │  composer install --no-dev
        │  drush config:import
        │
        ▼
GoDaddy cPanel Hosting
┌───────────────────────────────────────────────┐
│  public_html/         ← Drupal web/ contents  │
│  drupal-app/          ← Drupal root (private) │
│  ├── vendor/          ← composer install      │
│  ├── config/sync/     ← from Git              │
│  └── web/ → symlink or copy → public_html/    │
│                                               │
│  MySQL database       ← created in cPanel     │
│  PHP 8.3              ← set in cPanel         │
└───────────────────────────────────────────────┘
        │
        ▼
https://yourdomain.com  (GoDaddy nameservers)
```

**GoDaddy File Structure:**

```
/home/youruser/
├── public_html/            ← Web root (what the world sees)
│   ├── index.php           ← Copy/symlink from web/index.php
│   ├── .htaccess           ← Copy from web/.htaccess
│   └── sites/              ← Copy from web/sites/
│
└── drupal/                 ← Outside public_html (secure)
    ├── composer.json
    ├── composer.lock
    ├── config/sync/
    ├── vendor/
    └── web/                ← Drupal webroot
```

---

### 🔊 Auditory — Understand It

GoDaddy shared hosting does not give you Docker or DDEV — those are local
development tools only. On shared hosting, you use the server's installed
PHP, Apache, and MySQL directly.

The most important concept for GoDaddy: **the Drupal root and the web root
are different folders**. The `web/` subdirectory is the only folder Apache
should serve. Everything else (`vendor/`, `config/`, `composer.json`) must
live outside `public_html/` so visitors cannot access those files.

You manage the server through **cPanel** (GoDaddy's control panel) for
databases, PHP version, and file management. For deployments, use SSH.

---

### ✋ Kinesthetic — Do It

**Step 1 — Prepare GoDaddy Hosting**

In GoDaddy cPanel:

1. **Set PHP version to 8.3**
   - cPanel > Software > MultiPHP Manager
   - Select your domain → PHP 8.3

2. **Create a MySQL Database**
   - cPanel > Databases > MySQL Databases
   - Create database: `yourusername_drupal`
   - Create user: `yourusername_drup` with a strong password
   - Add user to database — grant ALL privileges

3. **Enable SSH Access**
   - cPanel > Security > SSH Access → Manage SSH Keys
   - Generate a key pair, or upload your public key

**Step 2 — SSH into GoDaddy and Clone Your Repo**

```bash
# From your local machine
ssh youruser@yourdomain.com

# On the GoDaddy server:
cd ~
git clone https://github.com/sufideen/drupal-training-portal.git drupal
cd drupal

# Install PHP dependencies (no dev packages in production)
composer install --no-dev --optimize-autoloader
```

**Step 3 — Configure settings.php on GoDaddy**

```bash
# On the GoDaddy server:
cp web/sites/default/settings.php.example web/sites/default/settings.php
nano web/sites/default/settings.php
```

Edit the database block:

```php
$databases['default']['default'] = [
  'database' => 'yourusername_drupal',
  'username' => 'yourusername_drup',
  'password' => 'YourDatabasePassword',
  'host'     => 'localhost',
  'port'     => '3306',
  'driver'   => 'mysql',
  'prefix'   => '',
];

$settings['trusted_host_patterns'] = [
  '^yourdomain\.com$',
  '^www\.yourdomain\.com$',
];

$settings['hash_salt'] = 'GENERATE_A_UNIQUE_64_CHARACTER_RANDOM_STRING';
$settings['config_sync_directory'] = '../config/sync';
```

**Step 4 — Point public_html to web/**

```bash
# On the GoDaddy server:
# Move existing public_html contents to backup
mv ~/public_html ~/public_html_backup

# Create symlink so public_html points to Drupal's web/ directory
ln -s ~/drupal/web ~/public_html

# OR if symlinks are not allowed, copy web/ contents to public_html:
cp -r ~/drupal/web/. ~/public_html/
```

**Step 5 — Set File Permissions**

```bash
# On GoDaddy server:
cd ~/drupal

# Drupal requires specific permissions
find web/sites/default/files -type d -exec chmod 755 {} \;
find web/sites/default/files -type f -exec chmod 644 {} \;
chmod 444 web/sites/default/settings.php

# Create the files directory if it doesn't exist
mkdir -p web/sites/default/files
chmod 755 web/sites/default/files
```

**Step 6 — Install Drupal and Import Config**

```bash
# On GoDaddy server — install Drupal using Drush
cd ~/drupal
vendor/bin/drush site:install standard \
  --db-url=mysql://yourusername_drup:PASSWORD@localhost/yourusername_drupal \
  --site-name="Drupal Training Portal" \
  --account-name=admin \
  --account-pass=StrongAdminPassword! \
  --yes

# Import your configuration from Git
vendor/bin/drush config:import -y
vendor/bin/drush cr
```

Visit `https://yourdomain.com` — your site should be live.

**Step 7 — Ongoing Sync Workflow**

Every time you make changes locally and push to GitHub:

```bash
# On GoDaddy server (via SSH):
cd ~/drupal
git pull origin main
composer install --no-dev --optimize-autoloader
vendor/bin/drush updatedb -y
vendor/bin/drush config:import -y
vendor/bin/drush cr
```

Or use the deploy script:

```bash
bash scripts/deploy-godaddy.sh
```

**Step 8 — Point Your Domain**

In GoDaddy Domains panel:
- DNS > A Record → point to your GoDaddy hosting IP
- Or use GoDaddy's built-in domain routing if on the same account

For SSL:
- cPanel > Security > Let's Encrypt (or SSL/TLS)
- Issue a free SSL certificate for your domain

**Exercise checklist:**

- [ ] GoDaddy PHP version set to 8.3
- [ ] MySQL database and user created in cPanel
- [ ] SSH key uploaded and SSH access working
- [ ] Repo cloned to GoDaddy server
- [ ] `composer install` completed without errors
- [ ] `settings.php` configured with real database credentials
- [ ] `public_html` points to `web/` directory
- [ ] Site accessible at your domain with SSL
- [ ] `drush config:import` succeeded

---

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| 500 server error | PHP version mismatch or `.htaccess` issue | Check cPanel > Error Logs |
| "Access denied" DB error | Wrong DB credentials in settings.php | Double-check database name, user, and password |
| Site installs but theme broken | CSS/JS not found | Check file paths; may need to clear cache and rebuild |
| `composer install` runs out of memory | GoDaddy memory limit | Add `COMPOSER_MEMORY_LIMIT=-1 composer install` |
| Drush not found | Path issue | Use `vendor/bin/drush` explicitly |
| Files upload fails | Wrong permissions | `chmod 755 web/sites/default/files` |

## Quick Reference

```bash
# On GoDaddy server after every git pull:
composer install --no-dev --optimize-autoloader
vendor/bin/drush updatedb -y
vendor/bin/drush config:import -y
vendor/bin/drush cr

# Check Drupal status
vendor/bin/drush status

# View error log
vendor/bin/drush watchdog:show --count=20
```
