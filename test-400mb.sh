#!/bin/bash

# Test script for szkmpztrv with 400MB memory limit
# This simulates your 500MB Vultr VM environment

echo "🧪 Testing szkmpztrv with 400MB memory limit (simulating 500MB Vultr VM)..."

# Stop any existing containers
echo "🛑 Stopping existing containers..."
docker-compose down

# Build and run with memory constraints
echo "🐳 Building and starting Docker container with 400MB memory limit..."
docker-compose up --build -d

echo "⏳ Waiting for container to start..."
sleep 10

# Check if container is running
if docker-compose ps | grep -q "Up"; then
    echo "✅ Container is running!"
    echo "🌐 Your app should be accessible at http://localhost:8080"
    echo ""
    echo "Memory usage:"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}"
    echo ""
    echo "To view logs:"
    echo "  docker-compose logs -f"
    echo ""
    echo "To stop:"
    echo "  docker-compose down"
else
    echo "❌ Container failed to start. Check logs:"
    docker-compose logs
fi
