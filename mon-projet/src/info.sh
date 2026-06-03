#!/bin/bash
# info.sh — Affiche des informations sur l'environnement

NOM_PROJET="NexaCloud"
VERSION="1.1.0"
LOG_FILE="ressources/server.log"

echo "==============================="
echo "  Projet   : $NOM_PROJET"
echo "  Version  : $VERSION"
echo "==============================="

# Vérifier que le fichier de log existe
if [ -f "$LOG_FILE" ]; then
    NB_LIGNES=$(wc -l < "$LOG_FILE"  | tr -d ' ')
    echo "  Log      : $LOG_FILE ($NB_LIGNES lignes)"
else
    echo "  Log      : fichier introuvable !"
fi

echo "==============================="