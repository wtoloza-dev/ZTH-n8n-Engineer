# Lesson 2: Interactive Exam - Docker Basics

**How to use this exam:**
1. Copy the entire prompt below (between the `---` markers)
2. Paste it into ChatGPT, Claude, Cursor, or any LLM
3. Press Enter and start the interactive exam
4. Answer questions honestly without looking back at the materials

---

## 📋 Copy This Prompt:

```
You are an expert Docker and n8n instructor administering a comprehensive exam for Lesson 2: Docker Basics.

EXAM RULES:
- Ask ONE question at a time
- Wait for my answer before proceeding
- After each answer, provide personalized feedback that varies based on the response
- Your feedback should be conversational and specific to what I wrote
- If my answer is partially correct, acknowledge what's right and gently correct what's wrong
- Keep a running score
- At the end, give a final grade and recommendations

GRADING SCALE:
- 90-100%: Excellent - Ready for Lesson 3 (Docker Compose)
- 75-89%: Good - Review weak areas before proceeding
- 60-74%: Fair - Review the lesson again
- Below 60%: Needs improvement - Re-study the materials

EXAM STRUCTURE (20 questions total):
- Part 1: Docker Fundamentals (4 questions)
- Part 2: Docker Architecture (4 questions)
- Part 3: Docker for n8n (4 questions)
- Part 4: Dockerfiles (4 questions)
- Part 5: Practical Applications (4 questions)

After I respond "START", begin with:
"Welcome to the Lesson 2 Exam! I'll ask you 20 questions across 5 topics about Docker basics for n8n. Answer to the best of your ability. Ready? Here's your first question..."

Then start with Part 1, Question 1.

QUESTION TYPES TO USE (vary throughout the exam):
- Open-ended questions (ask for explanations, descriptions, or reasoning)
- Multiple choice (only when testing specific facts - use sparingly)
- Scenario-based questions (present a situation and ask what would happen or what to do)
- Comparison questions (compare two concepts or approaches)
- Problem-solving questions (present a challenge and ask for solution)

IMPORTANT ABOUT QUESTION VARIETY:
- Use MOSTLY open-ended and scenario-based questions
- Only use multiple choice for 3-4 questions maximum in the entire exam
- Vary your question style so no two consecutive questions feel the same
- Challenge the student to explain concepts in their own words

Keep questions clear, relevant, and based on these topics:

PART 1 - Docker Fundamentals
- What Docker is and why it exists
- Containers vs Virtual Machines
- Difference between images and containers
- The "works on my machine" problem
- Benefits of containerization

PART 2 - Docker Architecture
- Docker daemon (dockerd)
- Docker client (CLI)
- Docker images and layers
- Docker registries (Docker Hub)
- Docker volumes and data persistence
- Docker networks

PART 3 - Docker for n8n
- Why Docker is ideal for n8n
- Official n8n images (tags, variants)
- Environment variables for n8n
- Volume mounting for data persistence
- Port mapping (5678)
- Difference between development and production setups

PART 4 - Dockerfiles
- Purpose of Dockerfile
- Key instructions (FROM, RUN, COPY, CMD, etc.)
- Layer caching and optimization
- Security best practices (USER directive)
- Multi-stage builds
- When to create custom images

PART 5 - Practical Applications
- Running n8n with docker run
- Managing container lifecycle (start, stop, restart)
- Viewing logs and debugging
- Backing up volumes
- Choosing between SQLite and PostgreSQL
- Scaling with multiple containers

After all 20 questions, provide:
1. Final score (X/20 = X%)
2. Grade and interpretation
3. Strongest areas
4. Areas needing review
5. Recommendation (proceed or review)

Type "START" when you're ready to begin.
```

---

## ✅ After Completing the Exam

### If you scored 90%+ 
**Excellent work!** You've mastered Docker basics for n8n.

**👉 [Proceed to Lesson 3: Docker Compose →](../../03-docker-compose/)**

### If you scored 75-89%
**Good job!** Review the topics you missed, then proceed.

Recommended actions:
- Re-read theory sections for weak areas
- Review the [Docker Cheat Sheet](docker-cheatsheet.md) for commands
- Redo practical exercises if needed
- Try running the [example configurations](../examples/)

### If you scored below 75%
**Needs more study.** Take time to review before moving on.

Recommended actions:
- Re-read all theory materials: [Theory Section](../theory/)
- Complete all practical exercises: [Practice Section](../practice/)
- Run through the [examples](../examples/) step by step
- Review the [Docker Cheat Sheet](docker-cheatsheet.md)
- Retake the exam after 24 hours

---

## 📚 Study Resources

If you need to review before taking the exam:

### Theory Materials
- **[Theory 1: What is Docker?](../theory/01-what-is-docker.md)**
- **[Theory 2: Docker Architecture](../theory/02-docker-architecture.md)**
- **[Theory 3: Docker for n8n](../theory/03-docker-for-n8n.md)**
- **[Theory 4: Understanding Dockerfiles](../theory/04-understanding-dockerfiles.md)**

### Practice Exercises
- **[Practice 1: Run n8n with Docker](../practice/01-run-n8n-docker.md)**
- **[Practice 2: Docker Volumes](../practice/02-docker-volumes.md)**
- **[Practice 3: Custom Dockerfile](../practice/03-custom-dockerfile.md)**

### Examples
- **[Example 1: Basic n8n](../examples/01-basic-n8n/)** - Simple setup
- **[Example 2: n8n with PostgreSQL](../examples/02-n8n-postgres/)** - Production database
- **[Example 3: Queue Mode](../examples/03-n8n-queue-mode/)** - High performance
- **[Example 4: Custom Nodes](../examples/04-n8n-custom-nodes/)** - Extended functionality

### Quick Reference
- **[Docker Cheat Sheet](docker-cheatsheet.md)** - Command reference

---

## 💡 Tips for Success

1. **Don't cheat yourself** - Close all materials before starting
2. **Answer honestly** - This helps identify what you really know
3. **Take your time** - Think through each question carefully
4. **Explain concepts** - Don't just memorize, understand WHY
5. **Apply knowledge** - Think about real scenarios
6. **Learn from feedback** - Read the explanations even when correct
7. **Retake if needed** - No shame in reviewing and trying again

---

## 🎯 Exam Objectives

By completing this exam, you demonstrate:

✅ Understanding of Docker fundamentals and why it matters  
✅ Knowledge of Docker architecture components  
✅ Ability to work with Docker images and containers  
✅ Comprehension of Dockerfiles and image building  
✅ Skills to run and manage n8n in Docker  
✅ Understanding of data persistence with volumes  
✅ Ability to choose appropriate n8n deployment patterns  

---

## 🧪 Hands-On Verification

After passing the exam, verify your skills practically:

```bash
# Can you do these without looking at the notes?

1. Run n8n with Docker
docker run -d --name n8n -p 5678:5678 -v n8n-data:/home/node/.n8n n8nio/n8n

2. View logs
docker logs -f n8n

3. Backup volume
docker run --rm -v n8n-data:/data -v $(pwd):/backup alpine tar czf /backup/backup.tar.gz -C /data .

4. Build custom image
# Create Dockerfile, then:
docker build -t my-n8n:1.0 .

5. Run with PostgreSQL
# Start network, PostgreSQL, then n8n with DB_TYPE=postgresdb
```

If you can do all of these confidently, you're ready for Lesson 3!

---

## 📈 What's Next?

Once you pass this exam with 75%+:

**Lesson 3: Docker Compose**
- Orchestrate multiple containers
- Manage complex n8n stacks
- Production-ready configurations
- Infrastructure as code

---

**Good luck! 🚀**

**Back to:** [Lesson 2 Overview](../README.md)

