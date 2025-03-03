#!/usr/bin/env bash

################################################################################ /ᐠ｡ꞈ｡ᐟ\ ################################################################################
# Developed by: Tal Mendelson                                                                                                                                          #
# Purpose: LOGIT is a lightweight and configurable Bash logging utility that enables structured logging with levels (INFO, DEBUG, WARN, ERROR).                        #
#          It supports automatic command logging, customizable timestamps, log rotation, and silent mode,making it ideal for script debugging and system monitoring.   #
# Date:03/03/2025                                                                                                                                                      #
# Version: 0.0.3                                                                                                                                                       #
################################################################################ /ᐠ｡ꞈ｡ᐟ\ ################################################################################

# Check if shell is interactive
if [[ $- == *i* ]]; then
    ##############################
    # Add Autocompletion for logit #
    ##############################
    _logit_completions() {
        local cur="${COMP_WORDS[COMP_CWORD]}"
        local options="help version update uninstall"

        # If the typed input isn't a valid option, prevent completion
        if [[ "$cur" != [A-Za-z]* ]]; then
            COMPREPLY=()  # Prevent completion for invalid input
            return 0
        fi

        COMPREPLY=( $(compgen -W "$options" -- "$cur") )
        return 0
    }

    complete -F _logit_completions logit
fi

function logit() {
### Description: Logs messages to a file with levels (INFO, DEBUG, ERROR)
### Version:
LOGIT_VERSION="0.0.3"

# Bold text for usage message
local BOLD='\033[1m'
local RESET='\033[0m'

# Colors
local BOLD="\033[1m"
local CYAN="\033[36m"
local GREEN="\033[32m"
local YELLOW="\033[33m"
local RED="\033[31m"

# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    printf "\n${BOLD}Usage: $0 {help | version | update | uninstall}${RESET}\n"
    return
fi

# Help
if [[ "$1" == "help" ]]; then
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

# Version
if [[ "$1" == "version" ]]; then
    printf "Installed Logit version: ${BOLD}${GREEN}$LOGIT_VERSION${RESET}\n"
    return
fi

# Uninstall
if [[ "$1" == "uninstall" ]]; then
    echo "TODO"
    return
fi

# Update
if [[ "$1" == "update" ]]; then
    # URL where the latest version is stored
    VERSION_URL="https://raw.githubusercontent.com/mendelsontal/devops_course/refs/heads/main/bash/logit/logit.sh"
    # Fetch the latest version from the URL
    LATEST_VERSION=$(curl -s "$VERSION_URL" | grep -oP 'LOGIT_VERSION="\K[^"]+')

    if [ -z "$LATEST_VERSION" ]; then
    printf "\n${BOLD}${RED}ERROR - Could not determine latest version from:${RESET}\n${VERSION_URL}\n\n"
    return 1
    fi

    # Local check
    LOCAL_FILE="~/bin/logit.sh"

    if [ -f "$LOCAL_FILE" ]; then
        local_version=$(sed -n 's/^LOGIT_VERSION="\([0-9.]*\)"$/\1/p' "$LOCAL_FILE")
        printf "LOGIT - Local - Version: $local_version\n"
        if [ "$(echo -e "$local_version\n$LATEST_VERSION" | sort -V | head -n 1)" = "$local_version" ] && [ "$local_version" != "$LATEST_VERSION" ]; then
            local_update_available='true'
        else 
            local_update_available='false'
        fi
    else
        local_installed='false'
    fi

    # Global check
    GLOBAL_FILE="/usr/local/bin/logit.sh"

    if [ -f "$GLOBAL_FILE" ]; then
        global_version=$(sed -n 's/^LOGIT_VERSION="\([0-9.]*\)"$/\1/p' "$GLOBAL_FILE")
        printf "Logit - Global - Version: $global_version\n"
        if [ "$(echo -e "$global_version\n$LATEST_VERSION" | sort -V | head -n 1)" = "$global_version" ] && [ "$global_version" != "$LATEST_VERSION" ]; then
            global_update_available='true'
        else 
            global_update_available='false'
        fi
    else
        global_installed='false'
    fi

    # Both have an update available.
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
    elif [ -n "$local_version" ] && [ "$local_update_available" = "true" ]; then
        printf "\n${BOLD}Local Logit update available.${RESET}\n"
        printf "Current version: $local_version\n"
        printf "Latest version: $LATEST_VERSION\n\n"

        # Choices - Local
        printf "1) Update Local (Current user only). \n"
        printf "2) Cancel. \n\n"

        # User local choice input
        read -p "$(echo -e "${BOLD}Please enter your choice ${BLUE}[1/2]${RESET}: ")" local_choice

        case $local_choice in
            1)
                # Update
                curl -s "$VERSION_URL" -o "$LOCAL_FILE"
                local_version=$(sed -n 's/^LOGIT_VERSION="\([0-9.]*\)"$/\1/p' "$LOCAL_FILE")

                if [ "$(echo -e "$local_version\n$LATEST_VERSION" | sort -V | head -n 1)" = "$local_version" ] && [ "$local_version" != "$LATEST_VERSION" ]; then
                    printf "\n${BOLD}${RED}ERROR${RESET} - Failed to update Logit - Local to version: $LATEST_VERSION\n"
                else 
                    printf "\n${BOLD}${GREEN}Success${RESET} - Logit Local has been successfully updated to version: $LATEST_VERSION\n\n"
                    source "$GLOBAL_FILE"
                    return
                fi
            ;;
            2)
                # Cancel
                printf "Updating Canceled, exiting.\n\n"
                return 0
            ;;
            *)
                # Catch invalid option
                printf "\n${RED}${BOLD}Invalid option.${RESET}\n"
                return 1
                ;;
        esac

    # Global update found.
    elif [ -n "$global_version" ] && [ "$global_update_available" = "true" ]; then
        printf "\n${BOLD}Global Logit updates available.${RESET}\n"
        printf "Current version: $global_version\n"
        printf "Latest version: $LATEST_VERSION\n\n"

    # Choices - Global
        printf "1) Update Logit Global. \n"
        printf "2) Cancel. \n\n"

        # User global choice input
        read -p "$(echo -e "${BOLD}Please enter your choice ${BLUE}[1/2]${RESET}: ")" global_choice

        case $global_choice in
            1)
                # Update
                sudo curl -s "$VERSION_URL" -o "$GLOBAL_FILE"
                global_version=$(sed -n 's/^LOGIT_VERSION="\([0-9.]*\)"$/\1/p' "$GLOBAL_FILE")

                if [ "$(echo -e "$global_version\n$LATEST_VERSION" | sort -V | head -n 1)" = "$global_version" ] && [ "$global_version" != "$LATEST_VERSION" ]; then
                    printf "\n${BOLD}${RED}ERROR${RESET} - Failed to update Logit - Global to version: $LATEST_VERSION\n"
                else 
                    printf "\n${BOLD}${GREEN}Success${RESET} - Logit Global has been successfully updated to version: $LATEST_VERSION\n\n"
                    source "$GLOBAL_FILE"
                    return
                fi
            ;;
            2)
                # Cancel
                printf "Updating Canceled, exiting.\n\n"
                return
            ;;
            *)
                # Catch invalid option
                printf "\n${RED}${BOLD}Invalid option.${RESET}\n\n"
                return
                ;;
        esac

    # No updates available
    else
        printf "${BOLD}${GREEN}No Logit updates available.${RESET}\n\n"
    fi

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
    echo -e "\n${BOLD}${RED}ERROR: Cannot write to log file $LOGFILE${RESET}.\n${GREEN}switching to home directory log...${RESET}\n" >&2

    # Define the 'logs' directory in the user's home folder
    LOG_DIR="$HOME/logs"

    # Check if the 'logs' directory exists, and create it if it doesn't
    if [ ! -d "$LOG_DIR" ]; then
        mkdir -p "$LOG_DIR" || { echo "ERROR: Failed to create directory $LOG_DIR" >&2; return 1; }
    fi

    # Set the log file path to the user's home directory logs folder
    LOGFILE="$LOG_DIR/$CALLER_SCRIPT.log"

    # Ensure the log file in home directory is writable
    if ! touch "$LOGFILE" 2>/dev/null; then
        echo "ERROR: Cannot write to log file in home directory ($LOGFILE)" >&2
        return 1
    fi
fi

# Log rotation: If log exceeds 10MB, archive it
MAX_LOG_SIZE=10485760  # 10MB
if [[ -f "$LOGFILE" && $(stat -c%s "$LOGFILE") -gt $MAX_LOG_SIZE ]]; then
mv "$LOGFILE" "$LOGFILE.$(date +%Y%m%d%H%M%S).bak"
touch "$LOGFILE"  # Ensure a fresh log file is created
fi

# Enable command logging if 'start' is given
if [[ "$1" == "start" ]]; then
    echo "Logging started: All commands will be logged."
    trap 'logit DEBUG "Running command: $BASH_COMMAND"' DEBUG
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

# Allow customizable timestamp format
LOGIT_DATE_FORMAT="${LOGIT_DATE_FORMAT:-"%Y-%m-%d %H:%M:%S.%3N"}"

local timestamp
timestamp=$(date +"$LOGIT_DATE_FORMAT")


# Format log entry
local log_entry="$timestamp [$level] - $message"

# Log to file
echo "$log_entry" >> "$LOGFILE"

# Control console output (silent mode)
    if [[ -z "$LOGIT_SILENT" ]]; then
        [[ "$level" == "ERROR" ]] && echo "$log_entry" >&2 || echo "$log_entry"
    fi

} #LOGITEND

# Remember kids, no good deed goes unpunished.