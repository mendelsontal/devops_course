#!/usr/bin/env bash
#################### /ᐠ｡ꞈ｡ᐟ\ ######################
#Developed by: Tal Mendelson
#Purpose: Holds the solutions for chapter 27 Linux Fundamentals by Paul Cobbaut
#Date:26/02/2025
#Version: 0.0.1
set -o errexit     # 
set -o pipefail    # 
#################### /ᐠ｡ꞈ｡ᐟ\ ######################

# Array containing all the current chapter tasks
chapter27_tasks=(
    "1. Run a command that displays only your currently logged on user name."
    "2. Display a list of all logged on users."
    "3. Display a list of all logged on users including the command they are running at this very moment."
    "4. Display your user name and your unique user identification (userid)."
    '5. Use su to switch to another user account (unless you are root,\n you will need the password of the other account). And get back to the previous account.'
    "6. Now use su - to switch to another user and notice the difference.\n Note that su - gets you into the home directory of Tania."
    '7. Try to create a new user account (when using your normal user account).\n this should fail. (Details on adding user accounts are explained in the next chapter.)'
    "8. Now try the same, but with sudo before your command."
)

# Press to continue function
function continue_press() {
    read -n 1 -s -r -p $'\n\e[1;34m > Press any key to continue... <\e[0m\n\n'
    clear
}

# Task print function
function taskprint() {
     printf "\n\e[1mTASK \e[0m \e[31m${chapter27_tasks[$1]}\e[0m\n"
}

### Solutions:
clear
printf "\n_/ᐠ｡ꞈ｡ᐟ\_\n"

# 1. Run a command that displays only your currently logged on user name.
taskprint 0
printf "\nYou are logged in as: \e[32m%s\e[0m\n" "$(whoami)"
continue_press

# 2. Display a list of all logged on users.
taskprint 1
printf "\nAll logged on users: \n\e[1;32m%s\e[0m\n" "$(who)"
continue_press

# 3. Display a list of all logged on users including the command they are running at this very moment.
taskprint 2
printf "\nList of all logged on users and the command they are running atm: \n\e[1;32m%s\e[0m\n" "$(w)"
continue_press

# 4. Display your user name and your unique user identification (userid).
taskprint 3
printf "\nYour user name and unique id: \e[1;32m%s\e[0m \e[1;32m%s\e[0m\n" "$(whoami)" "$(id -u)"
continue_press

# 5. Use su to switch to another user account (unless you are root, you will need the password of the other account). And get back to the previous account.
taskprint 4
printf "\nPlease enter a username to switch to: "
read user2su

# Check if the user exists in the system
while ! id "$user2su" &>/dev/null; do
    printf "\n\e[31mUser '$user2su' does not exist. Please enter a valid username.\e[0m\n"
    printf "\nPlease enter a username to switch to: "
    read user2su
done

printf "Switching user to $user2su...\n"
# Used su - here as well instead of just su to keep the script running
su - $user2su -c "echo 'This is the other user! Running whoami to prove it:'; whoami"
continue_press

# 6. Now use su - to switch to another user and notice the difference. Note that su - gets you into the home directory of Tania.
taskprint 5
su - $user2su -c "echo 'This is the other user home directiry :'; echo $HOME"
continue_press

# 7. Try to create a new user account (when using your normal user account). this should fail. (Details on adding user accounts are explained in the next chapter.)
taskprint 6
printf "\nPlease enter a username to add: "
read user2add

# Temporarily disable errexit for this command to allow failure without terminating the script
set +o errexit

# User creation
useradd $user2add

# Re-enable errexit for the rest of the script
set -o errexit
continue_press

# 8. Now try the same, but with sudo before your command.
taskprint 7
printf "\nWould you like to attempt adding the user '$user2add' using sudo? (y/n): "
read -r choice

# Check the user's response
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    printf "\nAttempting to add user using sudo... "
    # User creation
    sudo useradd "$user2add"
    if [[ $? -eq 0 ]]; then
        printf "\nUser '$user2add' added successfully.\n"
    else
        printf "\nFailed to add user '$user2add'. You may need root privileges.\n"
    fi
else
    printf "\nUser addition skipped.\n"
fi

# End of the script
printf "\n\e[1;34m########################################\e[0m\n"
printf "\e[1;32mEnd of Chapter 27 Tasks Script\e[0m\n"
printf "\e[1;34m########################################\e[0m\n"
printf "\n\e[1;33mPickle Rick!!!!\e[0m\n"
printf "\n\e[1;34m########################################\e[0m\n"

# Exit
exit 0