#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

SERVICES=$($PSQL "SELECT * FROM services order by service_id")

GET_INPUT(){
echo -e "\nWhich service would you like?"
echo "$(echo "$SERVICES" | sed s'/|/ /')" | while read SERVICE_ID SERVICE
do
  echo "$SERVICE_ID) $SERVICE"
done
read SERVICE_ID_SELECTED
SERVICE_ID_SELECTED_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")

if [[ -z $SERVICE_ID_SELECTED_ID ]]
then 
GET_INPUT
else
  echo -e "What is your phone number?"
  read CUSTOMER_PHONE
      #get customer id 
      CUSTOMER_ID=$($PSQL "SELECT  customer_id FROM customers where phone='$CUSTOMER_PHONE'")
      if [[ -z $CUSTOMER_ID ]] 
      then
      echo -e "\nWhat is your name"
      read CUSTOMER_NAME
      INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers where phone='$CUSTOMER_PHONE'")
      fi  
  echo -e "\nWhat time would you like the service? eg. 11am, 3pm"
  read SERVICE_TIME
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED_ID, '$SERVICE_TIME')")
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers where phone='$CUSTOMER_PHONE'")
  SERVICE_NAME=$($PSQL "SELECT name FROM services where service_id=$SERVICE_ID_SELECTED_ID ")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
fi
}
GET_INPUT

