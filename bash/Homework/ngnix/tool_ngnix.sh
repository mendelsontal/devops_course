#!/usr/bin/env bash
############################################################ /ᐠ｡ꞈ｡ᐟ\############################################################
#Developed by: Tal Mendelson
#Purpose: This script ensures Nginx is installed,
#         verifies and configures a virtual host if needed,
#         checks and installs dependencies for user directories,
#         authentication, and CGI, while providing an argument-based system for selective installation and configuration.
#Date:06/03/2025
#Version: 0.0.1
############################################################ /ᐠ｡ꞈ｡ᐟ\ ############################################################

# ============================
# Functions
# ============================

# Function for Logs, for logs
function func_logit() {
if [ -f "/usr/local/bin/logit.sh" ]; then
    # Calls for logit.sh as it's not automatically sourced at the moment.
    source "/usr/local/bin/logit.sh"
    # Sets Logit to silent so it won't spam the terminal gui.
    export LOGIT_SILENT=true
    # Starts Logit
    logit start
fi
}

# Function to check if a port is in use
function is_port_free() {
    ss -tuln | grep :$1 &> /dev/null
    return $?
}

# Function to validate if a port if within the valid port ranges
function is_valid_port() {
    local PORT_NUMBER=$1
    if [[ $PORT_NUMBER -ge 1 && $PORT_NUMBER -le 65535 ]]; then
        return 0
    else
        return 1
    fi
}

# ============================
# ANSI Color and Style Variables
# ============================
    # Text Colors
    BLACK="\e[30m"
    RED="\e[31m"
    GREEN="\e[32m"
    YELLOW="\e[33m"
    BLUE="\e[34m"
    MAGENTA="\e[35m"
    CYAN="\e[36m"
    WHITE="\e[37m"

    # Background Colors
    BG_BLACK="\e[40m"
    BG_RED="\e[41m"
    BG_GREEN="\e[42m"
    BG_YELLOW="\e[43m"
    BG_BLUE="\e[44m"
    BG_MAGENTA="\e[45m"
    BG_CYAN="\e[46m"
    BG_WHITE="\e[47m"

    # Text Styles
    BOLD="\e[1m"
    DIM="\e[2m"
    UNDERLINE="\e[4m"
    BLINK="\e[5m"
    REVERSE="\e[7m"
    HIDDEN="\e[8m"

    # Reset Formatting
    RESET="\e[0m"


# ===================================
# Nginx Script "Start"
# ===================================
SCRIPT_VERSION="0.0.1"

# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    printf "${BOLD}Usage: $0 {--help | --version}${RESET}\n\n"
fi

# Help section
if [[ "$1" == "--help" ]]; then
    printf "${BOLD}${CYAN}Usage:${RESET}\n"
    printf "\n Use parameter install"
    printf "\n Use parameter configure"
fi

# Version section
if [[ "$1" == "--version" ]]; then
    printf "${BOLD}${CYAN}Versions:${RESET}"
    NGNIX_VERSION=$(nginx -v 2>&1 | cut -d'/' -f2)
    if [[ -z $NGNIX_VERSION ]]; then
        NGNIX_VERSION='-'
    fi
    printf "\nScript version: $SCRIPT_VERSION\n"
    printf "Installed Ngnix version: $NGNIX_VERSION\n\n"
fi

# Install section
if [[ "$1" == "install" ]]; then

    # Checks if running with sudo
    if [[ $EUID -ne 0 ]]; then
    printf "\n${BOLD}${YELLOW}This script requires root privileges.${RESET}\n"
    printf "Re-launching with sudo.\n"
    exec sudo "$0" "$@"  # Restart script with sudo
    exit 1
    fi

    # Checks if not already installed
    if ! command -v nginx &> /dev/null; then
        printf "\n${BOLD}Do you wish to install Nginx on this machine?${RESET}\n\n"
        # Choices - Intall Ngnix
        printf "# ============================= #\n"
        printf "1) ${BLUE}Install Ngnix.${RESET}\n"
        printf "2) ${BLUE}Cancel.${RESET}\n"
        printf "# ============================= #\n\n"

        # User selection
        printf "${BOLD}Do you wish to install Nginx?${RESET} (1 = Yes / 2 = No ) " && read ngnix_install_choice
        case "$ngnix_install_choice" in
            1) 
                # Install.
                apt update && apt install -y nginx
                ## Check status
                    if command -v nginx > /dev/null 2>&1; then
                        printf "\n${BOLD}${GREEN}Nginx installation completed successfully.${RESET}\n\n"
                        nginx -v
                    else
                        printf "\n${BOLD}${RED}ERROR - Something went wrong.${RESET}\n\n"
                    fi
            ;;
            2)
                # Cancel.
                printf "Ngnix installation canceled, exiting script.\n\n"
                exit 0
            ;;
            *)
                # Invalid option.
                printf "\n${RED}${BOLD}Invalid option.${RESET}\n"
                exit 1
            ;;
        esac

    else # Installed
        printf "\n${BOLD}${GREEN}Ngnix installation detected:${RESET}\n"
        nginx -v
        printf "\nExiting Script...\n"
    fi
fi

# Configuration and set section
if [[ "$1" == "configure" ]]; then
    # Checks if running with sudo
    if [[ $EUID -ne 0 ]]; then
    printf "\n${BOLD}${YELLOW}This script requires root privileges.${RESET}\n"
    printf "Re-launching with sudo.\n\n"
    exec sudo "$0" "$@"  # Restart script with sudo
    exit 1
    fi

    # Welcome
    printf "${BOLD}Welcome to Tool_Ngnix - version${RESET} $SCRIPT_VERSION\n"
    printf "You have selected the ${YELLOW}configure${RESET} option\n"

    # Asks the user for the virtual host name 
    printf "\nPlease provide the virtual-host name:\n" && read VHOST_NAME

    # Checks if VHOST_NAME is not empty and that the config file doesnt exist
    if [ ! -f "/etc/nginx/sites-available/$VHOST_NAME" ] && [[ -n $VHOST_NAME ]]; then
        printf "\nVirtual host ${BOLD}${BLUE}$VHOST_NAME${RESET} not configured. Creating..."

        # Asks user for the port for use
        while true; do
            printf "\n${BOLD}\nEnter port number for use:${RESET} " && read PORT_NUMBER

            # Validate if the provided port is within ports scope
            if ! is_valid_port "$PORT_NUMBER";then
                printf "\n${BOLD}${RED}Invalid port number.${RESET}\n" && printf "Please enter a number between 1-65535 \n"
                continue
            fi

            # Check if the port is actualyl free
            if is_port_free $PORT_NUMBER; then
                printf "\nPort $PORT_NUMBER is already in use. Please choose another port.\n"
                continue
            fi
            # If valid and port is free, display virtual host and port info
            printf "\nVirtual Host Name: $VHOST_NAME\n"
            printf "Virtual Host Port: $PORT_NUMBER\n"
            printf "\n${BOLD}Please confirm${RESET} ${YELLOW}\n(Yes to confirm, No to retry, Cancel to exit)${RESET}:\n" && read USER_CONFIRMATION
            case "$USER_CONFIRMATION" in
                y |  yes | Yes | YES)
                    # Confirmed
                    break
                ;;
                n | no | No | NO)
                    # If user chooses No, re-ask for the port and confirmation
                    printf "\nYou chose No. Let's try again.\n"
                    continue
                ;;
                cancel | Cancel | CANCEL | Exit | exit)
                    # Cancel
                    printf "Virtual Host creation canceled, exiting script.\n\n"
                    exit 0
                ;;
                *)
                    # Invalid input
                    printf "\n${RED}${BOLD}Invalid input.${RESET}  Please enter Yes, No, or Cancel.\n"
                    continue
                ;;
            esac
        done
    # Param
    VHOST_ROOT="/var/www/$VHOST_NAME/html"
    NGINX_CONF="/etc/nginx/sites-available/$VHOST_NAME"
    NGINX_ENABLED="/etc/nginx/sites-enabled/$VHOST_NAME"

    # Create the vhost root directory
    mkdir -p "$VHOST_ROOT"

    tee "$NGINX_CONF" > /dev/null <<EOL
server {
    listen $PORT_NUMBER;
    server_name $VHOST_NAME www.$VHOST_NAME;

    root $VHOST_ROOT;
    index index.html index.htm index.php;

    location / {
        try_files $uri $uri/ =404;
    }

    access_log /var/log/nginx/${VHOST_NAME}_access.log;
    error_log /var/log/nginx/${VHOST_NAME}_error.log;
}
EOL

    else
        printf "Name ${RED}$VHOST_NAME${RESET} is already in use.\n"
    fi
fi