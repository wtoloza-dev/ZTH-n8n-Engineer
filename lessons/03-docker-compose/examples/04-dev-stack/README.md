# Example 4: Development Stack

**Difficulty:** ⭐⭐ Intermediate  
**Estimated Setup Time:** 3 minutes  
**Use Case:** Local development, testing, debugging

---

## 📋 Overview

Complete development environment with n8n and useful development tools.

**What's included:**
- n8n (with debug logging)
- PostgreSQL database
- Redis
- **Adminer** (database UI at :8080)
- **Redis Commander** (Redis UI at :8081)

**Benefits:**
- ✅ Visual database management
- ✅ Redis queue visualization
- ✅ Debug logging enabled
- ✅ Easy inspection of all services
- ✅ Perfect for learning and testing

---

## 🏗️ Architecture

```
┌─────────────────────────────────────┐
│         Development Stack           │
├─────────────────────────────────────┤
│                                     │
│  n8n (:5678)                        │
│    ↓                                │
│  PostgreSQL (:5432)                 │
│    ↓                                │
│  Adminer (:8080) ──► View DB       │
│                                     │
│  Redis (:6379)                      │
│    ↓                                │
│  Redis Commander (:8081) ──► View  │
│                                     │
└─────────────────────────────────────┘
```

---

## 🚀 Quick Start

### Step 1: Setup

```bash
mkdir ~/n8n-dev
cd ~/n8n-dev

# Copy files from this example
```

### Step 2: Configure

```bash
cp .env.example .env

# Generate encryption key
echo "N8N_ENCRYPTION_KEY=$(openssl rand -base64 32)" >> .env

# Edit other values
nano .env
```

### Step 3: Start Stack

```bash
docker compose up -d
```

### Step 4: Access Services

- **n8n:** http://localhost:5678
- **Adminer (DB UI):** http://localhost:8080
- **Redis Commander:** http://localhost:8081

---

## 📁 Files

### docker-compose.yml

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: n8n-dev-postgres
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-n8n}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-n8ndev}
      POSTGRES_DB: ${POSTGRES_DB:-n8n}
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - n8n-dev
    ports:
      - "5432:5432"  # Exposed for external tools
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-n8n}"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: n8n-dev-redis
    restart: unless-stopped
    volumes:
      - redis-data:/data
    networks:
      - n8n-dev
    ports:
      - "6379:6379"  # Exposed for external tools
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  n8n:
    image: n8nio/n8n
    container_name: n8n-dev
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      # Database
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=${POSTGRES_DB:-n8n}
      - DB_POSTGRESDB_USER=${POSTGRES_USER:-n8n}
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD:-n8ndev}
      
      # Redis (optional queue mode for testing)
      - QUEUE_BULL_REDIS_HOST=redis
      - QUEUE_BULL_REDIS_PORT=6379
      
      # n8n Configuration
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
      - N8N_HOST=localhost
      - N8N_PROTOCOL=http
      - N8N_PORT=5678
      - WEBHOOK_URL=http://localhost:5678/
      
      # Development Settings
      - N8N_LOG_LEVEL=debug
      - N8N_LOG_OUTPUT=console
      - NODE_ENV=development
      
      # Disable telemetry in dev
      - N8N_DIAGNOSTICS_ENABLED=false
    volumes:
      - n8n-data:/home/node/.n8n
      - ./custom-nodes:/home/node/.n8n/custom:ro
    networks:
      - n8n-dev
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy

  adminer:
    image: adminer:latest
    container_name: n8n-dev-adminer
    restart: unless-stopped
    ports:
      - "8080:8080"
    environment:
      - ADMINER_DEFAULT_SERVER=postgres
      - ADMINER_DESIGN=nette
    networks:
      - n8n-dev

  redis-commander:
    image: rediscommander/redis-commander:latest
    container_name: n8n-dev-redis-commander
    restart: unless-stopped
    ports:
      - "8081:8081"
    environment:
      - REDIS_HOSTS=local:redis:6379
    networks:
      - n8n-dev
    depends_on:
      - redis

volumes:
  postgres-data:
  redis-data:
  n8n-data:

networks:
  n8n-dev:
    driver: bridge
```

---

## 🔧 Using the Development Tools

### Adminer (Database UI)

1. Open: http://localhost:8080
2. Login with:
   - **System:** PostgreSQL
   - **Server:** postgres
   - **Username:** n8n (or from .env)
   - **Password:** (from .env)
   - **Database:** n8n

**Features:**
- Browse all tables
- Run SQL queries
- Export/Import data
- View table structure
- Edit records

**Useful queries:**
```sql
-- View all workflows
SELECT id, name, active, createdAt FROM workflow_entity;

-- View recent executions
SELECT * FROM execution_entity ORDER BY startedAt DESC LIMIT 20;

-- Count credentials
SELECT COUNT(*) FROM credentials_entity;
```

---

### Redis Commander (Redis UI)

1. Open: http://localhost:8081
2. Automatically connected to Redis

**Features:**
- View all Redis keys
- Inspect queue contents
- Monitor memory usage
- Execute Redis commands
- Real-time updates

**Common keys to inspect:**
- `bull:n8n:wait` - Pending jobs
- `bull:n8n:active` - Currently processing
- `bull:n8n:completed` - Completed jobs
- `bull:n8n:failed` - Failed jobs

---

## 🧪 Development Workflows

### Test Queue Mode

Enable queue mode:

```yaml
n8n:
  environment:
    - EXECUTIONS_MODE=queue
```

```bash
docker compose up -d
```

Watch jobs in Redis Commander in real-time.

---

### Test Custom Nodes

1. Create `custom-nodes` directory:
```bash
mkdir -p custom-nodes
```

2. Add your custom node code

3. Restart n8n:
```bash
docker compose restart n8n
```

4. Check logs:
```bash
docker compose logs -f n8n
```

---

### Debug Workflows

With `N8N_LOG_LEVEL=debug`, you'll see detailed logs:

```bash
docker compose logs -f n8n | grep -i error
```

---

### Test Database Migrations

```bash
# Export current schema
docker compose exec postgres pg_dump -U n8n -s n8n > schema.sql

# Make changes in n8n

# Export new schema
docker compose exec postgres pg_dump -U n8n -s n8n > schema-new.sql

# Compare
diff schema.sql schema-new.sql
```

---

## 📊 Monitoring and Debugging

### View All Logs

```bash
docker compose logs -f
```

### Filter Logs

```bash
# Only errors
docker compose logs -f | grep -i error

# Only n8n
docker compose logs -f n8n

# Last 100 lines
docker compose logs --tail=100
```

### Check Service Health

```bash
docker compose ps
```

### Inspect Network

```bash
docker network inspect n8n-dev_n8n-dev
```

### Resource Usage

```bash
docker compose stats
```

---

## 🔄 Common Development Tasks

### Reset Database

```bash
# Stop n8n
docker compose stop n8n

# Drop and recreate database
docker compose exec postgres psql -U n8n -c "DROP DATABASE n8n;"
docker compose exec postgres psql -U n8n -c "CREATE DATABASE n8n;"

# Restart n8n (will recreate schema)
docker compose start n8n
```

### Clear Redis Queue

```bash
docker compose exec redis redis-cli FLUSHALL
```

### Backup Development Data

```bash
# Backup
docker compose exec postgres pg_dump -U n8n n8n > dev-backup.sql

# Restore
docker compose exec -T postgres psql -U n8n n8n < dev-backup.sql
```

### Clean Restart

```bash
# Stop and remove everything
docker compose down -v

# Start fresh
docker compose up -d
```

---

## 🎯 Testing Scenarios

### Test High Load

Create test workflow that runs 100 times:

```javascript
// Code Node
for (let i = 0; i < 100; i++) {
  console.log(`Iteration ${i}`);
  await new Promise(r => setTimeout(r, 100));
}
return { completed: true };
```

Watch in:
- n8n logs
- Redis Commander (if queue mode)
- Adminer (execution_entity table)

### Test Database Connection Loss

```bash
# Stop PostgreSQL
docker compose stop postgres

# Try to execute workflow in n8n
# Watch error handling

# Start PostgreSQL
docker compose start postgres
```

### Test Redis Connection Loss (Queue Mode)

```bash
# Stop Redis
docker compose stop redis

# Try to execute workflow
# Watch graceful degradation

# Start Redis
docker compose start redis
```

---

## 📚 Learn More About Services

### Adminer
- **Docs:** https://www.adminer.org/
- **Tip:** Press `Alt+↓` in SQL editor for history

### Redis Commander
- **Docs:** https://joeferner.github.io/redis-commander/
- **Tip:** Enable auto-refresh for real-time queue monitoring

---

## ✅ Development Checklist

- [ ] All services started successfully
- [ ] Accessed n8n at :5678
- [ ] Accessed Adminer at :8080
- [ ] Connected to database via Adminer
- [ ] Accessed Redis Commander at :8081
- [ ] Created test workflow
- [ ] Viewed workflow in database
- [ ] Checked debug logs

---

## 🚫 Not for Production

**This setup is for development only!**

❌ **Do not use in production:**
- Ports exposed to host (security risk)
- Debug logging (performance impact)
- Simple passwords
- No resource limits
- No backup strategy

**For production, use:**
- [02-n8n-postgres](../02-n8n-postgres/) - Small production
- [03-queue-mode-complete](../03-queue-mode-complete/) - Enterprise

---

## 🎓 Learning Resources

- [Theory: Docker Compose](../../theory/01-what-is-compose.md)
- [Practice Exercises](../../practice/)
- [Docker Compose Cheat Sheet](../../resources/compose-cheatsheet.md)

---

**Back to:** [Examples Overview](../README.md)

