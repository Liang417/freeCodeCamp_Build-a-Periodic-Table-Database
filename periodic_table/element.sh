#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

MAIN(){
  # if input is a ATOMIC_NUMBER
  INPUT=$1
  if [[ $INPUT =~ [0-9]$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$INPUT");
    
    # if input is a SYMBOL
  elif [[ $INPUT =~ ^[A-Za-z]{1,2}$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$INPUT'");
    
  else
    # if input is a NAME
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$INPUT'");
  fi
  
  # if input is invalid
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    # get element information
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    
    # delete non exitent element
    DELETE_NON_EXITENT_ELEMENT=$($PSQL "DELETE FROM properties WHERE atomic_number > 118")
    DELETE_NON_EXITENT_ELEMENT=$($PSQL "DELETE FROM elements WHERE atomic_number > 118")
    
    # delete column of type in the properties table
    DELETE_TYPE=$($PSQL "ALTER TABLE properties DROP COLUMN TYPE")
    
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a nonmetal, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
  
}

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  MAIN $1
fi
