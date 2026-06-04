# Mon projet Bash

# 1. Combien de lignes contient server.log ?


# 2. Affichez uniquement les 5 premières lignes


# 3. Affichez uniquement les 3 dernières lignes

# 4. Combien de lignes contiennent le mot ERROR ?


# 5. Affichez toutes les lignes WARNING


# 6. Affichez toutes les lignes CRITICAL


# 7. Combien d'erreurs ET de critiques y a-t-il au total ?
#    (indice : grep -E "ERROR|CRITICAL")


# 1 liner for these commands

echo -e "=== LOGS REPORTS ===\n 
Number of lines : $(wc -l < server.log)\n 
Errors : $(grep -c 'ERROR' server.log)\n 
Warnings : $(grep -c 'WARNING' server.log)\n 
Critical : $(grep -c 'CRITICAL' server.log)" > rapport.txt  

&& 

echo -e "=== ERROR LINES ===\n 
$(grep 'ERROR' server.log)" > error.txt
