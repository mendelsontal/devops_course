#1 Write a script that asks for two numbers, and outputs the sum and product

vim ~/sumnprod.sh

#!/usr/bin/env bash
echo "Psstt.."
echo "Hi kid, wanna see some magic?"

read -p "Enter the first number: " num1
read -p "Enter the second number: " num2

# Function to check if input is a number
is_number() {
    [[ "$1" =~ ^[0-9]+$ ]]
}

# Validate both inputs
if is_number "$num1" && is_number "$num2"; then
    echo "Good, you didn't cheat!"
    echo "The magic sum number is: $((num1 + num2))"
	echo "and last, the magic of multiplying $((num1*num2))"
else
    echo "You tried to cheat, didn't you? Use numbers only next time!"
fi


chmod +x ~/sumnprod.sh
./sumnprod.sh

#2 Improve the previous script to test that the numbers are between 1 and 100, exit with an error if necessary.

vim ~/sumnprod.sh

#!/usr/bin/env bash
echo "Psstt.."
echo "Hi kid, wanna see some magic?"

read -p "Enter the first number: " num1
read -p "Enter the second number: " num2

# Function to check if input is a number
is_number() {
    [[ "$1" =~ ^[0-9]+$ ]]
}

# Check if the number is between 1 and 100
is_between_1_and_100() {
    [[ "$1" -ge 1 && "$1" -le 100 ]]
}

# Validate both inputs
if is_number "$num1" && is_number "$num2" && is_between_1_and_100 "$num1" && is_between_1_and_100 "$num2"; then
    echo "Good, you didn't cheat!"
    echo "The magic sum number is: $((num1 + num2))"
	echo "and last, the magic of multiplying $((num1*num2))"
else
    echo "You tried to cheat, didn't you? Use numbers between 1 to 100!"
fi