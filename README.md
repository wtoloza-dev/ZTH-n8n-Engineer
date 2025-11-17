# 🎓 Zero to Hero: n8n Engineer

> From zero to expert in n8n implementation and deployment

## 🎯 What Will You Learn?

This course teaches you how to **implement, configure, and deploy** n8n professionally. This is NOT a course on how to use n8n (that's ZTH: n8n Developer), but rather how to be the **engineer** who installs and maintains it.

### By the end you'll know:

✅ What Docker is and why it's fundamental
✅ How Docker Compose works
✅ The internal architecture of n8n
✅ Why n8n needs Redis and PostgreSQL
✅ Configure n8n locally for development
✅ Deploy n8n to production (VPS)
✅ Configure SSL/HTTPS
✅ Implement automatic CI/CD
✅ Monitor and maintain n8n in production
✅ Troubleshoot common problems
✅ Backups and disaster recovery

---

## 📚 Course Structure

### 🟢 Beginner Level (Foundations)

**Lesson 1: Fundamentals - What is n8n?**
- What n8n is and what it's used for
- Real-world use cases
- General architecture
- Difference between using vs implementing
- 📖 Duration: 30 minutes

**Lesson 2: Docker From Scratch**
- What is a container?
- Why Docker?
- Images vs Containers
- Your first container
- 📖 Duration: 1 hour
- 🧪 Practice: Run your first container

**Lesson 3: Docker Compose**
- The multi-container problem
- docker-compose.yml syntax
- Networks and volumes
- Essential commands
- 📖 Duration: 1 hour
- 🧪 Practice: Multi-container stack

**Lesson 4: Environment Variables**
- What are they and why do they exist?
- .env files
- Secrets and security
- Local vs Production
- 📖 Duration: 30 minutes
- 🧪 Practice: Configure .env

### 🟡 Intermediate Level (Implementation)

**Lesson 5: n8n Architecture**
- n8n components
- The threading problem
- Queue Mode explained
- Complete diagram
- 📖 Duration: 1 hour

**Lesson 6: PostgreSQL for n8n**
- Why a database?
- PostgreSQL vs SQLite vs MySQL
- Configuration for n8n
- PostgreSQL backups
- 📖 Duration: 1 hour
- 🧪 Practice: Connect n8n to PostgreSQL

**Lesson 7: Redis and Queue Mode**
- What is Redis?
- Job queues
- Workers explained
- Horizontal scaling
- 📖 Duration: 1 hour
- 🧪 Practice: Configure Queue Mode

**Lesson 8: Complete Local Setup**
- Local architecture
- docker-compose.local.yml
- Debugging and logs
- Common troubleshooting
- 📖 Duration: 2 hours
- 🧪 Practice: n8n running locally

### 🔴 Advanced Level (Production)

**Lesson 9: Production Preparation**
- Local vs production differences
- Server requirements
- VPS providers
- Estimated costs
- Security checklist
- 📖 Duration: 1 hour

**Lesson 10: Production Deployment**
- Configure server (VPS)
- docker-compose.prod.yml
- Security configuration
- First steps in production
- 📖 Duration: 2 hours
- 🧪 Practice: n8n in production

**Lesson 11: Nginx and HTTPS**
- What is a reverse proxy?
- Configure Nginx
- SSL with Let's Encrypt
- Automatic renewal
- 📖 Duration: 1.5 hours
- 🧪 Practice: HTTPS working

**Lesson 12: CI/CD with GitHub Actions**
- What is CI/CD?
- GitHub Actions explained
- Automatic deployment
- Rollback strategies
- 📖 Duration: 2 hours
- 🧪 Practice: Push to deploy

### 🟣 Expert Level (Operations)

**Lesson 13: Monitoring and Logs**
- Docker logs
- Monitoring with Docker stats
- Basic alerts
- Health checks
- 📖 Duration: 1 hour
- 🧪 Practice: Monitoring dashboard

**Lesson 14: Backups and Recovery**
- Backup strategies
- Automatic backups
- Disaster recovery
- Backup testing
- 📖 Duration: 1.5 hours
- 🧪 Practice: Backup plan

**Lesson 15: Scaling and Performance**
- Scale workers
- PostgreSQL optimization
- Redis tuning
- Load testing
- 📖 Duration: 2 hours
- 🧪 Practice: Scale n8n

**Lesson 16: Advanced Troubleshooting**
- Common problems
- Deep debugging
- Log analysis
- Performance issues
- 📖 Duration: 1 hour

### 🏆 Final Project

**Project: Complete Professional Deployment**
- Setup from scratch
- Production with HTTPS
- Configured CI/CD
- Active monitoring
- Complete documentation
- 📖 Duration: 4-6 hours

---

## 🗺️ Learning Roadmap

### Path 1: Fast (2-3 intensive days)
```
Day 1: Lessons 1-4 (Foundations)
Day 2: Lessons 5-8 (Implementation)
Day 3: Lessons 9-12 (Production)
```

### Path 2: Paced (2 weeks, 1-2 hours/day)
```
Week 1: Foundations + Implementation
Week 2: Production + Operations
```

### Path 3: Deep (1 month, extensive practice)
```
Week 1: Lessons 1-4 + exercises
Week 2: Lessons 5-8 + intermediate project
Week 3: Lessons 9-12 + real deployment
Week 4: Lessons 13-16 + final project
```

---

## 📦 Prerequisites

### Knowledge
- [ ] Basic terminal/command line usage
- [ ] Basic networking concepts (IP, ports, DNS)
- [ ] (Optional) Linux experience

### Required Software
- [ ] Docker Desktop installed
- [ ] Code editor (VS Code recommended)
- [ ] Git installed
- [ ] Terminal (bash/zsh)

### Resources
- [ ] GitHub account
- [ ] (For production) VPS or server
- [ ] (Optional) Own domain

---

## 🎯 How to Use This Course

### 1. Clone the Repository
```bash
git clone https://github.com/your-user/ZTH-n8n-Engineer.git
cd ZTH-n8n-Engineer
```

### 2. Follow Lessons in Order
```bash
cd lessons/01-foundations
# Read README.md
# Do practical exercises
```

### 3. Do the Exercises
Each lesson has a `practice/` folder with exercises.

### 4. Final Project
After completing all lessons, complete the final project.

---

## 📂 Repository Structure

```
ZTH-n8n-Engineer/
├── README.md                    # This file
├── lessons/                     # All lessons
│   ├── 01-foundations/
│   │   ├── README.md           # Lesson theory
│   │   ├── practice/           # Practical exercises
│   │   └── resources/          # Additional files
│   ├── 02-docker-basics/
│   ├── 03-docker-compose/
│   └── ...
├── resources/                   # Shared resources
│   ├── diagrams/               # Diagrams and graphics
│   ├── scripts/                # Useful scripts
│   ├── templates/              # Reusable templates
│   └── cheatsheets/            # Quick reference sheets
├── projects/                    # Practical projects
│   ├── final-project/          # Course final project
│   └── mini-projects/          # Mini projects per module
└── solutions/                   # Solutions to exercises
    └── (hidden until you finish)
```

---

## 🎓 Teaching Methodology

Each lesson follows this structure:

### 1. 🎯 Objectives
What you'll learn in this lesson.

### 2. 📖 Theory
Concepts explained with:
- Real-world analogies
- Visual diagrams
- Practical examples
- Before/after comparisons

### 3. 🧪 Guided Practice
Step-by-step exercises where:
- I explain WHAT you're doing
- I explain WHY you're doing it
- I show the expected result

### 4. 💪 Independent Exercises
Challenges for you to practice on your own.

### 5. ✅ Checklist
Verify you understood everything before continuing.

### 6. 🔗 Additional Resources
Links, videos, documentation to go deeper.

---

## 🏅 Certification (Informal)

Upon completing the course and final project:
1. You'll have a portfolio on GitHub
2. n8n running in production
3. Demonstrable knowledge
4. You can add to your CV: "n8n Infrastructure Engineer"

---

## 🤝 Contributions

This is an open course. If you find:
- Errors
- Improvements
- Additional topics

Open an issue or PR!

---

## 📞 Support

- **Issues**: For bugs or technical questions
- **Discussions**: For general questions
- **Discord**: [Community link] (coming soon)

---

## 📄 License

MIT License - Use it, modify it, share it.

---

## 🚀 Let's Get Started!

```bash
# Next step:
cd lessons/01-foundations
cat README.md
```

**See you in lesson 1!** 🎉

---

## 🗺️ Related Courses

- **ZTH: n8n Developer** (coming soon) - How to USE n8n to create automations
- **ZTH: n8n Advanced** (coming soon) - Custom nodes, advanced integrations
- **ZTH: Docker Mastery** - Deep dive into Docker and Kubernetes

---

**Created with ❤️ for the n8n community**

_Last updated: November 2024_

