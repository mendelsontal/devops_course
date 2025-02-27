#!/usr/bin/env bash
#################### /ᐠ｡ꞈ｡ᐟ\ ######################
#Developed by: Tal Mendelson
#Purpose: Holds the solutions for chapter 29 Linux Fundamentals by Paul Cobbaut
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
"1. Set the password for serena to hunter2."
'2. Also set a password for venus and then lock the venus user account with usermod. Verify the locking in /etc/shadow before and after you lock it.'
"3. Use passwd -d to disable the serena password. Verify the serena line in /etc/shadow before and after disabling."
"4. What is the difference between locking a user account and disabling a user account's password like we just did with usermod -L and passwd -d "
"5. Try changing the password of serena to serena as serena."
"6. Make sure serena has to change her password in 10 days."
"7. Make sure every new user needs to change their password every 10 days."
"8. Take a backup as root of /etc/shadow. Use vi to copy an encrypted hunter2 hash from venus to serena. Can serena now log on with hunter2 as a password ?"
"9. Why use vipw instead of vi ? What could be the problem when using vi or vim ?"
"10. Use chsh to list all shells (only works on RHEL/CentOS/Fedora), and compare to cat /etc/shells."
"11. Which useradd option allows you to name a home directory ?"
"12. How can you see whether the password of user serena is locked or unlocked ? Give asolution with grep and a solution with passwd."
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

# "1. Set the password for serena to hunter2."
taskprint 0

# Changing password
printf "\nChanging the password for \e[1;34mserena\e[0m using SHA-256\n"
usermod -p $(openssl passwd -5 hunter2) serena
continue_press

# '2. Also set a password for venus and then lock the venus user account with usermod. Verify the locking in /etc/shadow before and after you lock it.'
taskprint 1

# Changing password
printf "\nChanging the password for \e[1;34mvenus\e[0m using SHA-256\n"
usermod -p $(openssl passwd -5 hunter2) venus

# Check before locking
grep venus /etc/shadow

if grep venus /etc/shadow | grep '!' ; then
    printf "\e[1;31mThe user venus is locked.\e[0m\n"
else
    printf "\e[1;32mThe user venus is active.\e[0m\n"
fi

# Locking user
printf "\nLocking user \e[1;34mvenus\e[0m and confirming\n"
usermod -L venus
grep venus /etc/shadow

if grep venus /etc/shadow | grep '!' ; then
    printf "\e[1;31mThe user venus is locked.\e[0m\n"
else
    printf "\e[1;32mThe user venus is active.\e[0m\n"
fi

continue_press

# "3. Use passwd -d to disable the serena password. Verify the serena line in /etc/shadow before and after disabling."
taskprint 2
grep serena /etc/shadow

# Disable password
passwd -d serena
grep serena /etc/shadow

continue_press

# "4. What is the difference between locking a user account and disabling a user account's password like we just did with usermod -L and passwd -d "
taskprint 3
printf "\nlocking prevents login completely, while disabling the password only removes the password but leaves other login methods open.\n"
continue_press

# "5. Try changing the password of serena to serena as serena."
taskprint 4
printf "I was actually able to change the password using su serena, which makes sense since disabling simply removes the password... and we're setting a new one"
continue_press

# "6. Make sure serena has to change her password in 10 days."
taskprint 5

# Forces serena to change her password in 10 days
chage -M 10 serena

# Confirm change
chage -l serena | grep Maximum

continue_press

# "7. Make sure every new user needs to change their password every 10 days."
taskprint 6
cp /etc/login.defs /etc/login.defs.bak # Lets create a backup of this first

# Prints the current PASS_MAX_DAYS value
printf "\nThe current PASS_MAX_DAYS is set to: \e[1;34m%s\e[0m\n" "$(grep '^PASS_MAX_DAYS' /etc/login.defs | awk '{print $2}')"

# sets PASS_MAX_DAYS value to 10 and prints the updated value
printf "Settings PASS_MAX_DAYS to 10."
sed -i 's/^\(\s*PASS_MAX_DAYS\s*\)[0-9]\+/\1 10/' /etc/login.defs
printf "\nThe updated PASS_MAX_DAYS is now set to: \e[1;34m%s\e[0m\n" "$(grep '^PASS_MAX_DAYS' /etc/login.defs | awk '{print $2}')"

continue_press

# "8. Take a backup as root of /etc/shadow. Use vi to copy an encrypted hunter2 hash from venus to serena. Can serena now log on with hunter2 as a password ?"
taskprint 7
cp -p /etc/shadow /etc/shadow.bak # Creating a backup of /etc/shadow
printf "\nYes I was able to login to serena after using vi to copy the hash from venus\n"
continue_press

# "9. Why use vipw instead of vi ? What could be the problem when using vi or vim ?"
taskprint 8
printf "\nAccording to google:\nvipw is a safer tool for editing critical system files related to user accounts because it ensures locking and syntax checking, whereas vi or vim lacks these safeguards and can potentially cause system issues.\n"
continue_press

# "10. Use chsh to list all shells (only works on RHEL/CentOS/Fedora), and compare to cat /etc/shells."
taskprint 9
cat /etc/shells
continue_press

# "11. Which useradd option allows you to name a home directory ?"
taskprint 10
printf "\n useradd -d"
continue_press

# "12. How can you see whether the password of user serena is locked or unlocked ? Give asolution with grep and a solution with passwd."
taskprint 11
if grep serena /etc/shadow | grep '!' ; then
    printf "\e[1;31mThe user serena is locked.\e[0m\n"
else
    printf "\e[1;32mThe user serena is active.\e[0m\n"
fi

status=$(passwd -S serena)

if [[ $status == *"L"* ]]; then
    printf "\e[1;31mThe user serena is locked.\e[0m\n"
else
    printf "\e[1;32mThe user serena is active.\e[0m\n"
fi

# End of the script
printf "\n\e[1;34m########################################\e[0m\n"
printf "\e[1;32mEnd of Chapter 29 Tasks Script\e[0m\n"
printf "\e[1;34m########################################\e[0m\n"
printf "\n\e[1;33mI am the Emperor, and I speak the truth. Let none dare oppose me.\e[0m\n"
printf "\n\e[1;34m########################################\e[0m\n"

# Exit
exit 0