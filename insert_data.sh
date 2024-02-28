#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Open games.csv file and read the different variables
echo $($PSQL "TRUNCATE teams, games")
echo $($PSQL "SELECT SETVAL('teams_team_id_seq', 1);")
echo $($PSQL "SELECT SETVAL('games_game_id_seq', 1);")


cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Exclude the header line
  if [[ $YEAR != 'year' ]]

  then

    # Insert into teams into teams table

    # Get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER' ")
    # If winner_id is not found, then add it to the teams database.

    if [[ -z $WINNER_ID ]]
    then
      # insert winner into teams table
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      # If winner was inserted, then output a success message
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted $WINNER to teams table
      fi
    fi
    



    # Get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT' ")
    # If opponent_id is not found, then add it to the teams database.

    if [[ -z $OPPONENT_ID ]]
    then
      # insert opponent into teams table
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      # If opponen was inserted, then output a success message
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted $OPPONENT to teams table
      fi
    fi

    fi




    # Insert into games table

    # Each game will now have a unique ID, so we don't have to worry
    # about eventual duplicates as we did for the teams


    # Get winner_id again for games
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # Same for opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    INSERT_GAME=$($PSQL "INSERT INTO games
    (year, round, winner_id, opponent_id, winner_goals, opponent_goals)
    VALUES
    ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")

    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
      echo Inserted $WINNER - $OPPONENT, $WINNER_GOALS - $OPPONENT_GOALS, $ROUND $YEAR
    fi

done