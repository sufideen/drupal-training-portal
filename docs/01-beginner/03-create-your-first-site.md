# Lesson 3 — Create Your First Drupal Site with DDEV

## What You Will Learn
- How to create a new Drupal project with Composer
- How to configure DDEV for Drupal
- How to install Drupal and access it in your browser

## Why This Matters
This is the moment everything comes together. After this lesson you will
have a fully working Drupal site running on your own computer.

---

### 👁 Visual — See It

**What you will build:**

```
~/drupal-training-portal/          ← Your project root
│
├── .ddev/
│   └── config.yaml                ← DDEV configuration
│
├── config/
│   └── sync/                      ← Drupal configuration exports
│
├── vendor/                        ← PHP packages (Composer managed)
│
└── web/                           ← Drupal webroot (public files)
    ├── core/                      ← Drupal core (never edit)
    ├── modules/
    │   ├── contrib/               ← Downloaded modules
    │   └── custom/                ← Your own modules
    ├── themes/
    │   ├── contrib/               ← Downloaded themes
    │   └── custom/                ← Your own themes
    └── sites/
        └── default/
            ├── settings.php       ← Main configuration file
            └── files/             ← Uploaded files (images, docs)
```

**DDEV start sequence:**

```
ddev start
    │
    ├── Pulls Docker images (first time only — takes a few minutes)
    ├── Creates web container (Nginx + PHP 8.3)
    ├── Creates db container (MySQL 8.0)
    ├── Sets up HTTPS with a local certificate
    └── Opens https://drupal-training-portal.ddev.site
```

---

### 🔊 Auditory — Understand It

`composer create-project` is like ordering a Drupal starter kit.
Composer reads a list of required packages and downloads them all — Drupal
core, its dependencies, and the recommended folder structure.

The `web/` folder is the **document root** — the only folder the web server
serves publicly. Everything outside `web/` (like `vendor/` and `config/`)
is invisible to browsers. This is a security feature.

`ddev config` reads your project folder and creates a `.ddev/config.yaml`
file that tells DDEV: "this is a Drupal site, use PHP 8.3, the webroot is
the `web/` folder". Once configured, `ddev start` does all the heavy lifting.

`drush site:install` is Drupal's automated installer. It creates all the
database tables and sets the admin password. Without it, you would have to
click through a web installer — Drush makes it one command.

---

### ✋ Kinesthetic — Do It

```bash
# 1. Move to your working directory
cd ~/Documents/"Web hosting and development"/"Drupal CMS"

# 2. Create the Drupal project with Composer
composer create-project drupal/recommended-project drupal-training-portal
cd drupal-training-portal

# 3. Configure DDEV
ddev config \
  --project-name=drupal-training-portal \
  --project-type=drupal \
  --php-version=8.3 \
  --docroot=web

# 4. Start DDEV
ddev start

# 5. Add Drush (Drupal command-line tool)
ddev composer require drush/drush

# 6. Install Drupal
ddev drush site:install standard \
  --db-url=mysql://db:db@db/db \
  --site-name="Drupal Training Portal" \
  --site-mail="admin@training.local" \
  --account-name=admin \
  --account-pass=Admin1234! \
  --yes

# 7. Open the site
ddev launch
```

You should see your Drupal site homepage in the browser.

**Log in to the admin panel:**
```
URL:      https://drupal-training-portal.ddev.site/user/login
Username: admin
Password: Admin1234!
```

**Exercise checklist:**

- [ ] `composer create-project` completed without errors
- [ ] `ddev start` showed a green "Project can be reached at" message
- [ ] `ddev drush site:install` completed and showed "Installation complete"
- [ ] Site opened in browser at `https://drupal-training-portal.ddev.site`
- [ ] You logged in as admin successfully
- [ ] You can see the black Drupal admin toolbar at the top of the page

---

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| Composer create-project fails | PHP not installed or wrong version | Run `php -v`; need PHP 8.1+. Install with `sudo apt install php8.3` |
| `ddev start` fails with "project already exists" | Old DDEV config | Run `ddev delete -O` then `ddev config` again |
| Site install fails with DB error | DDEV not fully started | Wait 10 seconds and retry `ddev drush site:install` |
| Browser shows "not secure" warning | Local HTTPS cert | Click "Advanced > Proceed" — this is safe for local development |
| Admin toolbar not showing | Theme issue | Go to `/admin/appearance` and ensure Claro is set as admin theme |

## Quick Reference

```bash
ddev start                          # Start your site
ddev stop                           # Stop your site
ddev launch                         # Open browser
ddev launch /admin                  # Open admin panel
ddev drush uli                      # Generate one-time login link
ddev drush cr                       # Clear all caches
ddev describe                       # Show URLs and DB credentials
```
