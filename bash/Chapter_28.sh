#!/usr/bin/env bash
#################### /ᐠ｡ꞈ｡ᐟ\ ######################
#Developed by: Tal Mendelson
#Purpose: Holds the solutions for chapter 28 Linux Fundamentals by Paul Cobbaut
#Date:26/02/2025
#Version: 0.0.1
set -o errexit     # 
set -o pipefail    # 
#################### /ᐠ｡ꞈ｡ᐟ\ ######################

# Array containing all the current chapter tasks
chapter_tasks=(
"1. Create a user account named serena, including a home directory and a description\n that reads Serena Williams. Do all this in one single command."
"2. Create a user named venus, including home directory, bash shell, a description that reads Venus Williams all in one single command."
"3. Verify that both users have correct entries in /etc/passwd, /etc/shadow and /etc/group."
"4. Verify that their home directory was created."
"5. Create a user named einstime with /bin/date as his default logon shell."
"6. Wubbalubbadubdub!!!\n Seems like this chapter skipped task 6 in the book"
"7. What happens when you log on with the einstime user ? Can you think of a useful real world example for changing a user's login shell to an application"
"8. Create a file named welcome.txt and make sure every new user will see this file in their home directory."
"9. Verify this setup by creating and deleting a test user account."
"10. Change the default login shell for the serena user to /bin/bash. Verify before and after you make this change."
)

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script requires root privileges."
    exec sudo "$0" "$@"  # Restart script with sudo
    exit 1
fi

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

# 1. Create a user account named serena, including a home directory and a description (orcomment) that reads Serena Williams. Do all this in one single command.
taskprint 0
printf "\nCreating a new user named \e[1;34mserena\e[0m\n"

# Temporarily disable errexit for this command to allow failure without terminating the script
set +o errexit

# User creation
useradd -m -c "Serena Williams" serena

# Re-enable errexit for the rest of the script
set -o errexit
continue_press

# 2. Create a user named venus, including home directory, bash shell, a description that reads Venus Williams all in one single command.
taskprint 1
printf "\nCreating a new user named \e[1;34mvenus\e[0m\n"

# Temporarily disable errexit for this command to allow failure without terminating the script
set +o errexit

# User creation
useradd -m -s /bin/bash -c "Venus Williams" venus

# Re-enable errexit for the rest of the script
set -o errexit
continue_press

# 3. Verify that both users have correct entries in /etc/passwd, /etc/shadow and /etc/group.
taskprint 2
printf "\nVerifying that both users have correct entries:\n"

## Checks for users and prints
# /etc/passwd check
if grep -E 'serena|venus' /etc/passwd > /dev/null; then
    printf "\n\e[1;34m/etc/passwd:\e[0m\n" ; grep -E 'serena|venus' /etc/passwd
else
    echo "Error: User(s) not found in /etc/passwd"
fi

# /etc/shadow check
if grep -E 'serena|venus' /etc/shadow > /dev/null; then
    printf "\n\e[1;34m/etc/shadow:\e[0m\n" ; grep -E 'serena|venus' /etc/shadow
else
    echo "Error: User(s) not found in /etc/shadow"
fi
# /etc/group
if grep -E 'serena|venus' /etc/group > /dev/null; then
    printf "\n\e[1;34m/etc/group:\e[0m\n" ; grep -E 'serena|venus' /etc/group
else
    echo "Error: User(s) not found in /etc/group"
fi

continue_press

# 4. Verify that their home directory was created.
taskprint 3
printf "\nVerifying that both users have home folders:\n"
if [[ -d /home/venus && -d /home/serena ]]; then
    ls -l /home | grep -E 'serena|venus'
else
    echo "Error: User(s) not found in /home"
fi

continue_press

# 5. Create a user named einstime with /bin/date as his default logon shell.
taskprint 4
printf "\nCreating a new user named \e[1;34meinstime\e[0m\n"

# Temporarily disable errexit for this command to allow failure without terminating the script
set +o errexit

# User creation
useradd -s /bin/date einstime

# Re-enable errexit for the rest of the script
set -o errexit

printf "\n\e[1;34m/etc/passwd:\e[0m\n" ; grep 'einstime*' /etc/passwd
continue_press

# 6. Seems to be missing :S
taskprint 5
continue_press

# 7. What happens when you log on with the einstime user ? Can you think of a useful real world example for changing a user's login shell to an application
taskprint 6
printf "\nWhen you log into the user \e[1;34meinstime\e[0m it will displays the current date and time.\n"
su einstime
printf "Can be used for Restricted User Accounts: Instead of providing a full shell, you can assign a script or program that runs upon login and immediately logs out after execution."
continue_press

# 8. Create a file named welcome.txt and make sure every new user will see this file in their home directory.
taskprint 7
printf "\nCreating welcome.txt in \e[1;34m/etc/skel/\e[0m so every user see this file in their home folder.\n"
echo Hello > /etc/skel/welcome.txt
continue_press

# 9. Verify this setup by creating and deleting a test user account.
taskprint 8
printf "\nCreating a new user named \e[1;34mtest\e[0m\n"

# Temporarily disable errexit for this command to allow failure without terminating the script
set +o errexit

# User creation 
useradd -m test

# Re-enable errexit for the rest of the script
set -o errexit

printf "\nChecking for file \e[1;34mwelcome.txt\e[0m in user test home directory...\n"
if [[ -f /home/test/welcome.txt ]]; then
    ls -l /home/test | grep welcome.txt
else
    echo "Error: File not found"
fi

# Removing test user
printf "\nRemoving user \e[1;34mtest\e[0m\n"
userdel -r test
continue_press

# 10. Change the default login shell for the serena user to /bin/bash. Verify before and after you make this change.
taskprint 9

# /etc/passwd check before
if grep 'serena' /etc/passwd > /dev/null; then
    printf "\n\e[1;34m/etc/passwd:\e[0m\n" ; grep 'serena' /etc/passwd
else
    echo "Error: User(s) not found in /etc/passwd"
fi

# Changing default shell to /bin/bash
usermod -s /bin/bash serena

# /etc/passwd check after
if grep -E 'serena|venus' /etc/passwd > /dev/null; then
    printf "\n\e[1;34m/etc/passwd:\e[0m\n" ; grep 'serena' /etc/passwd
else
    echo "Error: User(s) not found in /etc/passwd"
fi

# End of the script
printf "\n\e[1;34m########################################\e[0m\n"
printf "\e[1;32mEnd of Chapter 28 Tasks Script\e[0m\n"
printf "\e[1;34m########################################\e[0m\n"
printf "\n\e[1;33mYou pass butter\e[0m\n"
printf "\n\e[1;34m########################################\e[0m\n"

# Exit
exit 0