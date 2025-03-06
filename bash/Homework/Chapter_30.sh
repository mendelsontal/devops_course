#!/usr/bin/env bash
#################### /ᐠ｡ꞈ｡ᐟ\ ######################
#Developed by: Tal Mendelson
#Purpose: Holds the solutions for chapter 30 Linux Fundamentals by Paul Cobbaut
#Date:26/02/2025
#Version: 0.0.1
set -o errexit     # 
set -o pipefail    # 
#################### /ᐠ｡ꞈ｡ᐟ\ ######################

# Array containing all the current chapter tasks
chapter_tasks=(
'1. Make a list of all the profile files on your system.'
'2. Read the contents of each of these, often they source extra scripts.'
'3. Put a unique variable, alias and function in each of those files.'
'4. Try several different ways to obtain a shell (su, su -, ssh, tmux, gnome-terminal, Ctrlalt-F1, ...) and verify which of your custom variables, aliases and function are present inyour environment.'
'5. Do you also know the order in which they are executed?'
'6. When an application depends on a setting in $HOME/.profile, does it matter whether$HOME/.bash_profile exists or not ?'
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

# 1. Make a list of all the profile files on your system.
taskprint 0
ls -a ~ ; ls -l /etc/profile* /etc/bash*
continue_press

# 2. Read the contents of each of these, often they source extra scripts.
taskprint 1
cat ~/.bash_profile
cat ~/.profile
cat ~/.bashrc
cat /etc/profile

continue_press
# 3. Put a unique variable, alias and function in each of those files.
taskprint 2

continue_press

# 4. Try several different ways to obtain a shell (su, su -, ssh, tmux, gnome-terminal, Ctrlalt-F1, ...) and verify which of your custom variables, aliases and function are present in your environment.

# 5. Do you also know the order in which they are executed?
taskprint 4
printf "/etc/profile → ~/.bash_profile (or ~/.profile) → ~/.bashrc\n"
printf "/etc/profile runs for all users; ~/.bash_profile is user-specific and runs once at login, then ~/.bashrc runs for every new interactive shell.\n"
continue_press

# 6. When an application depends on a setting in $HOME/.profile, does it matter whether $HOME/.bash_profile exists or not ?
taskprint 5
printf "Yes it matters,\n  If ~/.bash_profile exists, then Bash will ignore ~/.profile when starting a login shell.\n"
printf "If ~/.bash_profile does not exist, then Bash will read ~/.profile.\n"
continue_press

# End of the script
printf "\n\e[1;34m########################################\e[0m\n"
printf "\e[1;32mEnd of Chapter 30 Tasks Script\e[0m\n"
printf "\e[1;34m########################################\e[0m\n"
printf "\n\e[1;33mI am the Emperor, and I speak the truth. Let none dare oppose me.\e[0m\n"
printf "\n\e[1;34m########################################\e[0m\n"

# Exit
exit 0