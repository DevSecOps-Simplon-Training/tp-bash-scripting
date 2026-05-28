#!/bin/bash
# setup.sh — Prépare le projet NexaCloud en une commande

set -e

JAUNE="\033[0;33m"
VERT="\033[0;32m"
ROUGE="\033[0;31m"
CYAN="\033[0;36m"
VIOLET="\033[0;35m"
BOLD="\033[1m"
RESET="\033[0m"

info() { echo -e "${CYAN}[INFO]${RESET} $1"; }
ok()   { echo -e "${VERT}[OK]${RESET}   $1"; }
warn() { echo -e "${JAUNE}[WARN]${RESET} $1"; }
err()  { echo -e "${ROUGE}[ERR]${RESET}  $1"; exit 1; }
crit() { echo -e "${VIOLET}[CRIT]${RESET}   $1"; }

# ── Bannière (fournie) ────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${CYAN}============================================${RESET}"
echo -e "${BOLD}${CYAN}   SETUP NEXACLOUD — $(date '+%d/%m/%Y %H:%M')${RESET}"
echo -e "${BOLD}${CYAN}============================================${RESET}"
echo ""

# ── 1. Vérification des prérequis ─────────────────────────────────────
info "Vérification des prérequis..."

verifier_commande() {
    local cmd="$1"
    local nom="${2:-$1}"
    # La commande "command -v" vérifie si un programme existe
    # &>/dev/null redirige la sortie pour ne rien afficher
    if command -v "$cmd" &>/dev/null; then
        ok "$nom installé"
    else
        err "$nom non trouvé"
		exit 1
    fi
}

echo ""
echo "=== Vérification de l'environnement NexaCloud ==="
echo ""

verifier_commande "python3" "Python"
verifier_commande "node" 
verifier_commande "npm" "gestionaire de paquets node"
verifier_commande "git" 

echo ""


ok "Prérequis : Python3, Node.js, npm présents"

# ── 2. Installation des dépendances Python ────────────────────────────
info "Installation des dépendances Python..."

REQUIREMENT=python-api/requirements.txt
if [ ! -f "$REQUIREMENT" ]; then
	warn "Les requirement python n'existent pas" 
else
	pip install -r python-api/requirements.txt --quiet 
	ok
fi

echo ""



# ── 3. Installation des dépendances Node ─────────────────────────────
info "Installation des dépendances Node..."

PACKAGE=python-api/requirements.txt
if [ ! -f "$PACKAGE" ]; then
	warn "Le package node n'existe pas" 
else
	cd node-client && npm install --silent && cd .. 
	ok
fi

echo ""



# ── 4. Analyse des logs ───────────────────────────────────────────────
info "Analyse des logs..."
LOG="ressources/server.log"

[ -f "$LOG" ] && echo "Fichier log trouvé" || echo "Fichier log absent"
NB_ERR=$(grep -c "ERROR" "$LOG")
NB_CRIT=$(grep -c "CRITICAL" "$LOG")
ok "nombre d'erreurs: $NB_ERR \n    nombre d'errurs critiques: $NB_CRIT"
if [ "$NB_CRIT" -gt 0 ]; then
    echo "ALERTE CRITIQUE : $NB_CRIT incident(s) critique(s) détecté(s) !"
	echo "incidents critiques sur les lignes :"
	
	COMPTEUR=0
	while [ "$COMPTEUR" -le "$NB_CRIT" ]; do
		grep -n -m"$COMPTEUR" "CRITICAL" ressources/server.log | cut -f1 -d: | tail -n1
		COMPTEUR=$((COMPTEUR + 1))
	done
fi



# ── 5. Message de fin (fourni) ────────────────────────────────────────
echo ""
echo -e "${BOLD}${VERT}============================================${RESET}"
echo -e "${BOLD}${VERT}   SLIP TERMINÉ AVEC SUCCÈS                 ${RESET}"
echo -e "${BOLD}${VERT}============================================${RESET}"
echo ""
echo "  Lancer l'API Python  : cd python-api && python3 app.py"
echo "  Lancer le client Node: cd node-client && node app.js"
echo ""

# Créer un fichier .env pour stocker la configuration
echo "PORT=5001" > .env
echo "ENV=development" >> .env

# Charger les variables du .env dans le script
# (grep ignore les lignes commentées, xargs les exporte)
export "$(grep -v '^#' .env | xargs)"
echo "Port configuré : $PORT"