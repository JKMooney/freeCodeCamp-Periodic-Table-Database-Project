#!/bin/bash
# PSQL variable for querying the database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if if there an argument
if [[ -z $1 ]]
# If there is no argument
then
# Output: Please provide an element as an argument
echo -e "Please provide an element as an argument."
exit
fi
# If the argument is a number
if [[ $1 =~ ^[0-9]+$ ]]
  then
  JOINED_ELEMENTS=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1")
  # Or if the argument is a name or symbol
  else
  JOINED_ELEMENTS=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'")
fi
# If the argument does not exist
if [[ -z $JOINED_ELEMENTS ]]
  then
  # Output: I could not find that element in the db
  echo "I could not find that element in the database."
else
  # Select data atomic_number, name, symbol, type, mass, melting point, and boiling point from joined tables
  echo $JOINED_ELEMENTS | while IFS="|" read AT_NUM EL_NAME EL_SYMBOL EL_TYPE AT_MASS MPC BPC
do
  # Output: The element with atomic number <atomic_number> is <name> (<symbol>). It's a <type>, with a mass of <atomic_mass> amu. <name> has a melting point of <melting_point_celsius> celsius and a boiling point of <boiling_point_celsius> celsius.
  echo -e "The element with atomic number $AT_NUM is $EL_NAME ($EL_SYMBOL). It's a $EL_TYPE, with a mass of $AT_MASS amu. $EL_NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
done
  exit
fi


