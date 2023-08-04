#Use the official Node.js Docker image with Node.js version 10.15.3
FROM node:10.15.3-alpine as builder

# Set the working directory inside the container
WORKDIR /app

# Copy the React app code into the container
COPY . /app

# Install Python 3.x and other required build tools
RUN apk update && apk add --no-cache python3 && ln -s /usr/bin/python3 /usr/local/bin/python

# Install Node.js dependencies
RUN npm install --legacy-peer-deps
RUN npm cache clean --force

RUN npm --version

# Build the React app for production
RUN npm run build --max_old_space_size=17000

# Stage 2: Serve the React app with Apache web server
FROM httpd:2.4

COPY --from=builder /app/build/ /usr/local/apache2/htdocs/

#COPY .htaccess /usr/local/apache2/htdocs/

# Copying our Apache configuration file
COPY httpd.conf /usr/local/apache2/conf/httpd.conf
