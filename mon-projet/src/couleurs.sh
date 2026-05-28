#!/bin/bash
# couleurs.sh — Tester les fonctions d'affichage

# Les codes couleur sont fournis
VERT="\033[0;32m"
# shellcheck disable=SC2034
ROUGE="\033[0;31m"
JAUNE="\033[0;33m"
CYAN="\033[0;36m"
RESET="\033[0m"

# Ces fonctions sont déjà écrites — observez leur structure
ok()   { echo -e "${VERT}[OK]${RESET}   $1"; }
info() { echo -e "${CYAN}[INFO]${RESET} $1"; }

# TODO: écrivez les fonctions warn() et err() sur le même modèle
# warn() doit afficher en jaune avec le préfixe [WARN]
# err()  doit afficher en rouge avec le préfixe [ERR]



# Test — ces lignes doivent afficher chacune dans la bonne couleur
ok   "Installation réussie"
info "Démarrage du serveur..."
warn "Mémoire basse : 78%"
err  "Connexion échouée"
