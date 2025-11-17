# Exercise 1: Run n8n Locally

**Estimated Time:** 10-15 minutes  
**Difficulty:** Easy ⭐  
**Supported OS:** Linux, macOS

---

## 🎯 Objective

Execute n8n locally using npx and verify that the platform is running correctly.

---

## 📋 Prerequisites

Before starting, ensure you have:
- Node.js installed (version 18.x or higher)
- Terminal access
- Internet connection
- Linux or macOS operating system

---

## 📋 Instructions

### Step 1: Verify Node.js Installation

Open your terminal and run:

```bash
node --version
```

> **Note:** If Node.js is not installed, download it from [nodejs.org](https://nodejs.org/)

---

### Step 2: Run n8n with npx

Execute the following command in your terminal:

```bash
npx n8n
```

**What to observe:**
1. Installation process (if first time)
2. Server startup messages
3. Default port assignment (usually 5678)

---

### Step 3: Access the n8n Interface

1. Open your web browser
2. Navigate to: `http://localhost:5678`
3. You should see the n8n welcome screen

---

### Step 4: Create Your Owner Account

Fill in the registration form:
- Email
- First Name
- Last Name
- Password: (record securely)

> **Important:** Save these credentials securely!

---

### Step 5: Verify Installation

Once logged in, verify:

1. **Dashboard Access:**
   - [ ] Can you see the main dashboard?
   - [ ] Are the menu options visible?

2. **Create a Test Workflow:**
   - [ ] Click on "Create New Workflow"
   - [ ] Can you see the canvas?
   - [ ] Try adding a node (click the + button)

3. **System Check:**
   - [ ] Check the bottom status bar
   - [ ] Verify execution status
   - [ ] Check for any system notifications

---

### Step 6: Stop the Server

Return to your terminal and:
1. Press `CTRL + C` to stop the n8n server
2. Verify the server has stopped
3. Try accessing `http://localhost:5678` again (should not load)

---

## 💡 Technical Observations

Pay attention to the following during the exercise:

1. **Startup Time:** Notice how long the initial startup takes (first run will be slower)
2. **Data Storage:** n8n creates a `.n8n` directory in your home folder
3. **Default Database:** SQLite is used by default for local development
4. **Port Configuration:** Default port is 5678 (can be changed via environment variables)

---

## ✅ Completion Criteria

- [ ] Node.js and npm verified
- [ ] Successfully executed `npx n8n`
- [ ] Accessed n8n interface at localhost:5678
- [ ] Created owner account
- [ ] Explored the dashboard and workflow canvas
- [ ] Successfully stopped the server

---

**Next:** [Practice 2: Understanding n8n Storage →](02-storage-management.md)

