#!/bin/bash
# setup.sh — Prépare le projet NexaCloud en une commande
export "$(grep -v '^#' .env | xargs)"
echo "Port configuré : $PORT"

set -e

VERT="\033[0;32m"
ROUGE="\033[0;31m"
CYAN="\033[0;36m"
BOLD="\033[1m"
RESET="\033[0m"

info() { echo -e "${CYAN}[INFO]${RESET} $1"; }
ok()   { echo -e "${VERT}[OK]${RESET}   $1"; }
warn() { echo -e "${JAUNE}[WARN]${RESET} $1"; }
err()  { echo -e "${ROUGE}[ERR]${RESET}  $1"; exit 1; }

# ── Bannière (fournie) ────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${CYAN}============================================${RESET}"
echo -e "${BOLD}${CYAN}   SETUP NEXACLOUD — $(date '+%d/%m/%Y %H:%M')${RESET}"
echo -e "${BOLD}${CYAN}============================================${RESET}"
echo ""

# ── 1. Vérification des prérequis ─────────────────────────────────────
info "Vérification des prérequis..."

# TODO: vérifiez que python3, node et npm sont installés
# Si l'une des commandes est absente, appelez err() pour stopper le script
# Indice : command -v python3 &>/dev/null vérifie si python3 existe
# Indice : l'opérateur || execute la commande à droite si celle de gauche échoue
command -v python3 &>/dev/null || err "Python3 n'est pas installé."
command -v node &>/dev/null || err "Node.js n'est pas installé."    
command -v npm &>/dev/null || err "npm n'est pas installé."


ok "Prérequis : Python3, Node.js, npm présents"

# ── 2. Installation des dépendances Python ────────────────────────────
info "Installation des dépendances Python..."

# TODO: vérifiez si le fichier python-api/requirements.txt existe
# Si oui  → lancez pip install -r python-api/requirements.txt --quiet
#            puis affichez ok()
# Si non  → affichez warn() pour prévenir sans bloquer
if [ -f "python-api/requirements.txt" ]; then
    pip install -r python-api/requirements.txt --quiet
    ok "Dépendances Python installées"
else
    warn "Fichier requirements.txt introuvable, dépendances Python non installées"
fi


# ── 3. Installation des dépendances Node ─────────────────────────────
info "Installation des dépendances Node..."

# TODO: même logique pour node-client/package.json
# Si le fichier existe → cd node-client && npm install --silent && cd ..
# Indice : en Bash, on peut chaîner des commandes avec &&
if [ -f "node-client/package.json" ]; then
    cd node-client && npm install --silent && cd ..
    ok "Dépendances Node installées"
else
    warn "Fichier package.json introuvable, dépendances Node non installées"
fi


# ── 4. Analyse des logs ───────────────────────────────────────────────
info "Analyse des logs..."
LOG="ressources/server.log"

# TODO: vérifiez que $LOG existe, puis :
# - comptez les ERROR avec grep -c et stockez dans NB_ERR
# - comptez les CRITICAL avec grep -c et stockez dans NB_CRIT
# - affichez ok() avec les deux compteurs
# - si NB_CRIT > 0, affichez un message d'alerte rouge
#   et listez les lignes CRITICAL avec grep + une boucle while
if [ -f "$LOG" ]; then
    NB_ERR=$(grep -c "ERROR" "$LOG" 2>/dev/null || true)
    NB_CRIT=$(grep -c "CRITICAL" "$LOG" 2>/dev/null || true)
    # Vérifie qu'il s'agit bien de chiffres ; si le champ est vide, attribue la valeur par défaut 0
    NB_ERR=${NB_ERR:-0}
    NB_CRIT=${NB_CRIT:-0}
    ok "Analyse terminée : $NB_ERR erreurs, $NB_CRIT incidents critiques"
    
    if [ "$NB_CRIT" -gt 0 ]; then
        echo -e "${ROUGE}ALERTE CRITIQUE : $NB_CRIT incident(s) critique(s) détecté(s) !${RESET}"
        echo "Détails des incidents critiques :"
        grep "CRITICAL" "$LOG" | while read -r line; do
            echo -e "${ROUGE}$line${RESET}"
        done
    fi
else
    warn "Fichier de log introuvable : $LOG"
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