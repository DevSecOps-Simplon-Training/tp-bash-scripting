# Mon projet Bash

# 1. Combien de lignes contient server.log ?
wc -l server.log

# 2. Affichez uniquement les 5 premières lignes
head -n 5 server.log

# 3. Affichez uniquement les 3 dernières lignes
tail -n 3 server.log

# 4. Combien de lignes contiennent le mot ERROR ?
grep -c "ERROR" server.log

# 5. Affichez toutes les lignes WARNING
grep "WARNING" server.log

# 6. Affichez toutes les lignes CRITICAL
grep "CRITICAL" server.log

# 7. Combien d'erreurs ET de critiques y a-t-il au total ?
#    (indice : grep -E "ERROR|CRITICAL")
grep -cE "ERROR|CRITICAL" server.log