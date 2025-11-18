# Example 1: Basic n8n Setup

**Difficulty:** ⭐ Beginner  
**Estimated Setup Time:** 30 seconds  
**Use Case:** Development, testing, learning

---

## 📋 Overview

The simplest possible n8n setup using Docker Compose. Perfect for getting started quickly.

**What's included:**
- Single n8n container
- SQLite database (built-in, no external DB)
- Data persistence with Docker volumes
- Minimal configuration

**What's NOT included:**
- External database (uses SQLite)
- Redis / Queue mode
- Multiple workers
- Advanced security

---

## 🏗️ Architecture

```
┌─────────────────┐
│   User Browser  │
└────────┬────────┘
         │ :5678
         ▼
┌─────────────────┐
│   n8n Container │
│   ┌──────────┐  │
│   │  SQLite  │  │
│   └──────────┘  │
└─────────────────┘
         │
         ▼
┌─────────────────┐
│  Docker Volume  │
│   (n8n-data)    │
└─────────────────┘
```

---

## 🚀 Quick Start

### Step 1: Copy Files

```bash
# Create directory
mkdir ~/n8n-basic
cd ~/n8n-basic

# Copy docker-compose.yml from this example
```

### Step 2: Start n8n

```bash
docker compose up -d
```

### Step 3: Access n8n

Open in browser: `http://localhost:5678`

**That's it!** 🎉

---

## 📁 Files

### docker-compose.yml

```yaml
version: '3.8'

services:
  n8n:
    image: n8nio/n8n
    container_name: n8n
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - N8N_LOG_LEVEL=info
    volumes:
      - n8n-data:/home/node/.n8n

volumes:
  n8n-data:
    driver: local
```

### .env.example

```bash
# No environment variables needed for basic setup
# Copy this file to .env if you want to add custom config

# Optional: Set log level
# N8N_LOG_LEVEL=debug

# Optional: Set timezone
# GENERIC_TIMEZONE=America/New_York
```

---

## 🎯 Common Use Cases

### 1. Quick Testing

```bash
# Start
docker compose up -d

# Test your workflows

# Stop and remove
docker compose down
```

### 2. Learning n8n

Perfect for tutorials and experimentation without complex setup.

### 3. Local Development

Develop workflows locally before deploying to production.

---

## 🔧 Customization

### Change Port

Edit `docker-compose.yml`:

```yaml
ports:
  - "8080:5678"    # Access at localhost:8080
```

### Add Basic Authentication

Edit `docker-compose.yml`:

```yaml
environment:
  - N8N_LOG_LEVEL=info
  - N8N_BASIC_AUTH_ACTIVE=true
  - N8N_BASIC_AUTH_USER=admin
  - N8N_BASIC_AUTH_PASSWORD=your_password
```

### Enable Debug Logging

```yaml
environment:
  - N8N_LOG_LEVEL=debug
```

### Use Bind Mount Instead of Volume

```yaml
volumes:
  - ./n8n-data:/home/node/.n8n    # Data in local directory
```

---

## 📊 Resource Usage

Typical resource consumption:

```
CPU: 0.5-2%
Memory: 150-250 MB
Disk: ~100 MB (base) + workflows data
```

---

## ⚠️ Limitations

This basic setup has limitations:

❌ **Not suitable for production:**
- SQLite doesn't handle concurrent connections well
- Single point of failure
- No horizontal scaling
- Limited performance

❌ **Can't use queue mode:**
- No Redis
- No worker separation
- UI blocks during execution

❌ **No high availability:**
- Single container
- No redundancy

**For production, use:** [02-n8n-postgres](../02-n8n-postgres/) or [03-queue-mode-complete](../03-queue-mode-complete/)

---

## 🛠️ Management Commands

```bash
# Start n8n
docker compose up -d

# Stop n8n
docker compose stop

# Restart n8n
docker compose restart

# View logs
docker compose logs -f

# Access container shell
docker compose exec n8n sh

# Stop and remove container (keeps data)
docker compose down

# Remove everything including data
docker compose down -v
```

---

## 💾 Backup and Restore

### Backup

```bash
# Create backup directory
mkdir -p ~/backups

# Backup volume
docker run --rm \
  -v n8n-data:/data \
  -v ~/backups:/backup \
  alpine tar czf /backup/n8n-backup-$(date +%Y%m%d).tar.gz -C /data .
```

### Restore

```bash
# Restore from backup
docker run --rm \
  -v n8n-data:/data \
  -v ~/backups:/backup \
  alpine sh -c "cd /data && tar xzf /backup/n8n-backup-20241118.tar.gz"
```

---

## 🐛 Troubleshooting

### Port Already in Use

```bash
# Find process using port 5678
lsof -i :5678

# Change port in docker-compose.yml
ports:
  - "8080:5678"
```

### Can't Access n8n

```bash
# Check container is running
docker compose ps

# Check logs
docker compose logs

# Verify port mapping
docker ps
```

### Data Lost After Restart

Make sure you're using volumes:

```yaml
volumes:
  - n8n-data:/home/node/.n8n    # ← Must be present

volumes:
  n8n-data:                      # ← Must be declared
```

---

## ⬆️ Upgrade to Production

When ready for production:

### Option 1: Add PostgreSQL

See: [02-n8n-postgres](../02-n8n-postgres/)

### Option 2: Add Queue Mode

See: [03-queue-mode-complete](../03-queue-mode-complete/)

---

## ✅ Verification Checklist

- [ ] docker-compose.yml created
- [ ] Started with `docker compose up -d`
- [ ] Accessed http://localhost:5678
- [ ] Created test workflow
- [ ] Tested data persistence (restart container, workflows remain)
- [ ] Reviewed logs with `docker compose logs`

---

## 📚 Learn More

- [Docker Compose Basics](../../theory/01-what-is-compose.md)
- [Practice: Your First Compose File](../../practice/01-first-compose.md)
- [n8n Documentation](https://docs.n8n.io/)

---

**Next Example:** [02-n8n-postgres →](../02-n8n-postgres/)

**Back to:** [Examples Overview](../README.md)

