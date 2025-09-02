#!/bin/bash

# Vultr deployment script for szkmpztrv React SPA
# Run this script on your Vultr server after creating a new instance

echo "Setting up szkmpztrv React SPA on Vultr..."

# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js 18.x
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Nginx
sudo apt install nginx -y

# Install Git
sudo apt install git -y

# Create application directory
sudo mkdir -p /var/www/szkmpztrv
sudo chown $USER:$USER /var/www/szkmpv

# Clone repository (replace with your actual repository URL)
cd /var/www/szkmpztrv
git clone https://github.com/yourusername/szkmpztrv.git .

# Install dependencies
npm ci

# Build application
npm run build

# Configure Nginx
sudo cp nginx.conf /etc/nginx/sites-available/szkmpztrv
sudo ln -s /etc/nginx/sites-available/szkmpztrv /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default

# Test Nginx configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx
sudo systemctl enable nginx

# Set up firewall
sudo ufw allow 'Nginx Full'
sudo ufw allow OpenSSH
sudo ufw --force enable

echo "Deployment completed!"
echo "Your React SPA should now be accessible at your server's IP address"
echo "Don't forget to:"
echo "1. Update the domain in nginx.conf"
echo "2. Set up SSL with Let's Encrypt"
echo "3. Configure GitHub Actions secrets for CI/CD"
