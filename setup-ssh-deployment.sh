#!/bin/bash


USERNAME="deployer"
GITHUB_USER="Surfy567"  


echo "Fetching public SSH keys for GitHub user: $GITHUB_USER..."
PUB_KEYS=$(curl -s https://github.com/${GITHUB_USER}.keys)

if [[ -z "$PUB_KEYS" ]]; then
    echo "Failed to fetch SSH keys for user $GITHUB_USER. Exiting."
    exit 1
fi


if id "$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' already exists."
else
    echo "Creating user '$USERNAME'..."
    sudo adduser --disabled-password --gecos "" "$USERNAME"
    sudo usermod -aG sudo "$USERNAME"
fi


if ! dpkg -l | grep -q openssh-server; then
    echo "Installing OpenSSH server..."
    sudo apt update
    sudo apt install -y openssh-server
else
    echo "OpenSSH server is already installed."
fi


echo "Enabling and starting SSH..."
sudo systemctl enable --now ssh


echo "Setting up authorized_keys for $USERNAME..."
sudo -u "$USERNAME" mkdir -p /home/$USERNAME/.ssh
echo "$PUB_KEYS" | sudo tee /home/$USERNAME/.ssh/authorized_keys > /dev/null
sudo chmod 700 /home/$USERNAME/.ssh
sudo chmod 600 /home/$USERNAME/.ssh/authorized_keys
sudo chown -R "$USERNAME":"$USERNAME" /home/$USERNAME/.ssh


if command -v ufw &>/dev/null && ! sudo ufw status | grep -q "inactive"; then
    echo "Allowing SSH through UFW..."
    sudo ufw allow OpenSSH
    sudo ufw enable
else
    echo "Skipping UFW firewall changes."
fi

echo "Setup complete."
