#!/bin/bash
# rapport.sh — Génère un rapport complet avec des fonctions

LOG_FILE="${1:-ressources/server.log}"
RAPPORT="mon-projet/logs/rapport-$(date +%Y%m%d-%H%M%S).txt"

# ── Fonctions ──────────────────────────────────────────────────────

afficher_titre() {
    echo "==========================================="
    echo "  $1"
    echo "==========================================="
}

compter_niveau() {
    local niveau="$1"
    local fichier="$2"
    grep -c "$niveau" "$fichier" 2>/dev/null || echo 0
}

ecrire_section() {
    local titre="$1"
    local contenu="$2"
    {
        echo ""
        echo "--- $titre ---"
        echo "$contenu"
    } >>"$RAPPORT"
}

# ── Script principal ───────────────────────────────────────────────

if [ ! -f "$LOG_FILE" ]; then
    echo "Fichier introuvable : $LOG_FILE"
    exit 1
fi

afficher_titre "RAPPORT D'ANALYSE — $(date '+%d/%m/%Y %H:%M')"

INFO=$(compter_niveau "INFO" "$LOG_FILE")
WARNING=$(compter_niveau "WARNING" "$LOG_FILE")
ERROR=$(compter_niveau "ERROR" "$LOG_FILE")
CRITICAL=$(compter_niveau "CRITICAL" "$LOG_FILE")

echo "  INFO     : $INFO"
echo "  WARNING  : $WARNING"
echo "  ERROR    : $ERROR"
echo "  CRITICAL : $CRITICAL"

# Écrire le rapport dans un fichier
echo "RAPPORT D'ANALYSE — $(date '+%d/%m/%Y %H:%M')" >"$RAPPORT"
ecrire_section "Compteurs" "INFO=$INFO  WARNING=$WARNING  ERROR=$ERROR  CRITICAL=$CRITICAL"
ecrire_section "Incidents critiques" "$(grep 'CRITICAL' "$LOG_FILE")"
ecrire_section "Erreurs" "$(grep 'ERROR' "$LOG_FILE")"

echo ""
echo "Rapport sauvegardé : $RAPPORT"

echo ""
# Traiter plusieurs fichiers de log en argument
for FICHIER in "$@"; do
    echo "=== Traitement de $FICHIER ==="
    ERREURS=$(grep -c "ERROR" "$FICHIER")
    echo "  $ERREURS erreur(s)"
done
# Appel : ./script.sh logs/app.log logs/backup.log

# Boucle avec break et continue
for i in $(seq 1 10); do
    [ "$i" -eq 5 ] && continue # sauter le 5
    [ "$i" -eq 8 ] && break    # arrêter au 8
    echo "$i"
done
