#!/bin/bash
# check-env.sh - Vérifie que l'environnement est prêt pour NexaCloud

set -e

VERT="\033[0;32m"
ROUGE="\033[0;31m"
JAUNE="\033[0;33m"
RESET="\033[0m"

ok()   { echo -e "${VERT}   [OK]${RESET}  $1"; }
warn() { echo -e "${JAUNE}  [WARN]${RESET} $1"; }
err()  { echo -e "${ROUGE}  [ERR]${RESET}  $1"; }

# Cette fonction vérifie si une commande est installée
# $1 = nom de la commande  |  $2 = nom à afficher (optionnel)
verifier_commande() {
    local cmd="$1"
    local nom="${2:-$1}"
    # La commande "command -v" vérifie si un programme existe
    # &>/dev/null redirige la sortie pour ne rien afficher
    if command -v "$cmd" &>/dev/null; then
        ok "$nom installé"
    else
        err "$nom non trouvé"
    fi
}

echo ""
echo "=== Vérification de l'environnement NexaCloud ==="
echo ""

# -------------------------------------------------------------
# 1er TODO: appelez verifier_commande pour tester python3, node, npm et git
# -------------------------------------------------------------
verifier_commande "python3" "Python"
verifier_commande "node" "Node.js"
verifier_commande "npm" "NPM"
verifier_commande "git" "Git"

echo ""

# -------------------------------------------------------------
# TODO: vérifiez que ces deux fichiers existent avec [ -f ]
# et affichez ok ou warn selon le résultat
# Fichiers à vérifier : "config.json" et "ressources/server.log"
# -------------------------------------------------------------

# Vérification du fichier config.json
if [ -f "config.json" ]; then
    ok "Fichier config.json trouvé"
else
    warn "Fichier config.json manquant"
fi

# Vérification du fichier ressources/server.log
if [ -f "ressources/server.log" ]; then
    ok "Fichier ressources/server.log trouvé"
else
    warn "Fichier ressources/server.log manquant"
fi

echo ""
echo "=== Vérification terminée ==="
echo ""
