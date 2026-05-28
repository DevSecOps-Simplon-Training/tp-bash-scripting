#!/bin/bash
# setup.sh — Prépare le projet NexaCloud en une commande

set -e

VERT="\033[0;32m"
ROUGE="\033[0;31m"
CYAN="\033[0;36m"
BOLD="\033[1m"
RESET="\033[0m"
# J'ai ajouté la variable JAUNE qui manquait, elle est utilisée dans warn()
# mais n'était pas déclarée — sans ça warn() affichait sans couleur
JAUNE="\033[0;33m"

info() { echo -e "${CYAN}[INFO]${RESET} $1"; }
ok()   { echo -e "${VERT}[OK]${RESET}   $1"; }
warn() { echo -e "${JAUNE}[WARN]${RESET} $1"; }
err()  { echo -e "${ROUGE}[ERR]${RESET}  $1"; exit 1; }

# ── Bannière ─────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${CYAN}============================================${RESET}"
echo -e "${BOLD}${CYAN}   SETUP NEXACLOUD — $(date '+%d/%m/%Y %H:%M')${RESET}"
echo -e "${BOLD}${CYAN}============================================${RESET}"
echo ""

# ── 1. Vérification des prérequis ─────────────────────────────────────
info "Vérification des prérequis..."

# J'ai utilisé "command -v" pour vérifier que chaque outil est installé
# Le "|| err(...)" signifie : si la commande n'existe pas, j'appelle err()
# err() affiche le message en rouge ET stoppe le script avec exit 1
command -v python3 &>/dev/null || err "python3 non trouvé"
command -v node    &>/dev/null || err "Node.js non trouvé"
command -v npm     &>/dev/null || err "npm non trouvé"

ok "Prérequis : Python3, Node.js, npm présents"

# ── 2. Installation des dépendances Python ────────────────────────────
info "Installation des dépendances Python..."

# J'ai vérifié si le fichier requirements.txt existe avec [ -f ]
# Si oui → je lance pip install pour installer les dépendances
# Si non → j'affiche un warn() pour prévenir sans bloquer le script
if [ -f "python-api/requirements.txt" ]; then
    pip install -r python-api/requirements.txt --quiet
    ok "Dépendances Python installées"
else
    warn "python-api/requirements.txt manquant — dépendances Python ignorées"
fi

# ── 3. Installation des dépendances Node ─────────────────────────────
info "Installation des dépendances Node..."

# Même logique que pour Python : je vérifie si package.json existe
# Si oui → je me déplace dans node-client, je lance npm install, puis je reviens
# Les && enchaînent les commandes : la suivante ne s'exécute que si la précédente réussit
if [ -f "node-client/package.json" ]; then
    cd node-client && npm install --silent && cd ..
    ok "Dépendances Node installées"
else
    warn "node-client/package.json manquant — dépendances Node ignorées"
fi

# ── 4. Analyse des logs ───────────────────────────────────────────────
info "Analyse des logs..."
LOG="ressources/server.log"

# J'ai d'abord vérifié que le fichier de logs existe avec [ -f ]
if [ -f "$LOG" ]; then
    # J'utilise grep -c pour compter les lignes contenant ERROR et CRITICAL
    # Le "|| true" est important : si grep ne trouve rien il retourne une erreur
    # et set -e stopperait le script — || true l'en empêche
    NB_ERR=$(grep -c "ERROR" "$LOG" || true)
    NB_CRIT=$(grep -c "CRITICAL" "$LOG" || true)

    ok "Logs analysés — ERROR: $NB_ERR  |  CRITICAL: $NB_CRIT"

    # Si NB_CRIT est supérieur à 0, j'affiche une alerte en rouge
    # puis je liste chaque ligne CRITICAL avec grep et une boucle while
    if [ "$NB_CRIT" -gt 0 ]; then
        echo -e "${ROUGE}  /!\ $NB_CRIT ligne(s) CRITICAL détectée(s) :${RESET}"
        grep "CRITICAL" "$LOG" | while read -r ligne; do
            echo -e "${ROUGE}    → $ligne${RESET}"
        done
    fi
else
    warn "Fichier $LOG introuvable — analyse ignorée"
fi

# ── 5. Message de fin ─────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${VERT}============================================${RESET}"
echo -e "${BOLD}${VERT}   SETUP TERMINÉ AVEC SUCCÈS              ${RESET}"
echo -e "${BOLD}${VERT}============================================${RESET}"
echo ""
echo "  Lancer l'API Python  : cd python-api && python3 app.py"
echo "  Lancer le client Node: cd node-client && node app.js"
echo ""#!/bin/bash
