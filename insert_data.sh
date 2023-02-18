#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# insert all games to database
echo $($PSQL "truncate teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
	# check winner first
	# check title line
	if [[ $YEAR != year ]]
	then
		# get winner id
		TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")
		# if not found
		if [[ -z $TEAM_ID ]]
		then
			# insert team
			INSERT_WINNER_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
			if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
			then
				echo Insert into teams: $WINNER
			fi
		fi
		# get opponent id
		TEAM_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
		# if not found
		if [[ -z $TEAM_ID ]]
		then
			# insert team
			INSERT_OPPONENT_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
			if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
			then
				echo Insert into teams: $OPPONENT
			fi
		fi

		# insert games
		# get winner_id and opponent_id
		WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
		OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
		INSERT_GAME_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$W_GOALS', '$O_GOALS')")
		if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
		then
			echo Insert into games: $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $W_GOALS, $O_GOALS
		fi
	fi
done
