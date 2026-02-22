# Lesson 7 — Install and Configure a Drupal Theme

## What You Will Learn
- How to install a contributed theme using Composer
- How to set it as the default theme
- How to configure basic theme settings (logo, colours, fonts)
- How to set a separate admin theme

## Why This Matters
The theme is the first thing visitors see. A well-configured theme makes
your training portal look professional and trustworthy.

---

### 👁 Visual — See It

```
DRUPAL THEMING LAYERS

┌──────────────────────────────────────────────┐
│  Your Custom Sub-Theme (my_training_theme)   │  ← You edit this
│  Overrides only what you need to change      │
├──────────────────────────────────────────────┤
│  Base Theme (Bootstrap Barrio)               │  ← Downloaded, not edited
│  Provides Bootstrap 5 grid + components      │
├──────────────────────────────────────────────┤
│  Drupal Core Theme System                    │  ← Never touch
│  Twig templates, theme hooks, render arrays  │
└──────────────────────────────────────────────┘

ADMIN THEME (separate from frontend theme)
  Gin  ←  what admins see when managing the site
```

---

### 🔊 Auditory — Understand It

Drupal has two active themes at any time:
- The **default theme** — what visitors see
- The **admin theme** — what logged-in editors and admins see

It is best practice to use a clean, purpose-built admin theme (like Gin)
for the backend, and a branded theme for the frontend. This separates
"managing the site" from "what the public sees".

A **sub-theme** inherits everything from its base theme but lets you
override only what you want to change. If Bootstrap Barrio releases an
update, you pull in the update without losing your customisations,
because your customisations live in your sub-theme — not in Barrio itself.

The base theme (Bootstrap Barrio) gives you Bootstrap 5: a responsive grid
system, buttons, cards, modals, and typography — all ready to use.
Your sub-theme adds your logo, colours, and custom CSS on top.

---

### ✋ Kinesthetic — Do It

**Step 1 — Install Bootstrap Barrio and Gin**

```bash
# From inside your project folder
ddev composer require drupal/bootstrap_barrio drupal/gin drupal/gin_toolbar

# Enable all three
ddev drush theme:enable bootstrap_barrio gin gin_toolbar
ddev drush en gin_toolbar -y
```

**Step 2 — Set Gin as the Admin Theme**

```bash
ddev drush config-set system.theme admin gin -y
ddev drush cr
```

Log out and back in — the admin panel now uses Gin's modern dark UI.

**Step 3 — Create Your Sub-Theme**

```bash
# Navigate to the custom themes folder
mkdir -p web/themes/custom/training_theme
cd web/themes/custom/training_theme
mkdir css js templates
```

Create `training_theme.info.yml`:

```yaml
name: 'Training Theme'
type: theme
base theme: bootstrap_barrio
description: 'Custom theme for the Drupal Training Portal'
package: Custom
core_version_requirement: ^10 || ^11

libraries:
  - training_theme/global-styling

regions:
  header: Header
  primary_menu: 'Primary Menu'
  hero: Hero
  highlighted: Highlighted
  content: Content
  sidebar_first: 'Sidebar'
  footer: Footer
```

Create `training_theme.libraries.yml`:

```yaml
global-styling:
  css:
    theme:
      css/style.css: {}
  js:
    js/script.js: {}
```

Create `css/style.css`:

```css
:root {
  --brand-blue:   #1a3c6b;
  --brand-orange: #e87722;
  --text-dark:    #2c2c2c;
  --bg-light:     #f5f7fa;
}

body {
  font-family: 'Segoe UI', Arial, sans-serif;
  background: var(--bg-light);
  color: var(--text-dark);
}

.region-header {
  background: var(--brand-blue);
  color: white;
  padding: 0.75rem 1.5rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.region-header a {
  color: white;
  text-decoration: none;
  margin-right: 1.5rem;
  font-weight: 500;
}

.region-hero {
  background: linear-gradient(135deg, var(--brand-blue) 0%, var(--brand-orange) 100%);
  color: white;
  padding: 3rem 2rem;
  text-align: center;
}

.card {
  border: none;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  transition: transform 0.2s, box-shadow 0.2s;
}

.card:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 20px rgba(0,0,0,0.12);
}

.btn-primary {
  background: var(--brand-orange);
  border-color: var(--brand-orange);
}
```

Create `js/script.js`:

```javascript
(function ($, Drupal) {
  'use strict';
  Drupal.behaviors.trainingTheme = {
    attach: function (context, settings) {
      // Add active class to current menu item
      once('training-menu', '.region-header a', context).forEach(function(el) {
        if (el.href === window.location.href) {
          el.classList.add('active');
        }
      });
    }
  };
})(jQuery, Drupal);
```

**Step 4 — Enable Your Sub-Theme**

```bash
ddev drush theme:enable training_theme
ddev drush config-set system.theme default training_theme -y
ddev drush cr
ddev launch
```

Your site now uses your branded theme with the blue/orange colour scheme.

**Exercise checklist:**

- [ ] Bootstrap Barrio and Gin installed via Composer
- [ ] Gin set as the admin theme
- [ ] `training_theme/` folder created with all required files
- [ ] Sub-theme enabled and set as default
- [ ] Homepage shows the custom header colour from your CSS
- [ ] Admin panel uses Gin (dark modern UI)

---

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| Theme not showing in list | `.info.yml` has a YAML syntax error | Check indentation — YAML uses spaces not tabs |
| CSS not loading | Library not declared or cache not cleared | Run `ddev drush cr` |
| Admin theme still shows old theme | Cache | `ddev drush cr` then hard-refresh browser (Ctrl+Shift+R) |
| "Base theme not found" error | Bootstrap Barrio not enabled | Run `ddev drush theme:enable bootstrap_barrio` |

## Quick Reference

```bash
ddev drush theme:enable [name]                    # Enable a theme
ddev drush config-set system.theme default [name] # Set default theme
ddev drush config-set system.theme admin [name]   # Set admin theme
ddev drush cr                                     # Clear cache after theme changes
```
