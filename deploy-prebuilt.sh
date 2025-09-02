#!/bin/bash

# Deploy pre-built application to Vultr VM
# This avoids building on the low-memory server

echo "🚀 Deploying pre-built szkmpztrv to Vultr VM..."

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

# Copy the deployment package to the server
echo "📤 Copying deployment package to server..."
scp -r deploy-package/* root@64.176.214.253:/var/www/szkmpztrv/

# Deploy to server
echo "🚀 Deploying to Vultr VM..."
ssh root@64.176.214.253 'bash -s' < alpine-deploy-prebuilt.sh

# Clean up local deployment package
rm -rf deploy-package

echo "✅ Deployment completed!"
echo "🌐 Your app should be accessible at http://64.176.214.253"
