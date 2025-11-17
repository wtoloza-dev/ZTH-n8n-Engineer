# Docker Examples for n8n

This directory contains real-world Docker configurations for running n8n in different scenarios.

---

## 📁 Available Examples

### 1. **[basic-n8n](01-basic-n8n/)**
Simple n8n setup with SQLite database.
- **Use case:** Development, testing, personal projects
- **Complexity:** ⭐ Beginner
- **Components:** n8n only

### 2. **[n8n-with-postgres](02-n8n-postgres/)**
n8n with PostgreSQL database instead of SQLite.
- **Use case:** Small to medium production deployments
- **Complexity:** ⭐⭐ Intermediate
- **Components:** n8n + PostgreSQL

### 3. **[n8n-queue-mode](03-n8n-queue-mode/)**
n8n with Redis for queue mode (high performance).
- **Use case:** High-traffic production deployments
- **Complexity:** ⭐⭐⭐ Advanced
- **Components:** n8n + PostgreSQL + Redis

### 4. **[n8n-custom-nodes](04-n8n-custom-nodes/)**
n8n with custom nodes and additional packages.
- **Use case:** Extended functionality requirements
- **Complexity:** ⭐⭐ Intermediate
- **Components:** Custom n8n image

---

## 🚀 Quick Start

Each example directory contains:
- `Dockerfile` - Custom Docker image (if needed)
- `docker-compose.yml` - Multi-container setup (some examples)
- `README.md` - Detailed instructions
- `.env.example` - Environment variables template

**To use an example:**

```bash
# Navigate to example directory
cd 01-basic-n8n/

# Copy environment template (if available)
cp .env.example .env

# Edit environment variables
nano .env

# Follow README.md instructions
```

---

## 📊 Comparison Matrix

| Example | Database | Queue | Scalability | Complexity | Best For |
|---------|----------|-------|-------------|------------|----------|
| Basic | SQLite | No | Low | ⭐ | Learning, Testing |
| With PostgreSQL | PostgreSQL | No | Medium | ⭐⭐ | Small Production |
| Queue Mode | PostgreSQL | Redis | High | ⭐⭐⭐ | Enterprise |
| Custom Nodes | Any | Optional | Variable | ⭐⭐ | Special Requirements |

---

## 💡 Tips

1. **Start Simple:** Begin with the basic example, then progress to more complex setups
2. **Use Volumes:** Always mount volumes for data persistence
3. **Version Pinning:** Use specific versions in production (e.g., `n8nio/n8n:1.19.0`)
4. **Environment Variables:** Never commit `.env` files with real credentials
5. **Backup:** Regularly backup your volumes

---

## 🔗 Related Lessons

- [Lesson 3: Docker Compose](../../03-docker-compose/)
- [Lesson 4: Environment Variables](../../04-variables-entorno/)
- [Lesson 5: n8n Architecture](../../05-arquitectura-n8n/)

