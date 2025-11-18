# Docker Compose Cheat Sheet

Quick reference guide for Docker Compose commands and configurations.

---

## 📋 Basic Commands

### Starting and Stopping

```bash
# Start all services
docker compose up

# Start in detached mode (background)
docker compose up -d

# Start specific service
docker compose up n8n

# Start and build images
docker compose up --build

# Stop all services
docker compose stop

# Stop specific service
docker compose stop n8n

# Start stopped services
docker compose start

# Restart all services
docker compose restart

# Restart specific service
docker compose restart n8n
```

---

## 🗑️ Cleaning Up

```bash
# Stop and remove containers
docker compose down

# Stop, remove containers and volumes (⚠️ DELETES DATA)
docker compose down -v

# Stop, remove containers, volumes, and images
docker compose down -v --rmi all

# Remove orphan containers
docker compose down --remove-orphans
```

---

## 📊 Monitoring

### View Status

```bash
# List running services
docker compose ps

# List all services (including stopped)
docker compose ps -a

# View resource usage
docker compose stats

# View running processes
docker compose top
```

### Logs

```bash
# View logs
docker compose logs

# Follow logs in real-time
docker compose logs -f

# Follow logs for specific service
docker compose logs -f n8n

# View last N lines
docker compose logs --tail=100

# View logs with timestamps
docker compose logs -f --timestamps

# View logs for multiple services
docker compose logs -f n8n postgres
```

---

## 🔧 Working with Services

### Execute Commands

```bash
# Execute command in running service
docker compose exec n8n sh

# Execute as specific user
docker compose exec -u node n8n whoami

# Execute without TTY
docker compose exec -T postgres pg_dump -U n8n n8n > backup.sql

# Run one-off command (creates new container)
docker compose run n8n n8n --version
```

### Scaling

```bash
# Scale service to N instances
docker compose up -d --scale n8n-worker=3

# Scale multiple services
docker compose up -d --scale worker=3 --scale api=2
```

---

## 🔄 Updates and Rebuilds

```bash
# Pull latest images
docker compose pull

# Pull specific service
docker compose pull n8n

# Build images
docker compose build

# Build without cache
docker compose build --no-cache

# Build specific service
docker compose build n8n

# Update and restart
docker compose pull && docker compose up -d
```

---

## 📝 docker-compose.yml Reference

### File Structure

```yaml
version: '3.8'

services:
  service_name:
    # Service configuration

volumes:
  volume_name:
    # Volume configuration

networks:
  network_name:
    # Network configuration
```

---

## 🐳 Service Configuration

### Image and Build

```yaml
services:
  n8n:
    # Use existing image
    image: n8nio/n8n:latest
    
    # OR build from Dockerfile
    build:
      context: ./dir
      dockerfile: Dockerfile
      args:
        - VERSION=1.0
```

### Container Settings

```yaml
services:
  n8n:
    container_name: n8n-main
    hostname: n8n
    restart: unless-stopped  # no, always, on-failure, unless-stopped
    command: worker          # Override default command
    entrypoint: /custom.sh   # Override entrypoint
    user: "1000:1000"        # Run as specific user:group
    working_dir: /app        # Set working directory
```

### Ports

```yaml
services:
  n8n:
    ports:
      - "5678:5678"              # host:container
      - "8080:5678"              # different host port
      - "127.0.0.1:5678:5678"    # bind to localhost
      - "5678"                   # random host port
```

### Environment Variables

```yaml
services:
  n8n:
    environment:
      # Map format
      DB_TYPE: postgresdb
      DB_HOST: postgres
      
      # List format
      - DB_TYPE=postgresdb
      - DB_HOST=postgres
      
      # From host environment
      - DB_PASSWORD=${DB_PASSWORD}
      
      # With default value
      - N8N_PORT=${N8N_PORT:-5678}
    
    # Load from file
    env_file:
      - .env
      - .env.local
```

### Volumes

```yaml
services:
  n8n:
    volumes:
      # Named volume
      - n8n-data:/home/node/.n8n
      
      # Bind mount
      - ./data:/data
      
      # Read-only
      - ./config:/config:ro
      
      # Named volume with options
      - type: volume
        source: n8n-data
        target: /home/node/.n8n
        
volumes:
  n8n-data:
    driver: local
```

### Networks

```yaml
services:
  n8n:
    networks:
      - frontend
      - backend
    
    # With alias
    networks:
      backend:
        aliases:
          - n8n-app
          - automation

networks:
  frontend:
  backend:
    driver: bridge
```

### Dependencies

```yaml
services:
  n8n:
    depends_on:
      - postgres
      
    # With health check
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_started
```

### Health Checks

```yaml
services:
  n8n:
    healthcheck:
      test: ["CMD", "wget", "--spider", "http://localhost:5678"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
      
  postgres:
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U n8n"]
      interval: 10s
      
  redis:
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
```

### Resource Limits

```yaml
services:
  n8n:
    # Simple limits
    mem_limit: 2g
    memswap_limit: 2g
    cpus: 2.0
    
    # Deploy section (Swarm/v3+)
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 2G
        reservations:
          cpus: '0.5'
          memory: 512M
```

### Logging

```yaml
services:
  n8n:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
        
    # Or disable logging
    logging:
      driver: "none"
```

---

## 🔐 Environment File (.env)

### Format

```bash
# Comments start with #

# Simple values
POSTGRES_USER=n8n
POSTGRES_PASSWORD=secure_password

# Quotes optional
DB_TYPE=postgresdb
DB_TYPE="postgresdb"

# Multiline (not supported, use docker-compose.yml for multiline)
# Use | or > in YAML instead

# Variable substitution
N8N_HOST=${DOMAIN:-localhost}
```

### Usage in docker-compose.yml

```yaml
environment:
  - POSTGRES_USER=${POSTGRES_USER}
  - POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-defaultpass}
```

---

## 📦 Volume Management

```bash
# List volumes
docker volume ls

# Inspect volume
docker volume inspect n8n_n8n-data

# Create volume
docker volume create n8n-data

# Remove volume
docker volume rm n8n-data

# Remove unused volumes
docker volume prune

# Backup volume
docker run --rm \
  -v n8n_n8n-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/backup.tar.gz -C /data .

# Restore volume
docker run --rm \
  -v n8n_n8n-data:/data \
  -v $(pwd):/backup \
  alpine sh -c "cd /data && tar xzf /backup/backup.tar.gz"
```

---

## 🌐 Network Management

```bash
# List networks
docker network ls

# Inspect network
docker network inspect n8n_default

# Create network
docker network create n8n-network

# Remove network
docker network rm n8n-network

# Remove unused networks
docker network prune

# Connect container to network
docker network connect n8n-network n8n

# Disconnect container
docker network disconnect n8n-network n8n
```

---

## 🔍 Debugging

### Configuration

```bash
# Validate docker-compose.yml
docker compose config

# View resolved configuration
docker compose config --services

# Check which env vars are used
docker compose config --variables
```

### Inspection

```bash
# View service details
docker compose ps -a

# Inspect service
docker inspect n8n

# View service logs
docker compose logs --tail=50 n8n

# Check network connectivity
docker compose exec n8n ping postgres
docker compose exec n8n nc -zv postgres 5432
```

### Troubleshooting

```bash
# Force recreate containers
docker compose up -d --force-recreate

# Remove everything and start fresh
docker compose down -v
docker compose up -d

# View real-time events
docker compose events

# Check for port conflicts
lsof -i :5678
netstat -tulpn | grep 5678
```

---

## 🎯 Common n8n Patterns

### Basic Setup

```yaml
version: '3.8'
services:
  n8n:
    image: n8nio/n8n
    ports:
      - "5678:5678"
    volumes:
      - n8n-data:/home/node/.n8n
volumes:
  n8n-data:
```

### With PostgreSQL

```yaml
version: '3.8'
services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: n8n
      POSTGRES_USER: n8n
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres-data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U n8n"]
      
  n8n:
    image: n8nio/n8n
    ports:
      - "5678:5678"
    environment:
      DB_TYPE: postgresdb
      DB_POSTGRESDB_HOST: postgres
      DB_POSTGRESDB_USER: n8n
      DB_POSTGRESDB_PASSWORD: ${DB_PASSWORD}
    depends_on:
      postgres:
        condition: service_healthy
        
volumes:
  postgres-data:
```

### Queue Mode

```yaml
version: '3.8'
services:
  postgres:
    image: postgres:15-alpine
    # ... postgres config ...
    
  redis:
    image: redis:7-alpine
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      
  n8n-main:
    image: n8nio/n8n
    ports:
      - "5678:5678"
    environment:
      DB_TYPE: postgresdb
      EXECUTIONS_MODE: queue
      QUEUE_BULL_REDIS_HOST: redis
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
        
  n8n-worker:
    image: n8nio/n8n
    command: worker
    environment:
      DB_TYPE: postgresdb
      EXECUTIONS_MODE: queue
      QUEUE_BULL_REDIS_HOST: redis
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
```

---

## 🚀 Production Tips

### Always Use

- ✅ Specific image versions (not `latest`)
- ✅ Health checks on all services
- ✅ Restart policies (`unless-stopped`)
- ✅ Resource limits
- ✅ Named volumes for data
- ✅ `.env` files for secrets
- ✅ Proper depends_on with conditions

### Never In Production

- ❌ `latest` tags
- ❌ Exposed database ports
- ❌ Hardcoded passwords
- ❌ Debug logging
- ❌ `privileged: true` (unless absolutely necessary)
- ❌ Bind mounts for data (use named volumes)

---

## 📚 Additional Resources

- [Official Docker Compose Docs](https://docs.docker.com/compose/)
- [Compose File Reference](https://docs.docker.com/compose/compose-file/)
- [n8n Docker Docs](https://docs.n8n.io/hosting/installation/docker/)

---

**Back to:** [Lesson 3 Overview](../README.md)

