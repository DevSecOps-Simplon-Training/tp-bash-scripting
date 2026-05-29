#!/bin/bash
# check-logs.sh — Vérifie l'état des logs et alerte si nécessaire

SEUIL_ERREURS=3

function check_logs() {
    local log_file="$1"

    NB_ERREURS=$(grep -c "ERROR" "$log_file")
    NB_CRITIQUES=$(grep -c "CRITICAL" "$log_file")
    NB_WARNINGS=$(grep -c "WARNING" "$log_file")

    echo "=== Analyse de $log_file ==="
    echo "  INFO     : $(grep -c "INFO" "$log_file")"
    echo "  WARNING  : $NB_WARNINGS"
    echo "  ERROR    : $NB_ERREURS"
    echo "  CRITICAL : $NB_CRITIQUES"
    echo "==========================="

    if [ "$NB_CRITIQUES" -gt 0 ]; then
        echo "ALERTE CRITIQUE : $NB_CRITIQUES incident(s) critique(s) détecté(s) !"
    elif [ "$NB_ERREURS" -gt "$SEUIL_ERREURS" ]; then
        echo "ATTENTION : $NB_ERREURS erreurs détectées (seuil : $SEUIL_ERREURS)"
    else
        echo "OK : les logs sont dans les normes."
    fi
}

main() {
    local log_file="${1:-ressources/server.log}"
    check_logs "$log_file"
}

main "$@"