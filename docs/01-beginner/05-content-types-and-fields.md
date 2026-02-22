# Lesson 5 — Content Types and Fields

## What You Will Learn
- What a content type is and how to create one
- What fields are and how to add them
- How to build a "Course" content type for the training portal

## Why This Matters
Content types are the most powerful concept in Drupal.
Mastering them lets you structure any kind of data — courses, events,
staff profiles, product listings — exactly as you need.

---

### 👁 Visual — See It

```
CONTENT TYPE: Course
┌─────────────────────────────────────────────────┐
│ Field Name        │ Field Type    │ Required     │
├───────────────────┼───────────────┼──────────────┤
│ Title             │ Text (plain)  │ Yes (auto)   │
│ Course Code       │ Text (plain)  │ Yes          │
│ Description       │ Text (long)   │ Yes          │
│ Level             │ List (select) │ Yes          │
│ Duration (hours)  │ Number        │ No           │
│ Thumbnail         │ Image         │ No           │
│ Category          │ Term ref.     │ Yes          │
│ Is Restricted     │ Boolean       │ No           │
└─────────────────────────────────────────────────┘

How a node relates to a content type:

Content Type (Course)     ←  defines shape
        │
        ▼
  Node 1: "Intro to Drupal"   ← one specific course
  Node 2: "Drupal Theming"    ← another course
  Node 3: "Views Deep Dive"   ← another course
```

---

### 🔊 Auditory — Understand It

A **content type** is a template. It defines *what information* a particular
kind of content must have.

Think of it as a **form**. A job application form has fields: Name, Address,
Qualifications. Every person who applies fills in the same fields but with
their own answers. A Drupal content type works the same way — you design
the form (the content type), and every piece of content of that type is one
filled-in form (a node).

The **field** is each individual input on that form. Drupal gives you many
field types:
- **Text (plain)** — short text like a title or code
- **Text (formatted)** — rich text with bold, links, images
- **Image** — upload an image file
- **Number** — integers or decimals
- **Boolean** — a true/false toggle (e.g., "Is this restricted?")
- **List** — a dropdown of predefined options
- **Entity reference** — link to another node, user, or taxonomy term
- **Link** — a URL with optional link text
- **File** — upload any file type

Once you define a content type and its fields, Drupal automatically
creates the admin form for adding content and the database columns for
storing it. You never write SQL — Drupal does it.

---

### ✋ Kinesthetic — Do It

**Create the "Course" content type:**

1. Go to **Structure > Content types > Add content type**
2. Fill in:
   - Name: `Course`
   - Description: `A training course in the portal`
3. Under **Submission form settings**, set "Title field label" to `Course Title`
4. Click **Save and manage fields**

**Add fields to the Course content type:**

```
Field 1: Course Code
  → Click "Add field"
  → Field type: Text (plain)
  → Label: Course Code
  → Machine name: field_course_code
  → Required: Yes
  → Max length: 20
  → Save

Field 2: Description
  → Add field > Text (formatted, long)
  → Label: Description
  → Required: Yes
  → Save

Field 3: Level
  → Add field > List (text)
  → Label: Level
  → Allowed values:
      beginner|Beginner
      intermediate|Intermediate
      advanced|Advanced
  → Required: Yes
  → Save

Field 4: Duration
  → Add field > Number (integer)
  → Label: Duration (hours)
  → Min value: 1
  → Save

Field 5: Thumbnail
  → Add field > Image
  → Label: Course Thumbnail
  → Allowed file extensions: png gif jpg jpeg webp
  → Save
```

**Create your first course node:**

1. Go to **Content > Add content > Course**
2. Fill in all fields
3. Save
4. View the course page — it should display all your fields

**Exercise checklist:**

- [ ] "Course" content type created
- [ ] All 5 fields added
- [ ] At least one course node created and viewable
- [ ] Course page shows the correct field values

---

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| Field not appearing on content form | Field added but display not set | Go to **Manage display** tab and enable the field |
| Dropdown shows blank option | "Required" not checked | Edit the field and check "Required field" |
| Image not uploading | File size limit | Increase `upload_max_filesize` in `.ddev/php/php.ini` |

## Quick Reference

```
Structure > Content types              → Manage content types
Structure > Content types > [type] > Manage fields  → Add/edit fields
Structure > Content types > [type] > Manage display → Control display order
Content > Add content > [type]         → Create a node of that type
```
