#!/bin/bash
# check-logs.sh — Vérifie l'état des logs et alerte si nécessaire

LOG_FILE="ressources/server.log"
SEUIL_ERREURS=3

if [ -z "$1" ]; then
    echo "Usage : $0 <fichier.log>"
    exit 1
fi

NB_ERREURS=$(grep -c "ERROR" "$1")
NB_CRITIQUES=$(grep -c "CRITICAL" "$1")
NB_WARNINGS=$(grep -c "WARNING" "$1")

echo "=== Analyse de $1 ==="
echo "  INFO     : $(grep -c "INFO" "$1")"
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
