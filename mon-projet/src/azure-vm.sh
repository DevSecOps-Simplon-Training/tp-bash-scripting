#!/bin/bash

# Génère un nom de VM unique en ajoutant un nombre aléatoire
VM_NAME="mpetitvm$RANDOM"
VM_IMAGE="Ubuntu2204"
ADMIN_USER="mpetit"
SSH_DIR="$(dirname "$0")/SSH-Keys/${VM_NAME}"
# Chemin vers la clé SSH : sans extension = clé privée, avec .pub = clé publique
SSH_KEY_PATH="${SSH_DIR}/${VM_NAME}"

# Source le fichier environnement
source "$(dirname "$0")/.env"

function selectSmallestVMSize(){
    # Filtre les tailles sans restrictions, extrait nom et vCPUs, trie numériquement, prend la plus petite
    SMALLESTVM=$(az vm list-skus \
        --location "$LOCATION" \
        --resource-type "virtualMachines" \
        --query "[?length(restrictions)==\`0\`].{name:name, cpus:capabilities[?name=='vCPUs'].value|[0]}" \
        --output tsv \
        | sort -t$'\t' -k2 -n \
        | head -1 \
        | cut -f1)

    # Si SMALLESTVM est vide, utilise Standard_B1s comme valeur par défaut
    echo "Taille sélectionnée : ${SMALLESTVM:-Standard_B1s}"
}

function generateSSHKey(){
    # Crée le dossier SSH-Keys/<vm_name>/ si inexistant (-p évite l'erreur s'il existe déjà)
    mkdir -p "$SSH_DIR"
    chmod 600 "$SSH_DIR"
    # Génère une paire de clés RSA 4096 bits, sans passphrase (-N ""), en mode silencieux (-q)
    ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_PATH" -N "" -q
    # SSH refuse les clés avec des permissions trop ouvertes : 600 = lecture/écriture propriétaire uniquement
    chmod 600 "$SSH_KEY_PATH"
    echo "Clé SSH générée : $SSH_KEY_PATH"
}

function saveVMEnv(){
    # Heredoc : écrit le bloc jusqu'à EOF dans le fichier .env, les variables sont évaluées immédiatement
    cat > "${SSH_DIR}/.env" << EOF
VM_NAME="$VM_NAME"
RESOURCE_GROUP="$RESOURCE_GROUP"
IP="$IP"
ADMIN_USER="$ADMIN_USER"
SSH_KEY_PATH="$SSH_KEY_PATH"
EOF
    echo "Infos VM sauvegardées dans ${SSH_DIR}/.env"
}

function vmCreate(){
    # Fournit la clé publique (.pub) à Azure pour qu'elle soit installée sur la VM à la création
    az vm create \
        --resource-group "$RESOURCE_GROUP" \
        --name "$VM_NAME" \
        --image "$VM_IMAGE" \
        --size "$SMALLESTVM" \
        --admin-username "$ADMIN_USER" \
        --ssh-key-value "${SSH_KEY_PATH}.pub" \
        --output json
}

function catchVMPublicIP(){
    # --show-details charge les infos réseau, --query extrait uniquement l'IP publique du JSON
    # tr -d '\r' supprime les retours chariot (\r) que l'Azure CLI ajoute sous WSL
    IP=$(az vm show \
        --resource-group "$RESOURCE_GROUP" \
        --name "$VM_NAME" \
        --show-details \
        --query "publicIps" \
        --output tsv | tr -d '\r')

    echo "IP de la VM : $IP"
}

function connectVM(){
    # -i indique à SSH quelle clé privée utiliser pour s'authentifier
    ssh -i "$SSH_KEY_PATH" "$ADMIN_USER@$IP"
}

function main(){
    selectSmallestVMSize
    generateSSHKey
    vmCreate
    catchVMPublicIP
    saveVMEnv
    connectVM
}

main
