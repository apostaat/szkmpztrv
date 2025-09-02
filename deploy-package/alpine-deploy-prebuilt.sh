#!/bin/sh

# Alpine Linux script to deploy pre-built szkmpztrv
# This script handles files that are already copied via SCP

echo "🚀 Deploying pre-built szkmpztrv on Alpine Linux..."

# Update system
echo "📦 Updating system..."
apk update && apk upgrade

# Install Nginx only (no Node.js needed for pre-built)
echo "📦 Installing Nginx..."
apk add nginx

# Remove existing app directory
echo "🧹 Removing existing application directory..."
rm -rf /var/www/szkmpztrv

# Create fresh app directory
echo "📁 Creating fresh application directory..."
mkdir -p /var/www/szkmpztrv
cd /var/www/szkmpztrv

# Files are already copied via SCP from deploy-prebuilt.sh
echo "📦 Pre-built files are already copied..."

# Configure Nginx
echo "⚙️ Configuring Nginx..."
cp nginx.conf /etc/nginx/http.d/szkmpztrv.conf

# Remove default nginx config
rm -f /etc/nginx/http.d/default.conf

# Start and enable Nginx
echo "🔄 Starting Nginx..."
rc-service nginx start
rc-update add nginx default

# Configure firewall
echo "🔥 Configuring firewall..."
apk add iptables
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -j DROP

echo ""
echo "✅ Pre-built deployment completed!"
echo "🌐 Your app should be accessible at http://64.176.214.253"
echo ""
echo "To update later, run the deploy-prebuilt.sh script locally"
