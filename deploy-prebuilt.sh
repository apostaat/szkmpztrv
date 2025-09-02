#!/bin/bash

# Deploy pre-built application to Vultr VM
# This avoids building on the low-memory server

echo "🚀 Deploying pre-built szkmpztrv to Vultr VM..."

# Build locally first
echo "🏗️ Building application locally..."
npm run build:extreme-minimal

if [ $? -ne 0 ]; then
    echo "❌ Build failed locally. Exiting."
    exit 1
fi

echo "✅ Build successful locally!"

# Create deployment package
echo "📦 Creating deployment package..."
rm -rf deploy-package
mkdir deploy-package
cp -r build/* deploy-package/
cp nginx.conf deploy-package/
cp alpine-deploy-prebuilt.sh deploy-package/

# Deploy to server
echo "🚀 Deploying to Vultr VM..."
ssh root@64.176.214.253 'bash -s' < alpine-deploy-prebuilt.sh

echo "✅ Deployment completed!"
echo "🌐 Your app should be accessible at http://64.176.214.253"
