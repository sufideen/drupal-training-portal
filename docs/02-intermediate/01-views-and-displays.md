# Lesson 1 (Intermediate) — Views and Displays

## What You Will Learn
- What the Views module does and when to use it
- How to create a course listing page with filters
- How to build a block view for the homepage

## Why This Matters
Views is the most-used contributed module in Drupal's history.
It lets you build any listing — course grids, recent articles,
user directories, file libraries — without writing PHP or SQL.

---

### 👁 Visual — See It

```
HOW VIEWS WORKS

Database (all Course nodes)
        │
        ▼
┌───────────────────────────────────┐
│  VIEW: "Course Listing"           │
│                                   │
│  Filter by: Content type = Course │
│  Filter by: Status = Published    │
│  Filter exposed: Level (dropdown) │
│                                   │
│  Sort by: Title (A–Z)             │
│  Items per page: 12               │
│                                   │
│  Display format: Grid (Bootstrap) │
│  Fields shown: Thumbnail, Title,  │
│                Level, Duration    │
└───────────────────────────────────┘
        │
        ▼
  /courses  →  Responsive 3-column card grid
  /courses?level=beginner  →  Filtered results
```

**View Display Types:**

```
One View can have multiple Displays:

View: "Courses"
  ├── Page display    → /courses  (full page)
  ├── Block display   → "Featured Courses" (on homepage)
  └── REST export     → /api/courses.json (for apps)
```

---

### 🔊 Auditory — Understand It

Think of a View as a **saved database query with a presentation layer**.

Without Views, to show a list of courses you would:
1. Write SQL to query the database
2. Write PHP to loop through results
3. Write HTML to display each item

With Views, you configure all of this through a UI.
You choose what content type to pull, what fields to show,
how to sort, whether to add filters, and what format to use
(table, grid, list, carousel). Views generates the query for you.

An **exposed filter** is a filter that visitors can interact with.
When you expose the "Level" filter, a dropdown appears on the page
so visitors can show only Beginner, Intermediate, or Advanced courses.

A **contextual filter** is automatic — it reads a value from the URL.
If the URL is `/courses/beginner`, Views reads "beginner" from the URL
and filters automatically, without a visible dropdown.

---

### ✋ Kinesthetic — Do It

**Step 1 — Enable Views UI**

```bash
ddev drush en views views_ui -y
ddev drush cr
```

**Step 2 — Create the Courses Page View**

1. Go to **Structure > Views > Add view**
2. Fill in:
   - View name: `Courses`
   - Show: Content of type: Course
   - Sorted by: Title
   - Check: Create a page
     - Page title: All Courses
     - Path: `/courses`
     - Display format: Bootstrap Grid (3 columns)
     - Items per page: 12
   - Check: Create a block
     - Block title: Featured Courses
     - Display format: Bootstrap Grid
     - Items per page: 3
3. Click **Save and edit**

**Step 3 — Add Fields to the View**

In the View edit screen, under **Fields**:
- Remove "Content: Title" (it's the default — we'll re-add it)
- Add field: `Content: Course Thumbnail` (image, medium style)
- Add field: `Content: Title` (link to content)
- Add field: `Content: Level`
- Add field: `Content: Duration (hours)`

**Step 4 — Add an Exposed Filter**

Under **Filter criteria**:
1. Click **Add**
2. Search for "Level" — add "Content: Level (field_level)"
3. Check **Expose this filter to visitors**
4. Label: Filter by level
5. Apply

**Step 5 — Save and Test**

```bash
ddev drush cr
```

Go to `/courses` on your site. You should see:
- A grid of course cards
- A "Filter by level" dropdown above the grid

**Step 6 — Place the Block Display on the Homepage**

1. Go to **Structure > Block layout**
2. Find the "Content" region
3. Click **Place block** → search "Featured Courses"
4. Set visibility: Pages → `<front>` only
5. Save

**Exercise checklist:**

- [ ] Views UI module enabled
- [ ] "Courses" view created with page display at `/courses`
- [ ] Block display created and placed on the homepage
- [ ] Fields show: thumbnail, title, level, duration
- [ ] Exposed level filter works on `/courses`
- [ ] At least 3 course nodes exist so the grid is visible

---

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| View page returns 404 | Path not saved correctly | Edit view > Page settings > Path — confirm it says `/courses` |
| No results showing | Filter too restrictive or nodes unpublished | Check nodes are published; remove filters to debug |
| Grid shows one column | Bootstrap grid not configured | Set format to "Bootstrap Grid" and configure columns to 3 |
| Exposed filter not visible | Filter not marked as "exposed" | Edit filter > check "Expose this filter to visitors" |

## Quick Reference

```
Structure > Views                  → Manage all views
Structure > Views > Add view       → Create new view
/admin/structure/views/view/[name] → Edit a specific view
ddev drush views:list              → List all views via Drush
ddev drush views:execute [name]    → Test a view via Drush
```
