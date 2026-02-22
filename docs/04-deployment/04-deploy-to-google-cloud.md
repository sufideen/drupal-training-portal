# Lesson 4 (Deployment) — Deploy to Google Cloud (Compute Engine)

## What You Will Learn
- How to launch a Google Cloud Compute Engine VM for Drupal
- How to deploy from GitHub using Cloud Build or manual pull
- How to connect to Cloud SQL for managed MySQL
- How to configure the domain and SSL

## Why This Matters
Google Cloud offers strong performance, global infrastructure, and
tight integration with services like Cloud Storage, Cloud SQL, and
Cloud CDN — making it a solid choice for growing training platforms.

---

### 👁 Visual — See It

```
GOOGLE CLOUD ARCHITECTURE

Cloud DNS
    │
    ▼
Cloud Load Balancer (optional, for scale)
    │        or direct IP
    ▼
Compute Engine VM (e2-medium, Ubuntu 22.04)
┌───────────────────────────────────────────┐
│  Nginx + PHP 8.3-FPM                      │
│  Composer, Drush, Git                     │
│                                           │
│  /var/www/drupal/web  ← webroot           │
│  /var/private/files   ← private files     │
└───────────────────┬───────────────────────┘
                    │ private IP / Cloud SQL Proxy
                    ▼
          Cloud SQL (MySQL 8.0)
          Managed, auto-backup, encrypted

          Cloud Storage Bucket
          (optional: store Drupal files externally)
```

**Cost estimate (2025):**

| Resource | Spec | Monthly (approx) |
|----------|------|-----------------|
| e2-micro VM | 1 vCPU, 1GB RAM | ~$7 |
| e2-small VM | 1 vCPU, 2GB RAM | ~$13 (recommended) |
| Cloud SQL db-f1-micro | MySQL 8.0 | ~$10 |
| Static IP | Regional | ~$3 |
| SSL via Let's Encrypt | Free | $0 |
| **Total** | | **~$26/mo** |

---

### 🔊 Auditory — Understand It

Google Compute Engine (GCE) is Google's equivalent of AWS EC2 —
a virtual machine you fully control. Like Lightsail, you install
the software stack yourself and manage deployments via SSH.

The key advantage of Google Cloud for Drupal:
- **Cloud SQL** is a fully managed MySQL service — no database administration
- **Cloud Storage** can replace Drupal's local file system for uploaded files
- **Cloud Build** can automate deployments when you push to GitHub
- **Cloud CDN** serves static assets globally with low latency

For this lesson we use a straightforward Compute Engine + Cloud SQL setup,
which mirrors the AWS Lightsail approach but on Google infrastructure.

---

### ✋ Kinesthetic — Do It

**Step 1 — Set Up Google Cloud Project**

```bash
# Install gcloud CLI
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init

# Set your project
gcloud config set project YOUR_PROJECT_ID

# Enable required APIs
gcloud services enable \
  compute.googleapis.com \
  sqladmin.googleapis.com \
  servicenetworking.googleapis.com
```

**Step 2 — Create the VM**

```bash
# Create VM (e2-small = good balance of cost/performance)
gcloud compute instances create drupal-training \
  --zone=us-central1-a \
  --machine-type=e2-small \
  --image-family=ubuntu-2204-lts \
  --image-project=ubuntu-os-cloud \
  --boot-disk-size=20GB \
  --boot-disk-type=pd-ssd \
  --tags=http-server,https-server

# Reserve and assign a static IP
gcloud compute addresses create drupal-training-ip --region=us-central1
STATIC_IP=$(gcloud compute addresses describe drupal-training-ip \
  --region=us-central1 --format="value(address)")
gcloud compute instances add-access-config drupal-training \
  --access-config-name="External NAT" --address=$STATIC_IP

# Open HTTP/HTTPS firewall rules
gcloud compute firewall-rules create allow-http \
  --allow tcp:80 --target-tags http-server
gcloud compute firewall-rules create allow-https \
  --allow tcp:443 --target-tags https-server
```

**Step 3 — Create Cloud SQL MySQL Instance**

```bash
gcloud sql instances create drupal-training-db \
  --database-version=MYSQL_8_0 \
  --tier=db-f1-micro \
  --region=us-central1 \
  --root-password=RootPassword! \
  --storage-type=SSD \
  --backup-start-time=03:00

# Create database and user
gcloud sql databases create drupal_training \
  --instance=drupal-training-db \
  --charset=utf8mb4 \
  --collation=utf8mb4_unicode_ci

gcloud sql users create drupaluser \
  --instance=drupal-training-db \
  --password=StrongDbPassword!
```

**Step 4 — SSH into VM and Install the Stack**

```bash
# SSH via gcloud
gcloud compute ssh drupal-training --zone=us-central1-a

# On the VM:
sudo apt update && sudo apt upgrade -y

# Install Nginx, PHP 8.3, and extensions
sudo apt install -y nginx \
  php8.3 php8.3-fpm php8.3-cli php8.3-mysql \
  php8.3-xml php8.3-mbstring php8.3-curl php8.3-zip \
  php8.3-gd php8.3-intl php8.3-bcmath php8.3-opcache \
  mysql-client git unzip curl

# Install Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Install Cloud SQL Proxy (to connect to Cloud SQL securely)
curl -o cloud-sql-proxy \
  https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.8.0/cloud-sql-proxy.linux.amd64
chmod +x cloud-sql-proxy
sudo mv cloud-sql-proxy /usr/local/bin/
```

**Step 5 — Clone and Configure Drupal**

```bash
# On VM:
cd /var/www
sudo mkdir drupal && sudo chown $USER:$USER drupal
git clone https://github.com/sufideen/drupal-training-portal.git drupal
cd drupal
composer install --no-dev --optimize-autoloader

# Configure settings.php
cp web/sites/default/settings.php.example web/sites/default/settings.php
nano web/sites/default/settings.php
```

Update database block (using Cloud SQL Proxy on localhost):

```php
$databases['default']['default'] = [
  'database' => 'drupal_training',
  'username' => 'drupaluser',
  'password' => 'StrongDbPassword!',
  'host'     => '127.0.0.1',
  'port'     => '3306',
  'driver'   => 'mysql',
  'prefix'   => '',
];
$settings['trusted_host_patterns'] = [
  '^yourdomain\.com$',
  '^www\.yourdomain\.com$',
];
$settings['hash_salt'] = 'YOUR_UNIQUE_64_CHAR_HASH_SALT';
$settings['config_sync_directory'] = '../config/sync';
$settings['file_private_path'] = '/var/private/drupal';
```

**Step 6 — Configure Nginx**

```bash
sudo nano /etc/nginx/sites-available/drupal-training
```

```nginx
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;
    root /var/www/drupal/web;
    index index.php;

    location / {
        try_files $uri /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\. { deny all; }
    location = /robots.txt { access_log off; log_not_found off; }

    location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff2)$ {
        expires 30d;
        add_header Cache-Control "public, no-transform";
    }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/drupal-training \
           /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl reload nginx
```

**Step 7 — Start Cloud SQL Proxy and Install Drupal**

```bash
# Start Cloud SQL proxy (run as a service in production)
cloud-sql-proxy YOUR_PROJECT:us-central1:drupal-training-db &

# Set permissions
sudo chown -R www-data:www-data /var/www/drupal/web/sites/default/files
sudo mkdir -p /var/private/drupal && sudo chown www-data:www-data /var/private/drupal

# Install Drupal
sudo -u www-data vendor/bin/drush site:install standard \
  --db-url=mysql://drupaluser:StrongDbPassword!@127.0.0.1/drupal_training \
  --site-name="Drupal Training Portal" \
  --account-name=admin --account-pass=AdminPass! --yes

sudo -u www-data vendor/bin/drush config:import -y
sudo -u www-data vendor/bin/drush cr
```

**Step 8 — SSL with Let's Encrypt**

```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
```

**Step 9 — Point Your Domain to Google Cloud**

In your domain registrar (or GoDaddy DNS panel):
- Add an **A record**: `@` → `YOUR_STATIC_IP`
- Add an **A record**: `www` → `YOUR_STATIC_IP`

DNS propagation takes 5–60 minutes.

**Step 10 — Ongoing Deployment**

```bash
# On GCP VM after every git push:
cd /var/www/drupal
git pull origin main
composer install --no-dev --optimize-autoloader
sudo -u www-data vendor/bin/drush updatedb -y
sudo -u www-data vendor/bin/drush config:import -y
sudo -u www-data vendor/bin/drush cr
```

**Exercise checklist:**

- [ ] GCP project created with required APIs enabled
- [ ] Compute Engine VM running (e2-small)
- [ ] Cloud SQL MySQL instance created
- [ ] Static IP assigned
- [ ] Nginx, PHP 8.3, Composer installed
- [ ] Repo cloned and configured
- [ ] Nginx virtual host configured and active
- [ ] Cloud SQL Proxy running and DB connection works
- [ ] Drupal installed and config imported
- [ ] SSL certificate installed
- [ ] Site accessible at `https://yourdomain.com`

---

## Quick Reference

```bash
# SSH into VM
gcloud compute ssh drupal-training --zone=us-central1-a

# Deploy update
cd /var/www/drupal && git pull && composer install --no-dev && \
  sudo -u www-data vendor/bin/drush updatedb -y && \
  sudo -u www-data vendor/bin/drush config:import -y && \
  sudo -u www-data vendor/bin/drush cr

# View Nginx error log
sudo tail -f /var/log/nginx/error.log

# Check PHP-FPM
sudo systemctl status php8.3-fpm

# Drupal status
sudo -u www-data vendor/bin/drush status
```
