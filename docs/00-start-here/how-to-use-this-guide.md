# How to Use This Guide

Welcome to the Drupal Training Portal.
This guide is designed so that **anyone** — even with no prior CMS experience — can
build, manage, and deploy a Drupal website confidently.

---

## Step 1 — Know Your Level

**Beginner** — Start in `docs/01-beginner/`
You have never used Drupal before, or you have poked around the admin panel but
feel unsure. You will learn what every button does and why.

**Intermediate** — Start in `docs/02-intermediate/`
You can create content in Drupal and have used Views or basic modules before.
You want to go deeper: custom content types, roles, config management, deployment.

---

## Step 2 — Know Your Learning Style (VAK)

Each lesson is tagged with three sections.
You do not have to read all three — go to the one that works for you first,
then use the others to fill gaps.

```
👁  VISUAL   — Look at the diagram or screenshot before reading anything.
               If you understand it, skim the text.

🔊  AUDITORY  — Read the explanation out loud or have it read to you.
               Follow the narrated walkthrough step by step.

✋  KINESTHETIC — Jump straight to the "Try It" exercise.
               Learn by doing and refer back to the explanation only when stuck.
```

---

## Step 3 — Follow the Order (First Time)

If this is your first time, go through lessons in order.
Each one builds on the previous. Skipping ahead is fine for reference,
but the exercises assume you have completed earlier steps.

---

## Step 4 — Use the Scripts Folder

The `scripts/` folder contains shell scripts that automate common tasks.
When a lesson says "run the setup script", you will find it there.

```bash
# Example — run the DDEV quick-start script
bash scripts/ddev-quickstart.sh
```

---

## Step 5 — Sync Your Work to GitHub

Every change you make locally should be committed and pushed:

```bash
git add .
git commit -m "Completed lesson: install DDEV"
git push origin main
```

Your progress is saved and portable to any machine.

---

## Lesson Format

Every lesson follows this structure:

```
# Lesson Title

## What You Will Learn       ← Goal of the lesson
## Why This Matters          ← Context and motivation

---

### 👁 Visual — See It       ← Diagram / screenshot / folder tree

### 🔊 Auditory — Understand It  ← Narrated explanation

### ✋ Kinesthetic — Do It    ← Hands-on exercise with checklist

---

## Troubleshooting           ← Common errors and fixes
## Quick Reference           ← Commands or settings to remember
```

---

## Getting Help

- Open an issue: https://github.com/sufideen/drupal-training-portal/issues
- Drupal official docs: https://www.drupal.org/documentation
- DDEV docs: https://ddev.readthedocs.io
