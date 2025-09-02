#!/bin/sh

# Alpine Linux setup script for szkmpztrv
# Run this on your Alpine VM after SSH: ssh root@64.176.214.253

echo "🚀 Setting up szkmpztrv on Alpine Linux..."

# Update system
echo "📦 Updating system..."
apk update && apk upgrade

# Install Node.js, Nginx, Git
echo "📦 Installing Node.js, Nginx, Git..."
apk add nodejs npm nginx git

# Create app directory
echo "📁 Creating application directory..."
mkdir -p /var/www/szkmpztrv
cd /var/www/szkmpztrv

# Clone repository
echo "🔗 Cloning repository..."
git clone https://github.com/apostaat/szkmpztrv.git .

# Install dependencies and build
echo "📦 Installing dependencies..."
npm install
echo "🏗️ Building application..."
npm run build

# Configure Nginx
echo "⚙️ Configuring Nginx..."
cp nginx.conf /etc/nginx/http.d/szkmpztrv.conf

# Remove default nginx config
rm -f /etc/nginx/http.d/default.conf

# Start and enable Nginx
echo "🔄 Starting Nginx..."
rc-service nginx start
rc-update add nginx default

# Configure firewall (if using iptables)
echo "🔥 Configuring firewall..."
apk add iptables
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -j DROP

echo ""
echo "✅ Setup completed!"
echo "🌐 Your app should now be accessible at http://64.176.214.253"
echo ""
echo "To update the app later, just run:"
echo "  cd /var/www/szkmpztrv"
echo "  git pull origin main"
echo "  npm install"
echo "  npm run build"
echo "  rc-service nginx restart"
