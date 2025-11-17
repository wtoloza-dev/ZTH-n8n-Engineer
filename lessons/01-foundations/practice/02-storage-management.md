# Practice 2: Understanding n8n Storage

**Estimated Time:** 10-15 minutes  
**Difficulty:** Easy ⭐  
**Supported OS:** Linux, macOS

---

## 🎯 Objective

Explore the n8n data directory structure, understand what files are created, their purpose, and how to manage the local storage.

---

## 📋 Prerequisites

- Completed [Practice 1: Run n8n Locally](01-run-locally.md)
- n8n has been run at least once
- Terminal access
- Linux or macOS operating system

---

## 📋 Instructions

### Step 1: Check n8n Version

First, verify which version of n8n you're running:

```bash
npx n8n --version
```

This command shows:
- The installed n8n version
- Node.js version being used
- Platform information

---

### Step 2: Locate the n8n Data Directory

n8n stores all its data in a hidden directory in your home folder.

```bash
cd ~/.n8n
ls -la
```

---

### Step 3: Understand the File Structure

You should see several files and directories. Let's explore each one:

```bash
# List all files with details
ls -lah ~/.n8n/
```

---

## 📁 File Structure Explained

### Core Files

#### 1. `database.sqlite`
**Purpose:** Local SQLite database that stores:
- Workflow definitions
- Execution history
- Credentials (encrypted)
- User settings
- Tags and workflow metadata

**Size:** Grows with usage (workflows and executions)

#### 2. `credentials.json` (if exists)
**Purpose:** Legacy file for encrypted credentials storage
- In newer versions, credentials are stored in the database
- Uses encryption for security
- Should never be shared or committed to version control

#### 3. `config` (file, no extension)
**Purpose:** Configuration file for n8n instance
- Stores instance-specific settings
- Contains encryption key for credentials
- **Critical:** Losing this file means losing access to encrypted credentials

---

### Directories

#### 4. `nodes/` (if exists)
**Purpose:** Custom nodes directory
- Contains user-installed custom nodes
- Community nodes are stored here
- Empty by default until you install custom nodes

#### 5. `.cache/` (if exists)
**Purpose:** Temporary cache files
- Used for performance optimization
- Can be safely deleted (will be regenerated)

---

## 🔍 Inspect File Sizes

Check how much space n8n is using:

```bash
du -sh ~/.n8n/
du -sh ~/.n8n/*
```

This helps you monitor storage usage over time.

---

## 🧹 Storage Management

### View Database Size

```bash
ls -lh ~/.n8n/database.sqlite
```

### Understanding Growth

The database grows when you:
- Create new workflows
- Execute workflows (execution history is stored)
- Save credentials
- Create tags and annotations

---

## 🗑️ Clean Storage (Complete Reset)

> **⚠️ Warning:** This command will permanently delete ALL n8n data including workflows, credentials, and execution history!

### Option 1: Delete Entire n8n Directory

```bash
# Stop n8n first (CTRL+C if running)
rm -rf ~/.n8n/
```

### Option 2: Selective Cleanup

If you only want to clean execution history but keep workflows:

```bash
# Backup first
cp ~/.n8n/database.sqlite ~/.n8n/database.sqlite.backup

# Then manually clean via n8n UI or SQL commands
```

**Note:** For selective cleanup, it's safer to use n8n's built-in features or export/import workflows.

---

## 💾 Backup Best Practices

### Manual Backup

```bash
# Create backup with timestamp
cp ~/.n8n/database.sqlite ~/n8n-backup-$(date +%Y%m%d-%H%M%S).sqlite
```

### What to Backup

Essential files to backup:
- ✅ `database.sqlite` - Contains everything
- ✅ `config` - Contains encryption keys
- ⚠️ `credentials.json` - Only if it exists
- ⚠️ `nodes/` - Only if you have custom nodes

---

## 🔒 Security Considerations

1. **Never commit `.n8n/` to git**
   - Contains sensitive credentials
   - Add to `.gitignore` if working in a repo

2. **Encryption Key**
   - Stored in the `config` file
   - Without it, encrypted credentials cannot be decrypted

3. **Database Permissions**
   - Keep file permissions restricted
   - Only your user should have access

**Check permissions (Linux/Mac):**
```bash
ls -la ~/.n8n/database.sqlite
# Should show: -rw------- (600) or -rw-r--r-- (644)
```

---

## 🧪 Practical Exercise

Let's verify everything:

1. **Check current storage size:**
   ```bash
   du -sh ~/.n8n/
   ```

2. **Create a backup:**
   ```bash
   cp ~/.n8n/database.sqlite ~/n8n-backup-$(date +%Y%m%d-%H%M%S).sqlite
   ```

3. **Verify backup was created:**
   ```bash
   ls -lh ~/n8n-backup-*.sqlite
   ```

---

## ✅ Completion Criteria

- [ ] Located the `.n8n` directory
- [ ] Listed and understood all files/folders
- [ ] Checked n8n version
- [ ] Measured storage usage
- [ ] Know how to create a backup
- [ ] Know how to completely reset n8n
- [ ] Understand security implications

---

## 📚 Key Takeaways

1. **All data lives in `~/.n8n/`** - Easy to backup and migrate
2. **SQLite is used by default** - Simple for development, not recommended for production
3. **Credentials are encrypted** - But encryption key is in the `config` file
4. **Storage grows with usage** - Monitor execution history accumulation
5. **Easy to reset** - Just delete the directory (but backup first!)

---

**Next:** [Practice 3: Identify Use Cases →](03-identify-cases.md)

