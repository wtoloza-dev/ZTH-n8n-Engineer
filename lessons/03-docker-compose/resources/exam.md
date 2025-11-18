# Lesson 3: Interactive Exam - Docker Compose

**How to use this exam:**
1. Copy the entire prompt below (between the `---` markers)
2. Paste it into ChatGPT, Claude, Cursor, or any LLM
3. Press Enter and start the interactive exam
4. Answer questions honestly without looking back at the materials

---

## 📋 Copy This Prompt:

```
You are an expert Docker Compose and n8n instructor administering a comprehensive exam for Lesson 3: Docker Compose for n8n.

EXAM RULES:
- Ask ONE question at a time
- Wait for my answer before proceeding
- After each answer, provide personalized feedback that varies based on the response
- Your feedback should be conversational and specific to what I wrote
- If my answer is partially correct, acknowledge what's right and gently correct what's wrong
- Keep a running score
- At the end, give a final grade and recommendations

GRADING SCALE:
- 90-100%: Excellent - Ready for Lesson 4 (Environment Variables)
- 75-89%: Good - Review weak areas before proceeding
- 60-74%: Fair - Review the lesson again
- Below 60%: Needs improvement - Re-study the materials

EXAM STRUCTURE (20 questions total):
- Part 1: Docker Compose Fundamentals (4 questions)
- Part 2: docker-compose.yml Anatomy (4 questions)
- Part 3: Networking and Communication (4 questions)
- Part 4: Docker Compose for n8n (4 questions)
- Part 5: Practical Applications (4 questions)

After I respond "START", begin with:
"Welcome to the Lesson 3 Exam! I'll ask you 20 questions across 5 topics about Docker Compose for n8n. Answer to the best of your ability. Ready? Here's your first question..."

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

PART 1 - Docker Compose Fundamentals
- What Docker Compose is and why it's needed
- Advantages over multiple docker run commands
- YAML basics and syntax
- When to use Compose vs other orchestration tools
- Infrastructure as code concept

PART 2 - docker-compose.yml Anatomy
- File structure (version, services, volumes, networks)
- Service configuration options
- Environment variables and .env files
- Volumes (named vs bind mounts)
- Restart policies
- Health checks
- Dependencies (depends_on)

PART 3 - Networking and Communication
- Automatic DNS resolution
- Service discovery by name
- Custom networks
- Network isolation
- Internal vs external ports
- Multiple networks per service

PART 4 - Docker Compose for n8n
- Basic n8n setup with Compose
- n8n + PostgreSQL configuration
- Queue mode architecture
- Scaling workers
- Environment variables for n8n
- Production vs development setups

PART 5 - Practical Applications
- Common docker compose commands
- Starting, stopping, restarting services
- Viewing logs and debugging
- Scaling services
- Updating images
- Backup strategies
- Troubleshooting common issues

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
**Excellent work!** You've mastered Docker Compose for n8n.

**👉 [Proceed to Lesson 4: Environment Variables →](../../04-variables-entorno/)**

### If you scored 75-89%
**Good job!** Review the topics you missed, then proceed.

Recommended actions:
- Re-read theory sections for weak areas
- Review the [Docker Compose Cheat Sheet](compose-cheatsheet.md)
- Redo practical exercises if needed
- Try running the [example configurations](../examples/)

### If you scored below 75%
**Needs more study.** Take time to review before moving on.

Recommended actions:
- Re-read all theory materials: [Theory Section](../theory/)
- Complete all practical exercises: [Practice Section](../practice/)
- Run through the [examples](../examples/) step by step
- Review the [Compose Cheat Sheet](compose-cheatsheet.md)
- Retake the exam after 24 hours

---

## 📚 Study Resources

If you need to review before taking the exam:

### Theory Materials
- **[Theory 1: What is Docker Compose?](../theory/01-what-is-compose.md)**
- **[Theory 2: Anatomy of docker-compose.yml](../theory/02-compose-anatomy.md)**
- **[Theory 3: Networks and Communication](../theory/03-compose-networking.md)**
- **[Theory 4: Docker Compose for n8n](../theory/04-compose-for-n8n.md)**

### Practice Exercises
- **[Practice 1: Your First docker-compose.yml](../practice/01-first-compose.md)**
- **[Practice 2: n8n + PostgreSQL with Compose](../practice/02-n8n-postgres-compose.md)**
- **[Practice 3: Complete Stack - Queue Mode](../practice/03-complete-stack.md)**

### Examples
- **[Example 1: Basic n8n](../examples/01-basic-n8n/)** - Simple setup
- **[Example 2: n8n with PostgreSQL](../examples/02-n8n-postgres/)** - Production database
- **[Example 3: Queue Mode Complete](../examples/03-queue-mode-complete/)** - Enterprise setup
- **[Example 4: Development Stack](../examples/04-dev-stack/)** - Dev tools included

### Quick Reference
- **[Docker Compose Cheat Sheet](compose-cheatsheet.md)** - Command reference

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

✅ Understanding of Docker Compose fundamentals  
✅ Knowledge of docker-compose.yml structure  
✅ Ability to configure services, networks, and volumes  
✅ Comprehension of container networking  
✅ Skills to orchestrate n8n multi-container setups  
✅ Understanding of queue mode architecture  
✅ Ability to scale services horizontally  
✅ Capability to troubleshoot Compose deployments  

---

## 🧪 Hands-On Verification

After passing the exam, verify your skills practically:

```bash
# Can you do these without looking at the notes?

1. Create basic docker-compose.yml for n8n
# Write from scratch in your editor

2. Start stack
docker compose up -d

3. View logs
docker compose logs -f n8n

4. Scale workers
docker compose up -d --scale n8n-worker=3

5. Check service health
docker compose ps

6. Backup data
docker run --rm -v n8n_n8n-data:/data -v $(pwd):/backup alpine tar czf /backup/backup.tar.gz -C /data .

7. Clean up
docker compose down
```

If you can do all of these confidently, you're ready for Lesson 4!

---

## 📈 What's Next?

Once you pass this exam with 75%+:

**Lesson 4: Environment Variables**
- Managing configuration across environments
- Security best practices
- Secrets management
- .env file patterns
- Environment-specific configs

---

**Good luck! 🚀**

**Back to:** [Lesson 3 Overview](../README.md)

