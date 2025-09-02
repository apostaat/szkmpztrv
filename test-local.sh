#!/bin/bash

# Local testing script for szkmpztrv
# This will build and run the app in Docker to test the setup

echo "🧪 Testing szkmpztrv locally with Docker..."

# Build and run with docker-compose
echo "🐳 Building and starting Docker container..."
docker-compose up --build -d

echo "⏳ Waiting for container to start..."
sleep 5

# Check if container is running
if docker-compose ps | grep -q "Up"; then
    echo "✅ Container is running!"
    echo "🌐 Your app should be accessible at http://localhost:8080"
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
