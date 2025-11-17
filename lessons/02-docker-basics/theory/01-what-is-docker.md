# What is Docker?

**Reading Time:** 7 minutes

---

## Simple Definition

> Docker is a tool that packages applications and all their dependencies into standardized units called **containers** that can run anywhere.

Think of it like a shipping container: just as shipping containers standardize how goods are transported, Docker containers standardize how software runs.

---

## Technical Definition

> Docker is a platform for developing, shipping, and running applications inside lightweight, portable, self-sufficient containers.

Let's break this down:

```mermaid
mindmap
  root((Docker))
    Containerization
      Isolated environments
      Consistent across systems
      Lightweight
    Portability
      Same container everywhere
      Dev to Production parity
      No dependency hell
    Efficiency
      Share OS kernel
      Fast startup
      Minimal overhead
    Standardization
      Dockerfile format
      Image layers
      Registry system
```

---

## The Problem Docker Solves

### Before Docker

```
Developer's Machine:
✅ App works perfectly

Production Server:
❌ "It doesn't work!"
❌ Different OS version
❌ Missing dependencies
❌ Wrong library versions
❌ Environment differences
```

### Classic "Works on My Machine" Problem

```mermaid
graph TD
    A[Developer Laptop<br/>Node v18, Ubuntu 22.04] --> B[Staging Server<br/>Node v16, CentOS 7]
    B --> C[Production Server<br/>Node v20, Ubuntu 20.04]
    
    A -.->|Works| A
    B -.->|Fails| B
    C -.->|Fails| C
```

### With Docker

```
Developer's Machine:
✅ App runs in container

Production Server:
✅ Same container, works perfectly!
```

```mermaid
graph TD
    A[Same Docker Container] --> B[Developer Laptop]
    A --> C[Staging Server]
    A --> D[Production Server]
    
    B -.->|✅ Works| B
    C -.->|✅ Works| C
    D -.->|✅ Works| D
```

---

## Containers vs Virtual Machines

### Virtual Machines (Old Way)

```mermaid
graph TB
    subgraph "Physical Server"
        H[Hardware/Infrastructure]
        HV[Hypervisor - VMware, VirtualBox]
        
        subgraph VM1["Virtual Machine 1"]
            GOS1[Guest OS<br/>Ubuntu - 2GB]
            LIB1[Libraries]
            APP1[App 1]
        end
        
        subgraph VM2["Virtual Machine 2"]
            GOS2[Guest OS<br/>CentOS - 2GB]
            LIB2[Libraries]
            APP2[App 2]
        end
        
        subgraph VM3["Virtual Machine 3"]
            GOS3[Guest OS<br/>Debian - 2GB]
            LIB3[Libraries]
            APP3[App 3]
        end
    end
    
    H --> HV
    HV --> VM1
    HV --> VM2
    HV --> VM3
```

**Characteristics:**
- Each VM includes a full OS (GBs of space)
- Heavy resource usage
- Slow startup (minutes)
- Strong isolation
- 3 apps = 3 full OS copies

### Docker Containers (Modern Way)

```mermaid
graph TB
    subgraph "Physical Server"
        H[Hardware/Infrastructure]
        HOS[Host OS - Linux]
        DE[Docker Engine]
        
        subgraph C1["Container 1"]
            APP1[App 1<br/>+ Libraries]
        end
        
        subgraph C2["Container 2"]
            APP2[App 2<br/>+ Libraries]
        end
        
        subgraph C3["Container 3"]
            APP3[App 3<br/>+ Libraries]
        end
    end
    
    H --> HOS
    HOS --> DE
    DE --> C1
    DE --> C2
    DE --> C3
```

**Characteristics:**
- Containers share the host OS kernel
- Lightweight (MBs instead of GBs)
- Fast startup (seconds)
- Good isolation
- 3 apps = 1 OS, 3 isolated processes

### Comparison Table

| Feature | Virtual Machines | Docker Containers |
|---------|-----------------|-------------------|
| **Size** | GBs (1-10GB+) | MBs (50-500MB) |
| **Startup** | Minutes | Seconds |
| **Resource Usage** | Heavy | Light |
| **Isolation** | Complete | Process-level |
| **Portability** | Moderate | Excellent |
| **Use Case** | Full OS needed | App deployment |

---

## Core Docker Concepts

### 1. Container

> A running instance of an image. A container is to an image what a process is to a program.

```mermaid
graph LR
    A[Docker Image<br/>Blueprint] -->|docker run| B[Container 1<br/>Running]
    A -->|docker run| C[Container 2<br/>Running]
    A -->|docker run| D[Container 3<br/>Running]
```

**Analogy:** 
- Image = Recipe
- Container = Actual cake made from recipe

### 2. Image

> A read-only template with instructions for creating a container. Contains everything needed to run an application.

```mermaid
graph TD
    A[Docker Image n8n:latest] --> B[Operating System Base<br/>Alpine Linux]
    A --> C[Node.js Runtime<br/>v18]
    A --> D[n8n Application<br/>Code & Dependencies]
    A --> E[Configuration<br/>Default settings]
```

### 3. Dockerfile

> A text file with instructions on how to build a Docker image.

```dockerfile
# Example Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
CMD ["npm", "start"]
```

### 4. Docker Hub (Registry)

> A cloud-based repository where Docker images are stored and shared.

```mermaid
graph LR
    A[Developer] -->|docker push| B[Docker Hub<br/>Registry]
    B -->|docker pull| C[Production Server]
    B -->|docker pull| D[Other Developers]
```

---

## How Docker Works (Simplified)

```mermaid
sequenceDiagram
    participant U as User
    participant DC as Docker CLI
    participant DE as Docker Engine
    participant DH as Docker Hub
    participant C as Container
    
    U->>DC: docker run n8nio/n8n
    DC->>DE: Check for image locally
    
    alt Image not found locally
        DE->>DH: Pull n8nio/n8n image
        DH->>DE: Download image
    end
    
    DE->>DE: Create container from image
    DE->>C: Start container
    C->>C: n8n running
    C->>U: App accessible on port 5678
```

**Step-by-step:**
1. You run `docker run n8nio/n8n`
2. Docker checks if image exists locally
3. If not, downloads from Docker Hub
4. Creates container from image
5. Starts the container
6. n8n runs inside the container

---

## Why Docker for n8n?

### Without Docker

```bash
# Complex manual setup
1. Install Node.js (specific version)
2. Install PostgreSQL
3. Install Redis
4. Configure environment variables
5. Install n8n
6. Configure n8n
7. Setup process manager
8. Configure reverse proxy
9. Setup SSL certificates
10. Hope it all works together
```

**Problems:**
- ❌ Different versions on different servers
- ❌ Manual dependency management
- ❌ Hard to reproduce
- ❌ Difficult to scale
- ❌ Complex troubleshooting

### With Docker

```bash
# Simple Docker setup
docker run -d \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

**Benefits:**
- ✅ Consistent environment everywhere
- ✅ All dependencies included
- ✅ Easy to reproduce
- ✅ Simple to scale
- ✅ Isolated from host system

---

## Docker Workflow for n8n

```mermaid
graph TD
    A[Developer] -->|1. Pull| B[n8n Docker Image<br/>from Docker Hub]
    B -->|2. Run| C[Create Container]
    C -->|3. Configure| D[Set Environment Variables<br/>Volumes, Ports]
    D -->|4. Start| E[n8n Running in Container]
    E -->|5. Access| F[http://localhost:5678]
    
    G[Data Volume] -.->|Persist data| E
```

---

## Real-World Analogy

Think of Docker like a food delivery service:

| Food Delivery | Docker |
|---------------|--------|
| Restaurant prepares meal | Developer builds image |
| Sealed container | Docker container |
| Delivery anywhere | Run on any server |
| Same meal, same quality | Same app, same behavior |
| No need to cook | No need to install dependencies |

---

## Key Takeaways

✅ Docker packages apps and dependencies into containers  
✅ Containers are lightweight, portable, and consistent  
✅ Unlike VMs, containers share the host OS kernel  
✅ Images are blueprints, containers are running instances  
✅ Solves "works on my machine" problem  
✅ Perfect for deploying n8n consistently  

---

## Check Your Understanding

1. What's the main difference between a container and a VM?
2. What problem does Docker solve?
3. What's the relationship between an image and a container?
4. Why is Docker better than manual installation for n8n?

---

**Next:** [Docker Architecture →](02-docker-architecture.md)

