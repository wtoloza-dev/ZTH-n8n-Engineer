# Practice 3: Complete Stack - Queue Mode

**Estimated Time:** 12 minutes  
**Difficulty:** Advanced ⭐⭐⭐  
**Prerequisites:** Practice 2 completed

---

## 🎯 Objective

Build a production-ready n8n setup with queue mode, including PostgreSQL, Redis, n8n main instance, and multiple workers. Learn how to scale horizontally and understand high-performance architecture.

---

## 📁 Setup

Create a new directory:

```bash
mkdir ~/n8n-queue-mode
cd ~/n8n-queue-mode
```

---

## 📋 Instructions

### Step 1: Create Environment File

Create `.env`:

```bash
touch .env
```

Add configuration:

```bash
# PostgreSQL
POSTGRES_USER=n8n
POSTGRES_PASSWORD=super_secure_postgres_password
POSTGRES_DB=n8n

# Redis
REDIS_PASSWORD=super_secure_redis_password

# n8n
N8N_ENCRYPTION_KEY=your-very-long-random-encryption-key-generate-with-openssl
N8N_HOST=localhost
N8N_PROTOCOL=http
WEBHOOK_URL=http://localhost:5678/

# Basic Auth
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=admin_password_here
```

**Generate encryption key:**
```bash
openssl rand -base64 32
```

---

### Step 2: Create docker-compose.yml

Create the complete stack:

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: n8n-postgres
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
    volumes:
      - postgres-data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - n8n-network

  redis:
    image: redis:7-alpine
    container_name: n8n-redis
    restart: unless-stopped
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis-data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - n8n-network

  n8n-main:
    image: n8nio/n8n
    container_name: n8n-main
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      # Database
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=${POSTGRES_DB}
      - DB_POSTGRESDB_USER=${POSTGRES_USER}
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD}
      
      # Redis Queue
      - EXECUTIONS_MODE=queue
      - QUEUE_BULL_REDIS_HOST=redis
      - QUEUE_BULL_REDIS_PORT=6379
      - QUEUE_BULL_REDIS_PASSWORD=${REDIS_PASSWORD}
      
      # n8n Configuration
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
      - N8N_HOST=${N8N_HOST}
      - N8N_PROTOCOL=${N8N_PROTOCOL}
      - N8N_PORT=5678
      - WEBHOOK_URL=${WEBHOOK_URL}
      
      # Authentication
      - N8N_BASIC_AUTH_ACTIVE=${N8N_BASIC_AUTH_ACTIVE}
      - N8N_BASIC_AUTH_USER=${N8N_BASIC_AUTH_USER}
      - N8N_BASIC_AUTH_PASSWORD=${N8N_BASIC_AUTH_PASSWORD}
      
      # Logging
      - N8N_LOG_LEVEL=info
    volumes:
      - n8n-data:/home/node/.n8n
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      - n8n-network

  n8n-worker:
    image: n8nio/n8n
    restart: unless-stopped
    command: worker
    environment:
      # Database
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=${POSTGRES_DB}
      - DB_POSTGRESDB_USER=${POSTGRES_USER}
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD}
      
      # Redis Queue
      - EXECUTIONS_MODE=queue
      - QUEUE_BULL_REDIS_HOST=redis
      - QUEUE_BULL_REDIS_PORT=6379
      - QUEUE_BULL_REDIS_PASSWORD=${REDIS_PASSWORD}
      
      # n8n Configuration
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
      
      # Logging
      - N8N_LOG_LEVEL=info
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      - n8n-network

volumes:
  postgres-data:
    driver: local
  redis-data:
    driver: local
  n8n-data:
    driver: local

networks:
  n8n-network:
    driver: bridge
```

---

### Step 3: Understand the Architecture

This setup creates a high-performance n8n stack:

```
┌─────────────────────────────────────────────┐
│                                             │
│  User Browser ─────► n8n-main (Port 5678)  │
│                          │                  │
│                          ▼                  │
│                     PostgreSQL              │
│                          ▲                  │
│                          │                  │
│   ┌──────────────────────┴──────────────┐  │
│   │                                      │  │
│   │  Redis Queue ◄───── Jobs            │  │
│   │       │                              │  │
│   │       ├──► n8n-worker-1             │  │
│   │       ├──► n8n-worker-2             │  │
│   │       └──► n8n-worker-N             │  │
│   │                                      │  │
│   └──────────────────────────────────────┘  │
│                                             │
└─────────────────────────────────────────────┘
```

**Components:**
- **n8n-main:** UI, API, webhook receiver, job scheduler
- **n8n-worker:** Executes workflows from queue (scalable)
- **PostgreSQL:** Stores workflows, credentials, executions
- **Redis:** Job queue for distributing work
- **Custom network:** All services communicate internally

---

### Step 4: Start the Complete Stack

Start all services:

```bash
docker compose up -d
```

**Expected output:**
```
[+] Running 6/6
 ✔ Network n8n-queue-mode_n8n-network  Created     0.1s
 ✔ Container n8n-postgres              Healthy    10.5s
 ✔ Container n8n-redis                 Healthy    10.5s
 ✔ Container n8n-main                  Started    11.0s
 ✔ Container n8n-queue-mode-n8n-worker-1  Started    11.2s
```

---

### Step 5: Monitor Startup

Watch logs from all services:

```bash
docker compose logs -f
```

**Look for:**

**PostgreSQL:**
```
postgres    | database system is ready to accept connections
```

**Redis:**
```
redis       | Ready to accept connections
```

**n8n-main:**
```
n8n-main    | Queue mode activated
n8n-main    | Editor is now accessible via: http://localhost:5678
```

**n8n-worker:**
```
n8n-worker  | Started worker
n8n-worker  | Waiting for jobs...
```

Press `Ctrl+C` to exit.

---

### Step 6: Verify All Services Running

```bash
docker compose ps
```

**Expected output:**
```
NAME                          STATUS                   PORTS
n8n-main                      Up 1 minute              0.0.0.0:5678->5678/tcp
n8n-postgres                  Up 1 minute (healthy)    5432/tcp
n8n-redis                     Up 1 minute (healthy)    6379/tcp
n8n-queue-mode-n8n-worker-1   Up 1 minute
```

---

### Step 7: Test the Queue System

1. Access n8n: `http://localhost:5678`
2. Login with credentials from `.env`
3. Create a workflow with a long-running task:

**Example workflow:**

```
Trigger: Manual
  ↓
Code Node:
  for (let i = 0; i < 10; i++) {
    await new Promise(r => setTimeout(r, 1000));
    console.log(`Progress: ${i+1}/10`);
  }
  return { status: 'completed' };
```

4. Execute the workflow
5. Notice the UI remains responsive (queue mode working!)

---

### Step 8: Monitor Redis Queue

Check Redis has jobs:

```bash
docker compose exec redis redis-cli -a $REDIS_PASSWORD
```

Inside Redis CLI:

```redis
# List all keys
KEYS *

# Check queue length
LLEN bull:n8n:wait

# Exit
exit
```

---

### Step 9: View Worker Logs

See the worker processing jobs:

```bash
docker compose logs -f n8n-worker
```

**You should see:**
```
n8n-worker  | Job received
n8n-worker  | Executing workflow...
n8n-worker  | Job completed
```

---

### Step 10: Scale Workers Horizontally

Add more workers dynamically:

```bash
docker compose up -d --scale n8n-worker=3
```

**This creates 3 workers!**

Verify:

```bash
docker compose ps
```

**Expected:**
```
NAME                          STATUS
n8n-main                      Up
n8n-postgres                  Up (healthy)
n8n-redis                     Up (healthy)
n8n-queue-mode-n8n-worker-1   Up
n8n-queue-mode-n8n-worker-2   Up
n8n-queue-mode-n8n-worker-3   Up
```

---

### Step 11: Test Load Distribution

Create multiple workflows and execute them simultaneously:

1. Create 5 simple workflows
2. Execute all of them at once
3. View logs from all workers:

```bash
docker compose logs -f --tail=100 n8n-worker
```

**You'll see:** Jobs distributed across multiple workers!

---

### Step 12: Check Resource Usage

Monitor CPU and memory:

```bash
docker compose stats
```

**Example output:**
```
NAME                          CPU %     MEM USAGE / LIMIT
n8n-main                      2.50%     180MiB / 2GiB
n8n-postgres                  0.80%     45MiB / 2GiB
n8n-redis                     0.30%     12MiB / 2GiB
n8n-queue-mode-n8n-worker-1   1.20%     150MiB / 2GiB
n8n-queue-mode-n8n-worker-2   1.25%     152MiB / 2GiB
n8n-queue-mode-n8n-worker-3   0.90%     148MiB / 2GiB
```

---

## 🔬 Advanced Experiments

### Experiment 1: Test Worker Failure Recovery

Kill one worker:

```bash
docker compose kill n8n-queue-mode-n8n-worker-1
```

Execute workflows - they still process (other workers handle them)

Restart the killed worker:

```bash
docker compose up -d
```

---

### Experiment 2: Persistent Queue

1. Create and execute multiple workflows
2. Stop all workers:
   ```bash
   docker compose stop n8n-worker
   ```
3. Execute more workflows (they queue up)
4. Start workers again:
   ```bash
   docker compose start n8n-worker
   ```
5. Watch queued jobs execute

---

### Experiment 3: Custom Network Inspection

```bash
docker network inspect n8n-queue-mode_n8n-network
```

See all containers on the network and their IPs.

---

## 📊 Queue Mode vs Regular Mode

| Feature | Regular Mode | Queue Mode |
|---------|-------------|------------|
| **UI Blocking** | ❌ Blocks during execution | ✅ Always responsive |
| **Scalability** | ❌ Single process | ✅ Multiple workers |
| **Concurrent Executions** | Limited | High |
| **Failure Recovery** | ❌ Job lost if crash | ✅ Job re-queued |
| **Resource Usage** | Lower | Higher |
| **Setup Complexity** | Simple | Moderate |
| **Best For** | Personal use | Production |

---

## 📈 Performance Testing

### Test Concurrent Workflow Execution

Create a test workflow:

```javascript
// Code node
const delay = Math.random() * 5000;
await new Promise(r => setTimeout(r, delay));
return { 
  worker: process.env.HOSTNAME,
  delay: delay 
};
```

Execute 10 times simultaneously and watch distribution across workers.

---

## 🎛️ Production Tuning

### Limit Worker Concurrency

Add to worker environment:

```yaml
n8n-worker:
  environment:
    - EXECUTIONS_PROCESS=own
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

---

## ✅ Verification Checklist

- [ ] Created complete docker-compose.yml with 4 services
- [ ] Started stack and verified all services healthy
- [ ] Tested queue mode with long-running workflows
- [ ] Monitored Redis queue
- [ ] Scaled workers to 3 instances
- [ ] Tested load distribution across workers
- [ ] Verified resource usage
- [ ] Tested worker failure recovery

---

## 🐛 Troubleshooting

### "Worker can't connect to Redis"

**Check Redis password matches:**
```bash
docker compose exec n8n-worker env | grep REDIS
```

**Test connection:**
```bash
docker compose exec n8n-worker nc -zv redis 6379
```

---

### "Jobs not processing"

**Check workers are running:**
```bash
docker compose ps | grep worker
```

**View worker logs:**
```bash
docker compose logs n8n-worker
```

**Check Redis queue:**
```bash
docker compose exec redis redis-cli -a $REDIS_PASSWORD LLEN bull:n8n:wait
```

---

### High Memory Usage

**Reduce worker count:**
```bash
docker compose up -d --scale n8n-worker=1
```

**Add memory limits:**
```yaml
n8n-worker:
  mem_limit: 512m
```

---

## 🎯 Production Recommendations

### For Small Production (< 100 workflows)
- 1 main instance
- 2 workers
- PostgreSQL
- Redis
- 4GB RAM total

### For Medium Production (100-500 workflows)
- 1 main instance
- 3-5 workers
- PostgreSQL (tuned)
- Redis (persistent)
- 8GB RAM total

### For Large Production (> 500 workflows)
- 1-2 main instances (load balanced)
- 5-10 workers
- PostgreSQL (dedicated server)
- Redis cluster
- 16GB+ RAM total

---

## 📚 Key Concepts Learned

### Queue Mode Architecture
- Separates UI from execution
- Enables horizontal scaling
- Provides failure recovery

### Redis as Message Queue
- Distributes jobs to workers
- Persists pending jobs
- Handles job priorities

### Worker Scaling
- Add/remove workers dynamically
- Load balancing automatic
- No downtime for scaling

### Service Orchestration
- Multiple interdependent services
- Health checks ensure reliability
- Custom networks for isolation

---

## 🎉 Success!

You've successfully:
- ✅ Built a production-ready n8n stack
- ✅ Implemented queue mode with Redis
- ✅ Deployed and scaled multiple workers
- ✅ Tested high-availability features
- ✅ Monitored distributed job processing
- ✅ Understood enterprise n8n architecture

---

## 📖 What's Next?

**Explore real-world examples:**
- [Example 1: Basic n8n Setup](../examples/01-basic-n8n/)
- [Example 2: n8n + PostgreSQL](../examples/02-n8n-postgres/)
- [Example 3: Complete Queue Mode Stack](../examples/03-queue-mode-complete/)
- [Example 4: Development Stack](../examples/04-dev-stack/)

**Continue learning:**
- [Docker Compose Cheat Sheet](../resources/compose-cheatsheet.md)
- [Take the Interactive Exam](../resources/exam.md)

---

**Back to:** [Lesson 3 Overview](../README.md)

