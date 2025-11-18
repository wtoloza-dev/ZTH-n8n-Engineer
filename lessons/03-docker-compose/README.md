# 📘 Lesson 3: Docker Compose for n8n

**Estimated Duration:** 50 minutes  
**Level:** Intermediate ⭐⭐⭐  
**Prerequisites:** Lesson 2 (Docker Basics)

---

## 🎯 Learning Objectives

By the end of this lesson you will be able to:
- Explain what Docker Compose is and why it's essential for n8n
- Write `docker-compose.yml` files from scratch
- Orchestrate multiple containers (n8n + PostgreSQL + Redis)
- Manage services, networks, and volumes with Compose
- Deploy n8n in queue mode with a single command

---

## 📖 Theory (25 minutes)

Work through these sections in order:

1. **[What is Docker Compose?](theory/01-what-is-compose.md)** - 6 min
   - From multiple commands to one file
   - YAML and basic syntax
   - Why Compose is perfect for n8n

2. **[Anatomy of docker-compose.yml](theory/02-compose-anatomy.md)** - 8 min
   - File structure
   - Services, networks, volumes
   - Environment variables and secrets

3. **[Networks and Container Communication](theory/03-compose-networking.md)** - 6 min
   - Automatic networking
   - Internal DNS
   - Service dependencies

4. **[Docker Compose for n8n](theory/04-compose-for-n8n.md)** - 5 min
   - Complete n8n stack
   - Production configuration
   - Best practices and optimizations

---

## 🧪 Practice (25 minutes)

Complete these hands-on exercises:

1. **[Your First docker-compose.yml](practice/01-first-compose.md)** - 8 min
   - Create basic file for n8n
   - Start services with `docker compose up`
   - Verify functionality

2. **[n8n + PostgreSQL with Compose](practice/02-n8n-postgres-compose.md)** - 9 min
   - Add PostgreSQL service
   - Configure networking
   - Environment variables

3. **[Complete Stack: Queue Mode](practice/03-complete-stack.md)** - 8 min
   - n8n + PostgreSQL + Redis
   - Multiple workers
   - Horizontal scaling

---

## 📚 Resources & Examples

Additional materials to support your learning:

- **[Docker Compose Cheat Sheet](resources/compose-cheatsheet.md)** - Quick reference
- **[Interactive Exam](resources/exam.md)** - Test your knowledge with AI
- **[Example Configurations](examples/)** - Real n8n stacks
  - Basic n8n with Compose
  - n8n + PostgreSQL
  - Complete Queue Mode
  - Full development stack

---

## 🎯 Next Steps

Once you've completed all sections above:

1. Complete all practice exercises
2. Review the example configurations
3. Experiment modifying docker-compose.yml files
4. Take the [Interactive Exam](resources/exam.md) to verify your knowledge
5. Score 75%+ to demonstrate mastery

**👉 [Go to Lesson 4: Environment Variables →](../../04-variables-entorno)**

---

## 💬 Instructor Notes

> **Tip:** Docker Compose transforms the complexity of managing multiple containers into a single declarative file. For n8n in production, Compose is practically indispensable.

> **Important:** Once you master Compose, you'll never want to go back to individual `docker run` commands. It's infrastructure as code at its finest.

---

**Questions?** Open an issue in the repository or ask in the community.

