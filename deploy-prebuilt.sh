#!/bin/bash

# Deploy pre-built szkmpztrv to Vultr VM
# 
# Environment Variables:
#   DOMAIN_NAME - Domain for HTTPS configuration (e.g., "example.com")
#   WHATSAPP_NUMBER - WhatsApp number for merch ordering (e.g., "1234567890")
#
# Examples:
#   export DOMAIN_NAME=soyuzkompozitorov.com && export WHATSAPP_NUMBER=1234567890 && ./deploy-prebuilt.sh
#   export WHATSAPP_NUMBER=1234567890 && ./deploy-prebuilt.sh
#   export DOMAIN_NAME=soyuzkompozitorov.com && ./deploy-prebuilt.sh
#
# This script builds locally and deploys pre-built files to avoid memory issues on the VM

# Configuration
SERVER_IP="64.176.214.253"
DOMAIN_NAME="${DOMAIN_NAME:-}"
WHATSAPP_NUMBER="${WHATSAPP_NUMBER:-}"

echo "🚀 Deploying pre-built szkmpztrv to Vultr VM..."

# Check if domain name is provided for HTTPS
if [ -n "$DOMAIN_NAME" ]; then
    echo "🔒 HTTPS will be configured for domain: $DOMAIN_NAME"
else
    echo "⚠️  No domain name provided. HTTPS will not be configured."
    echo "   To enable HTTPS, set DOMAIN_NAME environment variable"
fi

# Check if WhatsApp number is provided
if [ -n "$WHATSAPP_NUMBER" ]; then
    echo "📱 WhatsApp ordering will use number: $WHATSAPP_NUMBER"
else
    echo "⚠️  No WhatsApp number provided. Using default placeholder."
    echo "   To customize WhatsApp ordering, set WHATSAPP_NUMBER environment variable"
fi

echo ""

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

if [ -n "$DOMAIN_NAME" ]; then
    echo "🔒 Configuring HTTPS for domain: $DOMAIN_NAME"
    ssh root@$SERVER_IP "cd /var/www/szkmpztrv && DOMAIN_NAME=$DOMAIN_NAME WHATSAPP_NUMBER=$WHATSAPP_NUMBER bash alpine-deploy-prebuilt.sh"
else
    ssh root@$SERVER_IP "cd /var/www/szkmpztrv && WHATSAPP_NUMBER=$WHATSAPP_NUMBER bash alpine-deploy-prebuilt.sh"
fi

# Clean up local deployment package
rm -rf deploy-package

echo "✅ Deployment completed!"
echo "🌐 Your app should be accessible at:"
if [ -n "$DOMAIN_NAME" ]; then
    echo "   HTTP:  http://$DOMAIN_NAME"
    echo "   HTTPS: https://$DOMAIN_NAME"
else
    echo "   HTTP:  http://$SERVER_IP"
fi

echo ""
echo "📱 WhatsApp ordering:"
if [ -n "$WHATSAPP_NUMBER" ]; then
    echo "   Configured for number: $WHATSAPP_NUMBER"
else
    echo "   Using default WhatsApp ordering (no specific number)"
fi

echo ""
echo "To update later, run the deploy-prebuilt.sh script locally"
echo "To enable HTTPS, set DOMAIN_NAME environment variable and redeploy"
echo "To customize WhatsApp, set WHATSAPP_NUMBER environment variable and redeploy"
echo ""
echo "Examples:"
echo "  export DOMAIN_NAME=yourdomain.com && export WHATSAPP_NUMBER=1234567890 && ./deploy-prebuilt.sh"
echo "  export WHATSAPP_NUMBER=1234567890 && ./deploy-prebuilt.sh"
echo "  export DOMAIN_NAME=yourdomain.com && ./deploy-prebuilt.sh"
