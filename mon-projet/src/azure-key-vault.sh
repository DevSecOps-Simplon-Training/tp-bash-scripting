#!/bin/bash
KEYVAULT_NAME="kv-nexacloud-$RANDOM"

# Créer le Key Vault
az keyvault create \
    --name "$KEYVAULT_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --location "$LOCATION"

# Ajouter un secret
az keyvault secret set \
    --vault-name "$KEYVAULT_NAME" \
    --name "db-password" \
    --value "MonMotDePasse123!"

# Récupérer un secret dans un script
SECRET=$(az keyvault secret show \
    --vault-name "$KEYVAULT_NAME" \
    --name "db-password" \
    --query "value" \
    --output tsv)

echo "Secret récupéré (longueur : ${#SECRET} caractères)"

# Lister tous les secrets
az keyvault secret list \
    --vault-name "$KEYVAULT_NAME" \
    --output table