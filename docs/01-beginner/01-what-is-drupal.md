# Lesson 1 — What Is Drupal?

## What You Will Learn
- What Drupal is and what it is used for
- How Drupal compares to WordPress and other CMS platforms
- The key parts of a Drupal site

## Why This Matters
Before installing anything, you need a clear mental model of what Drupal
is and how its pieces fit together. This lesson gives you that foundation.

---

### 👁 Visual — See It

```
A Drupal Website — the three layers
┌──────────────────────────────────────────────┐
│               FRONT END (Theme)              │
│  What visitors see: pages, menus, styles     │
│  Built with: HTML, CSS, Twig templates       │
└──────────────────────┬───────────────────────┘
                       │
┌──────────────────────▼───────────────────────┐
│            DRUPAL APPLICATION (Core)         │
│  Content types · Nodes · Users · Modules     │
│  Handles: routing, permissions, rendering    │
└──────────────────────┬───────────────────────┘
                       │
┌──────────────────────▼───────────────────────┐
│               DATABASE (MySQL)               │
│  Stores: all content, config, users, files   │
└──────────────────────────────────────────────┘
```

**Drupal vs WordPress vs Custom Code**

| Feature | Drupal | WordPress | Custom Code |
|---------|--------|-----------|-------------|
| Learning curve | Steeper | Gentle | Very steep |
| Flexibility | Very high | Medium | Total |
| Best for | Complex sites, portals | Blogs, simple sites | Unique apps |
| User roles | Fine-grained | Basic | You build it |
| Enterprise use | Common | Less common | Common |
| Community | Large | Very large | None |

---

### 🔊 Auditory — Understand It

Drupal is a **Content Management System** — software that lets you build and
manage websites without writing HTML for every page.

Think of Drupal like a **filing cabinet with a display window**.
- The **filing cabinet** is the database — it stores all your content.
- The **filing rules** are Drupal's content types — they decide what information
  each piece of content must have (title, body, image, date, etc.).
- The **display window** is the theme — it controls how content looks to visitors.
- The **filing clerk** is Drupal's core — it connects the database to the display,
  handles who is allowed to see what, and manages everything in between.

When a visitor opens your website, Drupal:
1. Receives the request (e.g., "show me /courses/drupal-basics")
2. Looks up the matching content in the database
3. Applies the theme to format it
4. Sends the finished HTML page to the visitor's browser

You never write that process manually — Drupal handles it automatically.

**Key vocabulary you will use every day:**

| Term | Plain meaning |
|------|--------------|
| Node | A single piece of content (one article, one course, one FAQ item) |
| Content type | The template that defines what fields a node has |
| Field | A data input (title, body text, image, date, price) |
| Module | A plugin that adds features to Drupal |
| Theme | The design layer — controls colours, fonts, layout |
| Block | A reusable chunk of content placed in a region (sidebar, footer) |
| Region | A named area of a page (header, sidebar, content, footer) |
| View | A configurable list or grid of content |
| Taxonomy | A categorisation system (tags, categories) |
| Drush | A command-line tool for managing Drupal |

---

### ✋ Kinesthetic — Do It

**Exercise 1.1 — Explore a live Drupal demo**

1. Open your browser and go to: https://simplytest.me
2. Choose **Drupal** and click "Launch"
3. Wait for the demo site to load (about 60 seconds)
4. Log in with the credentials shown on screen
5. Complete this checklist:

- [ ] Find the **Content** menu in the admin toolbar — what do you see?
- [ ] Click **Add content** — how many content types are available?
- [ ] Create a test article: give it a title and some body text, then save it
- [ ] Find your new article in the content list
- [ ] Click **Structure > Content types** — read the description of each type
- [ ] Click **Appearance** — note which theme is active
- [ ] Click **Extend** — scroll through the list of modules

**Write down three things that surprised you about the Drupal admin panel.**

---

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| Demo site times out | SimplyTest.me has a 30-minute limit | Restart the demo or move to Lesson 2 (local install) |
| Login fails | Wrong credentials | Use the credentials shown on the SimplyTest launch page |
| Page not found after saving | Caching issue on demo | Append `?nocache=1` to the URL |

## Quick Reference

- Drupal official site: https://www.drupal.org
- Drupal documentation: https://www.drupal.org/documentation
- Drupal project (GitHub): https://github.com/drupal/drupal
