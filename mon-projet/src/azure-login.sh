#!/bin/bash
# azure.sh — Azure CLI et automatisation cloud

RESOURCE_GROUP="mcherfiRG"

VERT="\033[0;32m"
ROUGE="\033[0;31m"
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

# Vérifier que Azure CLI est installé
if az --version &>/dev/null; then
    ok "Azure CLI installé"
else
    err "Azure CLI non trouvé. Veuillez l'installer pour continuer."
fi

# Se connecter à Azure
if az login; then
    ok "Connexion réussie à Azure"
else
    err "Erreur de connexion"
fi

# Vérifier le compte actif
info "Vérification du compte Azure actif..."
echo ""
if az account show &>/dev/null; then
    ok "Compte Azure actif : $(az account show --query 'user.name' -o tsv)"
else
    err "Aucun compte Azure actif. Veuillez vous connecter avec 'az login'."
fi

echo ""

# Vérifier que le groupe a été créé
if az group show --name "$RESOURCE_GROUP" --query "properties.provisioningState" -o tsv &>/dev/null; then
    ok "Groupe de ressources '$RESOURCE_GROUP' trouvé"
else
    err "Groupe de ressources '$RESOURCE_GROUP' non trouvé. Veuillez le créer avec 'az group create'."
fi
