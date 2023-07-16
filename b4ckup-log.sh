#!/bin/bash
source /home/eza/Documents/b4ckup/.conf

function addLog(){
  SQL="INSERT INTO log (file_name, dir, status) VALUES ('$1', '$2', '$3');"
  mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -e "$SQL"
}

function getLogID(){
  SQL="SELECT id FROM log ORDER BY id DESC LIMIT 1;"
  x=$(mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -e "$SQL")
  echo $x | awk '{print $2}'
}

function getLog(){
  SQL="SELECT * FROM log;"
  result=$(mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -e "$SQL")
  echo "${result}" | column -t -s$'\t'
}

getLog