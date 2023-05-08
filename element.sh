#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t -c"

if [[ $1 ]]
then

  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
    if [[ -z $ATOMIC_NUMBER ]]
    then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
    fi
  fi

  if [[ $ATOMIC_NUMBER ]]
  then
    ELEMENT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_ID) WHERE atomic_number=$ATOMIC_NUMBER")

    echo "$ELEMENT" | while read TYPE_ID BAR A_NUM BAR SYMBOL BAR NAME BAR A_MASS BAR M_POINT BAR B_POINT BAR TYPE
    do
    echo "The element with atomic number $A_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $A_MASS amu. $NAME has a melting point of $M_POINT celsius and a boiling point of $B_POINT celsius."
    done
  else
    echo "I could not find that element in the database."
  fi

else
  echo "Please provide an element as an argument."
fi
