# n8n Architecture

**Reading Time:** 5 minutes

---

## Overview

Understanding n8n's architecture is crucial for implementing it properly. Let's break down the components and how they work together.

---

## High-Level Architecture

```mermaid
graph TD
    A[Your Browser] -->|HTTPS| B[n8n Web UI]
    B <-->|WebSocket| C[n8n Main Process]
    C <-->|Queue Jobs| D[Redis]
    D <-->|Process Jobs| E[n8n Workers]
    C <-->|Store Data| F[PostgreSQL]
    E <-->|Store Results| F
    
    G[External APIs] <-->|Webhooks| C
    G <-->|API Calls| E
    
    style A fill:#e9ecef
    style B fill:#d1ecf1
    style C fill:#d1ecf1
    style D fill:#fff3cd
    style E fill:#d4edda
    style F fill:#f9d6d5
    style G fill:#e9ecef
```

---

## Core Components

n8n consists of 4 main components:

### 1. n8n Web (Frontend UI)

```mermaid
graph LR
    A[n8n Web UI] --> B[Visual Editor]
    A --> C[Workflow Management]
    A --> D[Execution History]
    A --> E[Settings & Credentials]
    
    style A fill:#d1ecf1
```

**What it does:**
- Provides the visual workflow editor
- Shows workflow execution history
- Manages credentials and settings
- Serves the web interface

**Technology:**
- Vue.js frontend
- Runs in your browser
- Communicates via WebSocket and REST API

**Port:** Usually `5678`

---

### 2. n8n Main Process (Backend)

```mermaid
graph TD
    A[n8n Main Process] --> B[API Server]
    A --> C[Webhook Handler]
    A --> D[Scheduler]
    A --> E[Workflow Manager]
    
    B --> F[REST API]
    C --> G[External Webhooks]
    D --> H[Cron Jobs]
    E --> I[Execution Control]
    
    style A fill:#d1ecf1
```

**What it does:**
- Handles API requests from UI
- Receives webhook triggers
- Manages scheduled workflows
- Coordinates workflow executions
- Acts as the "brain" of n8n

**Key Responsibilities:**
- User authentication
- Webhook routing
- Schedule management
- Job queuing (when using Redis)

---

### 3. PostgreSQL (Database)

```mermaid
graph TD
    A[PostgreSQL] --> B[Workflows]
    A --> C[Credentials]
    A --> D[Execution History]
    A --> E[Settings]
    
    B --> B1[Workflow definitions<br/>Node configurations]
    C --> C1[Encrypted credentials<br/>API keys, passwords]
    D --> D1[Execution logs<br/>Success/failure data]
    E --> E1[User settings<br/>System config]
    
    style A fill:#f9d6d5
```

**What it stores:**
- Workflow definitions (your workflows)
- Credentials (encrypted)
- Execution history
- System settings
- User data

**Why PostgreSQL?**
- ✅ Reliable and battle-tested
- ✅ ACID compliance (data integrity)
- ✅ Great performance for n8n's needs
- ✅ Excellent backup/restore tools

**Alternatives:**
- SQLite (for development only)
- MySQL (supported but PostgreSQL preferred)

---

### 4. Redis (Queue System)

```mermaid
graph LR
    A[Main Process] -->|Add Job| B[Redis Queue]
    B -->|Get Job| C[Worker 1]
    B -->|Get Job| D[Worker 2]
    B -->|Get Job| E[Worker 3]
    
    C -->|Complete| F[Results]
    D -->|Complete| F
    E -->|Complete| F
    
    style A fill:#d1ecf1
    style B fill:#fff3cd
    style C fill:#d4edda
    style D fill:#d4edda
    style E fill:#d4edda
```

**What it does:**
- Manages job queue (workflows to execute)
- Enables horizontal scaling (multiple workers)
- Coordinates distributed execution
- Provides pub/sub for real-time updates

**Why Redis?**
- ⚡ Extremely fast (in-memory)
- 🔄 Perfect for queues
- 📊 Built-in pub/sub
- 🚀 Enables scaling

**When is Redis needed?**
- ✅ Production environments
- ✅ High-volume workflows
- ✅ Multiple workers
- ❌ NOT needed for simple dev setup

---

## 5. n8n Workers (Execution Engine)

```mermaid
graph TD
    A[n8n Worker] --> B[Pull Jobs from Queue]
    B --> C[Execute Workflow]
    C --> D[Run Nodes Sequentially]
    D --> E[Call External APIs]
    E --> F[Process Data]
    F --> G[Save Results]
    G --> H[Complete Job]
    
    style A fill:#d4edda
```

**What they do:**
- Pull jobs from Redis queue
- Execute workflows
- Call external APIs
- Process data transformations
- Save execution results

**Scaling:**
```mermaid
graph TD
    A[Low Volume<br/>1-10 workflows/min] --> B[1 Worker]
    C[Medium Volume<br/>10-100 workflows/min] --> D[2-5 Workers]
    E[High Volume<br/>100+ workflows/min] --> F[5-20+ Workers]
    
    style B fill:#d4edda
    style D fill:#d1ecf1
    style F fill:#fff3cd
```

---

## Architecture Modes

### Mode 1: Single Process (Development)

```mermaid
graph TD
    A[Browser] -->|Port 5678| B[n8n All-in-One]
    B --> C[Built-in SQLite]
    
    B --> D[UI + API + Execution<br/>All in one process]
    
    style B fill:#d1ecf1
    style C fill:#e9ecef
```

**Characteristics:**
- ✅ Simple setup (one command)
- ✅ Perfect for development/testing
- ✅ No Redis needed
- ✅ Can use SQLite
- ❌ No horizontal scaling
- ❌ Limited performance

**When to use:** Local development, testing, low-volume personal use

---

### Mode 2: Main + Workers (Production)

```mermaid
graph TD
    A[Browser] -->|HTTPS| B[Nginx Reverse Proxy]
    B -->|Port 5678| C[n8n Main Process]
    C <-->|Queue| D[Redis]
    D <--> E[Worker 1]
    D <--> F[Worker 2]
    D <--> G[Worker 3]
    C <--> H[PostgreSQL]
    E <--> H
    F <--> H
    G <--> H
    
    style B fill:#e9ecef
    style C fill:#d1ecf1
    style D fill:#fff3cd
    style E fill:#d4edda
    style F fill:#d4edda
    style G fill:#d4edda
    style H fill:#f9d6d5
```

**Characteristics:**
- ✅ Horizontal scaling
- ✅ High performance
- ✅ Production-ready
- ✅ HTTPS with Nginx
- ✅ Multiple workers
- ⚠️ More complex setup

**When to use:** Production deployments, high-volume, business-critical

---

## Data Flow Example

Let's trace a complete workflow execution:

```mermaid
sequenceDiagram
    participant B as Browser
    participant W as n8n Web
    participant M as Main Process
    participant R as Redis
    participant K as Worker
    participant P as PostgreSQL
    participant E as External API
    
    B->>W: Create workflow
    W->>M: Save workflow
    M->>P: Store definition
    
    Note over E: Webhook trigger fires
    E->>M: POST to webhook URL
    M->>R: Add job to queue
    
    K->>R: Pull next job
    R->>K: Job data
    K->>P: Load workflow
    K->>K: Execute nodes
    K->>E: Call external API
    E->>K: API response
    K->>P: Save execution result
    K->>M: Job complete
    M->>W: Update UI (WebSocket)
    W->>B: Show execution result
```

---

## Component Communication

```mermaid
graph TD
    A[Component Communication] --> B[HTTP/REST]
    A --> C[WebSocket]
    A --> D[Redis Pub/Sub]
    A --> E[Database Queries]
    
    B --> B1[API calls<br/>UI ↔ Main]
    C --> C1[Real-time updates<br/>Main ↔ UI]
    D --> D1[Job coordination<br/>Main ↔ Workers]
    E --> E1[Data persistence<br/>All ↔ PostgreSQL]
    
    style A fill:#d1ecf1
```

---

## Deployment Patterns

### Pattern 1: Single Server (Small Scale)

```
┌─────────────────────────────┐
│      VPS (4GB RAM)          │
│                             │
│  ┌─────────────────────┐   │
│  │  Docker Compose     │   │
│  │  ├─ n8n             │   │
│  │  ├─ PostgreSQL      │   │
│  │  ├─ Redis           │   │
│  │  └─ Nginx           │   │
│  └─────────────────────┘   │
└─────────────────────────────┘
```

### Pattern 2: Scaled (Medium Scale)

```
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│  n8n Main    │  │  n8n Worker  │  │  n8n Worker  │
│  (2GB RAM)   │  │  (2GB RAM)   │  │  (2GB RAM)   │
└──────┬───────┘  └──────┬───────┘  └──────┬───────┘
       │                 │                 │
       └────────┬────────┴────────┬────────┘
                │                 │
       ┌────────▼─────┐  ┌───────▼────────┐
       │ PostgreSQL   │  │     Redis      │
       │  (4GB RAM)   │  │   (2GB RAM)    │
       └──────────────┘  └────────────────┘
```

---

## Key Takeaways

✅ **4 core components:** Web, Main, PostgreSQL, Redis  
✅ **Two modes:** Single (dev) vs Queue (production)  
✅ **PostgreSQL:** Stores workflows and credentials  
✅ **Redis:** Enables scaling with multiple workers  
✅ **Workers:** Execute the actual workflows  
✅ **Main Process:** Coordinates everything  

---

## Check Your Understanding

1. What are the 4 main components of n8n?
2. What does PostgreSQL store?
3. Why do we need Redis in production?
4. What's the difference between Main Process and Workers?
5. When would you use single process vs queue mode?

---

**Next:** [Using vs Implementing →](05-using-vs-implementing.md)

