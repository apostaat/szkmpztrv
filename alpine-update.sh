#!/bin/sh

# Alpine Linux update script for szkmpztrv
# Run this on your Alpine VM to deploy updates

echo "🔄 Updating szkmpztrv..."

cd /var/www/szkmpztrv

echo "📥 Pulling latest changes..."
git pull origin main

echo "📦 Installing dependencies..."
npm install

echo "🏗️ Building application (ultra-minimal mode for 500MB RAM)..."
npm run build:ultra-minimal

echo "🔄 Restarting Nginx..."
rc-service nginx restart

echo "✅ Update completed!"
echo "🌐 Your app is now updated at http://64.176.214.253"
