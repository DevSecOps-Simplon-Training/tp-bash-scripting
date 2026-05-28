#!/bin/bash
# analyse-niveaux.sh — Compte chaque niveau de log

LOG_FILE="ressources/server.log"

echo "=== Analyse par niveau ==="

for NIVEAU in INFO WARNING ERROR CRITICAL; do
    NB=$(grep -c "$NIVEAU" "$LOG_FILE")
    echo "  $NIVEAU : $NB occurrence(s)"
done

echo "=========================="
echo "  TOTAL : $(wc -l < "$LOG_FILE") lignes"

