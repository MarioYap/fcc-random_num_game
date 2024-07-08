#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

NUMBER=$(( RANDOM % 1000 + 1 ))

echo -e "\nEnter your username:"
read USERNAME

NAME_CHECK=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME'")

if [[ -z $NAME_CHECK ]]
then

else
  
fi