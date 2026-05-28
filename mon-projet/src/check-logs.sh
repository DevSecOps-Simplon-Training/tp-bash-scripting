#!/bin/bash
# check-logs.sh — Vérifie l'état des logs et alerte si nécessaire

SEUIL_ERREURS=3

if [ -z "$1" ]; then
    echo "Usage : $0 <fichier.log>"
    exit 1
fi

LOG_FILE=$1
[ -f "$LOG_FILE" ] && echo "Fichier $1 trouvé" || echo "Fichier $1 absent"

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
