# Docker Compose Examples for n8n

Real-world, production-ready Docker Compose configurations for various n8n deployment scenarios.

---

## 📁 Available Examples

### [01-basic-n8n](01-basic-n8n/)
**Difficulty:** ⭐ Beginner  
**Use Case:** Development, testing, personal projects

Quick setup with minimal configuration:
- Single n8n container
- SQLite database (no external DB needed)
- Data persistence with volumes
- Ready in 30 seconds

**When to use:**
- Learning n8n
- Local development
- Quick prototyping
- Personal automation projects

---

### [02-n8n-postgres](02-n8n-postgres/)
**Difficulty:** ⭐⭐ Intermediate  
**Use Case:** Small to medium production deployments

Production-ready setup with PostgreSQL:
- n8n + PostgreSQL
- Proper health checks
- Environment variable management
- Data persistence for both services
- Basic security

**When to use:**
- Small business production
- Team collaboration
- Up to 100 active workflows
- Need reliable database

---

### [03-queue-mode-complete](03-queue-mode-complete/)
**Difficulty:** ⭐⭐⭐ Advanced  
**Use Case:** High-performance production

Complete enterprise setup with queue mode:
- n8n main + multiple workers
- PostgreSQL database
- Redis queue
- Horizontal scaling
- Health monitoring
- Production security

**When to use:**
- Enterprise deployments
- High traffic workloads
- 100+ active workflows
- Need horizontal scaling
- Mission-critical automation

---

### [04-dev-stack](04-dev-stack/)
**Difficulty:** ⭐⭐ Intermediate  
**Use Case:** Development environment

Full development stack with all tools:
- n8n with hot reload
- PostgreSQL
- Redis
- Adminer (database UI)
- Redis Commander (Redis UI)
- Nginx (reverse proxy)

**When to use:**
- Local development
- Testing integrations
- Debugging workflows
- Learning n8n architecture

---

## 🚀 Quick Start

Each example includes:
- Complete `docker-compose.yml`
- `.env.example` template
- `README.md` with instructions
- Startup scripts (where applicable)

### General Usage Pattern

```bash
# 1. Navigate to example directory
cd 01-basic-n8n/

# 2. Copy environment template
cp .env.example .env

# 3. Edit .env with your values
nano .env

# 4. Start the stack
docker compose up -d

# 5. Access n8n
open http://localhost:5678
```

---

## 📊 Comparison Matrix

| Feature | Basic | + PostgreSQL | Queue Mode | Dev Stack |
|---------|-------|--------------|------------|-----------|
| **Setup Time** | 30 sec | 2 min | 5 min | 3 min |
| **Containers** | 1 | 2 | 4+ | 6 |
| **Database** | SQLite | PostgreSQL | PostgreSQL | PostgreSQL |
| **Queue** | ❌ | ❌ | ✅ Redis | ✅ Redis |
| **Scalability** | Low | Medium | High | Medium |
| **RAM Usage** | ~200MB | ~400MB | ~1GB | ~800MB |
| **Production Ready** | ❌ | ✅ | ✅ | ❌ |
| **Best For** | Learning | Small prod | Enterprise | Development |

---

## 💡 Choosing the Right Example

### Start Here: Basic n8n

If you're **new to n8n** or Docker Compose → **[01-basic-n8n](01-basic-n8n/)**

### For Production

**Small business (< 50 workflows):**  
→ **[02-n8n-postgres](02-n8n-postgres/)**

**Medium to large (50-200 workflows):**  
→ **[03-queue-mode-complete](03-queue-mode-complete/)** with 2-3 workers

**Enterprise (200+ workflows):**  
→ **[03-queue-mode-complete](03-queue-mode-complete/)** with 5+ workers

### For Development

**Learning or testing:**  
→ **[04-dev-stack](04-dev-stack/)**

---

## 🔧 Common Modifications

### Change Ports

Edit `docker-compose.yml`:

```yaml
ports:
  - "8080:5678"    # Access n8n at :8080 instead of :5678
```

### Add Basic Authentication

Add to n8n environment:

```yaml
environment:
  - N8N_BASIC_AUTH_ACTIVE=true
  - N8N_BASIC_AUTH_USER=admin
  - N8N_BASIC_AUTH_PASSWORD=secure_password
```

### Increase Worker Count (Queue Mode)

```bash
docker compose up -d --scale n8n-worker=5
```

### Add Custom Nodes

Mount custom nodes directory:

```yaml
volumes:
  - ./custom-nodes:/home/node/.n8n/custom
```

---

## 🛡️ Security Best Practices

All examples follow these security principles:

### 1. Environment Variables

```bash
# Never commit .env files
echo ".env" >> .gitignore
```

### 2. Encryption Key

```bash
# Generate strong encryption key
openssl rand -base64 32
```

### 3. Database Passwords

```bash
# Use strong, random passwords
openssl rand -base64 24
```

### 4. Network Isolation

```yaml
networks:
  internal:
    internal: true    # No external access
```

### 5. Non-Root User

n8n official image already uses non-root user (UID 1000).

---

## 📚 Additional Resources

### Official Documentation
- [n8n Docker Documentation](https://docs.n8n.io/hosting/installation/docker/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

### Course Materials
- [Theory: Docker Compose for n8n](../theory/04-compose-for-n8n.md)
- [Practice: Complete Stack](../practice/03-complete-stack.md)
- [Cheat Sheet](../resources/compose-cheatsheet.md)

---

## 🐛 Troubleshooting

### General Issues

**Services won't start:**
```bash
docker compose logs
```

**Check service health:**
```bash
docker compose ps
```

**Rebuild from scratch:**
```bash
docker compose down -v
docker compose up -d
```

### Port Conflicts

```bash
# Find what's using port 5678
lsof -i :5678

# Change port in docker-compose.yml
ports:
  - "8080:5678"
```

### Permission Issues

```bash
# Fix volume permissions
sudo chown -R 1000:1000 ./data
```

---

## 📖 Example Structure

Each example follows this structure:

```
example-name/
├── docker-compose.yml      # Main Compose file
├── .env.example            # Environment template
├── README.md               # Detailed instructions
├── .gitignore              # Ignore secrets
└── scripts/                # Helper scripts (optional)
    ├── start.sh
    ├── stop.sh
    └── backup.sh
```

---

## 🎯 Next Steps

1. Choose an example based on your needs
2. Follow the README in that example
3. Customize for your use case
4. Deploy and test
5. Monitor and optimize

---

**Questions or issues?** Open an issue in the repository or ask in the community.

**Back to:** [Lesson 3 Overview](../README.md)

