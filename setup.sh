#!/bin/bash
# setup.sh — Prépare le projet NexaCloud en une commande

set -e

VERT="\033[0;32m"
ROUGE="\033[0;31m"
JAUNE="\033[0;33m"
CYAN="\033[0;36m"
BOLD="\033[1m"
RESET="\033[0m"

info() { echo -e "${CYAN}[INFO]${RESET} $1"; }
ok() { echo -e "${VERT}[OK]${RESET}   $1"; }
warn() { echo -e "${JAUNE}[WARN]${RESET} $1"; }
err() {
  echo -e "${ROUGE}[ERR]${RESET}  $1"
  exit 1
}

# ── Bannière ────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${CYAN}============================================${RESET}"
echo -e "${BOLD}${CYAN}   SETUP NEXACLOUD — $(date '+%d/%m/%Y %H:%M')${RESET}"
echo -e "${BOLD}${CYAN}============================================${RESET}"
echo ""

# ── 1. Vérification des prérequis ───────────────────────────
info "Vérification des prérequis..."

command -v python3 &>/dev/null || err "Python3 non installé"
command -v node &>/dev/null || err "Node.js non installé"
command -v npm &>/dev/null || err "npm non installé"

ok "Prérequis : Python3, Node.js, npm présents"

# ── 2. Installation des dépendances Python ─────────────────
info "Installation des dépendances Python..."

if [ -f "python-api/requirements.txt" ]; then
  pip install -r python-api/requirements.txt --quiet
  ok "Dépendances Python installées"
else
  warn "python-api/requirements.txt introuvable"
fi

# ── 3. Installation des dépendances Node ───────────────────
info "Installation des dépendances Node..."

if [ -f "node-client/package.json" ]; then
  cd node-client && npm install --silent && cd ..
  ok "Dépendances Node installées"
else
  warn "node-client/package.json introuvable"
fi

# ── 4. Analyse des logs ────────────────────────────────────
info "Analyse des logs..."

LOG="ressources/server.log"

if [ -f "$LOG" ]; then
  NB_ERR=$(grep -c "ERROR" "$LOG")
  NB_CRIT=$(grep -c "CRITICAL" "$LOG")

  ok "Logs analysés : $NB_ERR erreur(s), $NB_CRIT critique(s)"

  if [ "$NB_CRIT" -gt 0 ]; then
    echo -e "${ROUGE}[ALERTE]${RESET} Incidents critiques détectés :"

    grep "CRITICAL" "$LOG" | while read -r ligne; do
      echo "  -> $ligne"
    done
  fi
else
  warn "Fichier de log introuvable : $LOG"
fi

# ── 5. Message de fin ──────────────────────────────────────
echo ""
echo -e "${BOLD}${VERT}============================================${RESET}"
echo -e "${BOLD}${VERT}   SETUP TERMINÉ AVEC SUCCÈS               ${RESET}"
echo -e "${BOLD}${VERT}============================================${RESET}"
echo ""

echo "  Lancer l'API Python  : cd python-api && python3 app.py"
echo "  Lancer le client Node: cd node-client && node app.js"
echo ""
