FROM alpine:3.22

# Install dependencies
RUN apk update && apk upgrade
RUN apk add nodejs npm nginx git

# Create app directory
WORKDIR /var/www/szkmpztrv

# Copy package files first for better caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build the application with ultra-minimal memory usage
RUN npm run build:ultra-minimal

# Copy nginx configuration
COPY nginx.conf /etc/nginx/http.d/szkmpztrv.conf

# Remove default nginx config
RUN rm -f /etc/nginx/http.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
