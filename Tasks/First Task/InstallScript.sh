#!/usr/bin/env bash
#################### /ᐠ｡ꞈ｡ᐟ\ ######################
#Developed by: Tal Mendelson
#Purpose: First setup, configurations and backup
#Date:14/02/2025
#Version: 0.0.1
set -o errexit     # 
set -o pipefail    # 
#################### /ᐠ｡ꞈ｡ᐟ\ ######################

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script requires root privileges."
    exec sudo "$0" "$@"  # Restart script with sudo
    exit 1
fi

# List of packages to install
packages=("curl" "wget" "git" "vim" "python3-pip")

# Vim configuration file path
VIMRC="/etc/vim/vimrc"

# Log file path
LOGFILE="/var/log/installations.log"

# Ensure log file exists
touch "$LOGFILE"

# Logs function
function logit() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" | tee -a "$LOGFILE"
}

# Installation function
function install_apt() {
    local package=$1
    logit "Attempting to install: $package"

    # Capture the error output in case the installation fails
    error_message=$(apt install -y "$package" 2>&1)

    # Check if installation was successful
    if [ $? -eq 0 ]; then
        # Installation success
        logit "Successfully installed: $package"
    else
        # Installation failed
        logit "Failed to install: $package"
        logit "Error message: $error_message"
    fi
}

# Update package lists
logit "Updating system packages"
if ! apt update -y; then
    logit "Failed to update package lists"
    exit 1
else
    logit "Packge lists updated successfully"
fi

if ! apt upgrade -y; then
    logit "Failed to upgrade"
    exit 1
else
    logit "Packages upgraded successfully"
fi

# Loop through each package and install it
for package in "${packages[@]}"; do
    install_apt "$package"
done

# Backup the original file before modifying
cp "$VIMRC" "$VIMRC.bak"

# Append new settings if they are not already present
cat <<EOL >> "$VIMRC"

" Custom Global Vim Configurations
syntax on          " Enable syntax highlighting
set number         " Show line numbers
set tabstop=4      " Set tab width to 4 spaces
set shiftwidth=4   " Auto-indent uses 4 spaces
set expandtab      " Convert tabs to spaces
set background=dark " Optimize for dark terminal themes
set mouse=a        " Enable mouse support
set clipboard=unnamedplus " Use system clipboard
EOL

