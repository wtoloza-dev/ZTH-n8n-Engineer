#!/bin/bash

# n8n with PostgreSQL Docker Run Script
# Usage: ./docker-run.sh

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Starting n8n with PostgreSQL${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Configuration
NETWORK_NAME="n8n-network"
POSTGRES_CONTAINER="n8n-postgres"
N8N_CONTAINER="n8n"
POSTGRES_VOLUME="postgres-data"
N8N_VOLUME="n8n-data"

# Database credentials (change these!)
POSTGRES_USER="n8n"
POSTGRES_PASSWORD="n8n_secure_password_$(openssl rand -hex 8)"
POSTGRES_DB="n8n"

# n8n credentials (change these!)
N8N_USER="admin"
N8N_PASSWORD="admin_secure_password_$(openssl rand -hex 8)"

# Check Docker
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Error: Docker is not running${NC}"
    exit 1
fi

# Create network
echo -e "${BLUE}1. Creating Docker network...${NC}"
if docker network ls --format '{{.Name}}' | grep -q "^${NETWORK_NAME}$"; then
    echo -e "${YELLOW}Network '${NETWORK_NAME}' already exists${NC}"
else
    docker network create ${NETWORK_NAME}
    echo -e "${GREEN}✓ Network created${NC}"
fi

# Create volumes
echo -e "${BLUE}2. Creating volumes...${NC}"
if ! docker volume ls --format '{{.Name}}' | grep -q "^${POSTGRES_VOLUME}$"; then
    docker volume create ${POSTGRES_VOLUME}
    echo -e "${GREEN}✓ PostgreSQL volume created${NC}"
else
    echo -e "${YELLOW}PostgreSQL volume already exists (data preserved)${NC}"
fi

if ! docker volume ls --format '{{.Name}}' | grep -q "^${N8N_VOLUME}$"; then
    docker volume create ${N8N_VOLUME}
    echo -e "${GREEN}✓ n8n volume created${NC}"
else
    echo -e "${YELLOW}n8n volume already exists (data preserved)${NC}"
fi

# Clean up existing containers
echo -e "${BLUE}3. Cleaning up existing containers...${NC}"
for container in ${POSTGRES_CONTAINER} ${N8N_CONTAINER}; do
    if docker ps -a --format '{{.Names}}' | grep -q "^${container}$"; then
        echo -e "${YELLOW}Stopping and removing ${container}...${NC}"
        docker stop ${container} > /dev/null 2>&1 || true
        docker rm ${container} > /dev/null 2>&1 || true
        echo -e "${GREEN}✓ ${container} removed${NC}"
    fi
done

# Start PostgreSQL
echo -e "${BLUE}4. Starting PostgreSQL...${NC}"
docker run -d \
  --name ${POSTGRES_CONTAINER} \
  --network ${NETWORK_NAME} \
  --restart unless-stopped \
  -e POSTGRES_USER=${POSTGRES_USER} \
  -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
  -e POSTGRES_DB=${POSTGRES_DB} \
  -v ${POSTGRES_VOLUME}:/var/lib/postgresql/data \
  postgres:15-alpine

echo -e "${GREEN}✓ PostgreSQL started${NC}"

# Wait for PostgreSQL
echo -e "${YELLOW}Waiting for PostgreSQL to be ready...${NC}"
for i in {1..30}; do
    if docker exec ${POSTGRES_CONTAINER} pg_isready -U ${POSTGRES_USER} > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PostgreSQL is ready${NC}"
        break
    fi
    echo -n "."
    sleep 1
done
echo ""

# Verify PostgreSQL
if ! docker exec ${POSTGRES_CONTAINER} pg_isready -U ${POSTGRES_USER} > /dev/null 2>&1; then
    echo -e "${RED}Error: PostgreSQL failed to start${NC}"
    echo -e "Check logs: ${YELLOW}docker logs ${POSTGRES_CONTAINER}${NC}"
    exit 1
fi

# Start n8n
echo -e "${BLUE}5. Starting n8n...${NC}"
docker run -d \
  --name ${N8N_CONTAINER} \
  --network ${NETWORK_NAME} \
  --restart unless-stopped \
  -p 5678:5678 \
  -e DB_TYPE=postgresdb \
  -e DB_POSTGRESDB_HOST=${POSTGRES_CONTAINER} \
  -e DB_POSTGRESDB_PORT=5432 \
  -e DB_POSTGRESDB_DATABASE=${POSTGRES_DB} \
  -e DB_POSTGRESDB_USER=${POSTGRES_USER} \
  -e DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD} \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=${N8N_USER} \
  -e N8N_BASIC_AUTH_PASSWORD=${N8N_PASSWORD} \
  -e GENERIC_TIMEZONE=America/New_York \
  -v ${N8N_VOLUME}:/home/node/.n8n \
  n8n/n8n:latest

echo -e "${GREEN}✓ n8n started${NC}"

# Wait for n8n
echo -e "${YELLOW}Waiting for n8n to be ready...${NC}"
sleep 5

# Verify n8n is running
if ! docker ps --format '{{.Names}}' | grep -q "^${N8N_CONTAINER}$"; then
    echo -e "${RED}Error: n8n failed to start${NC}"
    echo -e "Check logs: ${YELLOW}docker logs ${N8N_CONTAINER}${NC}"
    exit 1
fi

# Display summary
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  ✓ Setup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}Access Information:${NC}"
echo -e "  URL:      ${YELLOW}http://localhost:5678${NC}"
echo -e "  Username: ${YELLOW}${N8N_USER}${NC}"
echo -e "  Password: ${YELLOW}${N8N_PASSWORD}${NC}"
echo ""
echo -e "${BLUE}Database Information:${NC}"
echo -e "  Type:     ${YELLOW}PostgreSQL${NC}"
echo -e "  User:     ${YELLOW}${POSTGRES_USER}${NC}"
echo -e "  Password: ${YELLOW}${POSTGRES_PASSWORD}${NC}"
echo -e "  Database: ${YELLOW}${POSTGRES_DB}${NC}"
echo ""
echo -e "${RED}⚠️  IMPORTANT: Save these credentials securely!${NC}"
echo ""
echo -e "${BLUE}Useful Commands:${NC}"
echo -e "  n8n logs:          ${YELLOW}docker logs -f ${N8N_CONTAINER}${NC}"
echo -e "  PostgreSQL logs:   ${YELLOW}docker logs -f ${POSTGRES_CONTAINER}${NC}"
echo -e "  PostgreSQL CLI:    ${YELLOW}docker exec -it ${POSTGRES_CONTAINER} psql -U ${POSTGRES_USER} -d ${POSTGRES_DB}${NC}"
echo -e "  Stop all:          ${YELLOW}docker stop ${N8N_CONTAINER} ${POSTGRES_CONTAINER}${NC}"
echo -e "  Start all:         ${YELLOW}docker start ${POSTGRES_CONTAINER} ${N8N_CONTAINER}${NC}"
echo ""

