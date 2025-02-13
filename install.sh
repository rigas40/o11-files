#!/bin/bash

# Define target directory
TARGET_DIR="/home/o11"

# Create necessary directories
mkdir -p "$TARGET_DIR/scripts" "$TARGET_DIR/certs"
cd "$TARGET_DIR" || exit

# Clone GitHub repository into a temporary directory
temp_dir=$(mktemp -d)
git clone https://github.com/Random-Code-Guy/o11v4-Cracked.git "$temp_dir"

# Move repository contents to the target directory
mv "$temp_dir"/* "$TARGET_DIR"/
rm -rf "$temp_dir"

# Check if Node.js and npm are installed
if ! command -v node &> /dev/null || ! command -v npm &> /dev/null
then
    echo "Node.js and npm not found. Installing..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo "Node.js and npm are already installed."
fi

# Install required npm packages globally
npm install -g express pm2

# Set permissions for server.js
chmod 777 "$TARGET_DIR/server.js"

# Start server with PM2
pm2 start "$TARGET_DIR/server.js" --name licserver --silent
pm2 startup
pm2 save

# Run run.sh in background
nohup "$TARGET_DIR/run.sh" > /dev/null 2>&1 &

echo "Installation and setup complete."
