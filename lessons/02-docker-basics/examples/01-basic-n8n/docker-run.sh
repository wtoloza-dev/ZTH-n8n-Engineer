#!/bin/bash

# Basic n8n Docker Run Script
# Usage: ./docker-run.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Starting n8n with Docker${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Error: Docker is not running${NC}"
    echo "Please start Docker and try again"
    exit 1
fi

# Check if container already exists
if docker ps -a --format '{{.Names}}' | grep -q "^n8n$"; then
    echo -e "${YELLOW}Container 'n8n' already exists${NC}"
    echo -e "${YELLOW}Stopping and removing existing container...${NC}"
    docker stop n8n > /dev/null 2>&1
    docker rm n8n > /dev/null 2>&1
    echo -e "${GREEN}✓ Existing container removed${NC}"
fi

# Check if volume exists
if docker volume ls --format '{{.Name}}' | grep -q "^n8n-data$"; then
    echo -e "${GREEN}✓ Volume 'n8n-data' already exists (data will be preserved)${NC}"
else
    echo -e "${YELLOW}Creating volume 'n8n-data'...${NC}"
    docker volume create n8n-data
    echo -e "${GREEN}✓ Volume created${NC}"
fi

echo ""
echo -e "${GREEN}Starting n8n container...${NC}"

# Run n8n container
docker run -d \
  --name n8n \
  --restart unless-stopped \
  -p 5678:5678 \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=admin \
  -e N8N_BASIC_AUTH_PASSWORD=change_this_password \
  -e GENERIC_TIMEZONE=America/New_York \
  -v n8n-data:/home/node/.n8n \
  n8nio/n8n:latest

# Wait for container to start
echo -e "${YELLOW}Waiting for n8n to start...${NC}"
sleep 5

# Check if container is running
if docker ps --format '{{.Names}}' | grep -q "^n8n$"; then
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  ✓ n8n is running successfully!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "Access n8n at: ${YELLOW}http://localhost:5678${NC}"
    echo ""
    echo -e "Default credentials:"
    echo -e "  Username: ${YELLOW}admin${NC}"
    echo -e "  Password: ${YELLOW}change_this_password${NC}"
    echo ""
    echo -e "${RED}⚠️  IMPORTANT: Change the default password!${NC}"
    echo ""
    echo -e "Useful commands:"
    echo -e "  View logs:    ${YELLOW}docker logs -f n8n${NC}"
    echo -e "  Stop n8n:     ${YELLOW}docker stop n8n${NC}"
    echo -e "  Start n8n:    ${YELLOW}docker start n8n${NC}"
    echo -e "  Restart n8n:  ${YELLOW}docker restart n8n${NC}"
    echo ""
else
    echo -e "${RED}Error: Container failed to start${NC}"
    echo -e "Check logs with: ${YELLOW}docker logs n8n${NC}"
    exit 1
fi

