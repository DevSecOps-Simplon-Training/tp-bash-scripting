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

# Appele verifier_commande pour tester python3, node, npm et git
for cmd in python3 node npm git; do
    verifier_commande "$cmd"
done


echo ""

# Vérifie que ces deux fichiers existent avec [ -f ]

for fichier in "config.json" "ressources/server.log"; do
    if [ -f "$fichier" ]; then
        ok "Fichier $fichier trouvé"
    else
        warn "Fichier $fichier introuvable"
    fi
done


echo ""
echo "=== Vérification terminée ==="
echo ""