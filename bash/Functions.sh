#!/usr/bin/env bash
#################### /ᐠ｡ꞈ｡ᐟ\ ######################
# Developed by: Tal Mendelson
# Purpose: Holds useful functions for various uses to be called.
# Date:28/02/2025
# Version: 0.0.1
set -o errexit     # 
set -o pipefail    # 
#################### /ᐠ｡ꞈ｡ᐟ\ ######################

##########  <Available functions function START>  ##########
list_functions() {
    echo -e "\nAvailable Functions:\n"

    # List all functions in the current script, excluding list_functions
    function_names=$(declare -F | awk '{print $3}' | grep -v '^list_functions$')

    # Loop over all the function names found
    while read -r func; do
        # Ensure the function name is non-empty before proceeding
        if [[ -z "$func" ]]; then
            continue  # Skip if no function name is found
        fi

        # Now, search for the description and usage corresponding to the function
        name="$func"
        
        # Extract the description using awk (looking for '### Description:')
        desc=$(awk "/function $func/,/### Description:/ {if (/### Description:/) print substr(\$0, index(\$0, \"### Description:\") + 16)}" "${BASH_SOURCE[0]}")
        
        # Extract the usage using awk (looking for '### Usage:')
        usage=$(awk "/function $func/,/### Usage:/ {if (/### Usage:/) print substr(\$0, index(\$0, \"### Usage:\") + 14)}" "${BASH_SOURCE[0]}")

        # If description or usage is not found, set them as "Not available"
        [[ -z "$desc" ]] && desc="No description available"
        [[ -z "$usage" ]] && usage="No usage available"
        
        # Print the function with its description and usage in the requested format
        echo -e "- Name: $name"
        echo -e "  Description: $desc"
        echo -e "  Usage: $usage\n"
    done <<< "$function_names"
}

##########   <Available functions function END>   ##########
#------------------------------------------------------------------#

##########  <Run as root function START>  ##########
function runasadmin (){
### Description: Check if the script is run as root; reopens if it isn't.
### Usage: - - Add runasadmin at the start of your script to activate.
if [[ $EUID -ne 0 ]]; then
    echo "This script requires root privileges."
    exec sudo "$0" "$@"  # Restart script with sudo
    exit 1
fi
}
##########   <Run as root function END>   ##########
#------------------------------------------------------------------#

##########  <Logs function START>  ##########
function logit() {
### Description: Logs messages to a file with levels (INFO, DEBUG, ERROR)
### Usage:

if [[ "$1" == "help" ]]; then
        # Colors
        local RESET="\033[0m"
        local BOLD="\033[1m"
        local CYAN="\033[36m"
        local GREEN="\033[32m"
        local YELLOW="\033[33m"
        local RED="\033[31m"

        # Print help message with color
        printf "${BOLD}${CYAN}The logit function logs messages to a log file with customizable log levels (INFO, DEBUG, WARN, ERROR). By default, logs are saved in /var/log with a file name based on the script name. Both the log folder and file name can be overridden.${RESET}\n\n"
        printf "${BOLD}${CYAN}Usage:${RESET}\n\n"
        printf "${GREEN}To start logging:${RESET}\n"
        printf "    logit start\n\n"
        printf "${GREEN}To log a message:${RESET}\n"
        printf "    logit <LEVEL> \"<MESSAGE>\"\n"
        printf "    Replace <LEVEL> with one of: INFO, DEBUG, WARN, ERROR.\n"
        printf "    Replace <MESSAGE> with the text you want to log.\n\n"
        printf "${GREEN}To override the log directory and file name by calling the function before:${RESET}\n"
        printf "    You can set the environment variables LOGDIR for the directory\n"
        printf "    You can set the environment variables LOGFILE for the file name\n"
        printf "    ${YELLOW}Examples:${RESET}\n\n"
        printf '    export LOGDIR="/home/tal/"\n'
        printf '    export LOGFILE="/home/tal/blabla.txt"\n\n'
        
        return
    fi

# Default log directory (can be overridden)
    LOGDIR="${LOGDIR:-/var/log}"

    # Determine script name of the caller
    CALLER_SCRIPT="$(basename "${BASH_SOURCE[1]}" .sh)"

    # Default log file: Uses $LOGFILE if set, otherwise based on caller script
    LOGFILE="${LOGFILE:-$LOGDIR/$CALLER_SCRIPT.log}"

    # Ensure log directory exists
    [ ! -d "$LOGDIR" ] && mkdir -p "$LOGDIR"

    # Ensure the log file exists
    touch "$LOGFILE" || { echo "ERROR: Cannot write to $LOGFILE" >&2; return 1; }

    # Initialize script logging
    if [[ "$1" == "start" ]]; then
        logit INFO "Script execution started"
        # Function to log each command executed
        log_command() {
            logit DEBUG "Running command: $BASH_COMMAND"
        }
        # Trap every command execution and log it
        trap 'log_command' DEBUG
    fi

    # Validate input parameters
    if [[ "$1" == "start" ]]; then
        return
    fi

    # Validate log level and message
    local level="$1"
    local message="$2"

    # List of valid log levels
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
    timestamp=$(date '+%Y-%m-%d %H:%M:%S.%3N')

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
}
##########   <Logs function END>   ##########
#------------------------------------------------------------------#

##########  <Press 2 Continue function START>  ##########
function continue_press() {
### Description: Pauses execution and waits for user input to continue.
### Usage: 
    read -n 1 -s -r -p $'\n\e[1;34m > Press any key to continue... <\e[0m\n\n'
    clear
}
##########   <Press 2 Continue function END>   ##########
#------------------------------------------------------------------#

##########  <Task print START>  ##########
function taskprint() {
### Description: Prints a formatted task message.
### Usage: 
    printf "\n\e[1mTASK\e[0m \e[31m%s\e[0m\n" "$*"
}
##########   <Task print START END>   ##########
#------------------------------------------------------------------#

##########  <vi alias START>  ##########

function ensure_vi_alias() {
### Description: Checks if vi is aliased to vim and sets it globally if missing
### Usage: 
    # Check if alias already exists
    if ! alias vi 2>/dev/null | grep -q 'vim'; then
        echo 'alias vi="vim"' | tee -a /etc/profile > /dev/null
    fi
}
##########   <vi alias END>   ##########