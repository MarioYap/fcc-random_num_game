#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"


echo -e "\nEnter your username:"
read ENTRY_NAME

USERNAME=$($PSQL "SELECT username FROM users WHERE username = '$ENTRY_NAME'")

if [[ -z $USERNAME ]]
then
  echo -e "\nWelcome, $ENTRY_NAME! It looks like this is your first time here."
  NEW_USER=$($PSQL "INSERT INTO users(username) VALUES ('$ENTRY_NAME')")
else
  BEST_COUNT=$($PSQL "SELECT MAX(number_of_guesses) FROM games LEFT JOIN users USING(user_id) WHERE username = '$USERNAME'")
  PLAY_COUNT=$($PSQL "SELECT COUNT(game_id) FROM games LEFT JOIN users USING(user_id) WHERE username = '$USERNAME'")
  echo -e "\nWelcome back, $USERNAME! You have played $PLAY_COUNT games, and your best game took $BEST_COUNT guesses."
fi

NUMBER=$(( $RANDOM % 1000 + 1 ))
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$ENTRY_NAME'")

echo -e "\nGuess the secret number between 1 and 1000:"
INPUT_GUESS=0
I=0

until [[ $INPUT_GUESS == $NUMBER ]]
do
  (( I++ ))
  read INPUT_GUESS
  
  if [[ ! $INPUT_GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  elif [[ $INPUT_GUESS > $NUMBER ]]
  then
    echo "It's higher than that, guess again:"
  elif [[ $INPUT_GUESS < $NUMBER ]]
  then
    echo "It's lower than that, guess again:"
  elif [[ $INPUT_GUESS == $NUMBER ]]
  then
    echo "You guessed it in $I tries. The secret number was $NUMBER. Nice job!"
    GUESSED=$($PSQL "INSERT INTO games(number_of_guesses, user_id) VALUES ($I, $USER_ID)")
  fi
done