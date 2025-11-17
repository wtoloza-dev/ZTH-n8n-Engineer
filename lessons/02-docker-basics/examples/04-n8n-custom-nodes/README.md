# Example 4: n8n with Custom Nodes

**Complexity:** ⭐⭐ Intermediate  
**Use Case:** Extending n8n with custom functionality, community nodes, or specific integrations

---

## 📋 What's Included

- Custom Dockerfile extending n8n
- Example custom node installation
- System dependencies for special nodes
- Configuration for custom extensions

---

## 🎯 Use Cases

- Install community nodes from npm
- Add system dependencies (Python, libraries)
- Include custom-built nodes
- Pre-configure extensions
- Create company-specific n8n images

---

## 📁 Files

```
04-n8n-custom-nodes/
├── Dockerfile                  # Custom n8n image
├── Dockerfile.python          # n8n with Python support
├── Dockerfile.chromium        # n8n with browser automation
├── custom-nodes/              # Your custom node code (optional)
├── docker-build.sh            # Build script
└── README.md                 # This file
```

---

## 🏗️ Basic Custom Dockerfile

### Simple Extension

**`Dockerfile.basic`:**

```dockerfile
# Start from official n8n image
FROM n8nio/n8n:latest

# Switch to root for installations
USER root

# Install a community node from npm
RUN cd /usr/local/lib/node_modules/n8n && \
    npm install n8n-nodes-text-manipulation

# Return to node user
USER node

# Environment variable for custom extensions
ENV N8N_CUSTOM_EXTENSIONS="/home/node/.n8n/custom"
```

**Build and run:**

```bash
docker build -f Dockerfile.basic -t my-n8n-custom:1.0 .

docker run -d \
  --name n8n-custom \
  -p 5678:5678 \
  -v n8n-data:/home/node/.n8n \
  my-n8n-custom:1.0
```

---

## 🐍 n8n with Python Support

Some n8n nodes require Python (e.g., certain data processing nodes).

**`Dockerfile.python`:**

```dockerfile
FROM n8nio/n8n:latest

USER root

# Install Python and pip
RUN apk add --no-cache \
    python3 \
    py3-pip \
    python3-dev \
    g++ \
    make \
    && ln -sf python3 /usr/bin/python

# Install Python packages
RUN pip3 install --no-cache-dir \
    pandas \
    numpy \
    requests

# Clean up
RUN rm -rf /var/cache/apk/* /tmp/*

USER node

ENV PYTHON_PATH=/usr/bin/python3
```

**Build:**

```bash
docker build -f Dockerfile.python -t n8n-python:1.0 .
```

**Run:**

```bash
docker run -d \
  --name n8n-python \
  -p 5678:5678 \
  -v n8n-data:/home/node/.n8n \
  n8n-python:1.0
```

---

## 🌐 n8n with Chromium (Browser Automation)

For web scraping or browser automation nodes.

**`Dockerfile.chromium`:**

```dockerfile
FROM n8nio/n8n:latest

USER root

# Install Chromium and dependencies
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    nodejs \
    npm

# Configure Puppeteer
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Install Puppeteer
RUN npm install -g puppeteer-core

USER node
```

**Build and run:**

```bash
docker build -f Dockerfile.chromium -t n8n-chromium:1.0 .

docker run -d \
  --name n8n-browser \
  -p 5678:5678 \
  -v n8n-data:/home/node/.n8n \
  --cap-add=SYS_ADMIN \
  n8n-chromium:1.0
```

---

## 🔌 Installing Community Nodes

### Popular Community Nodes

```dockerfile
FROM n8nio/n8n:latest

USER root

# Navigate to n8n installation
WORKDIR /usr/local/lib/node_modules/n8n

# Install multiple community nodes
RUN npm install \
    n8n-nodes-text-manipulation \
    n8n-nodes-document-generator \
    @n8nio/n8n-nodes-langchain

# Fix ownership
RUN chown -R node:node /usr/local/lib/node_modules/n8n

USER node

WORKDIR /home/node
```

### Find Community Nodes

Search on npm: https://www.npmjs.com/search?q=n8n-nodes

---

## 🛠️ Custom Node Development

### Directory Structure

```
04-n8n-custom-nodes/
├── Dockerfile
├── custom-nodes/
│   └── MyCustomNode/
│       ├── MyCustomNode.node.ts
│       ├── MyCustomNode.node.json
│       └── package.json
```

### Dockerfile for Custom Nodes

```dockerfile
FROM n8nio/n8n:latest

USER root

# Create custom nodes directory
RUN mkdir -p /home/node/.n8n/custom

# Copy custom nodes
COPY --chown=node:node custom-nodes/ /home/node/.n8n/custom/

# Install dependencies for custom nodes
WORKDIR /home/node/.n8n/custom
RUN npm install

# Set permissions
RUN chown -R node:node /home/node/.n8n

USER node

WORKDIR /home/node

ENV N8N_CUSTOM_EXTENSIONS="/home/node/.n8n/custom"
```

---

## 🚀 Complete Example: Production-Ready Custom Image

**`Dockerfile`:**

```dockerfile
# Production-ready n8n with custom nodes and dependencies
FROM n8nio/n8n:1.19.0

# Metadata
LABEL maintainer="your-email@company.com"
LABEL version="1.0"
LABEL description="Custom n8n with company-specific extensions"

USER root

# Install system dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    g++ \
    make \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/cache/apk/*

# Install Python packages
RUN pip3 install --no-cache-dir \
    pandas \
    requests \
    beautifulsoup4

# Install community nodes
WORKDIR /usr/local/lib/node_modules/n8n
RUN npm install --save \
    n8n-nodes-text-manipulation \
    @n8nio/n8n-nodes-langchain \
    && npm cache clean --force

# Create custom directories
RUN mkdir -p /home/node/.n8n/custom /home/node/.n8n/backups

# Copy custom configurations (if any)
# COPY --chown=node:node config/ /home/node/.n8n/

# Set ownership
RUN chown -R node:node /usr/local/lib/node_modules/n8n && \
    chown -R node:node /home/node/.n8n

USER node

WORKDIR /home/node

# Environment variables
ENV N8N_CUSTOM_EXTENSIONS="/home/node/.n8n/custom" \
    N8N_USER_FOLDER="/home/node/.n8n" \
    PYTHON_PATH="/usr/bin/python3"

EXPOSE 5678

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:5678/healthz || exit 1
```

**Build:**

```bash
docker build -t company/n8n-custom:1.0 .
```

**Run:**

```bash
docker run -d \
  --name n8n-production \
  --restart unless-stopped \
  -p 5678:5678 \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=admin \
  -e N8N_BASIC_AUTH_PASSWORD=secure_password \
  -v n8n-data:/home/node/.n8n \
  company/n8n-custom:1.0
```

---

## 🔧 Build Script

**`docker-build.sh`:**

```bash
#!/bin/bash

set -e

IMAGE_NAME="my-n8n-custom"
VERSION="1.0"

echo "Building custom n8n image..."

docker build \
  --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
  --build-arg VCS_REF=$(git rev-parse --short HEAD) \
  -t ${IMAGE_NAME}:${VERSION} \
  -t ${IMAGE_NAME}:latest \
  .

echo "✓ Build complete: ${IMAGE_NAME}:${VERSION}"

# Optional: Tag for private registry
# docker tag ${IMAGE_NAME}:${VERSION} registry.company.com/${IMAGE_NAME}:${VERSION}
```

---

## 📦 Multi-Stage Build (Optimized Size)

For production, use multi-stage builds to reduce image size:

```dockerfile
# Stage 1: Build dependencies
FROM node:18-alpine AS builder

WORKDIR /build

# Install build dependencies
RUN apk add --no-cache python3 g++ make

# Install custom node modules
COPY package*.json ./
RUN npm ci --only=production

# Stage 2: Runtime
FROM n8nio/n8n:latest

USER root

# Copy only necessary files from builder
COPY --from=builder /build/node_modules /home/node/.n8n/custom/node_modules

# Install minimal runtime dependencies
RUN apk add --no-cache python3 && \
    rm -rf /var/cache/apk/*

RUN chown -R node:node /home/node/.n8n

USER node

ENV N8N_CUSTOM_EXTENSIONS="/home/node/.n8n/custom"
```

---

## 🧪 Testing Custom Image

```bash
# Build
docker build -t n8n-test:1.0 .

# Run in test mode
docker run --rm -it \
  --name n8n-test \
  -p 5678:5678 \
  n8n-test:1.0

# Access and verify custom nodes are available
# Check: Settings → Community Nodes

# Clean up
docker stop n8n-test
```

---

## 📊 Image Size Comparison

```bash
# Check image sizes
docker images | grep n8n

# Example output:
# n8nio/n8n                latest    200 MB
# n8n-python             1.0       280 MB  (+80 MB)
# n8n-chromium           1.0       450 MB  (+250 MB)
# n8n-custom-optimized   1.0       220 MB  (+20 MB)
```

**Tips to reduce size:**
- Use Alpine-based images
- Combine RUN commands
- Clean up after installations
- Use multi-stage builds
- Don't install unnecessary packages

---

## 🔍 Debugging Custom Images

```bash
# Build with verbose output
docker build --progress=plain -t n8n-custom:debug .

# Run interactively
docker run -it --rm n8n-custom:debug sh

# Inside container, check installations:
n8n --version
python3 --version
npm list -g
ls -la /home/node/.n8n/custom
```

---

## 📝 Best Practices

1. **Pin Versions:**
   ```dockerfile
   FROM n8nio/n8n:1.19.0  # ✅ Specific version
   FROM n8nio/n8n:latest  # ❌ Unpredictable
   ```

2. **Layer Optimization:**
   ```dockerfile
   # ✅ Good: Combined
   RUN apk add python3 && npm install package && rm -rf /tmp/*
   
   # ❌ Bad: Separate
   RUN apk add python3
   RUN npm install package
   RUN rm -rf /tmp/*
   ```

3. **Security:**
   ```dockerfile
   USER root
   RUN apk add packages
   USER node  # ✅ Always return to non-root
   ```

4. **Documentation:**
   ```dockerfile
   LABEL maintainer="you@example.com"
   LABEL description="What this image includes"
   LABEL version="1.0"
   ```

---

## ✅ When to Use Custom Images

**✅ Use custom images if:**
- Need community nodes
- Require system dependencies (Python, etc.)
- Company-specific configurations
- Pre-configured setups for teams
- Browser automation requirements

**❌ Standard image is fine if:**
- Using only built-in nodes
- No special dependencies
- Simple deployment
- Learning/testing

---

## 🎯 Next Steps

1. **Push to Registry:**
   ```bash
   docker tag my-n8n-custom:1.0 registry.company.com/n8n:1.0
   docker push registry.company.com/n8n:1.0
   ```

2. **Automate Builds:** Set up CI/CD
3. **Version Control:** Track Dockerfile in git
4. **Documentation:** Document custom nodes

---

**Related Resources:**
- [n8n Community Nodes](https://docs.n8n.io/integrations/community-nodes/)
- [n8n Node Development](https://docs.n8n.io/integrations/creating-nodes/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

