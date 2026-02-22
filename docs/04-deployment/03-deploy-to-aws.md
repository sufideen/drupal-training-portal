# Lesson 3 (Deployment) — Deploy to AWS (Lightsail)

## What You Will Learn
- How to launch an AWS Lightsail instance suitable for Drupal
- How to install the LAMP stack and Composer on the server
- How to deploy from GitHub and keep the site updated
- How to connect to RDS MySQL for a managed database

## Why This Matters
AWS Lightsail gives you a full Linux server at predictable cost.
It scales beyond shared hosting and gives you root access —
essential when GoDaddy's limitations become a bottleneck.

---

### 👁 Visual — See It

```
AWS ARCHITECTURE FOR DRUPAL TRAINING PORTAL

Route 53 (DNS)
    │
    ▼
CloudFront (optional CDN + SSL)
    │
    ▼
Lightsail Instance (Ubuntu 22.04)
┌───────────────────────────────────────┐
│  Apache or Nginx                      │
│  PHP 8.3 + required extensions        │
│  Composer                             │
│  Drush                                │
│  Git                                  │
│                                       │
│  /var/www/drupal/         ← app root  │
│  /var/www/drupal/web/     ← webroot   │
│  /var/private/drupal/     ← files     │
└──────────────────┬────────────────────┘
                   │ private network
                   ▼
         RDS MySQL 8.0 (managed DB)
         or Lightsail Managed DB
```

**Cost estimate (2025 prices):**

| Resource | Size | Monthly cost (approx) |
|----------|------|----------------------|
| Lightsail instance | $10/mo plan (2GB RAM) | ~$10 |
| Lightsail Managed DB | $15/mo (MySQL) | ~$15 |
| Static IP | Included with instance | $0 |
| SSL via Let's Encrypt | Free | $0 |
| **Total** | | **~$25/mo** |

---

### 🔊 Auditory — Understand It

AWS Lightsail is Amazon's simplified VPS (Virtual Private Server) product.
Unlike EC2, it has predictable flat-rate pricing and a simple control panel —
making it a good step up from shared hosting without the complexity of full AWS.

You get a real Ubuntu Linux server with root access. You install the software
yourself (Apache, PHP, Composer) and manage deployments via SSH and Git.

The key difference from GoDaddy: you have full control of the OS, can install
any PHP extension, run cron jobs, configure Nginx, set up Redis caching,
and scale vertically by upgrading the instance plan.

---

### ✋ Kinesthetic — Do It

**Step 1 — Create a Lightsail Instance**

```bash
# Install AWS CLI v2 (official method — do NOT use pip on Ubuntu)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
unzip -q /tmp/awscliv2.zip -d /tmp
sudo /tmp/aws/install
aws --version   # Expected: aws-cli/2.x.x

aws configure
# Enter: Access Key ID, Secret Access Key, Region (e.g., us-east-1), output: json

# Create a Lightsail instance
aws lightsail create-instances \
  --instance-names drupal-training \
  --availability-zone us-east-1a \
  --blueprint-id ubuntu_22_04 \
  --bundle-id small_3_0 \
  --key-pair-name your-keypair-name

# Allocate and attach a static IP
aws lightsail allocate-static-ip --static-ip-name drupal-training-ip
aws lightsail attach-static-ip \
  --static-ip-name drupal-training-ip \
  --instance-name drupal-training
```

Or use the Lightsail web console: https://lightsail.aws.amazon.com

**Step 2 — Open Firewall Ports**

```bash
aws lightsail put-instance-public-ports \
  --instance-name drupal-training \
  --port-infos fromPort=22,toPort=22,protocol=TCP \
               fromPort=80,toPort=80,protocol=TCP \
               fromPort=443,toPort=443,protocol=TCP
```

**Step 3 — SSH into the Instance and Install the Stack**

```bash
# SSH in (replace with your static IP)
ssh -i ~/.ssh/your-key.pem ubuntu@YOUR_STATIC_IP

# Update system
sudo apt update && sudo apt upgrade -y

# Install Apache, PHP 8.3, and extensions
sudo apt install -y apache2 \
  php8.3 php8.3-cli php8.3-fpm php8.3-mysql \
  php8.3-xml php8.3-mbstring php8.3-curl php8.3-zip \
  php8.3-gd php8.3-intl php8.3-bcmath php8.3-opcache \
  mysql-client git unzip curl

# Enable Apache modules
sudo a2enmod rewrite proxy_fcgi setenvif
sudo a2enconf php8.3-fpm
sudo systemctl restart apache2

# Install Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
composer --version
```

**Step 4 — Set Up MySQL**

Option A — Lightsail Managed Database (recommended):
```bash
# In Lightsail console: Databases > Create database
# Choose MySQL 8.0, $15/mo plan
# Note the endpoint, username, and password
```

Option B — MySQL on the same instance:
```bash
sudo apt install -y mysql-server
sudo mysql_secure_installation
sudo mysql -u root -p -e "
  CREATE DATABASE drupal_training CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
  CREATE USER 'drupaluser'@'localhost' IDENTIFIED BY 'StrongPassword!';
  GRANT ALL PRIVILEGES ON drupal_training.* TO 'drupaluser'@'localhost';
  FLUSH PRIVILEGES;"
```

**Step 5 — Clone Repo and Deploy**

```bash
# On the Lightsail server:
cd /var/www
sudo mkdir drupal && sudo chown ubuntu:ubuntu drupal
git clone https://github.com/sufideen/drupal-training-portal.git drupal
cd drupal

# Install PHP dependencies
composer install --no-dev --optimize-autoloader

# Configure settings.php
cp web/sites/default/settings.php.example web/sites/default/settings.php
nano web/sites/default/settings.php
# Fill in your database credentials and trusted_host_patterns
```

**Step 6 — Configure Apache Virtual Host**

```bash
sudo nano /etc/apache2/sites-available/drupal-training.conf
```

```apache
<VirtualHost *:80>
    ServerName yourdomain.com
    ServerAlias www.yourdomain.com
    DocumentRoot /var/www/drupal/web

    <Directory /var/www/drupal/web>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/drupal-error.log
    CustomLog ${APACHE_LOG_DIR}/drupal-access.log combined
</VirtualHost>
```

```bash
sudo a2ensite drupal-training.conf
sudo a2dissite 000-default.conf
sudo systemctl reload apache2
```

**Step 7 — Set File Permissions**

```bash
sudo chown -R www-data:www-data /var/www/drupal/web/sites/default/files
sudo find /var/www/drupal -type d -exec chmod 755 {} \;
sudo find /var/www/drupal -type f -exec chmod 644 {} \;
sudo chmod 444 /var/www/drupal/web/sites/default/settings.php
sudo mkdir -p /var/private/drupal && sudo chown www-data:www-data /var/private/drupal
```

**Step 8 — Install Drupal**

```bash
cd /var/www/drupal
sudo -u www-data vendor/bin/drush site:install standard \
  --db-url=mysql://drupaluser:StrongPassword!@localhost/drupal_training \
  --site-name="Drupal Training Portal" \
  --account-name=admin \
  --account-pass=SecureAdminPass! \
  --yes

sudo -u www-data vendor/bin/drush config:import -y
sudo -u www-data vendor/bin/drush cr
```

**Step 9 — Install SSL with Let's Encrypt**

```bash
sudo apt install -y certbot python3-certbot-apache
sudo certbot --apache -d yourdomain.com -d www.yourdomain.com
# Follow prompts — choose to redirect HTTP to HTTPS
```

**Step 10 — Set Up Automated Deployment**

Create `/var/www/drupal/scripts/deploy.sh` on the server:

```bash
#!/bin/bash
set -e
cd /var/www/drupal
git pull origin main
composer install --no-dev --optimize-autoloader
sudo -u www-data vendor/bin/drush updatedb -y
sudo -u www-data vendor/bin/drush config:import -y
sudo -u www-data vendor/bin/drush cr
echo "Deployment complete: $(date)"
```

```bash
chmod +x /var/www/drupal/scripts/deploy.sh
# Deploy with:
bash /var/www/drupal/scripts/deploy.sh
```

**Exercise checklist:**

- [ ] Lightsail instance created and running
- [ ] Static IP attached
- [ ] Apache, PHP 8.3, and all extensions installed
- [ ] MySQL database created and accessible
- [ ] Repo cloned and `composer install` successful
- [ ] Apache virtual host configured and active
- [ ] File permissions set correctly
- [ ] Drupal installed and config imported
- [ ] SSL certificate installed via Let's Encrypt
- [ ] Site accessible at `https://yourdomain.com`

---

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| Apache 403 Forbidden | DocumentRoot permissions | `sudo chmod 755 /var/www/drupal/web` |
| PHP errors on page | Missing extension | `php -m | grep [extension]`; install with `apt install php8.3-[ext]` |
| Database connection error | Wrong credentials or DB not running | `mysql -u drupaluser -p` to test connection |
| Certbot fails | Port 80 not open or domain not pointing to server | Check Lightsail firewall; confirm DNS A record |
| Drush: "permission denied" | Running as wrong user | Use `sudo -u www-data vendor/bin/drush` |

## Quick Reference

```bash
# On AWS server — update after git push:
bash /var/www/drupal/scripts/deploy.sh

# Check Apache status
sudo systemctl status apache2

# View PHP errors
sudo tail -f /var/log/apache2/drupal-error.log

# Drupal status check
sudo -u www-data vendor/bin/drush status
```
