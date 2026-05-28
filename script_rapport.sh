#!/bin/bash

# Put the absolut path of the server log file in this variable
SERVER_LOG_PATH="ressources/server.log"

function rapport_list_generator(){
echo -e "=== LOGS REPORTS ===\n 
Number of lines : $(wc -l < $SERVER_LOG_PATH)\n 
Errors : $(grep -c 'ERROR' $SERVER_LOG_PATH)\n 
Warnings : $(grep -c 'WARNING' $SERVER_LOG_PATH)\n 
Critical : $(grep -c 'CRITICAL' $SERVER_LOG_PATH)" > rapport.txt  

echo -e "=== ERROR LINES ===\n 
$(grep 'ERROR' $SERVER_LOG_PATH)" > error.txt

}

function main(){

rapport_list_generator

echo "Rapport generated successfully. Check rapport.txt and error.txt for details."
}

main