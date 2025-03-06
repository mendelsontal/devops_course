#!/usr/bin/env bash
#################### /ᐠ｡ꞈ｡ᐟ\ ######################
#Developed by: Tal Mendelson
#Purpose: Holds the solutions for chapter 31 Linux Fundamentals by Paul Cobbaut
#Date:26/02/2025
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

# Array containing all the current chapter tasks
chapter_tasks=(
    "1. Create the groups tennis, football and sports."
    "2. In one command, make venus a member of tennis and sports."
    "3. Rename the football group to foot."
    "4. Use vi to add serena to the tennis group."
    "5. Use the id command to verify that serena is a member of tennis."
    '6. Make someone responsible for managing group membership of foot and sports. Test that it works.'
)

# Press to continue function
function continue_press() {
    read -n 1 -s -r -p $'\n\e[1;34m > Press any key to continue... <\e[0m\n\n'
    clear
}

# Task print function
function taskprint() {
     printf "\n\e[1mTASK \e[0m \e[31m${chapter_tasks[$1]}\e[0m\n"
}

### Solutions:
clear
printf "\n_/ᐠ｡ꞈ｡ᐟ\_\n"

# 1. Create the groups tennis, football and sports.
taskprint 0
# Create groups
groupadd tennis ; groupadd football ; groupadd sports
continue_press

# 2. In one command, make venus a member of tennis and sports.
taskprint 1
# Adds venus to tennis and sports
usermod -a -G tennis,sports venus
continue_press

# 3. Rename the football group to foot.
taskprint 2
# Change group name
groupmod -n foot football
continue_press

# 4. Use vi to add serena to the tennis group.
taskprint 3
printf "I used vi /etc/group"
continue_press

# 5. Use the id command to verify that serena is a member of tennis.
taskprint 4
if [[ $(id -G -n serena | grep -wc tennis) -eq 0 ]]; then
    echo "serena is NOT in the tennis group."
else
    echo "serena is in the tennis group."
fi

continue_press

# 6. Make someone responsible for managing group membership of foot and sports. Test that it works.
taskprint 5
# Assign venus as the admin of football and sports groups
gpasswd -A venus football
gpasswd -A venus sports

# Run group management commands as venus
sudo -u venus bash <<EOF
gpasswd -a serena football
EOF

groups serena

# End of the script
printf "\n\e[1;34m########################################\e[0m\n"
printf "\e[1;32mEnd of Chapter 31 Tasks Script\e[0m\n"
printf "\e[1;34m########################################\e[0m\n"
printf "\n\e[1;33mIt is 3am... im slowly dying making this.\e[0m\n"
printf "\n\e[1;34m########################################\e[0m\n"

# Exit
exit 0