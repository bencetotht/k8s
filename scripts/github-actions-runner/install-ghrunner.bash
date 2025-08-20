#! /bin/bash

BINARY_URL="https://github.com/actions/runner/releases/download/v2.328.0/actions-runner-osx-x64-2.328.0.tar.gz"
BINARY_NAME="actions-runner-osx-x64-2.328.0.tar.gz"

RUNNER_URL=""
RUNNER_TOKEN=""

USERNAME=$(whoami)

# Install GitHub Actions Runner
echo "Installing GitHub Actions Runner"
mkdir -p ~/ghrunner && cd ~/ghrunner
sudo apt update
curl -o $BINARY_NAME -L $BINARY_URL

tar xzf $BINARY_NAME

./config.sh --url $RUNNER_URL --token $RUNNER_TOKEN

# To run it directly, use: ./run.sh
echo "GitHub Actions Runner installed"

# Add runner as a service
sudo touch /etc/systemd/system/ghrunner.service
sudo echo "[Unit]
Description=GitHub Actions Runner
After=network.target

[Service]
ExecStart=/home/$USERNAME/ghrunner/run.sh
WorkingDirectory=/home/$USERNAME/ghrunner
User=$USERNAME
Restart=always
RestartSec=5
Environment=PATH=/usr/local/bin:/usr/bin:/bin

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/ghrunner.service

chmod +x /home/$USERNAME/ghrunner/run.sh

sudo systemctl daemon-reload
sudo systemctl enable ghrunner # Enable the service to start on boot
sudo systemctl start ghrunner # Start the service immediately

echo "GitHub Actions Runner service added"

echo "Installing Dependencies..."
https://raw.githubusercontent.com/bencetotht/k8s/refs/heads/main/scripts/docker/docker-install.sh | bash
sudo apt install unzip -y
echo "Dependencies installed"