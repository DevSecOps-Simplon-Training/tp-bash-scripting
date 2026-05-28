!/bin/bash
# setup.sh — Prépare le projet NexaCloud en une commande

set -e

VERT="\033[0;32m"
ROUGE="\033[0;31m"
JAUNE="\033[0;33m"
CYAN="\033[0;36m"
BOLD="\033[1m"
RESET="\033[0m"

info() { echo -e "${CYAN}[INFO]${RESET} $1"; }
ok()   { echo -e "${VERT}[OK]${RESET}   $1"; }
warn() { echo -e "${JAUNE}[WARN]${RESET} $1"; }
err()  { echo -e "${ROUGE}[ERR]${RESET}  $1"; exit 1; }

echo ""
echo -e "${BOLD}${CYAN}============================================${RESET}"
echo -e "${BOLD}${CYAN}   SETUP NEXACLOUD — $(date '+%d/%m/%Y %H:%M')${RESET}"
echo -e "${BOLD}${CYAN}============================================${RESET}"
echo ""

info "Vérification des prérequis..."

command -v python3 >/dev/null || err "Python3 non trouvé"
command -v node >/dev/null || err "Node.js non trouvé"
command -v npm >/dev/null  || err "npm non trouvé"

ok "Prérequis : Python3, Node.js, npm présents"

info "Installation des dépendances Python..."

if [ -f "tp-collaboratif-git-dev-starter/python-api/requirements.txt" ]; then
    pip install -r tp-collaboratif-git-dev-starter/python-api/requirements.txt --quiet
    ok "Dépendances Python installées"
else
    warn "Fichier python-api/requirements.txt absent"
fi

info "Installation des dépendances Node..."

if [ -f "tp-collaboratif-git-dev-starter/node-client/package.json" ]; then
    cd tp-collaboratif-git-dev-starter/node-client &&  npm install --silent &&  cd ../..
    ok "Dépendances Node installées"
else
    warn "Fichier node-client/package.json absent"
fi

info "Analyse des logs..."

LOG="ressources/server.log"


if [ -f "$LOG" ]; then
    NB_ERR=$(grep -c "ERROR" "$LOG" || true)
    NB_CRIT=$(grep -c "CRITICAL" "$LOG" || true)

    ok "Logs analysés : $NB_ERR erreur(s), $NB_CRIT critique(s)"
    if [ "$NB_CRIT" -gt 0 ]; then
        echo -e "${ROUGE}Incidents critiques détectés${RESET}"
        grep "CRITICAL" "$LOG" | while read -r ligne; do
            echo -e "${ROUGE} - $ligne${RESET}"
        done
    fi
else
    warn "Fichier de logs absent : $LOG"
fi

echo ""
echo -e "${BOLD}${VERT}============================================${RESET}"
echo -e "${BOLD}${VERT}   SETUP TERMINÉ AVEC SUCCÈS              ${RESET}"
echo -e "${BOLD}${VERT}============================================${RESET}"
echo ""
echo "  Lancer l'API Python  : cd python-api && python3 app.py"
echo "  Lancer le client Node: cd node-client && node app.js"
echo ""