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

#########  <Logs function START>  ##########
function logit() {
### Description: Logs messages to a file with levels (INFO, DEBUG, ERROR)
### Usage: logit <LEVEL> "Your message here"

if [[ "$1" == "help" ]]; then
    # Colors
    local RESET="\033[0m"
    local BOLD="\033[1m"
    local CYAN="\033[36m"
    local GREEN="\033[32m"
    local YELLOW="\033[33m"
    
    # Help text with colors
    printf "${BOLD}${CYAN}Usage:${RESET}\n"
    printf "  logit start                ${GREEN}# Start logging all executed commands${RESET}\n"
    printf "  logit <LEVEL> <MESSAGE>    ${GREEN}# Log a message with level INFO, DEBUG, WARN, ERROR${RESET}\n"
    printf "\n"
    printf "  ${YELLOW}Example:${RESET}\n"
    printf "  logit INFO \"Application started\"\n"
    printf "  logit ERROR \"Something went wrong\"\n"
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
}
##########   <Logs function END>   ##########

#------------------------------------------------------------------#

##########  <Press 2 Continue function START>  ##########
function continue_press() {
### Description: Pauses execution and waits for user input to continue.
### Usage: add continue_press where you wish pauses execution and waits for user input to continue.
    read -n 1 -s -r -p $'\n\e[1;34m > Press any key to continue... <\e[0m\n\n'
    clear
}
##########   <Press 2 Continue function END>   ##########
#------------------------------------------------------------------#

##########  <Task print START>  ##########
function taskprint() {
### Description: Prints a formatted task message.
### Usage: taskprint "<task details here>".
    printf "\n\e[1mTASK\e[0m \e[31m%s\e[0m\n" "$*"
}
##########   <Task print START END>   ##########
#------------------------------------------------------------------#

##########  <vi alias START>  ##########

function ensure_vi_alias() {
### Description: Checks if vi is aliased to vim and sets it globally if missing.
### Usage: this will be moved to installation script later on.
    # Check if alias already exists
    if ! alias vi 2>/dev/null | grep -q 'vim'; then
        echo 'alias vi="vim"' | tee -a /etc/profile > /dev/null
    fi
}
##########   <vi alias END>   ##########