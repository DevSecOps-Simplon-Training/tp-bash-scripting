#!/bin/bash
# couleurs.sh — Tester les fonctions d'affichage

VERT="\033[0;32m"
ROUGE="\033[0;31m"
JAUNE="\033[0;33m"
CYAN="\033[0;36m"
RESET="\033[0m"

ok()   { echo -e "${VERT}[OK]${RESET}   $1"; }
info() { echo -e "${CYAN}[INFO]${RESET} $1"; }
warn() { echo -e "${JAUNE}[WARN]${RESET} $1"; }
err()  { echo -e "${ROUGE}[ERR]${RESET}  $1"; }

ok   "Installation réussie"
info "Démarrage du serveur..."
warn "Mémoire basse : 78%"
err  "Connexion échouée"