# Docker for n8n

**Reading Time:** 5 minutes

---

## Why Use Docker for n8n?

Running n8n with Docker provides significant advantages over traditional installation methods.

### Comparison: Docker vs Manual Installation

```mermaid
graph TB
    subgraph "Manual Installation"
        M1[Install Node.js<br/>15 min]
        M2[Install dependencies<br/>10 min]
        M3[Configure environment<br/>20 min]
        M4[Install n8n<br/>5 min]
        M5[Setup PostgreSQL<br/>30 min]
        M6[Setup Redis<br/>20 min]
        M7[Configure networking<br/>15 min]
        M8[Setup process manager<br/>10 min]
        
        M1 --> M2 --> M3 --> M4 --> M5 --> M6 --> M7 --> M8
        
        TOTAL1[Total: ~2 hours<br/>❌ Error-prone<br/>❌ Hard to reproduce]
    end
    
    subgraph "Docker Installation"
        D1[Pull n8n image<br/>2 min]
        D2[docker run command<br/>1 min]
        
        D1 --> D2
        
        TOTAL2[Total: ~3 minutes<br/>✅ Reliable<br/>✅ Easy to reproduce]
    end
```

---

## Benefits of Docker for n8n

### 1. **Consistency Across Environments**

```mermaid
graph LR
    A[Same Docker Image] --> B[Development]
    A --> C[Staging]
    A --> D[Production]
    
    B -.->|Identical| C
    C -.->|Identical| D
```

**Without Docker:**
```
Dev: Ubuntu 22.04, Node 18.x  ❌ Different
Staging: CentOS 7, Node 16.x  ❌ Different  
Prod: Debian 11, Node 20.x    ❌ Different
```

**With Docker:**
```
Dev: n8n/n8n:1.19.0      ✅ Identical
Staging: n8n/n8n:1.19.0  ✅ Identical
Prod: n8n/n8n:1.19.0     ✅ Identical
```

---

### 2. **Simplified Dependency Management**

All dependencies are bundled in the Docker image:

```dockerfile
# The n8n Docker image includes:
- Base OS (Alpine Linux)
- Node.js runtime (correct version)
- n8n application
- All npm dependencies
- Required system libraries
- Proper configurations
```

**You don't need to install:**
- ❌ Node.js
- ❌ npm packages
- ❌ System libraries
- ❌ Build tools

---

### 3. **Easy Updates and Rollbacks**

```bash
# Current version
docker run n8n/n8n:1.18.0

# Upgrade to new version
docker stop n8n
docker run n8n/n8n:1.19.0

# Rollback if issues occur
docker stop n8n
docker run n8n/n8n:1.18.0  # Back to previous version
```

```mermaid
graph LR
    A[Version 1.18.0] -->|upgrade| B[Version 1.19.0]
    B -->|issues found| C[Rollback to 1.18.0]
```

---

### 4. **Isolation and Security**

```mermaid
graph TB
    subgraph "Host Server"
        OS[Host Operating System]
        
        subgraph "n8n Container"
            N8N[n8n Process<br/>Isolated]
        end
        
        subgraph "PostgreSQL Container"
            PG[PostgreSQL<br/>Isolated]
        end
        
        subgraph "Other Apps Container"
            OTHER[Other Apps<br/>Isolated]
        end
    end
    
    OS --> N8N
    OS --> PG
    OS --> OTHER
    
    N8N -.->|Can't access directly| OTHER
```

**Benefits:**
- n8n runs in isolated environment
- Limited access to host system
- Compromised container doesn't affect host
- Each service in its own sandbox

---

### 5. **Resource Management**

Control how much resources n8n can use:

```bash
# Limit CPU and memory
docker run \
  --cpus="2.0" \
  --memory="2g" \
  n8n/n8n
```

```mermaid
graph TD
    A[Server Resources<br/>8 CPU, 16GB RAM] --> B[n8n Container<br/>2 CPU, 2GB RAM]
    A --> C[PostgreSQL Container<br/>2 CPU, 4GB RAM]
    A --> D[Redis Container<br/>1 CPU, 1GB RAM]
    A --> E[Other Services<br/>3 CPU, 9GB RAM]
```

---

## Official n8n Docker Images

### Available Images on Docker Hub

```bash
# Main repository
n8n/n8n

# Common tags
n8n/n8n:latest              # Latest stable version
n8n/n8n:1.19.0             # Specific version
n8n/n8n:latest-alpine      # Alpine Linux base
n8n/n8n:latest-debian      # Debian base
```

### Image Variants

**1. Standard (Debian-based)**
```bash
docker pull n8n/n8n:latest
# Size: ~500MB
# Use case: General purpose
```

**2. Alpine (Lightweight)**
```bash
docker pull n8n/n8n:latest-alpine
# Size: ~200MB
# Use case: Resource-constrained environments
```

### Version Strategy

```mermaid
graph LR
    A[n8n Release 1.19.0] --> B[Docker Image<br/>n8n/n8n:1.19.0]
    B --> C[Tagged as 'latest']
    
    D[User pulls 'latest'] --> C
    E[User pulls '1.19.0'] --> B
```

**Best Practice:**
```bash
# ❌ Don't use 'latest' in production (unpredictable)
docker run n8n/n8n:latest

# ✅ Use specific version (predictable)
docker run n8n/n8n:1.19.0
```

---

## n8n Docker Architecture

### Simple Setup (Single Container)

```mermaid
graph TB
    subgraph "Docker Host"
        C[n8n Container<br/>Port 5678]
        V[Volume: n8n-data<br/>SQLite database]
    end
    
    USER[User] -->|http://localhost:5678| C
    C -.->|persists to| V
```

```bash
docker run -d \
  --name n8n \
  -p 5678:5678 \
  -v n8n-data:/home/node/.n8n \
  n8n/n8n
```

**Use Case:** Development, testing, small personal projects

---

### Production Setup (Multiple Containers)

```mermaid
graph TB
    subgraph "Docker Host"
        subgraph "n8n-network"
            C1[n8n Container<br/>Main application]
            C2[PostgreSQL Container<br/>Database]
            C3[Redis Container<br/>Queue mode]
        end
        
        V1[Volume: n8n-data]
        V2[Volume: postgres-data]
        V3[Volume: redis-data]
    end
    
    USER[User] -->|https://n8n.example.com| C1
    C1 -->|store workflows| C2
    C1 -->|queue jobs| C3
    C1 -.-> V1
    C2 -.-> V2
    C3 -.-> V3
```

**Components:**
- **n8n Container:** Main application
- **PostgreSQL:** Production database (replaces SQLite)
- **Redis:** Queue mode for high-performance
- **Volumes:** Persistent data storage

**Use Case:** Production deployments, high availability

---

## Environment Variables for n8n Docker

Common environment variables you'll use:

```bash
docker run -d \
  --name n8n \
  -p 5678:5678 \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=admin \
  -e N8N_BASIC_AUTH_PASSWORD=secure_password \
  -e N8N_HOST=n8n.example.com \
  -e N8N_PROTOCOL=https \
  -e N8N_PORT=5678 \
  -e WEBHOOK_URL=https://n8n.example.com \
  -e DB_TYPE=postgresdb \
  -e DB_POSTGRESDB_HOST=postgres \
  -e DB_POSTGRESDB_PORT=5432 \
  -e DB_POSTGRESDB_DATABASE=n8n \
  -e DB_POSTGRESDB_USER=n8n \
  -e DB_POSTGRESDB_PASSWORD=n8n_password \
  -v n8n-data:/home/node/.n8n \
  n8n/n8n
```

### Key Environment Variables

| Variable | Purpose | Example |
|----------|---------|---------|
| `N8N_BASIC_AUTH_ACTIVE` | Enable authentication | `true` |
| `N8N_HOST` | Domain name | `n8n.example.com` |
| `DB_TYPE` | Database type | `postgresdb` |
| `WEBHOOK_URL` | Base URL for webhooks | `https://n8n.example.com` |
| `EXECUTIONS_MODE` | Execution mode | `queue` |
| `QUEUE_BULL_REDIS_HOST` | Redis host | `redis` |

---

## Data Persistence in Docker

### What Data Needs to Persist?

```mermaid
graph TD
    A[n8n Data] --> B[Workflows<br/>Your automations]
    A --> C[Credentials<br/>API keys, passwords]
    A --> D[Execution History<br/>Logs and results]
    A --> E[Settings<br/>Configuration]
    
    F[Stored in: /home/node/.n8n/] --> B
    F --> C
    F --> D
    F --> E
```

### Without Volume (Data Loss)

```bash
docker run -d --name n8n n8n/n8n
# Create workflows
docker stop n8n
docker rm n8n
docker run -d --name n8n n8n/n8n
# ❌ All workflows GONE!
```

### With Volume (Data Persists)

```bash
docker run -d --name n8n -v n8n-data:/home/node/.n8n n8n/n8n
# Create workflows
docker stop n8n
docker rm n8n
docker run -d --name n8n -v n8n-data:/home/node/.n8n n8n/n8n
# ✅ Workflows PRESERVED!
```

---

## Trade-offs: Docker vs Manual

### Advantages of Docker

✅ Fast deployment (minutes vs hours)  
✅ Consistent across environments  
✅ Easy updates and rollbacks  
✅ Better isolation and security  
✅ Simplified dependency management  
✅ Resource control  
✅ Easy to scale  

### Disadvantages of Docker

❌ Slight performance overhead (minimal)  
❌ Learning curve if new to Docker  
❌ Additional layer of complexity  
❌ Need to understand container concepts  
❌ Debugging can be more complex  

### When NOT to Use Docker

- Very simple, temporary testing
- Embedded systems with limited resources
- Legacy systems that can't run Docker
- When you need absolute maximum performance

---

## Key Takeaways

✅ Docker simplifies n8n deployment dramatically  
✅ Official images available on Docker Hub  
✅ Provides consistency across all environments  
✅ Easy to update, rollback, and scale  
✅ Always use volumes for data persistence  
✅ Production needs PostgreSQL and Redis containers  
✅ Use specific version tags in production  

---

## Check Your Understanding

1. What are 3 main benefits of running n8n with Docker?
2. What's the difference between `n8n/n8n:latest` and `n8n/n8n:1.19.0`?
3. Why do we need volumes for n8n?
4. What additional containers does a production n8n setup need?

---

**Next:** [Understanding Dockerfiles →](04-understanding-dockerfiles.md)

