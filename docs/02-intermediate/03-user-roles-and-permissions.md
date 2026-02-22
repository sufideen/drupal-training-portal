# Lesson 3 (Intermediate) — User Roles and Permissions

## What You Will Learn
- How Drupal's permission system works
- How to create roles for the training portal
- How to restrict content to specific roles
- How to manage user accounts

## Why This Matters
A training portal needs controlled access. Students should see courses
but not edit them. Instructors should create lessons. Admins should control
everything. Getting roles right is essential before launching.

---

### 👁 Visual — See It

```
ROLE HIERARCHY — Training Portal

Anonymous user          ← Not logged in
  Can: View public pages, login page
  Cannot: See courses, enroll

Student                 ← Default authenticated user
  Can: View courses, download resources, post in forums
  Cannot: Create/edit content, access admin

Instructor              ← Elevated role
  Can: Everything Student can + create/edit courses and lessons
  Cannot: Manage users, change site config

Moderator               ← Content oversight
  Can: Everything Instructor can + edit/delete any content, manage comments
  Cannot: Change site configuration, manage roles

Administrator           ← Full control
  Can: Everything
  Cannot: Nothing — full access

PERMISSION INHERITANCE: Roles do NOT inherit from each other in Drupal.
Each role gets its own explicit list of permissions.
```

**Permission matrix for the training portal:**

```
Permission                    | Anon | Student | Instructor | Mod | Admin
------------------------------|------|---------|------------|-----|------
View published courses        |  No  |   Yes   |    Yes     | Yes |  Yes
Create Course nodes           |  No  |   No    |    Yes     | Yes |  Yes
Edit own Course nodes         |  No  |   No    |    Yes     | Yes |  Yes
Edit any Course nodes         |  No  |   No    |    No      | Yes |  Yes
Delete any Course nodes       |  No  |   No    |    No      | Yes |  Yes
Administer users              |  No  |   No    |    No      | No  |  Yes
Administer permissions        |  No  |   No    |    No      | No  |  Yes
Access administration pages   |  No  |   No    |    No      | Yes |  Yes
```

---

### 🔊 Auditory — Understand It

Drupal uses a **flat role system** — not hierarchical.
Each role is a bucket of permissions. A user can have multiple roles,
and they receive the union of all permissions from all their roles.

There are two built-in roles you cannot delete:
- **Anonymous user** — anyone not logged in
- **Authenticated user** — anyone who is logged in, regardless of other roles

Every role you create is *additional* to "Authenticated user". So if you
give "Authenticated user" the permission to view courses, every logged-in
user — Students, Instructors, Moderators — automatically inherits that.

The key rule: **start with the least access, add permissions as needed**.
Never give a role more than it requires. This is the principle of
least privilege and it prevents accidents and security issues.

---

### ✋ Kinesthetic — Do It

**Step 1 — Create the Roles**

```bash
# Via Drush (fastest)
ddev drush role:create student "Student"
ddev drush role:create instructor "Instructor"
ddev drush role:create moderator "Moderator"
```

Or via UI: **Configuration > People > Roles > Add role**

**Step 2 — Set Permissions via UI**

Go to **Configuration > People > Permissions** (`/admin/people/permissions`)

For **Authenticated user**, enable:
- [ ] View published content
- [ ] Use the site-wide contact form

For **Student**, enable:
- [ ] Post comments
- [ ] Edit own comments

For **Instructor**, enable all Student permissions plus:
- [ ] Course: Create new content
- [ ] Course: Edit own content
- [ ] Lesson: Create new content
- [ ] Lesson: Edit own content
- [ ] Use the administration toolbar (admin_toolbar module)

For **Moderator**, enable all Instructor permissions plus:
- [ ] Course: Edit any content
- [ ] Course: Delete any content
- [ ] Administer comments
- [ ] Access the Content overview page

**Step 3 — Assign Roles to Users via Drush**

```bash
# Add a role to a user
ddev drush user:role:add instructor admin

# Create a test student user
ddev drush user:create student1 \
  --password="Student1234!" \
  --mail="student1@training.local"
ddev drush user:role:add student student1

# Create a test instructor
ddev drush user:create instructor1 \
  --password="Instructor1234!" \
  --mail="instructor1@training.local"
ddev drush user:role:add instructor instructor1

# List all users
ddev drush user:list
```

**Step 4 — Restrict Content Type Access**

Install the Content Access module:

```bash
ddev composer require drupal/content_access
ddev drush en content_access -y
```

Go to **Structure > Content types > Course > Access control**:
- View any content: check Student, Instructor, Moderator, Administrator
- Uncheck Anonymous user (courses are internal)

**Step 5 — Test Your Permissions**

Open a private/incognito browser window:
1. Go to your site without logging in — can you see courses? (Should be: No)
2. Log in as `student1` — can you see courses? (Should be: Yes)
3. Try to go to `/admin` — are you blocked? (Should be: Yes, access denied)
4. Log in as `instructor1` — can you create a course? (Should be: Yes)

**Exercise checklist:**

- [ ] Three custom roles created (Student, Instructor, Moderator)
- [ ] Permissions configured for each role
- [ ] Test users created and assigned to roles
- [ ] Anonymous users cannot view courses
- [ ] Students can view but not create courses
- [ ] Instructors can create and edit their own courses
- [ ] Permission test with incognito browser passed

---

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| User sees "Access denied" after role assigned | Cache | `ddev drush cr` — permissions are cached |
| Cannot find content type permissions | Content Access not installed | `ddev drush en content_access -y` |
| Admin toolbar not showing for Instructor | Missing permission | Grant "Use the administration toolbar" to Instructor role |
| Roles not appearing in permissions table | Roles not created yet | Create roles first via People > Roles |

## Quick Reference

```bash
ddev drush role:list                      # List all roles
ddev drush role:create [name] "[Label]"   # Create role
ddev drush user:role:add [role] [user]    # Add role to user
ddev drush user:role:remove [role] [user] # Remove role from user
ddev drush user:list                      # List all users
ddev drush user:block [username]          # Block a user account
ddev drush user:unblock [username]        # Unblock a user account
```
