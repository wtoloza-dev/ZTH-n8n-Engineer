# Docker Cheat Sheet for n8n

Quick reference guide for Docker commands used with n8n.

---

## 🚀 Quick Start Commands

```bash
# Run n8n (basic)
docker run -d --name n8n -p 5678:5678 -v n8n-data:/home/node/.n8n n8nio/n8n

# Run n8n with PostgreSQL
docker run -d --name postgres --network n8n-net -e POSTGRES_USER=n8n -e POSTGRES_PASSWORD=pass -e POSTGRES_DB=n8n postgres:15
docker run -d --name n8n --network n8n-net -p 5678:5678 -e DB_TYPE=postgresdb -e DB_POSTGRESDB_HOST=postgres -v n8n-data:/home/node/.n8n n8nio/n8n
```

---

## 📦 Image Commands

```bash
# Pull image
docker pull n8nio/n8n:latest
docker pull n8nio/n8n:1.19.0          # Specific version

# List images
docker images
docker images | grep n8n

# Remove image
docker rmi n8nio/n8n:latest
docker rmi $(docker images -q n8nio/n8n)  # Remove all n8n images

# Build custom image
docker build -t my-n8n:1.0 .
docker build -f Dockerfile.custom -t my-n8n .

# Inspect image
docker inspect n8nio/n8n:latest
docker history n8nio/n8n:latest       # View layers
```

---

## 🐳 Container Commands

### Create & Run

```bash
# Run (create + start)
docker run -d --name n8n n8nio/n8n

# Run with options
docker run -d \
  --name n8n \
  --restart unless-stopped \
  -p 5678:5678 \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -v n8n-data:/home/node/.n8n \
  n8nio/n8n:latest

# Run with environment file
docker run -d --name n8n --env-file .env n8nio/n8n

# Create without starting
docker create --name n8n -p 5678:5678 n8nio/n8n
```

### Manage Containers

```bash
# List containers
docker ps                           # Running
docker ps -a                        # All (including stopped)
docker ps --format "{{.Names}}"     # Just names

# Start/Stop
docker start n8n
docker stop n8n
docker restart n8n
docker stop $(docker ps -q)         # Stop all

# Pause/Unpause
docker pause n8n
docker unpause n8n

# Remove
docker rm n8n
docker rm -f n8n                    # Force remove (stop + remove)
docker rm $(docker ps -aq)          # Remove all stopped containers
```

### Inspect & Debug

```bash
# View logs
docker logs n8n
docker logs -f n8n                  # Follow logs
docker logs --tail 100 n8n          # Last 100 lines
docker logs --since 10m n8n         # Last 10 minutes

# Inspect container
docker inspect n8n
docker inspect -f '{{.State.Status}}' n8n
docker inspect -f '{{.NetworkSettings.IPAddress}}' n8n

# View processes
docker top n8n

# View stats
docker stats n8n
docker stats --no-stream n8n        # One-time stats

# Port mapping
docker port n8n
```

### Execute Commands

```bash
# Interactive shell
docker exec -it n8n sh
docker exec -it n8n bash            # If bash available

# Run single command
docker exec n8n n8n --version
docker exec n8n ls -la /home/node/.n8n
docker exec n8n ps aux

# Execute as specific user
docker exec -u root n8n apk add curl
```

### Copy Files

```bash
# Copy from container to host
docker cp n8n:/home/node/.n8n/database.sqlite ./backup.sqlite

# Copy from host to container
docker cp config.json n8n:/home/node/.n8n/config.json
```

---

## 💾 Volume Commands

```bash
# Create volume
docker volume create n8n-data

# List volumes
docker volume ls
docker volume ls -q                 # Just names

# Inspect volume
docker volume inspect n8n-data

# Remove volume
docker volume rm n8n-data
docker volume rm $(docker volume ls -q)  # Remove all

# Prune unused volumes
docker volume prune
docker volume prune -f              # Force (no prompt)

# Backup volume
docker run --rm -v n8n-data:/data -v $(pwd):/backup alpine tar czf /backup/backup.tar.gz -C /data .

# Restore volume
docker run --rm -v n8n-data:/data -v $(pwd):/backup alpine tar xzf /backup/backup.tar.gz -C /data
```

---

## 🌐 Network Commands

```bash
# Create network
docker network create n8n-network
docker network create --driver bridge n8n-network

# List networks
docker network ls

# Inspect network
docker network inspect n8n-network
docker network inspect -f '{{range .Containers}}{{.Name}} {{end}}' n8n-network

# Connect container to network
docker network connect n8n-network n8n

# Disconnect container
docker network disconnect n8n-network n8n

# Remove network
docker network rm n8n-network
docker network prune                # Remove unused networks
```

---

## 🔧 System Commands

```bash
# System info
docker info
docker version

# Disk usage
docker system df
docker system df -v                 # Detailed

# Clean up
docker system prune                 # Remove unused data
docker system prune -a              # Remove all unused (including images)
docker system prune -af --volumes   # Nuclear option (careful!)

# Show all running processes
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

---

## 🐛 Debugging & Troubleshooting

### Container Won't Start

```bash
# Check logs
docker logs n8n

# Inspect container
docker inspect n8n | grep -A 10 State

# Try running interactively
docker run -it --rm n8nio/n8n sh
```

### Network Issues

```bash
# Test connectivity between containers
docker exec n8n ping n8n-postgres

# Check network configuration
docker network inspect n8n-network

# Test from host
curl http://localhost:5678
```

### Permission Issues

```bash
# Check file ownership in container
docker exec n8n ls -la /home/node/.n8n

# Fix permissions (if needed)
docker exec -u root n8n chown -R node:node /home/node/.n8n
```

### Resource Issues

```bash
# Check resource usage
docker stats n8n

# Limit resources
docker run -d --name n8n --cpus="2.0" --memory="2g" n8nio/n8n
```

---

## 🎯 n8n-Specific Commands

```bash
# Run with basic auth
docker run -d --name n8n \
  -p 5678:5678 \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=admin \
  -e N8N_BASIC_AUTH_PASSWORD=password \
  n8nio/n8n

# Run with PostgreSQL
docker run -d --name n8n \
  -p 5678:5678 \
  -e DB_TYPE=postgresdb \
  -e DB_POSTGRESDB_HOST=postgres \
  -e DB_POSTGRESDB_DATABASE=n8n \
  -e DB_POSTGRESDB_USER=n8n \
  -e DB_POSTGRESDB_PASSWORD=password \
  -v n8n-data:/home/node/.n8n \
  n8nio/n8n

# Check n8n version
docker exec n8n n8n --version

# Export workflows
docker exec n8n n8n export:workflow --all --output=/tmp/workflows.json
docker cp n8n:/tmp/workflows.json ./workflows-backup.json

# Import workflows
docker cp workflows-backup.json n8n:/tmp/workflows.json
docker exec n8n n8n import:workflow --input=/tmp/workflows.json
```

---

## 📋 Common Patterns

### Start Multiple Containers

```bash
# Create network
docker network create n8n-net

# Start PostgreSQL
docker run -d \
  --name postgres \
  --network n8n-net \
  -e POSTGRES_USER=n8n \
  -e POSTGRES_PASSWORD=n8n \
  -e POSTGRES_DB=n8n \
  -v postgres-data:/var/lib/postgresql/data \
  postgres:15

# Wait for PostgreSQL
sleep 10

# Start n8n
docker run -d \
  --name n8n \
  --network n8n-net \
  -p 5678:5678 \
  -e DB_TYPE=postgresdb \
  -e DB_POSTGRESDB_HOST=postgres \
  -v n8n-data:/home/node/.n8n \
  n8nio/n8n
```

### Complete Cleanup

```bash
# Stop and remove all n8n-related containers
docker stop n8n n8n-postgres n8n-redis
docker rm n8n n8n-postgres n8n-redis

# Remove volumes (WARNING: deletes data)
docker volume rm n8n-data postgres-data redis-data

# Remove network
docker network rm n8n-network

# Remove images
docker rmi n8nio/n8n postgres redis
```

### Backup Everything

```bash
# Backup n8n volume
docker run --rm \
  -v n8n-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/n8n-$(date +%Y%m%d).tar.gz -C /data .

# Backup PostgreSQL
docker exec postgres pg_dump -U n8n n8n > n8n-db-$(date +%Y%m%d).sql
```

---

## 🔗 Useful Docker Run Flags

| Flag | Description | Example |
|------|-------------|---------|
| `-d` | Detached (background) | `-d` |
| `--name` | Container name | `--name n8n` |
| `-p` | Port mapping | `-p 5678:5678` |
| `-e` | Environment variable | `-e N8N_PORT=5678` |
| `-v` | Volume mount | `-v n8n-data:/home/node/.n8n` |
| `--network` | Connect to network | `--network n8n-net` |
| `--restart` | Restart policy | `--restart unless-stopped` |
| `--cpus` | CPU limit | `--cpus="2.0"` |
| `--memory` | Memory limit | `--memory="2g"` |
| `--env-file` | Environment file | `--env-file .env` |
| `-it` | Interactive + TTY | `-it` |
| `--rm` | Auto-remove on exit | `--rm` |
| `-u` | Run as user | `-u root` |

---

## 💡 Pro Tips

```bash
# View real-time events
docker events

# Format output with Go templates
docker ps --format "{{.Names}}: {{.Status}}"

# Filter containers
docker ps --filter "name=n8n" --filter "status=running"

# See what changed in container filesystem
docker diff n8n

# Export/Import containers
docker export n8n > n8n-container.tar
docker import n8n-container.tar my-n8n:backup

# Save/Load images
docker save n8nio/n8n:latest > n8n-image.tar
docker load < n8n-image.tar
```

---

**For more details, see:**
- [Docker Official Docs](https://docs.docker.com/)
- [n8n Documentation](https://docs.n8n.io/)
- [Lesson 3: Docker Compose](../../03-docker-compose/)

