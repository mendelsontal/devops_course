#1 Write a script that receives four parameters, and outputs them in reverse order.
vim ~/4rev.sh

#!/usr/bin/env bash

# Check if exactly 4 parameters
if [ $# -ne 4 ]; then
    echo "Usage: $0 param1 param2 param3 param4"
    exit 1
fi

# Print parameters in reverse order
echo "$4 $3 $2 $1"

chmod +x ~/4rev.sh
./4rev.sh

#2 Write a script that receives two parameters (two filenames) and outputs whether those files exist.
vim ~/2parfiles.sh

#!/usr/bin/env bash

# Check if exactly 2 parameters
if [ $# -ne 2 ]; then
    echo "Usage: $0 filename filename"
    exit 1
fi

if [ -f $1 ]
then echo file $1 exist
else echo file $1 not exist
fi
if [ -f $2 ]
then echo file $2 exist
else echo file $2 not exist
fi


chmod +x ~/2parfiles.sh
./2parfiles.sh

#3 Write a script that asks for a filename.
#  Verify existence of the file, then verify that youown the file, and whether it is writable.
#  If not, then make it writable.

vim ~/fileownership.sh

# Check if 1 parameter was added
if [ $# -ne 1 ]; then
    echo "Usage: $0 filename"
    exit 1
fi

# Check if the file exists
if [ -f $1 ]; then
	echo file $1 exist
	
    # Check if the user owns the file
    if [ -O "$1" ]; then
        echo "You own the file."

        # Check if the file is writable
        if [ -w "$1" ]; then
            echo "The file is writable."
        else
            echo "The file is not writable. Making it writable..."
            chmod u+w "$1"
            echo "File '$1' is now writable."
        fi
    else
        echo "You do not own the file."
    fi
else
    echo "File '$1' does not exist."
fi

#4 Make a configuration file for the previous script. Put a logging switch in the config file,
#  logging means writing detailed output of everything the script does to a log file in /tmp.

vim config.cfg
# Logging switch: set to "yes" to enable logging, "no" to disable
LOGGING="yes"

# Log file location
LOGFILE="/tmp/fileownership.log"

vim ~/fileownership.sh

#!/usr/bin/env bash

# Load configuration file
CONFIG_FILE="./config.cfg"

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Configuration file not found! Exiting."
    exit 1
fi

# Logging function
logit() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message"
    if [[ "$LOGGING" == "yes" ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOGFILE"
    fi
}

# Check if exactly one parameter was added
if [ $# -ne 1 ]; then
    logit "Usage: $0 filename"
    exit 1
fi

# Check if the file exists
if [ -f "$1" ]; then
    logit "File '$1' exists."

    # Check if the user owns the file
    if [ -O "$1" ]; then
        logit "You own the file."

        # Check if the file is writable
        if [ -w "$1" ]; then
            logit "The file is writable."
        else
            logit "The file is not writable. Making it writable..."
            chmod u+w "$1"
            logit "File '$1' is now writable."
        fi
    else
        logit "You do not own the file."
    fi
else
    logit "File '$1' does not exist."
fi