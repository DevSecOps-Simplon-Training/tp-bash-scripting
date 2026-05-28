#!/bin/bash
# setup.sh – Prépare le projet NexaCloud en une commande

set -e

VERT="\033[0;32m"
ROUGE="\033[0;31m"
CYAN="\033[0;36m"
JAUNE="\033[0;33m"
BOLD="\033[1m"
RESET="\033[0m"

info() { echo -e "${CYAN}[INFO]${RESET} $1"; }
ok()   { echo -e "${VERT}[OK]${RESET} $1"; }
warn() { echo -e "${JAUNE}[WARN]${RESET} $1"; }
err()  { echo -e "${ROUGE}[ERR]${RESET} $1"; exit 1; }

# — Bannière (fournie) ————————————————————————————————————
echo ""
echo -e "${BOLD}${CYAN}==================================================${RESET}"
echo -e "${BOLD}${CYAN}  SETUP NEXACLOUD – $(date '+%d/%m/%Y %H:%M')${RESET}"
echo -e "${BOLD}${CYAN}==================================================${RESET}"
echo ""

# — 1. Vérification des prérequis ————————————————————————
info "Vérification des prérequis..."

# TODO: vérifiez que python3, node et npm sont installés
# Si l'une des commandes est absente, appelez err() pour stopper le script
command -v python3 &>/dev/null || err "python3 est manquant"
command -v node &>/dev/null || err "node est manquant"
command -v npm &>/dev/null || err "npm est manquant"

ok "Prérequis : Python3, Node.js, npm présents"

# — 2. Installation des dépendances Python ——————————————————
info "Installation des dépendances Python..."

# TODO: vérifiez si le fichier python-api/requirements.txt existe
# Si oui -> lancez pip install -r python-api/requirements.txt --quiet
#           puis affichez ok()
# Si non -> affichez warn() pour prévenir sans bloquer
if [ -f "python-api/requirements.txt" ]; then
    pip install -r python-api/requirements.txt --quiet
    ok "Dépendances Python installées avec succès"
else
    warn "Le fichier python-api/requirements.txt est absent. Installation ignorée."
fi

# — 3. Installation des dépendances Node ————————————————————
info "Installation des dépendances Node..."

# TODO: même logique pour node-client/package.json
# Si le fichier existe -> cd node-client && npm install --silent && cd ..
if [ -f "node-client/package.json" ]; then
    cd node-client && npm install --silent && cd ..
    ok "Dépendances Node installées avec succès"
else
    warn "Le fichier node-client/package.json est absent. Installation ignorée."
fi

# — 4. Analyse des logs ————————————————————————————————————
info "Analyse des logs..."
LOG="ressources/server.log"

# TODO: vérifiez que $LOG existe, puis :
# - comptez les ERROR avec grep -c et stockez dans NB_ERR
# - comptez les CRITICAL avec grep -c et stockez dans NB_CRIT
# - affichez ok() avec les deux compteurs
# - si NB_CRIT > 0, affichez un message d'alerte rouge
#   et listez les lignes CRITICAL avec grep + une boucle while
if [ -f "$LOG" ]; then
    NB_ERR=$(grep -c "ERROR" "$LOG")
    NB_CRIT=$(grep -c "CRITICAL" "$LOG")
    
    ok "Analyse terminée : $NB_ERR erreurs et $NB_CRIT alertes critiques trouvées."
    
    if [ "$NB_CRIT" -gt 0 ]; then
        err "ATTENTION : $NB_CRIT lignes CRITICAL détectées dans le fichier de log !"
        
        # Ce bloc ci-dessous listera les lignes s'il y en a
        # shellcheck disable=SC2317
grep "CRITICAL" "$LOG" | while read -r ligne; do
            echo -e "${ROUGE}  -> $ligne${RESET}"
        done
    fi
else
    warn "Le fichier de log $LOG est introuvable. Analyse impossible."
fi

# — 5. Message de fin (fourni) ————————————————————————————
echo ""
echo -e "${BOLD}${VERT}==================================================${RESET}"
echo -e "${BOLD}${VERT}  SETUP TERMINÉ AVEC SUCCÈS                       ${RESET}"
echo -e "${BOLD}${VERT}==================================================${RESET}"
echo ""
echo "  Lancer l'API Python : cd python-api && python3 app.py"
echo "  Lancer le client Node : cd node-client && node app.js"
echo ""

exit 0