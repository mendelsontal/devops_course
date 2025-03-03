#!/usr/bin/env bash
#################### /ᐠ｡ꞈ｡ᐟ\ ######################
#Developed by: Tal Mendelson
#Purpose: Setup LOGIT function for global use.
#Date:02/03/2025
#Version: 0.0.1
set -o errexit     # 
set -o pipefail    # 
#################### /ᐠ｡ꞈ｡ᐟ\ ######################

## Logit Function - Usage Manual

# The logit function is a Bash utility for logging messages with different severity levels (INFO, DEBUG, WARN, ERROR) into a log file.
#It also supports automatic command logging when enabled.

# Parameters
LOGIT_VERSION='0.0.1'

# Text Formatting function
function TEXT_FORMAT(){
    # Basic Colors
    BLACK="\033[30m"
    RED="\033[31m"
    GREEN="\033[32m"
    YELLOW="\033[33m"
    BLUE="\033[34m"
    MAGENTA="\033[35m"
    CYAN="\033[36m"
    WHITE="\033[37m"

    # Bright Colors
    BRIGHT_BLACK="\033[90m"
    BRIGHT_RED="\033[91m"
    BRIGHT_GREEN="\033[92m"
    BRIGHT_YELLOW="\033[93m"
    BRIGHT_BLUE="\033[94m"
    BRIGHT_MAGENTA="\033[95m"
    BRIGHT_CYAN="\033[96m"
    BRIGHT_WHITE="\033[97m"

    # Background Colors
    BG_BLACK="\033[40m"
    BG_RED="\033[41m"
    BG_GREEN="\033[42m"
    BG_YELLOW="\033[43m"
    BG_BLUE="\033[44m"
    BG_MAGENTA="\033[45m"
    BG_CYAN="\033[46m"
    BG_WHITE="\033[47m"

    # Bright Background Colors
    BG_BRIGHT_BLACK="\033[100m"
    BG_BRIGHT_RED="\033[101m"
    BG_BRIGHT_GREEN="\033[102m"
    BG_BRIGHT_YELLOW="\033[103m"
    BG_BRIGHT_BLUE="\033[104m"
    BG_BRIGHT_MAGENTA="\033[105m"
    BG_BRIGHT_CYAN="\033[106m"
    BG_BRIGHT_WHITE="\033[107m"

    # Text Formatting
    UNDERLINE="\033[4m"
    INVERT="\033[7m"
    BOLD="\033[1m"
    RESET="\033[0m"
}

# Calling the Text formnat function for "menu" usage.
TEXT_FORMAT

# Check if at least one argument is provided.
if [ $# -lt 1 ] || [ $# -gt 1 ]; then
    printf "\n${BOLD}Usage: $0 {install | update | remove | version | help}${RESET}\n"
    exit 1
fi

# Get the first argument and convert it to lowercase
ACTION="$(echo "$1" | tr '[:upper:]' '[:lower:]')"

# Define the LOGIT function as a heredoc
LOGIT_FUNCTION=$(cat << 'EOF'

function LOGIT() {
### Version:
LOGIT_VERSION="0.0.1"

### Description: Logs messages to a file with levels (INFO, DEBUG, ERROR)

# Check if at least one argument is provided.
if [ $# -lt 1 ]; then
    printf "\n${BOLD}Usage: $0 {help | version | remove}${RESET}\n"
    return 1
else
    if [[ "$1" == "version" ]]; then
        if grep -q "function LOGIT()" /etc/bash.bashrc; then
            global_version=$(sed -n 's/^LOGIT_VERSION="\([0-9.]*\)"$/\1/p' /etc/bash.bashrc)
            printf "${GREEN}Installed${RESET} - LOGIT Global - Version: $global_version\n"
        fi
        if grep -q "function LOGIT()" ~/.bashrc; then
            local_version=$(sed -n 's/^LOGIT_VERSION="\([0-9.]*\)"$/\1/p' /etc/bash.bashrc)
            printf "${GREEN}Installed${RESET} - LOGIT Local - Version: $local_version\n"
        fi
        return
    fi

    if [[ "$1" == "remove" ]]; then
        # Checks for Global LOGIT and removes
        if grep -q "function LOGIT()" /etc/bash.bashrc; then
            sed -i "/function LOGIT/,/#LOGITEND:/d" /etc/bash.bashrc
        fi

        # Checks for Local LOGIT and removes
        if grep -q "function LOGIT()" ~/.bashrc; then
            sed -i "/function LOGIT/,/#LOGITEND:/d" ~/.bashrc
        fi

        # Checks if removal succeeded
        if grep -q "function LOGIT()" ~/.bashrc || grep -q "function LOGIT()" /etc/bash.bashrc; then
            printf "${BOLD}${BRIGHT_RED}Failed to remove, exiting.${RESET}\n"
        else
            printf "${BOLD}${BRIGHT_GREEN}Uninstalled successfully, exiting.${RESET}\n"
        fi
        return
    fi
fi

if [[ "$1" == "help" ]]; then
    # Colors
    local RESET="\033[0m"
    local BOLD="\033[1m"
    local CYAN="\033[36m"
    local GREEN="\033[32m"
    local YELLOW="\033[33m"
    
    # Help text with colors
    printf "${BOLD}${CYAN}Usage:${RESET}\n"
    printf "  LOGIT start                ${GREEN}# Start logging all executed commands${RESET}\n"
    printf "  LOGIT <LEVEL> <MESSAGE>    ${GREEN}# Log a message with level INFO, DEBUG, WARN, ERROR${RESET}\n"
    printf "\n"
    printf "  ${YELLOW}Example:${RESET}\n"
    printf "  LOGIT INFO \"Application started\"\n"
    printf "  LOGIT ERROR \"Something went wrong\"\n"
    printf "\n"
    printf "  ${GREEN}To override the log location, set:${RESET}\n"
    printf "  export LOGDIR=/path/to/logs\n"
    printf "  export LOGFILE=/path/to/logfile.log\n"
    printf "\n"
    return
fi

# Default log directory (can be overridden)
LOGDIR="${LOGDIR:-/var/log}"

# Determine script name of the caller
CALLER_SCRIPT="$(basename "${BASH_SOURCE[1]}" .sh)"

# Default log file: Uses $LOGFILE if set, otherwise based on caller script
LOGFILE="${LOGFILE:-$LOGDIR/$CALLER_SCRIPT.log}"

# Ensure log directory exists
if [ ! -d "$LOGDIR" ]; then
    mkdir -p "$LOGDIR" || { echo "ERROR: Failed to create log directory $LOGDIR" >&2; return 1; }
fi

# Ensure log file is writable
if ! touch "$LOGFILE" 2>/dev/null; then
    echo "ERROR: Cannot write to log file $LOGFILE" >&2
    return 1
fi

# Enable command logging if 'start' is given
if [[ "$1" == "start" ]]; then
    echo "Logging started: All commands will be logged."
    trap 'LOGIT DEBUG "Running command: $BASH_COMMAND"' DEBUG
    return
fi

# Validate log level
local level="$1"
local message="${@:2}"  # Capture all remaining arguments as message

case "$level" in
    INFO|DEBUG|WARN|ERROR) ;;
    *) echo "ERROR: Invalid log level '$level'" >&2; return 1 ;;
esac

# Prevent empty messages
if [[ -z "$message" ]]; then
    echo "ERROR: Log message cannot be empty" >&2
    return 1
fi

# Get timestamp with milliseconds
local timestamp
timestamp=$(date '+%Y-%m-%d %H:%M:%S')$(printf ".%03d" $(( $(date +%N) / 1000000 )))

# Format log entry
local log_entry="$timestamp [$level] - $message"

# Log to file
echo "$log_entry" >> "$LOGFILE"

# If ERROR, send output to stderr
if [[ "$level" == "ERROR" ]]; then
    echo "$log_entry" >&2
else
    echo "$log_entry"
fi
} #LOGITEND

EOF
)

### Install
function install(){
    printf "\n${BOLD}Installing LOGIT Version ${LOGIT_VERSION}${RESET}\n"
    printf "\n${BOLD}${CYAN}Please select a 'LOGIT' installation option: ${RESET}\n" # Asks for user input
    # Choices
    printf "1) Global (All users). \n"
    printf "2) Local (Current user only). \n"
    printf "3) Cancel. \n\n"

    # User choice input
    read -p "$(echo -e "${BOLD}Please enter your choice ${BLUE}[1/2/3]${RESET}: ")" choice

    case $choice in
        1) # Global Installations
            if grep -q "function LOGIT()" /etc/bash.bashrc; then
                printf "LOGIT is already globally installed.\n\n"
            else 
                printf "Installing LOGIT globally...\n"
                echo "$LOGIT_FUNCTION" | sudo tee -a /etc/bash.bashrc > /dev/null
                if grep -q "function LOGIT()" /etc/bash.bashrc; then
                    printf "${BOLD}${GREEN}LOGIT Global function added successfully.${RESET}\n"
                    source /etc/bash.bashrc
                else
                    printf "${BOLD}${BRIGHT_RED}Failed to add function LOGIT.${RESET}\n" >&2
                fi
            fi
            ;;
        2) # Local Installation
            if grep -q "function LOGIT()" ~/.bashrc; then
                printf "LOGIT is already installed locally.\n"
            else
                printf "Installing LOGIT locally...\n"
                echo "$LOGIT_FUNCTION" >> ~/.bashrc
                if grep -q "function LOGIT()" ~/.bashrc; then
                    printf "${BOLD}${GREEN}LOGIT Local function added successfully.${RESET}\n"
                else
                    printf "${BOLD}${BRIGHT_RED}Failed to add function LOGIT.${RESET}\n" >&2
                fi
            fi
            ;;
        3)  # Cancel
            printf "${BOLD}${BRIGHT_RED}Installation canceled, exiting.${RESET}\n"
            exit 0
            ;;
        *) # Invalid input
            printf "${BOLD}${BRIGHT_RED}Invalid option. Exiting.${RESET}\n"
            exit 1
            ;;
    esac
}

# Remove
function remove(){
    # Checks for Global LOGIT and removes
    if grep -q "function LOGIT()" /etc/bash.bashrc; then
        sudo sed -i.bak  '/function LOGIT() {/,/} #LOGITEND/d' /etc/bash.bashrc
    fi

    # Checks for Local LOGIT and removes
    if grep -q "function LOGIT()" ~/.bashrc; then
    sed -i.bak  '/function LOGIT() {/,/} #LOGITEND/d' ~/.bashrc
    fi

    # Checks if removal succeeded
    if grep -q "function LOGIT()" ~/.bashrc || grep -q "function LOGIT()" /etc/bash.bashrc; then
        printf "${BOLD}${BRIGHT_RED}Failed to remove, exiting.${RESET}\n"
        exit 1
    else
        printf "${BOLD}${BRIGHT_GREEN}Uninstalled successfully, exiting.${RESET}\n"
        exit 0
    fi
}

# Update
function update() {
    # Checks if "LOGIT" is installed.
    printf "\n${BOLD}Checking for LOGIT installation on the system.${RESET}\n\n"

    # Local check
    if grep -q "function LOGIT()"  ~/.bashrc; then
        local_version=$(sed -n 's/^LOGIT_VERSION="\([0-9.]*\)"$/\1/p' ~/.bashrc )
        printf "${GREEN}Installed${RESET} - LOGIT Local - Version: $local_version\n"
        #if [ "$(echo -e "$local_version\n$LOGIT_VERSION" | sort -V | head -n 1)" = "$local_version" ]; then
        if [ "$(echo -e "$local_version\n$LOGIT_VERSION" | sort -V | head -n 1)" = "$local_version" ] && [ "$local_version" != "$LOGIT_VERSION" ]; then
            local_update_avilabile='true'
        else 
            local_update_avilabile='false'
        fi
    else 
        local_installed='false'
    fi
    
    # Global check
    if grep -q "function LOGIT()" /etc/bash.bashrc; then
        global_version=$(sed -n 's/^LOGIT_VERSION="\([0-9.]*\)"$/\1/p' /etc/bash.bashrc)
        printf "${GREEN}Installed${RESET} - LOGIT Global - Version: $global_version\n"
        #if [ "$(echo -e "$global_version\n$LOGIT_VERSION" | sort -V | head -n 1)" = "$global_version" ]; then
        if [ "$(echo -e "$global_version\n$LOGIT_VERSION" | sort -V | head -n 1)" = "$global_version" ] && [ "$global_version" != "$LOGIT_VERSION" ]; then

            global_update_avilabile='true'
        else 
            global_update_avilabile='false'
        fi
    else
        global_installed='false'
    fi

    # Detecting both versions, and both have an update available.
    if [ "$global_installed" = "false" ] && [ "$local_installed" = "false" ]; then
        printf "LOGIT is not installed on your machine.\n\n"
        exit 1
    fi

    if [ -n "$local_version" ] && [ -n "$global_version" ] && [ "$local_version" = "true" ] && [ "$global_version" = "true" ]; then
        printf "Detected Local Version: $local_version\nGlobal Version: $global_version\n"

        # Choices
        printf "1) Update Global (All users). \n"
        printf "2) Update Local (Current user only). \n"
        printf "3) Update both (Global and current user). \n"
        printf "4) Cancel. \n\n"

    # User choice input
    read -p "$(echo -e "${BOLD}Please enter your choice ${BLUE}[1/2/3/4]${RESET}: ")" choice

    # Local update found.
    elif [ -n "$local_version" ] && [ "$local_update_avilabile" = "true" ]; then
        printf "\n${BOLD}Global LOGIT updates available.${RESET}\n"
        printf "Your version: $local_version\n"
        printf "Latest version: $LOGIT_VERSION\n\n"

        # Choices - Local
        printf "1) Update Local (Current user only). \n"
        printf "2) Cancel. \n\n"

        # User local choice input
        read -p "$(echo -e "${BOLD}Please enter your choice ${BLUE}[1/2]${RESET}: ")" local_choice

        case $local_choice in
            1)
                # Delete
                ## delete to do

                # Install
                echo "$LOGIT_FUNCTION" >> ~/.bashrc
            ;;
            2)
                # Cancel
                printf "${BOLD}${BRIGHT_RED}Updating Canceled, exiting.${RESET}\n"
                exit 0
            ;;
            *)
                # Catch invalid option
                printf "\n${RED}${BOLD}Invalid option.${RESET}\n"
                exit 1
                ;;
        esac

    # Global update found.
    elif [ -n "$global_version" ] && [ "$global_update_avilabile" = "true" ]; then
        printf "\n${BOLD}Global LOGIT updates available.${RESET}\n"
        printf "Your version: $global_version\n"
        printf "Latest version: $LOGIT_VERSION\n\n"

    # Choices - Global
        printf "1) Update Global LOGIT. \n"
        printf "2) Cancel. \n\n"

        # User global choice input
        read -p "$(echo -e "${BOLD}Please enter your choice ${BLUE}[1/2]${RESET}: ")" global_choice

        case $global_choice in
            1)
                # Delete
                sudo sed -i.bak  '/function LOGIT() {/,/} #LOGITEND/d' /etc/bash.bashrc

                # Install
                echo "$LOGIT_FUNCTION" | sudo tee -a /etc/bash.bashrc > /dev/null
            ;;
            2)
                # Cancel
                printf "${BOLD}${BRIGHT_RED}Updating Canceled, exiting.${RESET}\n"
                exit 0
            ;;
            *)
                # Catch invalid option
                printf "\n${RED}${BOLD}Invalid option.${RESET}\n"
                exit 1
                ;;
        esac

    # No updates available
    else
        printf "${BOLD}${GREEN}No LOGIT updates available.${RESET}\n\n"
    fi

}

# Version
function version(){
    printf "LOGIT Installation Version:${BOLD}${BLUE}${LOGIT_VERSION}${RESET}\n"
}

# Help
function help(){
    echo "helllp!!!"
}

# Case statement to handle different options
case $ACTION in
    install)
        install
        ;;
    remove)
        remove
        ;;
    update)
        update
        ;;
    version)
        version
        ;;
    help)
        help
        ;;
    *)
        # Catch invalid option
        printf "\n${RED}${BOLD}Invalid option.${RESET}\n"
        printf "\n${BOLD}Usage: $0 {install | update | remove | version | help}${RESET}\n"
        exit 1
        ;;
esac