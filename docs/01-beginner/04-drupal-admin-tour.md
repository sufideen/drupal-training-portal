# Lesson 4 — Tour of the Drupal Admin Panel

## What You Will Learn
- What every section of the Drupal admin toolbar does
- Where to find common settings
- How to navigate confidently without getting lost

## Why This Matters
New Drupal users spend a lot of time lost in the admin panel.
This lesson gives you a complete map so every menu feels familiar.

---

### 👁 Visual — See It

```
DRUPAL ADMIN TOOLBAR (top of every admin page)
┌────────────────────────────────────────────────────────────────────┐
│ 🏠 Home │ Content │ Structure │ Appearance │ Extend │ Config │ Reports │ Help │ 👤 admin │
└────────────────────────────────────────────────────────────────────┘

CONTENT
├── Add content            → Create a new page, article, or custom type
├── Content list           → View, edit, delete all existing content
├── Comments               → Manage reader comments
├── Files                  → Browse uploaded files
└── Media                  → Manage images, videos, documents

STRUCTURE
├── Content types          → Define what types of content exist
├── Taxonomy               → Manage categories and tags
├── Menus                  → Build navigation menus
├── Blocks                 → Manage content regions (header, sidebar, footer)
├── Views                  → Create lists/grids of content
└── Paragraphs             → (when installed) Reusable content components

APPEARANCE
├── Installed themes       → Switch active theme
├── Settings               → Configure the active theme
└── Install new theme      → Upload or download a theme

EXTEND
├── Installed modules      → Enable/disable modules
└── Install new module     → Upload or download a module

CONFIGURATION
├── System                 → Site name, email, maintenance mode
├── Content authoring      → Text formats, editor settings
├── People                 → Account settings, registration
├── Regional & Language    → Timezone, date format, language
├── Search & Metadata      → URL aliases, metatags
└── Development            → Cache, performance, logging

REPORTS
├── Recent log messages    → Error and activity log
├── Status report          → System health check
├── Available updates      → Module and core update status
└── Views plugins          → Debug Views configuration
```

---

### 🔊 Auditory — Understand It

The Drupal admin toolbar is split into logical groups.

**Content** is where you go to *create and manage what visitors read*.
Every article, course, page, and FAQ item lives here.

**Structure** is where you go to *define how content is organised*.
If Content is the filing cabinet drawers, Structure defines the labels
and folders inside each drawer.

**Appearance** controls *how the site looks* — colours, fonts, layout,
logo. You switch themes here.

**Extend** is the *module manager*. Think of modules as apps for your
Drupal site. The "Extend" screen lets you turn them on and off.

**Configuration** holds *site-wide settings* — the site name, email address,
timezone, text editor options. Changes here affect the whole site.

**Reports** is your *diagnostic dashboard*. If something breaks, the error
log here usually tells you why. The status report flags security issues
and outdated software.

---

### ✋ Kinesthetic — Do It

With your DDEV site running, log in and complete each task:

**Task 1 — Content**
- [ ] Go to **Content > Add content > Basic page**
- [ ] Create a page titled "About This Training Site"
- [ ] Add 2–3 sentences in the body
- [ ] Save and view the page

**Task 2 — Structure**
- [ ] Go to **Structure > Content types**
- [ ] Read the descriptions of "Article" and "Basic page"
- [ ] Note the difference between them

**Task 3 — Menus**
- [ ] Go to **Structure > Menus > Main navigation**
- [ ] Click **Add link**
- [ ] Add your "About" page to the menu
- [ ] Go to the homepage — does the menu link appear?

**Task 4 — Reports**
- [ ] Go to **Reports > Status report**
- [ ] Look for any items marked in red or orange
- [ ] Go to **Reports > Recent log messages**
- [ ] Note what kind of events are logged

**Task 5 — Configuration**
- [ ] Go to **Configuration > System > Basic site settings**
- [ ] Change the site slogan to "Training & Development Portal"
- [ ] Save and verify it appears on the homepage

---

## Quick Reference

| Task | Where to go |
|------|------------|
| Create new content | Content > Add content |
| Edit existing content | Content > (find item) > Edit |
| Add a menu link | Structure > Menus |
| Change site name | Configuration > System > Basic site settings |
| Enable a module | Extend |
| Switch theme | Appearance |
| View error log | Reports > Recent log messages |
| Check for updates | Reports > Available updates |
| Clear cache | Configuration > Development > Performance > Clear all caches |
