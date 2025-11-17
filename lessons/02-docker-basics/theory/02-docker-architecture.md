# Docker Architecture

**Reading Time:** 8 minutes

---

## Overview

Docker uses a client-server architecture. Understanding this architecture helps you work effectively with Docker for n8n deployments.

```mermaid
graph TB
    subgraph "Docker Architecture"
        CLI[Docker CLI<br/>Command Line Interface]
        
        subgraph "Docker Host"
            DE[Docker Daemon<br/>dockerd]
            
            subgraph Images
                I1[Image: n8n]
                I2[Image: postgres]
                I3[Image: redis]
            end
            
            subgraph Containers
                C1[Container: n8n<br/>Running]
                C2[Container: postgres<br/>Running]
                C3[Container: redis<br/>Running]
            end
        end
        
        DH[Docker Hub<br/>Registry]
    end
    
    CLI -->|docker run| DE
    CLI -->|docker build| DE
    DE -->|pulls images| DH
    DE -->|creates| C1
    DE -->|creates| C2
    DE -->|creates| C3
    I1 -->|used by| C1
    I2 -->|used by| C2
    I3 -->|used by| C3
```

---

## Components Breakdown

### 1. Docker Client (CLI)

> The Docker client is how you interact with Docker. When you run commands like `docker run`, the client sends these to the Docker daemon.

```bash
# You type commands here
docker run n8nio/n8n
docker ps
docker logs my-container
docker build -t my-image .
```

**Key Points:**
- Command-line tool you interact with
- Sends instructions to Docker daemon
- Can connect to remote Docker daemons
- User-friendly interface to Docker Engine

---

### 2. Docker Daemon (dockerd)

> The Docker daemon is the background service that does the heavy lifting: building, running, and distributing containers.

```mermaid
graph TD
    A[Docker Daemon<br/>dockerd] --> B[Manages Images]
    A --> C[Manages Containers]
    A --> D[Manages Networks]
    A --> E[Manages Volumes]
    
    B --> B1[Pull from registries]
    B --> B2[Build from Dockerfile]
    B --> B3[Cache layers]
    
    C --> C1[Start/Stop containers]
    C --> C2[Monitor status]
    C --> C3[Handle logs]
```

**Responsibilities:**
- Listens for Docker API requests
- Manages Docker objects (images, containers, networks, volumes)
- Communicates with other daemons
- Handles the container lifecycle

---

### 3. Docker Images

> A Docker image is a read-only template with instructions for creating a container.

#### Image Layers

Images are built in layers. Each instruction in a Dockerfile creates a layer:

```mermaid
graph BT
    L1[Layer 1: Alpine Linux<br/>5 MB] --> L2[Layer 2: Node.js<br/>50 MB]
    L2 --> L3[Layer 3: n8n Dependencies<br/>100 MB]
    L3 --> L4[Layer 4: n8n Application<br/>50 MB]
    L4 --> L5[Layer 5: Configuration<br/>1 MB]
    
    L5 --> IMG[Complete Image<br/>n8nio/n8n:latest<br/>206 MB total]
```

**Why Layers Matter:**
- Layers are cached and reusable
- Only changed layers need to be rebuilt/downloaded
- Saves bandwidth and storage
- Speeds up builds and deployments

#### Example: n8n Image Layers

```dockerfile
# Each instruction creates a layer

FROM node:18-alpine          # Layer 1: Base OS + Node.js
WORKDIR /usr/src/app        # Layer 2: Working directory
COPY package.json ./         # Layer 3: Package definition
RUN npm install             # Layer 4: Dependencies
COPY . .                    # Layer 5: Application code
CMD ["node", "index.js"]    # Layer 6: Startup command
```

#### Image Tags

```bash
# Image naming format
registry/repository:tag

# Examples
n8nio/n8n:latest           # Latest stable version
n8nio/n8n:1.19.0          # Specific version
n8nio/n8n:latest-alpine    # Latest with Alpine base
```

---

### 4. Docker Containers

> A container is a runnable instance of an image. You can create, start, stop, move, or delete a container.

```mermaid
stateDiagram-v2
    [*] --> Created: docker create
    Created --> Running: docker start
    Running --> Paused: docker pause
    Paused --> Running: docker unpause
    Running --> Stopped: docker stop
    Stopped --> Running: docker start
    Stopped --> [*]: docker rm
    Running --> [*]: docker rm -f
```

#### Container States

| State | Description | Command |
|-------|-------------|---------|
| **Created** | Container exists but not started | `docker create` |
| **Running** | Container is executing | `docker start` / `docker run` |
| **Paused** | Container is frozen | `docker pause` |
| **Stopped** | Container has exited | `docker stop` |
| **Deleted** | Container removed | `docker rm` |

#### Container vs Image

```mermaid
graph LR
    A[Image<br/>n8nio/n8n<br/>Read-only template] -->|docker run| B[Container 1<br/>Writable layer<br/>Running n8n]
    A -->|docker run| C[Container 2<br/>Writable layer<br/>Running n8n]
    
    B -->|Changes| B1[Writable Layer<br/>User data, logs, temp files]
    C -->|Changes| C1[Writable Layer<br/>Different user data]
```

**Key Differences:**
- **Image:** Immutable, shareable, versioned
- **Container:** Mutable, instance-specific, ephemeral

---

### 5. Docker Registry

> A Docker registry stores Docker images. Docker Hub is the default public registry.

```mermaid
graph TB
    subgraph "Docker Hub (Registry)"
        O[Official Images]
        V[Verified Publishers]
        C[Community Images]
        P[Private Repositories]
        
        O --> N8N[n8nio/n8n]
        O --> PG[postgres]
        O --> RED[redis]
    end
    
    DEV[Developer] -->|docker push| C
    USER[User] -->|docker pull| N8N
    USER -->|docker pull| PG
    USER -->|docker pull| RED
```

#### Registry Types

**1. Docker Hub (Public)**
```bash
docker pull n8nio/n8n              # From Docker Hub
docker pull postgres:15          # Official PostgreSQL
```

**2. Private Registry**
```bash
docker pull mycompany.com/n8n:custom
```

**3. Self-hosted Registry**
```bash
docker pull registry.local:5000/n8n:internal
```

---

## Docker Networking

Containers can communicate with each other through Docker networks.

```mermaid
graph TB
    subgraph "Docker Network: n8n-network"
        C1[Container: n8n<br/>IP: 172.18.0.2<br/>Port: 5678]
        C2[Container: postgres<br/>IP: 172.18.0.3<br/>Port: 5432]
        C3[Container: redis<br/>IP: 172.18.0.4<br/>Port: 6379]
    end
    
    HOST[Host Machine<br/>localhost]
    
    C1 -->|connects to| C2
    C1 -->|connects to| C3
    HOST -->|port 5678:5678| C1
```

### Network Types

**1. Bridge (Default)**
- Private network on host
- Containers can communicate
- Access from host via port mapping

**2. Host**
- Container uses host's network directly
- No network isolation
- Better performance

**3. None**
- No networking
- Completely isolated

---

## Docker Volumes

Volumes persist data outside the container filesystem.

```mermaid
graph LR
    subgraph "Host Machine"
        V[Docker Volume<br/>n8n-data<br/>/var/lib/docker/volumes/]
    end
    
    subgraph "Container: n8n"
        APP[n8n Application]
        MOUNT[Mount Point<br/>/home/node/.n8n]
    end
    
    V -.->|mounted to| MOUNT
    APP -->|writes data| MOUNT
    MOUNT -->|persists to| V
```

### Why Volumes?

**Without Volumes:**
```bash
docker run n8nio/n8n
# Create workflow, stop container
docker stop <container>
# Start new container
docker run n8nio/n8n
# ❌ Workflow data is GONE!
```

**With Volumes:**
```bash
docker run -v n8n-data:/home/node/.n8n n8nio/n8n
# Create workflow, stop container
docker stop <container>
# Start new container with same volume
docker run -v n8n-data:/home/node/.n8n n8nio/n8n
# ✅ Workflow data is PRESERVED!
```

### Volume Types

**1. Named Volumes**
```bash
docker run -v n8n-data:/home/node/.n8n n8nio/n8n
```

**2. Bind Mounts**
```bash
docker run -v /home/user/n8n-data:/home/node/.n8n n8nio/n8n
```

**3. tmpfs (temporary)**
```bash
docker run --tmpfs /tmp n8nio/n8n
```

---

## Complete n8n Docker Architecture

```mermaid
graph TB
    subgraph "Docker Host"
        subgraph "n8n-network"
            C1[Container: n8n<br/>Port 5678]
            C2[Container: PostgreSQL<br/>Port 5432]
            C3[Container: Redis<br/>Port 6379]
        end
        
        V1[Volume: n8n-data]
        V2[Volume: postgres-data]
        V3[Volume: redis-data]
    end
    
    USER[User Browser] -->|http://localhost:5678| C1
    C1 -->|stores workflows| C2
    C1 -->|queue jobs| C3
    C1 -.->|persists| V1
    C2 -.->|persists| V2
    C3 -.->|persists| V3
```

---

## Docker Lifecycle Commands

### Image Operations

```bash
# Pull image from registry
docker pull n8nio/n8n:latest

# List images
docker images

# Remove image
docker rmi n8nio/n8n:latest

# Build image from Dockerfile
docker build -t my-n8n:latest .
```

### Container Operations

```bash
# Run container (create + start)
docker run -d --name n8n n8nio/n8n

# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Stop container
docker stop n8n

# Start stopped container
docker start n8n

# Remove container
docker rm n8n

# View logs
docker logs n8n

# Execute command in running container
docker exec -it n8n sh
```

### Volume Operations

```bash
# Create volume
docker volume create n8n-data

# List volumes
docker volume ls

# Inspect volume
docker volume inspect n8n-data

# Remove volume
docker volume rm n8n-data
```

---

## Key Takeaways

✅ Docker uses client-server architecture  
✅ Images are templates, containers are running instances  
✅ Images are built in layers for efficiency  
✅ Docker daemon manages all Docker objects  
✅ Volumes persist data outside containers  
✅ Networks allow container communication  
✅ Registries store and distribute images  

---

## Check Your Understanding

1. What's the role of the Docker daemon?
2. Why are Docker images built in layers?
3. What happens to container data when you stop it?
4. How do containers communicate with each other?
5. What's the difference between a named volume and a bind mount?

---

**Next:** [Docker for n8n →](03-docker-for-n8n.md)

