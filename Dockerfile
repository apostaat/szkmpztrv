FROM alpine:3.22

# Install only Nginx (no Node.js needed for pre-built files)
RUN apk update && apk add nginx

# Create app directory
WORKDIR /var/www/szkmpztrv

# Copy pre-built files (no building needed)
COPY . .

# Configure Nginx
RUN rm -f /etc/nginx/http.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
