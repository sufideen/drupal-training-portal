# Lesson 6 — Menus and Blocks

## What You Will Learn
- How to build and manage navigation menus
- What blocks are and how to place them on pages
- How to control which blocks appear for which users

## Why This Matters
Menus and blocks control what visitors can navigate to and what appears
on each page. Without them, your site has no navigation and no layout.

---

### 👁 Visual — See It

```
PAGE LAYOUT — Regions and Blocks

┌──────────────────────────────────────────────┐
│            HEADER region                     │
│  [Site name block]  [Main nav menu block]    │
├──────────────────────────────────────────────┤
│  SIDEBAR region  │     CONTENT region        │
│                  │                           │
│  [Who's online]  │  [Page title block]       │
│  [Search block]  │  [Main content block]     │
│                  │  [Tabs block]             │
├──────────────────────────────────────────────┤
│            FOOTER region                     │
│  [Footer menu block]   [Copyright block]     │
└──────────────────────────────────────────────┘

A MENU is a list of links → it is placed as a BLOCK in a REGION
```

---

### 🔊 Auditory — Understand It

**Menus** are simply lists of links. Drupal comes with four default menus:
- **Main navigation** — the primary site navigation
- **Administration** — the admin toolbar links
- **Footer** — links in the footer area
- **User account** — links like "Log in" and "My account"

You can create unlimited custom menus. Each menu item can have children
(sub-menus) and you control the order by dragging items.

**Blocks** are the *containers* that display content in specific areas of
the page. Almost everything you see on a Drupal page is a block:
- The site logo — a block
- The navigation menu — a block
- The main content area — a block
- The "Who's online" sidebar widget — a block

**Regions** are named areas defined by the theme. Blocks are *placed* into
regions. If your theme has a "Sidebar" region, you can put any block there.

The **Block Layout** screen (`/admin/structure/block`) is your drag-and-drop
layout manager. You drag blocks into regions, set visibility conditions
(show this block only on the front page, or only to logged-in users), and
control the order blocks appear.

---

### ✋ Kinesthetic — Do It

**Part 1 — Build the Training Portal Menu**

1. Go to **Structure > Menus > Add menu**
2. Title: `Training Navigation`
3. Save
4. Click **Add link**
5. Add these links one by one:

| Link title | Path | Parent |
|-----------|------|--------|
| Home | `<front>` | — |
| Courses | `/courses` | — |
| Resources | `/resources` | — |
| My Learning | `/my-learning` | — |
| About | `/about` | — |

6. Drag "Courses" to be a parent and add a child:
   - Beginner Courses → `/courses?level=beginner`

**Part 2 — Place the Menu as a Block**

1. Go to **Structure > Block layout**
2. Find the **Header** region
3. Click **Place block**
4. Search for "Training Navigation" — click **Place block**
5. Set:
   - Label: (leave blank or "Training Navigation")
   - Display title: unchecked
   - Region: Header
6. Save block — save layout

**Part 3 — Add a Custom Text Block**

1. Go to **Structure > Block layout > Add custom block**
2. Block description: `Welcome Banner`
3. Body: `Welcome to the Drupal Training Portal — your step-by-step guide to mastering Drupal.`
4. Save
5. Place this block in the **Hero** or **Content top** region

**Part 4 — Restrict Block Visibility**

1. Edit the "Welcome Banner" block
2. Click **Visibility** tab
3. Under **Pages**, select "Show for the listed pages"
4. Enter: `<front>`
5. Under **Roles**, check "Show block for specific roles" > select "Authenticated user"
6. Save — the banner now shows only to logged-in users on the homepage

**Exercise checklist:**

- [ ] Custom menu created with 5 items including one sub-item
- [ ] Menu displayed in the header region
- [ ] Custom text block created and placed
- [ ] Block visibility restricted to front page and authenticated users

---

## Quick Reference

```
Structure > Menus                → Manage all menus
Structure > Menus > [menu] > Add link  → Add a menu item
Structure > Block layout         → Place and arrange blocks
Structure > Block layout > Add custom block  → Create a text/HTML block
```
