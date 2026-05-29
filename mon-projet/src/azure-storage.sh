#!/bin/bash
# azure-storage.sh — Crée un compte de stockage et uploade server.log

set -e

RESOURCE_GROUP="ntesseyreRG"
LOCATION="francecentral"
STORAGE_ACCOUNT="stnexacloud$RANDOM"
CONTAINER="logs"
FICHIER_LOCAL="ressources/server.log"
FICHIER_BLOB="server.log"

echo "=== Création du compte de stockage Azure ==="

# Créer le compte de stockage
az storage account create \
    --name "$STORAGE_ACCOUNT" \
    --resource-group "$RESOURCE_GROUP" \
    --location "$LOCATION" \
    --sku Standard_LRS \
    --kind StorageV2 \
    --output none

echo "Compte créé : $STORAGE_ACCOUNT"

# Récupérer la clé de connexion
CLE=$(az storage account keys list \
    --resource-group "$RESOURCE_GROUP" \
    --account-name "$STORAGE_ACCOUNT" \
    --query "[0].value" \
    --output tsv)

# Créer un conteneur
az storage container create \
    --name "$CONTAINER" \
    --account-name "$STORAGE_ACCOUNT" \
    --account-key "$CLE" \
    --output none

echo "Conteneur créé : $CONTAINER"

# Uploader server.log
az storage blob upload \
    --container-name "$CONTAINER" \
    --file "$FICHIER_LOCAL" \
    --name "$FICHIER_BLOB" \
    --account-name "$STORAGE_ACCOUNT" \
    --account-key "$CLE" \
    --output none

echo "Fichier uploadé : $FICHIER_BLOB"

# Lister les blobs du conteneur
echo ""
echo "=== Contenu du conteneur ==="
az storage blob list \
    --container-name "$CONTAINER" \
    --account-name "$STORAGE_ACCOUNT" \
    --account-key "$CLE" \
    --output table