#!/bin/bash
# setup.sh — Prépare le projet NexaCloud en une commande

set -e

export "$(grep -v '^#' .env | xargs)"

VERT="\033[0;32m"
ROUGE="\033[0;31m"
CYAN="\033[0;36m"
BOLD="\033[1m"
RESET="\033[0m"

info() { echo -e "${CYAN}[INFO]${RESET} $1"; }
ok() { echo -e "${VERT}[OK]${RESET}   $1"; }
warn() { echo -e "${JAUNE}[WARN]${RESET} $1"; }
err() {
    echo -e "${ROUGE}[ERR]${RESET}  $1"
    exit 1
}

# ── Bannière (fournie) ────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${CYAN}============================================${RESET}"
echo -e "${BOLD}${CYAN}   SETUP NEXACLOUD — $(date '+%d/%m/%Y %H:%M')${RESET}"
echo -e "${BOLD}${CYAN}============================================${RESET}"
echo ""

echo "Port configuré : $PORT"
echo ""

# ── 1. Vérification des prérequis ─────────────────────────────────────
info "Vérification des prérequis..."

for cmd in python3 node npm; do
    if command -v "$cmd" &>/dev/null; then
        ok "$cmd installé"
    else
        err "$cmd non trouvé"
    fi
done

ok "Prérequis : Python3, Node.js, npm présents"

# ── 2. Installation des dépendances Python ────────────────────────────
info "Installation des dépendances Python..."

if [ -f "python-api/requirements.txt" ]; then
    pip install -r python-api/requirements.txt --quiet
    ok "Dépendances Python installées"
else
    warn "Fichier python-api/requirements.txt non trouvé"
fi

# ── 3. Installation des dépendances Node ─────────────────────────────
info "Installation des dépendances Node..."

if [ -f "node-client/package.json" ]; then
    cd node-client && npm install --silent && cd ..
    ok "Dépendances Node installées"
else
    warn "Fichier node-client/package.json non trouvé"
fi

# ── 4. Analyse des logs ───────────────────────────────────────────────
info "Analyse des logs..."
LOG="ressources/server.log"

if [ -f "$LOG" ]; then
    NB_ERR=$(grep -c "ERROR" "$LOG")
    NB_CRIT=$(grep -c "CRITICAL" "$LOG")
    ok "Logs analysés : $NB_ERR erreurs, $NB_CRIT critiques"
    if [ "$NB_CRIT" -gt 0 ]; then
        echo ""
        echo -e "${ROUGE}ATTENTION IL Y A $NB_CRIT ERREURS CRITIQUES${RESET}"
    fi
    while [ "${i=1}" -le "$NB_CRIT" ]; do
        grep "CRITICAL" "$LOG" | sed -n "$i"p
        i=$((i + 1))
    done
else
    warn "Fichier de log $LOG non trouvé"
fi

# ── 5. Message de fin (fourni) ────────────────────────────────────────
echo ""
echo -e "${BOLD}${VERT}============================================${RESET}"
echo -e "${BOLD}${VERT}   SETUP TERMINÉ AVEC SUCCÈS              ${RESET}"
echo -e "${BOLD}${VERT}============================================${RESET}"
echo ""
echo "  Lancer l'API Python  : cd python-api && python3 app.py"
echo "  Lancer le client Node: cd node-client && node app.js"
echo ""
