#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

NUMBER=$(( RANDOM % 1000 + 1 ))

echo -e "\nEnter your username:"
read ENTRY_NAME

USERNAME=$($PSQL "SELECT username FROM users WHERE username = '$ENTRY_NAME'")

if [[ -z $USERNAME ]]
then
  echo -e "\nWelcome, '$ENTRY_NAME'! It looks like this is your first time here."
  NEW_USER=$($PSQL "INSERT INTO users(username) VALUES ('$ENTRY_NAME')")
else
  BEST_COUNT=$($PSQL "SELECT MAX(number_of_guesses) FROM games LEFT JOIN users USING(user_id) WHERE username = '$USERNAME'")
  PLAY_COUNT=$($PSQL "SELECT COUNT(game_id) FROM games LEFT JOIN users USING(user_id) WHERE username = '$USERNAME'")
  echo -e "\nWelcome back, '$USERNAME'! You have played '$PLAY_COUNT' games, and your best game took '$BEST_COUNT' guesses."
fi