#!/usr/bin/env bash
#################### /ᐠ｡ꞈ｡ᐟ\ ######################
#Developed by: Tal Mendelson
#Purpose: Holds the solutions for chapter 33 Linux Fundamentals by Paul Cobbaut
#Date:26/02/2025
#Version: 0.0.1
set -o errexit     # 
set -o pipefail    # 
#################### /ᐠ｡ꞈ｡ᐟ\ ######################

# Array containing all the current chapter tasks
chapter_tasks=(
    "1a. Set up a directory, owned by the group sports."
    "1b. Members of the sports group should be able to create files in this directory."
    "1c. All files created in this directory should be group-owned by the sports group."
    "1d. Users should be able to delete only their own user-owned files."
    '1e. Test that this works'
    '2. Verify the permissions on /usr/bin/passwd. Remove the setuid, then try changing your password as a normal user. Reset the permissions back and try again.'
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

# 1a. Set up a directory, owned by the group sports.
taskprint 0
mkdir /tmp/sports_folder
chgrp sports /tmp/sports_folder
continue_press

# 1b. Members of the sports group should be able to create files in this directory.
taskprint 1
sudo chmod 770 /tmp/sports_folder
continue_press

# 1c. All files created in this directory should be group-owned by the sports group.
taskprint 2
sudo chmod 2770 /tmp/sports_folder
continue_press

# 1d. Users should be able to delete only their own user-owned files.
taskprint 3
sudo chmod +t /tmp/sports_folder
continue_press

# 1e. Test that this works!
taskprint 4
sudo usermod -aG sports serena
su - serena
touch /tmp/sports_folder/test.txt
ls -l /tmp/sports_folder/test.txt
rm /tmp/sports_folder/test.txt

continue_press

# 2. Verify the permissions on /usr/bin/passwd. Remove the setuid, then try changing your password as a normal user. Reset the permissions back and try again.
taskprint 5
ls -l /usr/bin/passwd
chmod 755 /usr/bin/passwd
ls -l /usr/bin/passwd

echo "A normal user will not be able to change password"

# End of the script
printf "\n\e[1;34m########################################\e[0m\n"
printf "\e[1;32mEnd of Chapter 33 Tasks Script\e[0m\n"
printf "\e[1;34m########################################\e[0m\n"
printf "\n\e[1;33mIm too scared to check what time it is...\e[0m\n"
printf "\n\e[1;34m########################################\e[0m\n"

# Exit
exit 0