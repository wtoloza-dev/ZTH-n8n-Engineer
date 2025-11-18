# Practice 2: n8n + PostgreSQL with Compose

**Estimated Time:** 9 minutes  
**Difficulty:** Medium ⭐⭐  
**Prerequisites:** Practice 1 completed

---

## 🎯 Objective

Learn to orchestrate multiple services by adding PostgreSQL to your n8n setup. Understand service communication, health checks, and dependencies.

---

## 📁 Setup

Create a new directory:

```bash
mkdir ~/n8n-postgres-compose
cd ~/n8n-postgres-compose
```

---

## 📋 Instructions

### Step 1: Create Environment File

Create `.env` file for secrets:

```bash
touch .env
```

Add the following content:

```bash
# Database credentials
POSTGRES_USER=n8n
POSTGRES_PASSWORD=n8n_secure_password_123
POSTGRES_DB=n8n

# n8n encryption key (generate with: openssl rand -base64 32)
N8N_ENCRYPTION_KEY=your-very-long-random-encryption-key-here
```

**Important:** Replace `your-very-long-random-encryption-key-here` with a real random key:

```bash
# Generate encryption key
openssl rand -base64 32
```

---

### Step 2: Create docker-compose.yml

Create the Compose file:

```bash
touch docker-compose.yml
```

Add this configuration:

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: n8n-postgres
    restart: unless-stopped
    environment:
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_DB=${POSTGRES_DB}
    volumes:
      - postgres-data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5

  n8n:
    image: n8nio/n8n
    container_name: n8n-app
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=${POSTGRES_DB}
      - DB_POSTGRESDB_USER=${POSTGRES_USER}
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD}
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
      - N8N_HOST=localhost
      - N8N_PORT=5678
      - N8N_PROTOCOL=http
      - WEBHOOK_URL=http://localhost:5678/
    volumes:
      - n8n-data:/home/node/.n8n
    depends_on:
      postgres:
        condition: service_healthy

volumes:
  postgres-data:
  n8n-data:
```

---

### Step 3: Understand the Configuration

**Key changes from Practice 1:**

1. **Two services now:**
   - `postgres` - Database
   - `n8n` - Application

2. **Environment variables from .env file:**
   - `${POSTGRES_USER}` - Reads from .env
   - `${POSTGRES_PASSWORD}` - Reads from .env

3. **Health check for postgres:**
   ```yaml
   healthcheck:
     test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
   ```
   - Checks if PostgreSQL is ready
   - Runs every 10 seconds
   - 5 retries before marking unhealthy

4. **Service dependency:**
   ```yaml
   depends_on:
     postgres:
       condition: service_healthy
   ```
   - n8n waits for PostgreSQL to be healthy before starting

5. **n8n database configuration:**
   ```yaml
   - DB_TYPE=postgresdb
   - DB_POSTGRESDB_HOST=postgres    # ← Service name!
   ```

---

### Step 4: Start the Stack

Start both services:

```bash
docker compose up -d
```

**Expected output:**
```
[+] Running 3/3
 ✔ Network n8n-postgres-compose_default  Created     0.1s
 ✔ Container n8n-postgres                Healthy     5.5s
 ✔ Container n8n-app                     Started     5.7s
```

**Notice:** PostgreSQL starts first and becomes healthy before n8n starts.

---

### Step 5: Watch the Startup Process

View logs in real-time:

```bash
docker compose logs -f
```

**Look for these messages:**

PostgreSQL:
```
postgres    | database system is ready to accept connections
```

n8n:
```
n8n-app     | Successfully connected to database
n8n-app     | Editor is now accessible via: http://localhost:5678
```

Press `Ctrl+C` to exit logs.

---

### Step 6: Verify Services

Check both services are running:

```bash
docker compose ps
```

**Expected output:**
```
NAME           IMAGE             STATUS                   PORTS
n8n-app        n8nio/n8n         Up 30 seconds            0.0.0.0:5678->5678/tcp
n8n-postgres   postgres:15-alpine   Up 30 seconds (healthy)   5432/tcp
```

---

### Step 7: Test Database Connection

Execute a shell in the n8n container:

```bash
docker compose exec n8n sh
```

Test connection to PostgreSQL:

```bash
# Using netcat to test port connectivity
nc -zv postgres 5432
```

**Expected:** `postgres (172.18.0.2:5432) open`

Try DNS resolution:

```bash
# Ping postgres by service name
ping -c 3 postgres
```

**Expected:** Successful pings to postgres container

Exit the container:

```bash
exit
```

---

### Step 8: Query the Database Directly

Connect to PostgreSQL:

```bash
docker compose exec postgres psql -U n8n -d n8n
```

Run SQL queries:

```sql
-- List all tables (n8n creates these automatically)
\dt

-- Check workflows count
SELECT COUNT(*) FROM workflow_entity;

-- Exit
\q
```

---

### Step 9: Access n8n and Create Workflows

1. Open: `http://localhost:5678`
2. Complete the setup wizard
3. Create a few test workflows
4. Save them

---

### Step 10: Verify Data in PostgreSQL

Check that workflows are stored in PostgreSQL:

```bash
docker compose exec postgres psql -U n8n -d n8n -c "SELECT id, name, active FROM workflow_entity;"
```

**You should see your workflows listed!**

---

### Step 11: Test Container Restart (Data Persistence)

Stop the n8n container only:

```bash
docker compose stop n8n
```

Start it again:

```bash
docker compose start n8n
```

Access `http://localhost:5678` - **Your workflows are still there!**

---

### Step 12: Test Full Stack Restart

Stop everything:

```bash
docker compose down
```

Start again:

```bash
docker compose up -d
```

Access `http://localhost:5678` - **Data persists!**

---

## 🔍 Understanding Service Communication

### How n8n Finds PostgreSQL

```yaml
environment:
  - DB_POSTGRESDB_HOST=postgres    # ← Service name
```

**Docker Compose automatically:**
1. Creates a network
2. Connects both containers to it
3. Sets up DNS: `postgres` → IP address of postgres container
4. n8n can connect using the service name

**Behind the scenes:**

```
n8n container: "Connect to postgres:5432"
   ↓
Docker DNS: "postgres = 172.18.0.2"
   ↓
n8n connects to: 172.18.0.2:5432
   ↓
PostgreSQL container receives connection
```

---

## 🧪 Experiments

### Experiment 1: View Network Details

List networks:

```bash
docker network ls
```

Inspect the network:

```bash
docker network inspect n8n-postgres-compose_default
```

**Look for:** Both containers connected with their IP addresses.

---

### Experiment 2: Test Without Health Check

Edit `docker-compose.yml`, remove health check and condition:

```yaml
postgres:
  image: postgres:15-alpine
  # Remove healthcheck section

n8n:
  depends_on:
    - postgres    # Simple dependency
```

Restart:

```bash
docker compose down
docker compose up -d
```

**Problem:** n8n might start before PostgreSQL is ready and fail to connect.

**Solution:** Always use health checks in production!

---

### Experiment 3: Add More Environment Variables

Add to n8n service:

```yaml
environment:
  # ... existing vars ...
  - N8N_BASIC_AUTH_ACTIVE=true
  - N8N_BASIC_AUTH_USER=admin
  - N8N_BASIC_AUTH_PASSWORD=admin123
  - N8N_LOG_LEVEL=debug
```

Apply:

```bash
docker compose up -d
```

Now n8n requires authentication!

---

## 📊 Compare SQLite vs PostgreSQL

### View Database Size

**SQLite (from Practice 1):**
```bash
# Single file in volume
docker volume inspect n8n-data
```

**PostgreSQL (current setup):**
```bash
# Check database size
docker compose exec postgres psql -U n8n -c "SELECT pg_size_pretty(pg_database_size('n8n'));"
```

---

## ✅ Verification Checklist

- [ ] Created .env file with credentials
- [ ] Created docker-compose.yml with two services
- [ ] Started stack and verified both containers running
- [ ] Tested service-to-service communication
- [ ] Accessed PostgreSQL directly
- [ ] Created workflows and verified they're in database
- [ ] Tested data persistence across restarts
- [ ] Understood health checks and dependencies

---

## 🐛 Troubleshooting

### "n8n: Connection failed"

**Check PostgreSQL is healthy:**
```bash
docker compose ps
```

Look for `(healthy)` status.

**View PostgreSQL logs:**
```bash
docker compose logs postgres
```

---

### "could not connect to server"

**Verify service name in n8n config:**
```yaml
environment:
  - DB_POSTGRESDB_HOST=postgres    # Must match service name
```

**Test network connectivity:**
```bash
docker compose exec n8n nc -zv postgres 5432
```

---

### "password authentication failed"

**Check .env variables match:**
```bash
# View environment in containers
docker compose exec postgres env | grep POSTGRES
docker compose exec n8n env | grep POSTGRES
```

---

### PostgreSQL won't start

**Check logs:**
```bash
docker compose logs postgres
```

**Common issue:** Port 5432 already in use on host

**Solution:** PostgreSQL doesn't expose ports externally in this setup, so this shouldn't happen. If it does:
```bash
# Check what's using port 5432
lsof -i :5432
```

---

## 📚 Key Concepts Learned

### Service Communication
- Services find each other by service name
- Docker Compose creates automatic DNS
- No need to know IP addresses

### Health Checks
- Ensure service is ready before dependent services start
- Prevents connection errors
- Essential for production

### Dependencies
- `depends_on` controls startup order
- `condition: service_healthy` waits for health check
- Ensures reliable startup

### Environment Variables
- `.env` file keeps secrets out of code
- `${VAR_NAME}` syntax references env vars
- Easy to change between environments

---

## 🎉 Success!

You've successfully:
- ✅ Orchestrated multiple services with Compose
- ✅ Configured service-to-service communication
- ✅ Implemented health checks and dependencies
- ✅ Used environment files for secrets
- ✅ Connected n8n to PostgreSQL
- ✅ Verified data persistence in a real database

---

## 📖 What's Next?

**[Practice 3: Complete Stack - Queue Mode →](03-complete-stack.md)**

Learn to build a production-ready n8n setup with queue mode, Redis, and multiple workers.

---

**Back to:** [Lesson 3 Overview](../README.md)

