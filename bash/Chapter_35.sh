#!/usr/bin/env bash
#################### /ᐠ｡ꞈ｡ᐟ\ ######################
#Developed by: Tal Mendelson
#Purpose: Holds the solutions for chapter 35 Linux Fundamentals by Paul Cobbaut
#Date:26/02/2025
#Version: 0.0.1
set -o errexit     # 
set -o pipefail    # 
#################### /ᐠ｡ꞈ｡ᐟ\ ######################

# Array containing all the current chapter tasks
chapter_tasks=(
    '1. Create two files named winter.txt and summer.txt, put some text in them.'
    '2. Create a hard link to winter.txt named hlwinter.txt.'
    '3. Display the inode numbers of these three files, the hard links should have the same inode.'
    '4. Use the find command to list the two hardlinked files'
    '5. Everything about a file is in the inode, except two things : name them!'
    '6. Create a symbolic link to summer.txt called slsummer.txt.'
    '7. Find all files with inode number 2. What does this information tell you ?'
    '8. Look at the directories /etc/init.d/ /etc/rc2.d/ /etc/rc3.d/ ... do you see the links ?'
    '9. Look in /lib with ls -l...'
    '10. Use find to look in your home directory for regular files that do not(!) have one hard link.'
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

# 1. Create two files named winter.txt and summer.txt, put some text in them.
taskprint 0
echo ice > winter.txt ; echo icecream > summer.txt
continue_press

# 2. Create a hard link to winter.txt named hlwinter.txt.
taskprint 1
ln winter.txt hlwinter.txt
continue_press

# 3. Display the inode numbers of these three files, the hard links should have the same inode.
taskprint 2
ls -li winter.txt summer.txt hlwinter.txt
continue_press

# 4. Use the find command to list the two hardlinked files
taskprint 3
find . -inum $(ls -i winter.txt | cit -f1 -d ' ') 2> /dev/null
echo "There are two files"
continue_press

# 5. Everything about a file is in the inode, except two things : name them!
taskprint 4
continue_press

# 6. Create a symbolic link to summer.txt called slsummer.txt.
taskprint 5
ln -s summer.txt slsummer.txt
continue_press

# 7. Find all files with inode number 2. What does this information tell you ?
taskprint 6
find / -inum 2
continue_press

# 8. Look at the directories /etc/init.d/ /etc/rc2.d/ /etc/rc3.d/ ... do you see the links ?
taskprint 7
ls -l /etc/init.d
ls -l /etc/rc2.d
ls -l /etc/rc3.d
continue_press

# 9. Look in /lib with ls -l...
taskprint 8
ls -l /lib
continue_press

# 10. Use find to look in your home directory for regular files that do not(!) have one hard link.
taskprint 9
find ~ ! -links 1 -type f

# End of the script
printf "\n\e[1;34m########################################\e[0m\n"
printf "\e[1;32mEnd of Chapter 35 Tasks Script\e[0m\n"
printf "\e[1;34m########################################\e[0m\n"
printf "\n\e[1;33mWho said sleep was overrated.. finnaly I can go to bed\e[0m\n"
printf "\n\e[1;34m########################################\e[0m\n"

# Exit
exit 0