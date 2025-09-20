#!/bin/bash

# KaziApp Docker Cleanup Script
# This script cleans up Docker containers, images, volumes, and networks

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Change to the docker directory
cd "$(dirname "$0")/.."

print_status "Starting KaziApp Docker cleanup..."

# Stop all running containers
print_status "Stopping all KaziApp containers..."
docker-compose down

# Remove all containers (including stopped ones)
print_status "Removing all KaziApp containers..."
docker-compose rm -f

# Remove KaziApp images
print_status "Removing KaziApp images..."
docker images | grep kaziapp | awk '{print $3}' | xargs -r docker rmi -f

# Clean up dangling images
print_status "Removing dangling images..."
docker image prune -f

# Clean up unused volumes (with confirmation)
read -p "Do you want to remove all KaziApp volumes? This will delete all data! (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Removing KaziApp volumes..."
    docker volume ls | grep kaziapp | awk '{print $2}' | xargs -r docker volume rm
    print_success "Volumes removed"
else
    print_status "Volumes preserved"
fi

# Clean up unused networks
print_status "Removing unused networks..."
docker network prune -f

# Clean up build cache
print_status "Cleaning up build cache..."
docker builder prune -f

# System cleanup
print_status "Running system cleanup..."
docker system prune -f

print_success "KaziApp Docker cleanup completed!"

print_status "Remaining KaziApp resources:"
echo "Images:"
docker images | grep kaziapp || echo "  No KaziApp images found"
echo
echo "Volumes:"
docker volume ls | grep kaziapp || echo "  No KaziApp volumes found"
echo
echo "Networks:"
docker network ls | grep kaziapp || echo "  No KaziApp networks found"

print_status "To start fresh, run:"
echo "  ./scripts/build-all.sh"
echo "  ./scripts/start-dev.sh"
