# Lesson 6 (Intermediate) — Configuration Management

## What You Will Learn
- What Drupal configuration management is and why it matters
- How to export config from your local DDEV site
- How to import config on a staging or production server
- How to use Git to track configuration changes

## Why This Matters
Configuration management is what separates professional Drupal developers
from beginners. It ensures that every change you make locally — content types,
views, permissions, theme settings — can be reliably deployed to any server
without clicking through the admin UI again.

---

### 👁 Visual — See It

```
WITHOUT CONFIG MANAGEMENT (the painful way)

Local: set up content type, views, permissions
           │
           │  "I'll just redo it on the server"
           ▼
Server: manually click through 40+ admin screens
        → mistakes happen, settings differ
        → "Why does it work locally but not on staging?"

─────────────────────────────────────────────────

WITH CONFIG MANAGEMENT (the professional way)

Local (DDEV)
  │
  │  ddev drush config:export
  │
  ▼
config/sync/*.yml files  ←  plain text, human-readable
  │
  │  git add . && git commit && git push
  │
  ▼
GitHub repository
  │
  │  git pull  (on server)
  │  drush config:import
  │
  ▼
Server: identical configuration — no clicking required
```

**Config sync folder structure:**

```
config/sync/
├── core.extension.yml           ← which modules/themes are enabled
├── system.site.yml              ← site name, email, front page
├── node.type.course.yml         ← Course content type definition
├── field.field.node.course.*.yml ← Course field definitions
├── views.view.courses.yml       ← Your courses view
├── user.role.student.yml        ← Student role + permissions
└── block.block.*.yml            ← Block placements
```

---

### 🔊 Auditory — Understand It

In Drupal, there are two kinds of data:
- **Content** — nodes, users, uploaded files. These change constantly.
- **Configuration** — content types, views, permissions, theme settings. These define *how the site works*.

Drupal stores configuration as YAML files when you export.
YAML is a plain-text format, readable by humans and trackable by Git.

The workflow is:
1. Make changes in your local admin UI (create a content type, tweak a View)
2. Export: `drush config:export` — writes those changes to `config/sync/*.yml`
3. Commit the YAML files to Git: `git add config/ && git commit`
4. On the server: `git pull` + `drush config:import` — applies your changes

This means the server never needs to be manually configured.
One `config:import` command replicates every setting change you made locally.

A critical rule: **never edit configuration on the live server directly**.
Always make changes locally, export, commit, and import. Otherwise your
local and server configs drift apart, causing hard-to-debug inconsistencies.

---

### ✋ Kinesthetic — Do It

**Step 1 — Set the Config Sync Directory**

Confirm `web/sites/default/settings.php` has this line
(it should already be there in a standard install):

```php
$settings['config_sync_directory'] = '../config/sync';
```

```bash
# Create the directory if it doesn't exist
mkdir -p config/sync
```

**Step 2 — Export Your Current Configuration**

```bash
# Export all configuration to config/sync/
ddev drush config:export -y

# Check what was created
ls config/sync/ | head -20
```

You will see dozens of `.yml` files — one per configuration object.

**Step 3 — Commit Configuration to Git**

```bash
git add config/sync/
git status   # Review what changed
git commit -m "Export initial configuration"
git push origin main
```

**Step 4 — Make a Change and Track It**

1. Go to **Configuration > System > Basic site settings**
2. Change the site slogan to "Learn Drupal — Step by Step"
3. Save

```bash
# Export again — only changed files will differ
ddev drush config:export -y

# See exactly what changed
git diff config/sync/system.site.yml
```

You will see a diff showing the old and new slogan. This is the power of
config management — every change is visible and reversible.

```bash
git add config/sync/system.site.yml
git commit -m "Update site slogan for training portal"
git push origin main
```

**Step 5 — Simulate Importing on a Fresh Install**

```bash
# Imagine this is a new server with a fresh Drupal install
# Pull the repo and import config:
git pull origin main
ddev drush config:import -y

# Drupal will say "The configuration was imported successfully"
# Your site now matches the exported config exactly
```

**Step 6 — Useful Config Commands**

```bash
# Check for differences between active config and sync directory
ddev drush config:status

# Export everything
ddev drush config:export -y

# Import everything
ddev drush config:import -y

# Get a single config value
ddev drush config:get system.site name

# Set a single config value
ddev drush config:set system.site slogan "New Slogan" -y

# View a full config object
ddev drush config:get views.view.courses
```

**Exercise checklist:**

- [ ] `config/sync/` directory exists and contains `.yml` files after export
- [ ] Configuration is committed to Git
- [ ] Made a visible change in the admin UI, re-exported, and confirmed the YAML diff
- [ ] Ran `config:status` to compare active config with sync directory
- [ ] Understand why you should never configure a live server manually

---

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| `config:import` fails with UUID mismatch | Different Drupal site UUIDs | Run `drush config:get system.site uuid` on both — they must match for import |
| Config export is empty | Sync directory not configured | Check `settings.php` for `config_sync_directory` |
| Changes lost after import | Config was changed on server directly | Always import from Git, never configure server manually |
| `config:status` shows hundreds of changes | First export ever | Normal — export once to establish baseline |

## Quick Reference

```bash
ddev drush config:export -y        # Export config to config/sync/
ddev drush config:import -y        # Import config from config/sync/
ddev drush config:status           # Show differences
ddev drush config:get [key]        # Read one config value
ddev drush config:set [key] [val]  # Write one config value
```
