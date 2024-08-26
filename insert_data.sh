#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games;")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
if [[ $WINNER != "winner" ]]
then
  WINNER_INSERT=$($PSQL "insert into teams(name) values('$WINNER') ON CONFLICT DO NOTHING;")
  OPPONENT_INSERT=$($PSQL "insert into teams(name) values('$OPPONENT') ON CONFLICT DO NOTHING;")
fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
if [[ $WINNER != "winner" ]]
then
  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER';")
  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT';")
  INSERT_GAME=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $W_GOALS, $O_GOALS);")
fi
done