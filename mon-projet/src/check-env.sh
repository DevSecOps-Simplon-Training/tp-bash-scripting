#!/bin/bash
set -e

VERT="\033[0;32m"
JAUNE="\033[0;33m"
ROUGE="\033[0;31m"
RESET="\033[0m"

ok()   { echo -e "${VERT}[OK]${RESET} $1"; }
warn() { echo -e "${JAUNE}[WARN]${RESET} $1"; }
err()  { echo -e "${ROUGE}[ERR]${RESET} $1"; }

verifier_commande() {
    local cmd="$1"
    local name="${2:-$1}"

    if command -v "$cmd" &>/dev/null; then
        ok "$name présent"
    else
        err "$name absent"
    fi
}

echo "=== CHECK ENV ==="
