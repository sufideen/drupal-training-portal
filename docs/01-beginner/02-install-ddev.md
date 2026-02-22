# Lesson 2 — Install DDEV (Your Local Development Environment)

## What You Will Learn
- What DDEV is and why developers use it instead of installing Apache/PHP manually
- How to install Docker and DDEV on Linux, macOS, or Windows
- How to verify your installation is working

## Why This Matters
DDEV gives you a complete server environment (PHP, MySQL, Nginx) running inside
Docker containers on your own machine. This means:
- No conflicts with other software on your computer
- One command to start your entire Drupal environment
- Identical setup across your machine, a colleague's machine, and any server

---

### 👁 Visual — See It

```
Your Computer
┌──────────────────────────────────────────────────┐
│                                                  │
│   DDEV (manages Docker containers)               │
│   ┌─────────────────────────────────────────┐   │
│   │  web container   │   db container        │   │
│   │  Nginx + PHP 8.3 │   MySQL 8.0           │   │
│   │                  │                       │   │
│   │  Runs Drupal     │   Stores your data    │   │
│   └──────────────────┴───────────────────────┘   │
│                                                  │
│   Browser → https://mysite.ddev.site             │
│          (works only on your machine)            │
│                                                  │
└──────────────────────────────────────────────────┘
```

**What gets installed — in order:**

```
Step 1: Docker Desktop    ← The container engine (required by DDEV)
Step 2: DDEV              ← The tool that manages your Drupal containers
Step 3: Composer          ← PHP dependency manager (downloads Drupal)
Step 4: (Optional) Git    ← Already installed on most systems
```

---

### 🔊 Auditory — Understand It

Docker is like a **portable, sealed box** that contains an entire mini-server.
The box has its own operating system, PHP, MySQL, and Nginx — completely
isolated from your main computer.

DDEV is the **remote control** for that box. Instead of manually configuring
each container, you run `ddev start` and DDEV does everything for you:
creates the containers, connects them, sets up HTTPS, and gives you a
working URL like `https://my-drupal-site.ddev.site`.

When you are done working, `ddev stop` shuts the containers down.
Your code and database are preserved — nothing is lost.

The URL `*.ddev.site` is a wildcard DNS entry that points to `127.0.0.1`
(your own machine). It only works while DDEV is running.

---

### ✋ Kinesthetic — Do It

#### Linux (Ubuntu/Debian)

```bash
# 1. Install Docker (if not already installed)
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add your user to the docker group (no sudo needed for docker)
sudo usermod -aG docker $USER
newgrp docker

# 2. Install DDEV
curl -fsSL https://ddev.com/install.sh | bash

# 3. Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"
```

#### macOS

```bash
brew install --cask docker        # Install Docker Desktop
brew install ddev/ddev/ddev       # Install DDEV
brew install composer             # Install Composer
```

#### Windows (WSL2)

```powershell
# In PowerShell as Administrator:
wsl --install                     # Enable WSL2
# Then open Ubuntu from Start Menu and run the Linux commands above
```

#### Verify Everything Works

```bash
docker --version
# Expected: Docker version 26.x.x or higher

ddev version
# Expected: DDEV version 1.23.x or higher

composer --version
# Expected: Composer version 2.x.x

git --version
# Expected: git version 2.x.x
```

**Exercise checklist:**

- [ ] Docker is installed and running (Docker icon visible in system tray / menu bar)
- [ ] `docker ps` runs without error
- [ ] `ddev version` shows a version number
- [ ] `composer --version` shows version 2.x
- [ ] `git --version` shows a version number

---

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| `docker: permission denied` | User not in docker group | Run `sudo usermod -aG docker $USER` then log out and back in |
| `ddev: command not found` | DDEV install path not in `$PATH` | Run `source ~/.bashrc` or open a new terminal |
| DDEV start fails with port conflict | Port 80 or 443 in use | Run `sudo lsof -i :80` to find what's using port 80, stop it |
| Composer not found | Install path wrong | Run `which composer`; if empty, re-run the install step |

## Quick Reference

```bash
docker ps              # List running containers
ddev version           # Show DDEV version
ddev start             # Start DDEV environment
ddev stop              # Stop DDEV environment
ddev poweroff          # Stop ALL DDEV projects
```
