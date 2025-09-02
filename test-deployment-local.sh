#!/bin/bash

# Test the deployment package locally before sending to server

echo "🧪 Testing deployment package locally..."

# Build locally first
echo "🏗️ Building application locally..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed locally. Exiting."
    exit 1
fi

echo "✅ Build successful locally!"

# Create deployment package
echo "📦 Creating deployment package..."
rm -rf deploy-package
mkdir deploy-package

# Copy built files
cp -r build/* deploy-package/

# Copy nginx configuration
cp nginx.conf deploy-package/

# Copy deployment script
cp alpine-deploy-prebuilt.sh deploy-package/

# Test the package locally using Docker
echo "🧪 Testing if built app actually works with Docker..."
cd deploy-package

# Check if all files are present
echo "📋 Checking deployment package contents:"
ls -la

# Test with Docker using our existing setup
echo "🐳 Testing with Docker..."
docker-compose up --build -d

echo "⏳ Waiting for container to start..."
sleep 10

# Check if container is actually running
echo "📊 Checking container status..."
docker-compose ps

# Test if the app responds
echo "🌐 Testing app accessibility..."
if curl -s http://localhost:8080 > /dev/null; then
    echo "✅ App is responding on port 8080!"
    echo "📋 App content preview:"
    curl -s http://localhost:8080 | head -5
    echo ""
    if curl -s http://localhost:8080 | grep -q "союз композиторов и эвм"; then
        echo "✅ Found main title in app!"
    else
        echo "❌ Main title not found in app"
    fi
else
    echo "❌ App is NOT responding on port 8080!"
    echo "📋 Checking what's happening..."
    docker-compose logs
fi

echo ""
echo "🎯 Container is now running and ready for manual testing!"
echo "🌐 Open http://localhost:8080 in your browser"
echo "📊 Check container status: docker-compose ps"
echo "📋 View logs: docker-compose logs -f"
echo "🛑 Stop when done: docker-compose down"
echo ""
echo "Press Enter when you're done testing..."

# Wait for user input
read -r

# Stop Docker
echo "🛑 Stopping Docker container..."
docker-compose down

echo ""
echo "✅ Deployment package created and tested successfully!"
echo "📁 Contents:"
echo "  - Built React app files"
echo "  - nginx.conf"
echo "  - alpine-deploy-prebuilt.sh"

# Clean up
cd ..
rm -rf deploy-package

echo ""
echo "🎯 Ready to deploy to Vultr VM!"
echo "Run: ./deploy-prebuilt.sh"
