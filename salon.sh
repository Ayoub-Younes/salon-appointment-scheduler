#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
MAIN_MENU(){
if [[ $1 ]]
then
 echo -e "\n$1"
fi
 echo -e "\nWelcome to My Salon, how can I help you?\n"
 SERVICES=$($PSQL "SELECT * FROM services")
 echo "$SERVICES" | while read SERVICE_ID BAR SERVICE
 do 
  echo "$SERVICE_ID) $SERVICE"
 done
 read SERVICE_ID_SELECTED
 
 case $SERVICE_ID_SELECTED in
 1) CUT ;;
 2) COLOR ;;
 3) FACIAL ;;
 *) MAIN_MENU "I could not find that service. What would you like today?" ;;
 esac
}
CUT(){
  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  INFO
}
COLOR(){
  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  INFO
}
FACIAL(){
  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  INFO
}
INFO(){
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then 
   echo -e "\n I don't have a record for that phone number, what's your name?"
   read CUSTOMER_NAME
   CUSTOMER_UPDATE=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
   CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  fi
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  echo -e "\nWhat time would you like your$SERVICE,$CUSTOMER_NAME?"
  read SERVICE_TIME
  APNT_UPDATE=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME',$CUSTOMER_ID,$SERVICE_ID_SELECTED)")
  echo -e "\nI have put you down for a$SERVICE at $SERVICE_TIME,$CUSTOMER_NAME."
}
MAIN_MENU
