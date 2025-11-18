# Example 3: Complete Queue Mode Stack

**Difficulty:** ⭐⭐⭐ Advanced  
**Estimated Setup Time:** 5 minutes  
**Use Case:** Enterprise production, high-traffic deployments

---

## 📋 Overview

Production-grade n8n deployment with queue mode, enabling horizontal scaling and high availability.

**What's included:**
- n8n main instance (UI + webhook receiver)
- Multiple n8n workers (scalable execution)
- PostgreSQL database
- Redis queue
- Complete health monitoring
- Production security settings
- Horizontal scaling support

**Capabilities:**
- ✅ Non-blocking UI (queue mode)
- ✅ Horizontal scaling (add/remove workers dynamically)
- ✅ High availability
- ✅ Job distribution across workers
- ✅ Failure recovery
- ✅ Production-ready security

---

## 🏗️ Architecture

```
                    Internet
                       │
                       ▼
         ┌─────────────────────────┐
         │  n8n-main (Port 5678)   │
         │  - UI/Editor            │
         │  - API                  │
         │  - Webhooks             │
         │  - Job Scheduler        │
         └──────────┬──────────────┘
                    │
         ┌──────────┴──────────┐
         │                     │
         ▼                     ▼
   ┌──────────┐         ┌──────────┐
   │PostgreSQL│         │  Redis   │
   │  - DB    │         │ - Queue  │
   └─────┬────┘         └─────┬────┘
         │                    │
         └────────┬───────────┘
                  │
      ┌───────────┼───────────┐
      │           │           │
      ▼           ▼           ▼
┌──────────┐┌──────────┐┌──────────┐
│ worker-1 ││ worker-2 ││ worker-N │
│          ││          ││          │
│Executes  ││Executes  ││Executes  │
│workflows ││workflows ││workflows │
└──────────┘└──────────┘└──────────┘
```

**Job Flow:**
1. User triggers workflow via UI/webhook
2. n8n-main schedules job in Redis queue
3. Available worker picks up job
4. Worker executes workflow
5. Worker stores results in PostgreSQL
6. UI remains responsive throughout

---

## 🚀 Quick Start

### Step 1: Setup Directory

```bash
mkdir ~/n8n-enterprise
cd ~/n8n-enterprise

# Copy docker-compose.yml from this example
```

### Step 2: Configure Environment

```bash
# Copy template
cp .env.example .env

# Generate secrets
echo "POSTGRES_PASSWORD=$(openssl rand -base64 24)" >> .env
echo "REDIS_PASSWORD=$(openssl rand -base64 24)" >> .env
echo "N8N_ENCRYPTION_KEY=$(openssl rand -base64 32)" >> .env

# Edit remaining variables
nano .env
```

### Step 3: Start Stack

```bash
docker compose up -d
```

### Step 4: Scale Workers

```bash
# Start with 3 workers
docker compose up -d --scale n8n-worker=3
```

### Step 5: Access n8n

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
      - n8n-internal
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-n8n}"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: n8n-redis
    restart: unless-stopped
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis-data:/data
    networks:
      - n8n-internal
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  n8n-main:
    image: n8nio/n8n:${N8N_VERSION:-latest}
    container_name: n8n-main
    restart: unless-stopped
    ports:
      - "${N8N_PORT:-5678}:5678"
    environment:
      # Database Configuration
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=${POSTGRES_DB:-n8n}
      - DB_POSTGRESDB_USER=${POSTGRES_USER:-n8n}
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD}
      
      # Queue Configuration
      - EXECUTIONS_MODE=queue
      - QUEUE_BULL_REDIS_HOST=redis
      - QUEUE_BULL_REDIS_PORT=6379
      - QUEUE_BULL_REDIS_PASSWORD=${REDIS_PASSWORD}
      - QUEUE_BULL_REDIS_DB=${REDIS_DB:-0}
      - QUEUE_BULL_REDIS_TIMEOUT_THRESHOLD=${REDIS_TIMEOUT:-10000}
      
      # n8n Configuration
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
      - N8N_HOST=${N8N_HOST:-localhost}
      - N8N_PROTOCOL=${N8N_PROTOCOL:-http}
      - N8N_PORT=5678
      - WEBHOOK_URL=${WEBHOOK_URL:-http://localhost:5678/}
      
      # Authentication
      - N8N_BASIC_AUTH_ACTIVE=${N8N_BASIC_AUTH_ACTIVE:-true}
      - N8N_BASIC_AUTH_USER=${N8N_BASIC_AUTH_USER}
      - N8N_BASIC_AUTH_PASSWORD=${N8N_BASIC_AUTH_PASSWORD}
      
      # Logging and Performance
      - N8N_LOG_LEVEL=${N8N_LOG_LEVEL:-info}
      - N8N_LOG_OUTPUT=${N8N_LOG_OUTPUT:-console}
      - EXECUTIONS_DATA_SAVE_ON_ERROR=${EXECUTIONS_DATA_SAVE_ON_ERROR:-all}
      - EXECUTIONS_DATA_SAVE_ON_SUCCESS=${EXECUTIONS_DATA_SAVE_ON_SUCCESS:-all}
      - EXECUTIONS_DATA_SAVE_MANUAL_EXECUTIONS=${EXECUTIONS_DATA_SAVE_MANUAL_EXECUTIONS:-true}
      
      # Timezone
      - GENERIC_TIMEZONE=${TIMEZONE:-UTC}
      - TZ=${TIMEZONE:-UTC}
    volumes:
      - n8n-data:/home/node/.n8n
    networks:
      - n8n-internal
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "wget", "--spider", "-q", "http://localhost:5678/healthz"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s

  n8n-worker:
    image: n8nio/n8n:${N8N_VERSION:-latest}
    restart: unless-stopped
    command: worker
    environment:
      # Database Configuration
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=${POSTGRES_DB:-n8n}
      - DB_POSTGRESDB_USER=${POSTGRES_USER:-n8n}
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD}
      
      # Queue Configuration
      - EXECUTIONS_MODE=queue
      - QUEUE_BULL_REDIS_HOST=redis
      - QUEUE_BULL_REDIS_PORT=6379
      - QUEUE_BULL_REDIS_PASSWORD=${REDIS_PASSWORD}
      - QUEUE_BULL_REDIS_DB=${REDIS_DB:-0}
      - QUEUE_BULL_REDIS_TIMEOUT_THRESHOLD=${REDIS_TIMEOUT:-10000}
      
      # Worker Configuration
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
      - EXECUTIONS_PROCESS=main
      
      # Logging
      - N8N_LOG_LEVEL=${N8N_LOG_LEVEL:-info}
      - N8N_LOG_OUTPUT=${N8N_LOG_OUTPUT:-console}
      
      # Timezone
      - GENERIC_TIMEZONE=${TIMEZONE:-UTC}
      - TZ=${TIMEZONE:-UTC}
    networks:
      - n8n-internal
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy

volumes:
  postgres-data:
    driver: local
  redis-data:
    driver: local
  n8n-data:
    driver: local

networks:
  n8n-internal:
    driver: bridge
```

### .env Template

```bash
# PostgreSQL Configuration
POSTGRES_USER=n8n
POSTGRES_PASSWORD=GENERATE_SECURE_PASSWORD
POSTGRES_DB=n8n

# Redis Configuration
REDIS_PASSWORD=GENERATE_SECURE_PASSWORD
REDIS_DB=0
REDIS_TIMEOUT=10000

# n8n Configuration
N8N_VERSION=latest
N8N_ENCRYPTION_KEY=GENERATE_WITH_openssl_rand_base64_32
N8N_HOST=localhost
N8N_PROTOCOL=http
N8N_PORT=5678
WEBHOOK_URL=http://localhost:5678/

# Authentication
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=CHANGE_THIS_PASSWORD

# Logging
N8N_LOG_LEVEL=info
N8N_LOG_OUTPUT=console

# Execution Data
EXECUTIONS_DATA_SAVE_ON_ERROR=all
EXECUTIONS_DATA_SAVE_ON_SUCCESS=all
EXECUTIONS_DATA_SAVE_MANUAL_EXECUTIONS=true

# Timezone
TIMEZONE=UTC
```

---

## 🛠️ Management Commands

### Start Stack with 1 Worker

```bash
docker compose up -d
```

### Scale to Multiple Workers

```bash
# 3 workers
docker compose up -d --scale n8n-worker=3

# 5 workers
docker compose up -d --scale n8n-worker=5

# 10 workers
docker compose up -d --scale n8n-worker=10
```

### Check Status

```bash
docker compose ps
```

### View Logs

```bash
# All services
docker compose logs -f

# Main instance only
docker compose logs -f n8n-main

# All workers
docker compose logs -f n8n-worker

# Specific worker
docker logs n8n-enterprise-n8n-worker-1 -f
```

### Restart Services

```bash
# Restart all
docker compose restart

# Restart main only
docker compose restart n8n-main

# Restart all workers
docker compose restart n8n-worker
```

### Stop Everything

```bash
docker compose down
```

---

## 📊 Monitoring

### Resource Usage

```bash
docker compose stats
```

### Worker Activity

```bash
# View logs from all workers
docker compose logs -f --tail=50 n8n-worker
```

### Redis Queue Status

```bash
# Connect to Redis
docker compose exec redis redis-cli -a $REDIS_PASSWORD

# Check queue length
LLEN bull:n8n:wait

# Check active jobs
LLEN bull:n8n:active

# List all keys
KEYS bull:n8n:*

# Exit
exit
```

### PostgreSQL Monitoring

```bash
# Connect to database
docker compose exec postgres psql -U n8n -d n8n

# Active workflows
SELECT COUNT(*) FROM workflow_entity WHERE active = true;

# Recent executions
SELECT 
  id, 
  workflow_id, 
  mode, 
  finished, 
  "startedAt", 
  "stoppedAt"
FROM execution_entity 
ORDER BY "startedAt" DESC 
LIMIT 10;

# Database size
SELECT pg_size_pretty(pg_database_size('n8n'));

# Exit
\q
```

---

## 🎯 Performance Testing

### Load Test with Multiple Workflows

1. Create a test workflow:
```javascript
// Code node
const workerId = process.env.HOSTNAME;
const delay = Math.random() * 3000;
await new Promise(r => setTimeout(r, delay));
return {
  worker: workerId,
  delay: Math.round(delay),
  timestamp: new Date().toISOString()
};
```

2. Create webhook trigger
3. Execute 50 times simultaneously
4. Watch load distribution:

```bash
docker compose logs -f n8n-worker | grep "Job"
```

### Monitor Worker Distribution

```bash
# Count jobs per worker
docker compose logs n8n-worker | grep "Job completed" | awk '{print $2}' | sort | uniq -c
```

---

## 🔧 Advanced Configuration

### Limit Worker Concurrency

Add to worker environment:

```yaml
n8n-worker:
  environment:
    - N8N_CONCURRENCY_PRODUCTION_LIMIT=10
```

### Add Resource Limits

```yaml
n8n-worker:
  deploy:
    resources:
      limits:
        cpus: '1.0'
        memory: 1G
      reservations:
        cpus: '0.25'
        memory: 256M
```

### Configure Redis Persistence

```yaml
redis:
  command: >
    redis-server 
    --requirepass ${REDIS_PASSWORD}
    --appendonly yes
    --save 60 1000
```

---

## 💾 Backup Strategy

### Automated Backup Script

Create `backup.sh`:

```bash
#!/bin/bash
set -e

BACKUP_DIR=~/backups/n8n
DATE=$(date +%Y%m%d-%H%M%S)
mkdir -p "$BACKUP_DIR"

echo "Starting backup at $DATE"

# Backup PostgreSQL
echo "Backing up PostgreSQL..."
docker compose exec -T postgres pg_dump -U n8n n8n | gzip > "$BACKUP_DIR/postgres-$DATE.sql.gz"

# Backup Redis
echo "Backing up Redis..."
docker compose exec redis redis-cli -a $(grep REDIS_PASSWORD .env | cut -d= -f2) --rdb /data/dump.rdb BGSAVE
sleep 5
docker compose exec redis cat /data/dump.rdb | gzip > "$BACKUP_DIR/redis-$DATE.rdb.gz"

# Backup n8n data volume
echo "Backing up n8n data..."
docker run --rm \
  -v n8n-enterprise_n8n-data:/data \
  -v "$BACKUP_DIR:/backup" \
  alpine tar czf "/backup/n8n-data-$DATE.tar.gz" -C /data .

# Cleanup old backups (keep 30 days)
find "$BACKUP_DIR" -name "*.gz" -mtime +30 -delete

echo "Backup completed successfully"
echo "Files created:"
ls -lh "$BACKUP_DIR" | grep "$DATE"
```

Make executable and schedule:

```bash
chmod +x backup.sh

# Add to crontab (daily at 2 AM)
0 2 * * * /path/to/backup.sh >> /var/log/n8n-backup.log 2>&1
```

---

## 📈 Scaling Guidelines

### Small Production (100-500 workflows)
```bash
docker compose up -d --scale n8n-worker=2
```
**Resources:** 4GB RAM, 2 CPU cores

### Medium Production (500-1500 workflows)
```bash
docker compose up -d --scale n8n-worker=5
```
**Resources:** 8GB RAM, 4 CPU cores

### Large Production (1500+ workflows)
```bash
docker compose up -d --scale n8n-worker=10
```
**Resources:** 16GB+ RAM, 8+ CPU cores

### Auto-Scaling Indicators

Add more workers when:
- Queue length consistently > 50
- Worker CPU > 80%
- Execution delays increasing

Remove workers when:
- Queue length consistently < 10
- Worker CPU < 20%
- Cost optimization needed

---

## ✅ Production Checklist

Before going live:

- [ ] All passwords generated with `openssl rand -base64`
- [ ] `N8N_ENCRYPTION_KEY` set and backed up
- [ ] `.env` file in `.gitignore`
- [ ] HTTPS configured (reverse proxy)
- [ ] Firewall rules configured
- [ ] Health checks passing
- [ ] Automated backups scheduled
- [ ] Restore procedure tested
- [ ] Monitoring configured
- [ ] Log aggregation set up
- [ ] Alerting configured
- [ ] Documentation updated

---

## 🐛 Troubleshooting

### Workers Not Processing Jobs

**Check Redis connection:**
```bash
docker compose exec n8n-worker nc -zv redis 6379
```

**Check queue has jobs:**
```bash
docker compose exec redis redis-cli -a $REDIS_PASSWORD LLEN bull:n8n:wait
```

**Check worker logs:**
```bash
docker compose logs n8n-worker | tail -50
```

### High Memory Usage

**Check stats:**
```bash
docker compose stats
```

**Limit worker memory:**
```yaml
n8n-worker:
  mem_limit: 512m
  memswap_limit: 512m
```

### Redis Out of Memory

**Check Redis memory:**
```bash
docker compose exec redis redis-cli -a $REDIS_PASSWORD INFO memory
```

**Increase Redis memory limit or enable eviction:**
```yaml
redis:
  command: >
    redis-server 
    --requirepass ${REDIS_PASSWORD}
    --maxmemory 512mb
    --maxmemory-policy allkeys-lru
```

---

## 📚 Learn More

- [Theory: Compose Networking](../../theory/03-compose-networking.md)
- [Practice: Complete Stack](../../practice/03-complete-stack.md)
- [n8n Queue Mode Documentation](https://docs.n8n.io/hosting/scaling/queue-mode/)

---

**Next Example:** [04-dev-stack →](../04-dev-stack/)

**Back to:** [Examples Overview](../README.md)

