#!/bin/bash
# check-env.sh — Vérifie que l'environnement est prêt pour NexaCloud

set -e

VERT="\033[0;32m"
ROUGE="\033[0;31m"
JAUNE="\033[0;33m"
RESET="\033[0m"
VIOLET="\033[0;35m"

ok()   { echo -e "${VERT}  [OK]${RESET}   $1"; }
warn() { echo -e "${JAUNE}  [WARN]${RESET} $1"; }
err()  { echo -e "${ROUGE}  [ERR]${RESET}  $1"; }
crit() { echo -e "${VIOLET}  [CRIT]${RESET}   $1"; }

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

verifier_commande "python3" "Python"
verifier_commande "node" 
verifier_commande "npm" "gestionaire de paquets node"
verifier_commande "git" 

echo ""

# TODO: vérifiez que ces deux fichiers existent avec [ -f ]
# et affichez ok ou warn selon le résultat
# Fichiers à vérifier : "config.json" et "ressources/server.log"
CONFIG="config.json"
LOGS="ressources/server.log"

if [ -f "$CONFIG" ]; then
	ok "le fichier $CONFIG est bien présent, l'ami"
else
	warn "attention" 
	err "ATTENTION !!" 
	crit "le fichier $CONFIG n'existe pas !!!!"
fi

echo ""

if [ -f "$LOGS" ]; then
	ok "le fichier $LOGS est bien présent, l'ami"
else
	warn "attention" 
	err "ATTENTION !!" 
	crit "le fichier $LOGS n'existe pas !!!!"
fi

echo ""
echo "=== Vérification terminée ==="
echo ""