#!/bin/bash
LOG_FILE="ressources/server.log"
SEUIL_ERREURS=3

if [ ! -f "$LOG_FILE" ]; then
    echo "ERREUR : le fichier $LOG_FILE n'existe pas."
    exit 1
fi

NB_ERREURS=$(grep -c "ERROR" "$LOG_FILE")
NB_CRITIQUES=$(grep -c "CRITICAL" "$LOG_FILE")
NB_WARNINGS=$(grep -c "WARNING" "$LOG_FILE")

echo "=== Analyse de $LOG_FILE ==="
echo "  INFO     : $(grep -c "INFO" "$LOG_FILE")"
echo "  WARNING  : $NB_WARNINGS"
echo "  ERROR    : $NB_ERREURS"
echo "  CRITICAL : $NB_CRITIQUES"
echo "==========================="

# Vérifier le seuil d'erreurs
if [ $NB_CRITIQUES -gt 0 ]; then
    echo "ALERTE CRITIQUE : $NB_CRITIQUES incident(s) critique(s) détecté(s) !"
elif [ $NB_ERREURS -gt $SEUIL_ERREURS ]; then
    echo "ATTENTION : $NB_ERREURS erreurs détectées (seuil : $SEUIL_ERREURS)"
else
    echo "OK : les logs sont dans les normes."
fi