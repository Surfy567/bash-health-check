# Lint, Package & Deploy Script

## Overview

This project provides a GitHub Actions workflow to automate the process of linting, packaging, and securely deploying a shell script (setup-ssh-deployment.sh) to a remote Ubuntu VM via SSH.

The workflow runs on a self-hosted runner and performs the following steps on every push to the main branch:

- Checkout code

- Ensure required dependencies (shellcheck, openssh-client) are installed

- Lint the deployment shell script using ShellCheck

- Validate shell script syntax

- Package the script into a tarball (healthcheck.tar.gz)

- Setup SSH key for passwordless authentication

- Create a deployment directory on the remote VM if it doesn’t exist

- Copy the packaged script to the remote VM

- Extract and execute the script on the remote VM

### Benefits
- Automates manual deployment tasks

- Enforces script quality checks before deployment

- Securely manages SSH credentials via GitHub Secrets

- Easily extendable to support additional deployment scripts or tasks

- Reliable, repeatable deployment process

### Prerequisites

- A self-hosted GitHub Actions runner running Ubuntu (or compatible)

- A remote Ubuntu VM accessible over SSH

- SSH key pair configured with private key stored in GitHub Secrets as VM_SSH_KEY

- GitHub Secrets configured for:

- VM_HOST — remote VM IP or hostname

- VM_USER — SSH user on remote VM

# How to Use
1. Clone this repository and update the setup-ssh-deployment.sh script as needed.

2. Ensure your GitHub Secrets are set for VM_SSH_KEY, VM_HOST, and VM_USER.

3. Push your changes to the main branch.

4. The workflow will automatically run and deploy the script to the remote VM.

5. Monitor the workflow logs for status and debug information.

## Troubleshooting

- SSH connection errors: Check your secrets, firewall rules, and SSH key permissions.

- Permission denied on remote directory: Ensure VM_USER has write permissions on /home/${{ VM_USER }}/healthcheck-deploy.

- Missing dependencies: Confirm your self-hosted runner has internet access to install packages.

- File not found errors: Make sure healthcheck.tar.gz is correctly created and located in the runner workspace before scp.
