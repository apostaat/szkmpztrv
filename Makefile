# Makefile for szkmpztrv deployment
# Usage: make deploy SERVER=username@SERVER-IP

.PHONY: help deploy setup build clean

# Default values
SERVER ?= root@your-server-ip
REPO_URL ?= https://github.com/apostaat/szkmpztrv.git
APP_DIR ?= /var/www/szkmpztrv

help:
	@echo "Available commands:"
	@echo "  make deploy SERVER=username@SERVER-IP  - Deploy to Vultr server"
	@echo "  make setup SERVER=username@SERVER-IP   - Initial server setup"
	@echo "  make build                            - Build locally"
	@echo "  make clean                            - Clean build files"
	@echo ""
	@echo "Examples:"
	@echo "  make deploy SERVER=root@192.168.1.100"
	@echo "  make setup SERVER=root@192.168.1.100"

deploy: build
	@echo "🚀 Deploying to $(SERVER)..."
	@echo "📁 App directory: $(APP_DIR)"
	ssh $(SERVER) "cd $(APP_DIR) && git pull origin main && npm ci && npm run build && sudo systemctl restart nginx"
	@echo "✅ Deployment completed!"

setup:
	@echo "🔧 Setting up server $(SERVER)..."
	@echo "📦 Installing dependencies..."
	ssh $(SERVER) "sudo apt update && sudo apt upgrade -y"
	ssh $(SERVER) "curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt-get install -y nodejs"
	ssh $(SERVER) "sudo apt install nginx git -y"
	@echo "📁 Creating application directory..."
	ssh $(SERVER) "sudo mkdir -p $(APP_DIR) && sudo chown \$$USER:\$$USER $(APP_DIR)"
	@echo "🔗 Cloning repository..."
	ssh $(SERVER) "cd $(APP_DIR) && git clone $(REPO_URL) ."
	@echo "📦 Installing npm dependencies..."
	ssh $(SERVER) "cd $(APP_DIR) && npm ci"
	@echo "🏗️ Building application..."
	ssh $(SERVER) "cd $(APP_DIR) && npm run build"
	@echo "⚙️ Configuring Nginx..."
	ssh $(SERVER) "sudo cp $(APP_DIR)/nginx.conf /etc/nginx/sites-available/szkmpztrv"
	ssh $(SERVER) "sudo ln -sf /etc/nginx/sites-available/szkmpztrv /etc/nginx/sites-enabled/"
	ssh $(SERVER) "sudo rm -f /etc/nginx/sites-enabled/default"
	ssh $(SERVER) "sudo nginx -t && sudo systemctl restart nginx && sudo systemctl enable nginx"
	@echo "🔥 Configuring firewall..."
	ssh $(SERVER) "sudo ufw allow 'Nginx Full' && sudo ufw allow OpenSSH && sudo ufw --force enable"
	@echo "✅ Server setup completed!"
	@echo "🌐 Your app should now be accessible at http://$(shell echo $(SERVER) | cut -d@ -f2)"

build:
	@echo "🏗️ Building application..."
	npm ci
	npm run build
	@echo "✅ Build completed!"

clean:
	@echo "🧹 Cleaning build files..."
	rm -rf build/
	rm -rf node_modules/
	@echo "✅ Clean completed!"

# Quick deploy without building (assumes code is already built on server)
quick-deploy:
	@echo "⚡ Quick deploy to $(SERVER)..."
	ssh $(SERVER) "cd $(APP_DIR) && git pull origin main && sudo systemctl restart nginx"
	@echo "✅ Quick deployment completed!"

# Check server status
status:
	@echo "📊 Checking server status..."
	ssh $(SERVER) "systemctl status nginx --no-pager -l"
	ssh $(SERVER) "cd $(APP_DIR) && git log --oneline -5"

# View logs
logs:
	@echo "📋 Nginx logs:"
	ssh $(SERVER) "sudo tail -f /var/log/nginx/error.log"
