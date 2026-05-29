#!/bin/bash

# Source le fichier environnement
source "$(dirname "$0")/.env"

function createKeyVault(){
set -e
# Créer le Key Vault
az keyvault create \
    --name "$KEYVAULT_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --location "$LOCATION"
}

function AddSecretKey(){
# Ajouter un secret
az keyvault secret set \
    --vault-name "$KEYVAULT_NAME" \
    --name "db-password" \
    --value "$DBPassword"
}

function CatchSecret(){
# Récupérer un secret dans un script
SECRET=$(az keyvault secret show \
    --vault-name "$KEYVAULT_NAME" \
    --name "db-password" \
    --query "value" \
    --output tsv)
    echo "Secret récupéré (longueur : ${#SECRET} caractères)"
}

function ListSecret(){
# Lister tous les secrets
az keyvault secret list \
    --vault-name "$KEYVAULT_NAME" \
    --output table
}

function main(){
    createKeyVault
    AddSecretKey
    CatchSecret
    ListSecret
}

main