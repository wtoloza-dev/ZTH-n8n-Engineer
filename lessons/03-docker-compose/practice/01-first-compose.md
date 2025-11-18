# Practice 1: Your First docker-compose.yml

**Estimated Time:** 8 minutes  
**Difficulty:** Easy ⭐  
**Prerequisites:** Lesson 2 completed, Docker Compose installed

---

## 🎯 Objective

Create your first `docker-compose.yml` file to run n8n, learn basic Compose commands, and understand the benefits over `docker run`.

---

## 📋 Prerequisites

Ensure you have Docker Compose installed:

```bash
docker compose version
```

> **Note:** Modern Docker includes Compose v2. If you see an error, try `docker-compose --version` (older version).

---

## 📁 Setup

Create a new directory for this exercise:

```bash
mkdir ~/n8n-compose-basic
cd ~/n8n-compose-basic
```

---

## 📋 Instructions

### Step 1: Create docker-compose.yml

Create a new file named `docker-compose.yml`:

```bash
touch docker-compose.yml
```

Open it in your editor and add:

```yaml
version: '3.8'

services:
  n8n:
    image: n8nio/n8n
    container_name: n8n-basic
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - N8N_LOG_LEVEL=info
    volumes:
      - n8n-data:/home/node/.n8n

volumes:
  n8n-data:
```

**What this file does:**
- Defines one service called `n8n`
- Uses the official n8n image
- Exposes port 5678
- Persists data in a volume
- Restarts automatically if it crashes

---

### Step 2: Start Services

Start n8n using Compose:

```bash
docker compose up -d
```

**Expected output:**
```
[+] Running 2/2
 ✔ Network n8n-compose-basic_default  Created     0.1s
 ✔ Container n8n-basic                Started     0.5s
```

**Command breakdown:**
- `docker compose` → Compose CLI
- `up` → Create and start containers
- `-d` → Detached mode (background)

---

### Step 3: Verify Services Running

Check the status:

```bash
docker compose ps
```

**Expected output:**
```
NAME        IMAGE       COMMAND   SERVICE   CREATED          STATUS          PORTS
n8n-basic   n8nio/n8n   "n8n"     n8n       10 seconds ago   Up 9 seconds    0.0.0.0:5678->5678/tcp
```

**Alternative:** View with Docker directly:
```bash
docker ps
```

---

### Step 4: Access n8n

1. Open your browser
2. Navigate to: `http://localhost:5678`
3. Complete the n8n setup wizard
4. Create a test workflow

---

### Step 5: View Logs

View logs from all services:

```bash
docker compose logs
```

Follow logs in real-time:

```bash
docker compose logs -f
```

View logs for specific service:

```bash
docker compose logs n8n
```

**Exit log viewing:** Press `Ctrl+C`

---

### Step 6: Execute Commands in Container

Open a shell inside the n8n container:

```bash
docker compose exec n8n sh
```

Once inside, try these commands:

```bash
# Check n8n version
n8n --version

# List environment variables
env | grep N8N

# Check current directory
pwd

# Exit container
exit
```

---

### Step 7: Stop Services

Stop all services defined in docker-compose.yml:

```bash
docker compose stop
```

**Verify they stopped:**
```bash
docker compose ps
```

---

### Step 8: Start Services Again

Restart the stopped services:

```bash
docker compose start
```

Check they're running:

```bash
docker compose ps
```

**Important:** Your data is still there! Access http://localhost:5678 and your workflows should be intact.

---

### Step 9: Restart a Service

Restart n8n (stops and starts in one command):

```bash
docker compose restart n8n
```

Useful when you change environment variables.

---

### Step 10: View Resource Usage

See CPU and memory usage:

```bash
docker compose stats
```

**Example output:**
```
CONTAINER ID   NAME        CPU %     MEM USAGE / LIMIT     MEM %
abc123def456   n8n-basic   0.50%     150MiB / 7.775GiB     1.88%
```

Press `Ctrl+C` to exit.

---

### Step 11: Clean Up

Stop and remove all containers:

```bash
docker compose down
```

**Expected output:**
```
[+] Running 2/2
 ✔ Container n8n-basic                Removed     0.5s
 ✔ Network n8n-compose-basic_default  Removed     0.2s
```

**Note:** This removes containers but NOT volumes. Your data is safe.

---

### Step 12: Verify Data Persistence

Start services again:

```bash
docker compose up -d
```

Access http://localhost:5678

**✅ Your workflows are still there!**

This demonstrates volume persistence.

---

## 🔄 Comparison: docker run vs docker compose

### With docker run (Old Way)

```bash
# Create volume
docker volume create n8n-data

# Run container
docker run -d \
  --name n8n-basic \
  --restart unless-stopped \
  -p 5678:5678 \
  -e N8N_LOG_LEVEL=info \
  -v n8n-data:/home/node/.n8n \
  n8nio/n8n

# View logs
docker logs n8n-basic

# Stop container
docker stop n8n-basic

# Start container
docker start n8n-basic

# Remove container
docker rm n8n-basic
```

**Problems:**
- Long, complex commands
- Hard to remember
- Error-prone
- Not version controlled
- Hard to share with team

---

### With docker compose (Modern Way)

**docker-compose.yml:**
```yaml
version: '3.8'
services:
  n8n:
    image: n8nio/n8n
    container_name: n8n-basic
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - N8N_LOG_LEVEL=info
    volumes:
      - n8n-data:/home/node/.n8n
volumes:
  n8n-data:
```

**Commands:**
```bash
docker compose up -d        # Start
docker compose logs n8n     # View logs
docker compose stop         # Stop
docker compose start        # Start
docker compose down         # Remove
```

**Benefits:**
- ✅ Simple commands
- ✅ Easy to read and modify
- ✅ Version controlled (Git)
- ✅ Team-shareable
- ✅ Self-documenting

---

## 🧪 Experiments

Try these modifications to learn more:

### Experiment 1: Change Port Mapping

Edit `docker-compose.yml`:

```yaml
ports:
  - "8080:5678"    # Change host port to 8080
```

Apply changes:

```bash
docker compose up -d
```

Now access n8n at: `http://localhost:8080`

---

### Experiment 2: Add Another Environment Variable

```yaml
environment:
  - N8N_LOG_LEVEL=debug        # More detailed logs
  - N8N_BASIC_AUTH_ACTIVE=true
  - N8N_BASIC_AUTH_USER=admin
  - N8N_BASIC_AUTH_PASSWORD=admin123
```

Restart:

```bash
docker compose up -d
```

Access n8n - now it requires authentication!

---

### Experiment 3: Multiple Services

Add a second service (nginx):

```yaml
version: '3.8'

services:
  n8n:
    image: n8nio/n8n
    container_name: n8n-basic
    restart: unless-stopped
    ports:
      - "5678:5678"
    volumes:
      - n8n-data:/home/node/.n8n
  
  nginx:
    image: nginx:alpine
    ports:
      - "8081:80"

volumes:
  n8n-data:
```

Start both:

```bash
docker compose up -d
```

Check both are running:

```bash
docker compose ps
```

Access:
- n8n: `http://localhost:5678`
- nginx: `http://localhost:8081`

---

## ✅ Verification Checklist

- [ ] Created docker-compose.yml file
- [ ] Started services with `docker compose up -d`
- [ ] Accessed n8n at http://localhost:5678
- [ ] Viewed logs with `docker compose logs`
- [ ] Executed commands inside container
- [ ] Stopped services with `docker compose stop`
- [ ] Restarted and verified data persistence
- [ ] Cleaned up with `docker compose down`

---

## 🐛 Troubleshooting

### "Error: network not found"

```bash
docker compose down
docker compose up -d
```

### "Port already in use"

Check what's using port 5678:

```bash
# On Linux/Mac
lsof -i :5678

# On Windows
netstat -ano | findstr :5678
```

Stop the conflicting service or change the port in docker-compose.yml.

### "Cannot connect to Docker daemon"

Start Docker:

```bash
# Linux
sudo systemctl start docker

# Mac/Windows
# Start Docker Desktop
```

### Container not starting

View detailed logs:

```bash
docker compose logs -f n8n
```

---

## 📚 Key Commands Summary

```bash
# Start all services
docker compose up -d

# View status
docker compose ps

# View logs
docker compose logs
docker compose logs -f         # Follow logs
docker compose logs n8n        # Specific service

# Execute command
docker compose exec n8n sh

# Stop services
docker compose stop

# Start stopped services
docker compose start

# Restart services
docker compose restart

# Remove containers (keeps volumes)
docker compose down

# Remove everything including volumes
docker compose down -v

# Pull latest images
docker compose pull

# View resource usage
docker compose stats
```

---

## 🎉 Success!

You've successfully:
- ✅ Created your first docker-compose.yml
- ✅ Understood the structure of a Compose file
- ✅ Learned essential Docker Compose commands
- ✅ Experienced the benefits over `docker run`
- ✅ Verified data persistence with volumes

---

## 📖 What's Next?

**[Practice 2: n8n + PostgreSQL with Compose →](02-n8n-postgres-compose.md)**

Learn to orchestrate multiple services by adding PostgreSQL to your n8n setup.

---

**Back to:** [Lesson 3 Overview](../README.md)

