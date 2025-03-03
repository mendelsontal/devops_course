#!/usr/bin/env bash

################################################################################ /ᐠ｡ꞈ｡ᐟ\ ################################################################################
# Developed by: Tal Mendelson                                                                                                                                          #
# Purpose: LOGIT is a lightweight and configurable Bash logging utility that enables structured logging with levels (INFO, DEBUG, WARN, ERROR).                        #
#          It supports automatic command logging, customizable timestamps, log rotation, and silent mode,making it ideal for script debugging and system monitoring.   #
# Date:03/03/2025                                                                                                                                                      #
# Version: 0.0.2                                                                                                                                                       #
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
# Enable strict error handling
set -o errexit
set -o pipefail

### Description: Logs messages to a file with levels (INFO, DEBUG, ERROR)
### Version:
LOGIT_VERSION="0.0.2"

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
    printf "Installed logit version: ${BOLD}${GREEN}$LOGIT_VERSION.${RESET}\n"
    return
fi

# Uninstall
if [[ "$1" == "uninstall" ]]; then
    echo "TODO"
    return
fi

# Update
if [[ "$1" == "update" ]]; then
    echo "Update"
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