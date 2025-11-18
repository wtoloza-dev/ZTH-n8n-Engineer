# Example 2: n8n with PostgreSQL

**Difficulty:** ⭐⭐ Intermediate  
**Estimated Setup Time:** 2 minutes  
**Use Case:** Small to medium production deployments

---

## 📋 Overview

Production-ready n8n setup with PostgreSQL database.

**What's included:**
- n8n application server
- PostgreSQL 15 database
- Health checks for both services
- Environment variable management
- Data persistence with volumes
- Automatic service dependencies

**Improvements over basic setup:**
- ✅ PostgreSQL instead of SQLite (better performance, reliability)
- ✅ Production-grade database
- ✅ Health monitoring
- ✅ Proper startup ordering
- ✅ Secure credential management

---

## 🏗️ Architecture

```
┌─────────────────┐
│   User Browser  │
└────────┬────────┘
         │ :5678
         ▼
┌──────────────────────┐
│   n8n Container      │
│   - Workflows        │
│   - API              │
│   - Webhooks         │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ PostgreSQL Container │
│  - Workflows DB      │
│  - Credentials DB    │
│  - Executions DB     │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   Docker Volumes     │
│  - n8n-data          │
│  - postgres-data     │
└──────────────────────┘
```

---

## 🚀 Quick Start

### Step 1: Prepare Environment

```bash
# Create directory
mkdir ~/n8n-production
cd ~/n8n-production

# Copy docker-compose.yml and .env.example from this example
```

### Step 2: Configure Environment

```bash
# Copy environment template
cp .env.example .env

# Edit with your values
nano .env
```

**Important:** Set these values in `.env`:
```bash
POSTGRES_PASSWORD=your-secure-password-here
N8N_ENCRYPTION_KEY=$(openssl rand -base64 32)
```

### Step 3: Start the Stack

```bash
docker compose up -d
```

### Step 4: Access n8n

Open: `http://localhost:5678`

---

## 📁 Files

### docker-compose.yml

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: n8n-postgres
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-n8n}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB:-n8n}
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - n8n-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-n8n}"]
      interval: 10s
      timeout: 5s
      retries: 5

  n8n:
    image: n8nio/n8n
    container_name: n8n
    restart: unless-stopped
    ports:
      - "${N8N_PORT:-5678}:5678"
    environment:
      # Database
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=${POSTGRES_DB:-n8n}
      - DB_POSTGRESDB_USER=${POSTGRES_USER:-n8n}
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD}
      
      # n8n Configuration
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
      - N8N_HOST=${N8N_HOST:-localhost}
      - N8N_PROTOCOL=${N8N_PROTOCOL:-http}
      - N8N_PORT=5678
      - WEBHOOK_URL=${WEBHOOK_URL:-http://localhost:5678/}
      
      # Optional: Basic Authentication
      - N8N_BASIC_AUTH_ACTIVE=${N8N_BASIC_AUTH_ACTIVE:-false}
      - N8N_BASIC_AUTH_USER=${N8N_BASIC_AUTH_USER:-}
      - N8N_BASIC_AUTH_PASSWORD=${N8N_BASIC_AUTH_PASSWORD:-}
      
      # Logging
      - N8N_LOG_LEVEL=${N8N_LOG_LEVEL:-info}
    volumes:
      - n8n-data:/home/node/.n8n
    networks:
      - n8n-network
    depends_on:
      postgres:
        condition: service_healthy

volumes:
  postgres-data:
    driver: local
  n8n-data:
    driver: local

networks:
  n8n-network:
    driver: bridge
```

### .env Template

Create `.env` from this template:

```bash
# PostgreSQL Configuration
POSTGRES_USER=n8n
POSTGRES_PASSWORD=CHANGE_THIS_SECURE_PASSWORD
POSTGRES_DB=n8n

# n8n Configuration
N8N_ENCRYPTION_KEY=GENERATE_WITH_openssl_rand_base64_32
N8N_HOST=localhost
N8N_PROTOCOL=http
N8N_PORT=5678
WEBHOOK_URL=http://localhost:5678/

# Optional: Basic Authentication
N8N_BASIC_AUTH_ACTIVE=false
N8N_BASIC_AUTH_USER=
N8N_BASIC_AUTH_PASSWORD=

# Optional: Logging
N8N_LOG_LEVEL=info
```

---

## 🔐 Security Setup

### 1. Generate Encryption Key

```bash
openssl rand -base64 32
```

Add to `.env`:
```bash
N8N_ENCRYPTION_KEY=your-generated-key-here
```

### 2. Set Strong Database Password

```bash
openssl rand -base64 24
```

Add to `.env`:
```bash
POSTGRES_PASSWORD=your-generated-password-here
```

### 3. Enable Basic Authentication (Optional)

In `.env`:
```bash
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=your-secure-password
```

### 4. Protect .env File

```bash
# Never commit .env
echo ".env" >> .gitignore

# Restrict permissions
chmod 600 .env
```

---

## 🛠️ Management Commands

### Start Stack

```bash
docker compose up -d
```

### View Logs

```bash
# All services
docker compose logs -f

# n8n only
docker compose logs -f n8n

# PostgreSQL only
docker compose logs -f postgres
```

### Check Service Health

```bash
docker compose ps
```

### Restart Services

```bash
# Restart all
docker compose restart

# Restart n8n only
docker compose restart n8n
```

### Stop Stack

```bash
docker compose stop
```

### Remove Stack (keeps data)

```bash
docker compose down
```

### Remove Everything (including data)

```bash
docker compose down -v
```

---

## 💾 Backup and Restore

### Backup PostgreSQL Database

```bash
# Create backup directory
mkdir -p ~/backups

# Backup database
docker compose exec postgres pg_dump -U n8n n8n > ~/backups/n8n-db-$(date +%Y%m%d).sql

# Or use pg_dumpall for all databases
docker compose exec postgres pg_dumpall -U n8n > ~/backups/n8n-all-$(date +%Y%m%d).sql
```

### Backup n8n Data Volume

```bash
docker run --rm \
  -v n8n-production_n8n-data:/data \
  -v ~/backups:/backup \
  alpine tar czf /backup/n8n-data-$(date +%Y%m%d).tar.gz -C /data .
```

### Restore Database

```bash
# Stop n8n first
docker compose stop n8n

# Restore database
docker compose exec -T postgres psql -U n8n n8n < ~/backups/n8n-db-20241118.sql

# Start n8n
docker compose start n8n
```

### Automated Backup Script

Create `backup.sh`:

```bash
#!/bin/bash
BACKUP_DIR=~/backups
DATE=$(date +%Y%m%d-%H%M%S)

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Backup PostgreSQL
docker compose exec postgres pg_dump -U n8n n8n > "$BACKUP_DIR/n8n-db-$DATE.sql"

# Backup n8n data
docker run --rm \
  -v n8n-production_n8n-data:/data \
  -v "$BACKUP_DIR:/backup" \
  alpine tar czf "/backup/n8n-data-$DATE.tar.gz" -C /data .

# Keep only last 7 backups
find "$BACKUP_DIR" -name "n8n-*.sql" -mtime +7 -delete
find "$BACKUP_DIR" -name "n8n-*.tar.gz" -mtime +7 -delete

echo "Backup completed: $DATE"
```

Make executable:
```bash
chmod +x backup.sh
```

Schedule with cron:
```bash
# Run daily at 2 AM
0 2 * * * /path/to/backup.sh >> /var/log/n8n-backup.log 2>&1
```

---

## 🔍 Database Management

### Connect to PostgreSQL

```bash
docker compose exec postgres psql -U n8n -d n8n
```

### Useful SQL Queries

```sql
-- List all tables
\dt

-- Count workflows
SELECT COUNT(*) FROM workflow_entity;

-- View recent executions
SELECT id, workflow_id, finished, mode 
FROM execution_entity 
ORDER BY "startedAt" DESC 
LIMIT 10;

-- Check database size
SELECT pg_size_pretty(pg_database_size('n8n'));

-- Exit
\q
```

---

## 📊 Monitoring

### Check Resource Usage

```bash
docker compose stats
```

### Monitor Logs in Real-Time

```bash
docker compose logs -f --tail=100
```

### Health Check Status

```bash
docker compose ps
```

Look for `(healthy)` status on PostgreSQL.

---

## 🔧 Troubleshooting

### n8n Can't Connect to Database

**Check PostgreSQL is healthy:**
```bash
docker compose ps postgres
```

**View PostgreSQL logs:**
```bash
docker compose logs postgres
```

**Test connectivity:**
```bash
docker compose exec n8n nc -zv postgres 5432
```

### "Password authentication failed"

**Verify environment variables match:**
```bash
docker compose exec postgres env | grep POSTGRES
docker compose exec n8n env | grep POSTGRES
```

**Recreate containers:**
```bash
docker compose down
docker compose up -d
```

### Database Schema Issues

**Reset database (⚠️ DELETES ALL DATA):**
```bash
docker compose down -v
docker compose up -d
```

### Performance Issues

**Check database connections:**
```sql
SELECT COUNT(*) FROM pg_stat_activity WHERE datname = 'n8n';
```

**Optimize database:**
```bash
docker compose exec postgres vacuumdb -U n8n -d n8n --analyze
```

---

## ⚡ Performance Tuning

### PostgreSQL Configuration

For better performance, tune PostgreSQL. Create `postgres-custom.conf`:

```ini
# Memory
shared_buffers = 256MB
effective_cache_size = 1GB
maintenance_work_mem = 64MB
work_mem = 16MB

# Checkpoints
checkpoint_completion_target = 0.9
wal_buffers = 16MB

# Query planning
random_page_cost = 1.1
effective_io_concurrency = 200
```

Mount in `docker-compose.yml`:

```yaml
postgres:
  volumes:
    - postgres-data:/var/lib/postgresql/data
    - ./postgres-custom.conf:/etc/postgresql/postgresql.conf
  command: postgres -c config_file=/etc/postgresql/postgresql.conf
```

---

## ⬆️ Upgrading

### Update n8n

```bash
# Pull latest images
docker compose pull

# Recreate containers with new images
docker compose up -d
```

### Update PostgreSQL (major version)

⚠️ **Requires database migration!**

See: [PostgreSQL Upgrade Documentation](https://www.postgresql.org/docs/current/upgrading.html)

---

## ✅ Production Checklist

Before going to production:

- [ ] Set strong `POSTGRES_PASSWORD`
- [ ] Generate secure `N8N_ENCRYPTION_KEY`
- [ ] Enable `N8N_BASIC_AUTH_ACTIVE` or use OAuth
- [ ] Set correct `N8N_HOST` and `WEBHOOK_URL`
- [ ] Configure HTTPS (use reverse proxy)
- [ ] Set up automated backups
- [ ] Configure log rotation
- [ ] Monitor resource usage
- [ ] Test restore procedure
- [ ] Document your setup

---

## 📈 Scaling Options

When you outgrow this setup:

### Horizontal Scaling

Add queue mode with Redis: [03-queue-mode-complete](../03-queue-mode-complete/)

### Database Scaling

- Use dedicated PostgreSQL server
- Enable replication
- Configure connection pooling

---

## 📚 Learn More

- [Theory: Compose for n8n](../../theory/04-compose-for-n8n.md)
- [Practice: n8n + PostgreSQL](../../practice/02-n8n-postgres-compose.md)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

**Next Example:** [03-queue-mode-complete →](../03-queue-mode-complete/)

**Back to:** [Examples Overview](../README.md)

