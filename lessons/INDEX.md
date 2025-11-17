# 📚 Lessons Index - ZTH: n8n Engineer

## 🎯 How to Navigate the Lessons

1. **Read the README.md of each lesson** - Contains all the theory
2. **Do the exercises in `/practice`** - Hands-on learning
3. **Check `/resources`** - Additional material and references
4. **Complete the checklist** at the end of each lesson
5. **Don't skip lessons** - Each one builds upon the previous one

---

## 🟢 BEGINNER LEVEL: Foundations

### [Lesson 1: Fundamentals - What is n8n?](./01-foundations)
**Duration:** 30 minutes | **Difficulty:** ⭐

📖 **You will learn:**
- What n8n is and what it's used for
- Real-world use cases
- Difference between "using" vs "implementing" n8n
- High-level general architecture

🧪 **Practice:**
- Explore n8n.io and use cases
- Identify automation scenarios

🎯 **Goal:** Understand WHAT you're going to learn to implement

---

### [Lesson 2: Docker From Scratch](./02-docker-basics)
**Duration:** 1 hour | **Difficulty:** ⭐⭐

📖 **You will learn:**
- What is a container? (with analogies)
- Why Docker solves "it works on my machine"?
- Images vs Containers
- Essential Docker commands
- Volumes and persistence

🧪 **Practice:**
- Install Docker Desktop
- Run your first container
- Explore active containers
- Create a container with volume

🎯 **Goal:** Master basic Docker concepts

---

### [Lesson 3: Docker Compose](./03-docker-compose)
**Duration:** 1 hour | **Difficulty:** ⭐⭐

📖 **You will learn:**
- The multi-container problem
- docker-compose.yml syntax
- Services, networks and volumes
- Docker Compose commands
- depends_on and startup order

🧪 **Practice:**
- Create your first docker-compose.yml
- Multi-container stack (nginx + app)
- Connect containers to each other

🎯 **Goal:** Orchestrate multiple containers

---

### [Lesson 4: Environment Variables](./04-variables-entorno)
**Duration:** 30 minutes | **Difficulty:** ⭐

📖 **You will learn:**
- What are environment variables?
- .env and .env.example files
- Secrets and security
- Local vs Production
- .gitignore and security

🧪 **Practice:**
- Create .env file
- Use variables in docker-compose
- Separate local/prod configuration

🎯 **Goal:** Configure applications securely

---

## 🟡 INTERMEDIATE LEVEL: Implementation

### [Lesson 5: n8n Architecture](./05-arquitectura-n8n)
**Duration:** 1 hour | **Difficulty:** ⭐⭐

📖 **You will learn:**
- n8n components (Web + Workers)
- The threading problem explained
- Queue Mode vs Main Mode
- Why Redis is necessary
- Complete architecture diagram

🧪 **Practice:**
- Analyze architecture diagrams
- Compare Main Mode vs Queue Mode
- Identify bottlenecks

🎯 **Goal:** Understand how n8n works internally

---

### [Lesson 6: PostgreSQL for n8n](./06-postgresql)
**Duration:** 1 hour | **Difficulty:** ⭐⭐

📖 **You will learn:**
- Why does n8n need a database?
- PostgreSQL vs SQLite vs MySQL
- PostgreSQL configuration for n8n
- Connection and verification
- Basic PostgreSQL backups

🧪 **Practice:**
- Launch PostgreSQL with Docker
- Connect to PostgreSQL with CLI
- View n8n tables
- Perform manual backup

🎯 **Goal:** Configure and manage PostgreSQL

---

### [Lesson 7: Redis and Queue Mode](./07-redis-queue)
**Duration:** 1 hour | **Difficulty:** ⭐⭐⭐

📖 **You will learn:**
- What is Redis and why is it fast?
- Job queues explained
- Workers and parallelism
- Horizontal scaling of workers
- Queue monitoring

🧪 **Practice:**
- Launch Redis with Docker
- Connect to Redis with redis-cli
- View n8n queues
- Simulate workload

🎯 **Goal:** Master Queue Mode with Redis

---

### [Lesson 8: Complete Local Setup](./08-setup-local)
**Duration:** 2 hours | **Difficulty:** ⭐⭐⭐

📖 **You will learn:**
- Complete local architecture
- docker-compose.local.yml explained
- Effective debugging and logs
- Common troubleshooting
- Development workflow

🧪 **Practice:**
- Configure complete n8n locally
- Create and execute workflows
- Debug problems
- Export/import workflows

🎯 **Goal:** n8n running 100% locally

---

## 🔴 ADVANCED LEVEL: Production

### [Lesson 9: Production Preparation](./09-preparacion-prod)
**Duration:** 1 hour | **Difficulty:** ⭐⭐

📖 **You will learn:**
- Critical differences local vs production
- Server requirements (VPS)
- Recommended providers
- Cost estimation
- Security checklist

🧪 **Practice:**
- Compare VPS providers
- Calculate necessary resources
- Review security checklist

🎯 **Goal:** Plan production deployment

---

### [Lesson 10: Production Deployment](./10-deploy-produccion)
**Duration:** 2 hours | **Difficulty:** ⭐⭐⭐

📖 **You will learn:**
- Configure server (VPS) from scratch
- docker-compose.prod.yml explained
- Security configuration
- Firewall and ports
- First steps in production

🧪 **Practice:**
- Configure a VPS
- Install Docker on server
- Deploy n8n to production
- Verify it works

🎯 **Goal:** n8n running in production

---

### [Lesson 11: Nginx and HTTPS](./11-nginx-https)
**Duration:** 1.5 hours | **Difficulty:** ⭐⭐⭐

📖 **You will learn:**
- What is a reverse proxy?
- Configure Nginx for n8n
- SSL/TLS with Let's Encrypt
- Automatic certificate renewal
- Security configuration

🧪 **Practice:**
- Configure Nginx
- Obtain SSL certificate
- HTTPS working
- HTTP → HTTPS redirection

🎯 **Goal:** n8n accessible via HTTPS

---

### [Lesson 12: CI/CD with GitHub Actions](./12-cicd)
**Duration:** 2 hours | **Difficulty:** ⭐⭐⭐

📖 **You will learn:**
- What is CI/CD and why use it?
- GitHub Actions explained
- Deployment workflows
- SSH keys and security
- Rollback strategies

🧪 **Practice:**
- Configure GitHub Actions
- Automatic push to deploy
- Testing deployments
- Simulate rollback

🎯 **Goal:** Automatic deployment with git push

---

## 🟣 EXPERT LEVEL: Operations

### [Lesson 13: Monitoring and Logs](./13-monitoreo)
**Duration:** 1 hour | **Difficulty:** ⭐⭐⭐

📖 **You will learn:**
- Docker logs
- docker stats and monitoring
- Advanced health checks
- Basic alerts
- Production debugging

🧪 **Practice:**
- Configure health checks
- Create monitoring dashboard
- Simulate and detect problems

🎯 **Goal:** Monitor n8n in production

---

### [Lesson 14: Backups and Recovery](./14-backups)
**Duration:** 1.5 hours | **Difficulty:** ⭐⭐⭐

📖 **You will learn:**
- Backup strategies (3-2-1)
- Automatic PostgreSQL backups
- Disaster recovery planning
- Backup testing
- Backup retention

🧪 **Practice:**
- Configure automatic backups
- Simulate data loss
- Recover from backup
- Document process

🎯 **Goal:** Robust backup system

---

### [Lesson 15: Scaling and Performance](./15-escalado)
**Duration:** 2 hours | **Difficulty:** ⭐⭐⭐⭐

📖 **You will learn:**
- Scale workers horizontally
- PostgreSQL optimization
- Redis tuning
- Load testing
- Identify bottlenecks

🧪 **Practice:**
- Scale to 5+ workers
- Load testing with tools
- Optimize configuration
- Measure improvements

🎯 **Goal:** Optimized and scaled n8n

---

### [Lesson 16: Advanced Troubleshooting](./16-troubleshooting)
**Duration:** 1 hour | **Difficulty:** ⭐⭐⭐

📖 **You will learn:**
- Common problems and solutions
- Deep debugging
- Log analysis
- Performance issues
- Recovery from critical situations

🧪 **Practice:**
- Real troubleshooting cases
- Live debugging
- Create problem runbook

🎯 **Goal:** Solve any problem

---

## 🏆 FINAL PROJECT

### [Project: Complete Professional Deployment](../projects/final-project)
**Duration:** 4-6 hours | **Difficulty:** ⭐⭐⭐⭐

🎯 **Goal:**
Deploy n8n in a 100% professional manner from scratch.

**Includes:**
- Setup from scratch on VPS
- PostgreSQL + Redis
- Queue Mode with 3 workers
- HTTPS with valid certificate
- Automatic CI/CD
- Automatic backups
- Basic monitoring
- Complete documentation

**Deliverables:**
- GitHub repository
- n8n running in production
- Process documentation
- Operations runbook

---

## 📊 Recommended Progress

### Week 1: Foundations
- [ ] Lesson 1: Fundamentals
- [ ] Lesson 2: Docker Basics
- [ ] Lesson 3: Docker Compose
- [ ] Lesson 4: Environment Variables

### Week 2: Implementation
- [ ] Lesson 5: n8n Architecture
- [ ] Lesson 6: PostgreSQL
- [ ] Lesson 7: Redis and Queue
- [ ] Lesson 8: Local Setup

### Week 3: Production
- [ ] Lesson 9: Preparation
- [ ] Lesson 10: Production Deployment
- [ ] Lesson 11: Nginx and HTTPS
- [ ] Lesson 12: CI/CD

### Week 4: Operations & Project
- [ ] Lesson 13: Monitoring
- [ ] Lesson 14: Backups
- [ ] Lesson 15: Scaling
- [ ] Lesson 16: Troubleshooting
- [ ] Final Project

---

## 🎓 Certification

Upon completing all lessons and the final project:
- ✅ Demonstrable knowledge of n8n
- ✅ GitHub portfolio
- ✅ n8n running in production
- ✅ Applied DevOps skills

---

**Start with [Lesson 1: Fundamentals](./01-foundations)!**

