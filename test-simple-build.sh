#!/bin/bash

# Simple test script for szkmpztrv
# Uses regular build without memory constraints

echo "🧪 Testing szkmpztrv with regular build..."

# Build locally first
echo "🏗️ Building application locally..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed locally. Exiting."
    exit 1
fi

echo "✅ Build successful locally!"

# Test with Docker
echo "🐳 Testing with Docker..."
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
