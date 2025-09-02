#!/bin/sh

# Alpine Linux update script for szkmpztrv
# Run this on your Alpine VM to deploy updates

echo "🔄 Updating szkmpztrv..."

cd /var/www/szkmpztrv

echo "📥 Pulling latest changes..."
git pull origin main

echo "📦 Installing dependencies..."
npm ci

echo "🏗️ Building application..."
npm run build

echo "🔄 Restarting Nginx..."
rc-service nginx restart

echo "✅ Update completed!"
echo "🌐 Your app is now updated at http://64.176.214.253"
