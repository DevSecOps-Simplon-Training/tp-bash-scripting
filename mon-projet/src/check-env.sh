#!/bin/bash
# check-env.sh — Vérifie que l'environnement est prêt pour NexaCloud

set -e

VERT="\033[0;32m"
ROUGE="\033[0;31m"
JAUNE="\033[0;33m"
RESET="\033[0m"

ok()   { echo -e "${VERT}  [OK]${RESET}   $1"; }
warn() { echo -e "${JAUNE}  [WARN]${RESET} $1"; }
err()  { echo -e "${ROUGE}  [ERR]${RESET}  $1"; }

verifier_commande() {
    local cmd="$1"
    local nom="${2:-$1}"
    if command -v "$cmd" &>/dev/null; then
        ok "$nom installé"
    else
        err "$nom non trouvé"
    fi
}

echo ""
echo "=== Vérification de l'environnement NexaCloud ==="
echo ""

verifier_commande "python3" "Python"
verifier_commande "node"    "Node.js"
verifier_commande "npm"     "npm"
verifier_commande "git"     "Git"

echo ""

if [ -f "config.json" ]; then
    ok "config.json trouvé"
else
    warn "config.json manquant"
fi

if [ -f "ressources/server.log" ]; then
    ok "ressources/server.log trouvé"
else
    warn "ressources/server.log manquant"
fi

echo ""
echo "=== Vérification terminée ==="
echo ""