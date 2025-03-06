#!/usr/bin/env bash
############################################################ /ᐠ｡ꞈ｡ᐟ\############################################################
#Developed by: Tal Mendelson
#Purpose: This script ensures Nginx is installed,
#         verifies and configures a virtual host if needed,
#         checks and installs dependencies for user directories,
#         authentication, and CGI, while providing an argument-based system for selective installation and configuration.
#Date:05/03/2025
#Version: 0.0.1
set -o errexit     # 
set -o pipefail    # 
############################################################ /ᐠ｡ꞈ｡ᐟ\ ############################################################

# Checks if logit is enabled if enabled, Calls for Logit
if [ -f "/usr/local/bin/logit.sh" ]; then
    logit start
    LOGITLOGS="Enabled"
fi

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script requires root privileges."
    exec sudo "$0" "$@"  # Restart script with sudo
    exit 1
fi

# Check if Nginx is installed
if ! command -v nginx &> /dev/null; then
    printf "Nginx not detected on this machine."
    read -p "Do you wish to installed Nginx?"

    apt update && apt install -y nginx
    echo "Nginx installation complete."
fi
