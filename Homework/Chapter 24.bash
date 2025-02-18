#1 Write a script that uses a for loop to count from 3 to 7.
vi ~/count.sh

#!/usr/bin/env bash
echo "Lets count from 3 to 7"
for i in 3 4 5 6 7
do
	echo $i
	sleep 0.5
done


chmod +x ~/count.sh
./count.sh

#2 Write a script that uses a for loop to count from 1 to 17000.
vi ~/countto17k.sh

#!/usr/bin/env bash
echo "Lets count from 1 to 17000"

for i in {1..17000}
do
    echo $i
    sleep 0.5  # Wait for 1 second
done


chmod +x ~/countto17k.sh
./countto17k.sh

#3 Write a script that uses a while loop to count from 3 to 7.
vi ~/whilecount.sh

#!/usr/bin/env bash
echo "Counting from 3 to 7 using a while loop"

# Start from
i=3

while [ $i -le 7 ]
do
	echo $i
	sleep 0.5
	((i+=1))
done


chmod +x ~/whilecount.sh
./whilecount.sh

#4 Write a script that uses an until loop to count down from 8 to 4.
vi ~/untilcount.sh

#!/usr/bin/env bash
echo "Counting down from 8 to 4 using until loop"

# counter
counter=8

until [ $counter -lt 4 ]; do
	echo $counter
	sleep 0.5
	((counter-=1))
done


chmod +x ~/untilcount.sh
./untilcount.sh

#5 Write a script that counts the number of files ending in .txt in the current directory.
vi ~/counttxtfiles.sh

#!/usr/bin/env bash

count=0
for file in *.txt; do
	((count+=1))
done
echo "Found $count files ending with .txt"


chmod +x ~/counttxtfiles.sh
./counttxtfiles.sh

#6 Wrap an if statement around the script so it is also correct when there are zero files ending in .txt.
vi ~/counttxtfiles.sh

# Check if there are any .txt files
ls *.txt > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "There are 0 files ending in .txt"
else
    count=0
    for file in *.txt; do
        ((count+=1))
    done
    echo "Found $count files ending with .txt"
fi

./counttxtfiles.sh