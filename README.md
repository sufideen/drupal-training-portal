# Drupal Training Portal

**A structured, hands-on training guide for Drupal admins and developers**
Built for **beginner and intermediate** learners using the **VAK learning model**
(Visual · Auditory · Kinesthetic)

> Developed locally with DDEV · Synced to GitHub · Deployable to GoDaddy, AWS, or Google Cloud

---

## Who This Is For

| Level | You can... | Start here |
|-------|-----------|------------|
| **Beginner** | Use a computer, browse the web | [docs/01-beginner](docs/01-beginner/) |
| **Intermediate** | Comfortable with terminal, some PHP/HTML | [docs/02-intermediate](docs/02-intermediate/) |

---

## How This Guide Is Structured (VAK Model)

Every lesson includes three learning modes so you absorb content your way:

| Symbol | Style | What it means |
|--------|-------|---------------|
| 👁 **Visual** | See it | Diagrams, folder trees, before/after screenshots, flow charts |
| 🔊 **Auditory** | Hear/read it | Step-by-step narrated explanations, "think aloud" walkthroughs |
| ✋ **Kinesthetic** | Do it | Hands-on tasks, exercises, checklists you complete yourself |

---

## Learning Path

```
START HERE
    │
    ▼
docs/00-start-here/
    ├── how-to-use-this-guide.md      ← Read this first
    └── vak-learning-explained.md     ← Understand your style
    │
    ▼
docs/01-beginner/
    ├── 01-what-is-drupal.md
    ├── 02-install-ddev.md
    ├── 03-create-your-first-site.md
    ├── 04-drupal-admin-tour.md
    ├── 05-content-types-and-fields.md
    ├── 06-menus-and-blocks.md
    └── 07-install-a-theme.md
    │
    ▼
docs/02-intermediate/
    ├── 01-views-and-displays.md
    ├── 02-custom-content-types.md
    ├── 03-user-roles-and-permissions.md
    ├── 04-paragraphs-module.md
    ├── 05-media-management.md
    └── 06-config-management.md
    │
    ▼
docs/03-themes/
    ├── 01-understanding-drupal-themes.md
    ├── 02-install-bootstrap-barrio.md
    └── 03-build-a-custom-subtheme.md
    │
    ▼
docs/04-deployment/
    ├── 01-git-workflow-and-github-sync.md
    ├── 02-deploy-to-godaddy.md
    ├── 03-deploy-to-aws.md
    └── 04-deploy-to-google-cloud.md
    │
    ▼
docs/05-security/
    ├── 01-harden-drupal.md
    └── 02-ssl-and-access-control.md
```

---

## Quick Start

```bash
# Clone this repo
git clone https://github.com/sufideen/drupal-training-portal.git
cd drupal-training-portal

# Follow the setup guide
open docs/00-start-here/how-to-use-this-guide.md
```

---

## Tech Stack

| Component | Technology |
|-----------|-----------|
| CMS | Drupal 10 / 11 |
| Local dev | DDEV + Docker |
| Version control | Git + GitHub |
| Shared hosting | GoDaddy cPanel |
| Cloud option A | AWS (Lightsail / ECS) |
| Cloud option B | Google Cloud (Cloud Run) |
| Theme | Bootstrap Barrio + custom sub-theme |
| PHP | 8.3 |
| Database | MySQL 8.0 |

---

## Repository Owner

**GitHub:** [@sufideen](https://github.com/sufideen)
**License:** MIT — free to use, adapt, and share

---

## Contributing

Pull requests welcome. Please follow the VAK format when adding lessons:
include a visual diagram, a written explanation, and a hands-on exercise.
