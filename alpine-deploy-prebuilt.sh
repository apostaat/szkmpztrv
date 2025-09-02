#!/bin/bash

# Configuration
DOMAIN_NAME="${DOMAIN_NAME:-}"
WHATSAPP_NUMBER="${WHATSAPP_NUMBER:-}"

echo "🚀 Deploying pre-built szkmpztrv on Alpine Linux..."

# Check if domain name is provided for HTTPS
if [ -n "$DOMAIN_NAME" ]; then
    echo "🔒 HTTPS will be configured for domain: $DOMAIN_NAME"
else
    echo "⚠️  No domain name provided. HTTPS will not be configured."
fi

# Check if WhatsApp number is provided
if [ -n "$WHATSAPP_NUMBER" ]; then
    echo "📱 WhatsApp ordering will use number: $WHATSAPP_NUMBER"
else
    echo "⚠️  No WhatsApp number provided. Using default placeholder."
fi

echo ""

# Update system
echo "📦 Updating system..."
apk update && apk upgrade

# Install Nginx and Certbot
echo "📦 Installing Nginx and Certbot..."
apk add nginx certbot certbot-nginx

# Files are already copied via SCP from deploy-prebuilt.sh
echo "📦 Pre-built files are already copied..."

# Stop Nginx if it's running
echo "🛑 Stopping Nginx if running..."
rc-service nginx stop 2>/dev/null || true

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
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -j DROP

# Setup HTTPS with Let's Encrypt
echo "🔒 Setting up HTTPS..."
if [ -n "$DOMAIN_NAME" ]; then
    echo "📝 Using domain: $DOMAIN_NAME"
    # Stop nginx temporarily for certbot
    rc-service nginx stop
    
    # Get SSL certificate
    certbot certonly --standalone -d $DOMAIN_NAME --non-interactive --agree-tos --email admin@$DOMAIN_NAME
    
    # Update nginx config for HTTPS - replace the entire server block
    cat > /etc/nginx/http.d/szkmpztrv.conf << EOF
server {
    listen 80;
    server_name $DOMAIN_NAME;
    root /var/www/szkmpztrv;
    index index.html;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/json
        application/javascript
        application/xml+rss
        application/atom+xml
        image/svg+xml;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;

    # Serve static files
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Cache static assets
    location ~* \\.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Font files
    location ~* \\.(ttf|otf|woff|woff2)$ {
        add_header Access-Control-Allow-Origin *;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # API routes (if any)
    location /api/ {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}

server {
    listen 443 ssl;
    server_name $DOMAIN_NAME;
    root /var/www/szkmpztrv;
    index index.html;

    # Basic SSL configuration
    ssl_certificate /etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/json
        application/javascript
        application/xml+rss
        application/atom+xml
        image/svg+xml;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;

    # Serve static files
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Cache static assets
    location ~* \\.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Font files
    location ~* \\.(ttf|otf|woff|woff2)$ {
        add_header Access-Control-Allow-Origin *;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # API routes (if any)
    location /api/ {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF
    
    # Start nginx with HTTPS config
    rc-service nginx start
    
    echo "✅ HTTPS configured for domain: $DOMAIN_NAME"
else
    echo "⚠️  No domain name provided. HTTPS not configured."
    echo "   To enable HTTPS, set DOMAIN_NAME environment variable and redeploy."
fi

# Inject WhatsApp number into the built React app if provided
if [ -n "$WHATSAPP_NUMBER" ]; then
    echo "📱 Injecting WhatsApp number: $WHATSAPP_NUMBER"
    
    # Find and replace the WhatsApp number in the main JavaScript bundle
    find /var/www/szkmpztrv -name "*.js" -type f -exec sed -i "s|process\.env\.REACT_APP_WHATSAPP_NUMBER||g" {} \;
    find /var/www/szkmpztrv -name "*.js" -type f -exec sed -i "s|REACT_APP_WHATSAPP_NUMBER||g" {} \;
    
    # Replace the placeholder with the actual number in the WhatsApp URL
    find /var/www/szkmpztrv -name "*.js" -type f -exec sed -i "s|https://wa.me/?text=|https://wa.me/$WHATSAPP_NUMBER?text=|g" {} \;
    
    echo "✅ WhatsApp number injected successfully"
else
    echo "⚠️  No WhatsApp number provided. Using default WhatsApp ordering."
fi

echo ""
echo "✅ Pre-built deployment completed!"
if [ -n "$DOMAIN_NAME" ]; then
    echo "🌐 Your app should be accessible at:"
    echo "   HTTP:  http://$DOMAIN_NAME"
    echo "   HTTPS: https://$DOMAIN_NAME"
else
    echo "🌐 Your app should be accessible at http://64.176.214.253"
fi
echo ""
echo "To update later, run the deploy-prebuilt.sh script locally"
echo "To enable HTTPS, set DOMAIN_NAME and redeploy"
