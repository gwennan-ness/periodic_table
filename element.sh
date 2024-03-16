#!/bin/bash

# Returns information about input element from database

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only --no-align -c"

if [[ -z $* ]]
then
  # Null input behavious
  echo "Please provide an element as an argument."
else
  # If input is a number
  if [[ $1 =~ [0-9]+ ]]
  then
    ELEMENT_INFO="$($PSQL "SELECT el.atomic_number, el.symbol, el.name, types.type, prop.atomic_mass, prop.melting_point_celsius, prop.boiling_point_celsius FROM elements el INNER JOIN properties prop USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1;")"
  else
    ELEMENT_INFO="$($PSQL "SELECT el.atomic_number, el.symbol, el.name, types.type, prop.atomic_mass, prop.melting_point_celsius, prop.boiling_point_celsius FROM elements el INNER JOIN properties prop USING(atomic_number) INNER JOIN types USING(type_id) WHERE el.name='$1' OR el.symbol='$1';")"
  fi
  echo $ELEMENT_INFO | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
  do
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."
    else
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    fi
  done
fi