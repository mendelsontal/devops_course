#!/usr/bin/env bash
#################### /ᐠ｡ꞈ｡ᐟ\ ######################
#Developed by: Tal Mendelson
#Purpose: Holds the solutions for chapter 32 Linux Fundamentals by Paul Cobbaut
#Date:26/02/2025
#Version: 0.0.1
set -o errexit     # 
set -o pipefail    # 
#################### /ᐠ｡ꞈ｡ᐟ\ ######################

# Array containing all the current chapter tasks
chapter_tasks=(
    "1. As normal user, create a directory ~/permissions. Create a file owned by yourself in there."
    "2. Copy a file owned by root from /etc/ to your permissions dir, who owns this file now ?"
    "3. As root, create a file in the users ~/permissions directory."
    "4. As normal user, look at who owns this file created by root."
    "5. Change the ownership of all files in ~/permissions to yourself."
    "6. Make sure you have all rights to these files, and others can only read."
    "7. With chmod, is 770 the same as rwxrwx--- ?"
    "8. With chmod, is 664 the same as r-xr-xr-- ?"
    "9. With chmod, is 400 the same as r-------- ?"
    "10. With chmod, is 734 the same as rwxr-xr-- ?"
    "11a. Display the umask in octal and in symbolic form."
    "11b. Set the umask to 077, but use the symbolic format to set it. Verify that this works."
    "12. Create a file as root, give only read to others. Can a normal user read this file ? Test writing to this file with vi."
    "13a. Create a file as normal user, give only read to others. Can another normal user read thisfile ? Test writing to this file with vi."
    "13b. Can root read this file ? Can root write to this file with vi ?"
    "14. Create a directory that belongs to a group, where every member of that group can read and write to files, and create files. Make sure that people can only delete their own files."
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

# 1. As normal user, create a directory ~/permissions. Create a file owned by yourself in there.
taskprint 0
mkdir -p ~/permissions ; touch ~/permissions/cats.txt
continue_press

# 2. Copy a file owned by root from /etc/ to your permissions dir, who owns this file now ?
taskprint 1
cp /etc/magic ~/magic
ls -l ~/permissions/magic
printf "The file is owned by my user"
continue_press

# 3. As root, create a file in the users ~/permissions directory.
taskprint 2
sudo touch ~/permissions/supermagic.txt
continue_press

# 4. As normal user, look at who owns this file created by root.
taskprint 3
ls -l ~/permissions/supermagic.txt
continue_press

# 5. Change the ownership of all files in ~/permissions to yourself.
taskprint 4
chown -R $USER ~/permissions
continue_press

# 6. Make sure you have all rights to these files, and others can only read.
taskprint 5
chmod -R 744 ~/permissions
continue_press

# 7. With chmod, is 770 the same as rwxrwx--- ?
taskprint 6
printf "Yes, chmod 770 is the same as rwxrwx---\n"
continue_press

# 8. With chmod, is 664 the same as r-xr-xr-- ?
taskprint 7
printf "No, chmod 664 is not the same as r-xr-xr--\n"
continue_press

# 9. With chmod, is 400 the same as r-------- ?
taskprint 8
printf "Yes, hmod 400 is the same as r--------\n"
continue_press

# 10. With chmod, is 734 the same as rwxr-xr-- ?
taskprint 9
printf "No, chmod 734 is not the same as rwxr-xr--\n"
continue_press

# 11a. Display the umask in octal and in symbolic form.
taskprint 10
printf "Umask in \e[1;34moctal\e[0m: %s\n" "$(umask)"
printf "Umask in \e[1;34msymbolic\e[0m: %s\n" "$(umask -S)"
continue_press

# 11b. Set the umask to 077, but use the symbolic format to set it. Verify that this works.
taskprint 11
umask -S u=rwx,go=

#Test that it worked
touch ~\testfile.txt
ls -l ~\testfile.txt
continue_press

# 12. Create a file as root, give only read to others. Can a normal user read this file ? Test writing to this file with vi.
taskprint 12
sudo touch /tmp/supermagicplusplus.txt
sudo chmod 644 /tmp/supermagicplusplus.txt
su - venus
cat /tmp/supermagicplusplus.txt
printf "\e[1;32myes\e[0m\n"

continue_press
# 13a. Create a file as normal user, give only read to others. Can another normal user read this file ? Test writing to this file with vi.
taskprint 13
touch /tmp/venus.txt
chmod 744 /tmp/venus.txt
ls -l /tmp/venus.txt
su - tal
printf "Yes, cat works as another normal user\n Trying to use vi gives Can't open file for writing error"
continue_press

# 13b. Can root read this file ? Can root write to this file with vi ?
taskprint 14
printf "\e[1;32myes x 2\e[0m\n"
continue_press

# 14. Create a directory that belongs to a group, where every member of that group can read and write to files, and create files. Make sure that people can only delete their own files.
taskprint 15
mkdir /tmp/shared
sudo chown root:tennis /tmp/shared
sudo chmod 1770 /tmp/shared


# End of the script
printf "\n\e[1;34m########################################\e[0m\n"
printf "\e[1;32mEnd of Chapter 32 Tasks Script\e[0m\n"
printf "\e[1;34m########################################\e[0m\n"
printf "\n\e[1;33mIt is 4:09am... im dying making this.\e[0m\n"
printf "\n\e[1;34m########################################\e[0m\n"

# Exit
exit 0