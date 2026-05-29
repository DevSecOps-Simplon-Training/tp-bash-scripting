#!/bin/bash
# Ce script permet de créer un compte de stockage et uploade server.log

set -e

RESOURCE_GROUP="mpetitRG"
LOCATION="francecentral"
STORAGE_ACCOUNT="mpstorageaccount$RANDOM"
CONTAINER="logs"
FICHIER_LOCAL="ressources/server.log"
FICHIER_BLOB="server.log"

create_storage_account() {
    echo "=== Creation du compte de stockage Azure ==="
    az storage account create \
        --name "$STORAGE_ACCOUNT" \
        --resource-group "$RESOURCE_GROUP" \
        --location "$LOCATION" \
        --sku Standard_LRS \
        --kind StorageV2 \
        --output none
    echo "Compte cree : $STORAGE_ACCOUNT"
}

get_storage_key() {
    az storage account keys list \
        --resource-group "$RESOURCE_GROUP" \
        --account-name "$STORAGE_ACCOUNT" \
        --query "[0].value" \
        --output tsv
}

create_container() {
    local cle="$1"
    az storage container create \
        --name "$CONTAINER" \
        --account-name "$STORAGE_ACCOUNT" \
        --account-key "$cle" \
        --output none
    echo "Conteneur créé : $CONTAINER"
}

upload_blob() {
    local cle="$1"
    az storage blob upload \
        --container-name "$CONTAINER" \
        --file "$FICHIER_LOCAL" \
        --name "$FICHIER_BLOB" \
        --account-name "$STORAGE_ACCOUNT" \
        --account-key "$cle" \
        --output none
    echo "Fichier uploadé : $FICHIER_BLOB"
}

list_blobs() {
    local cle="$1"
    echo ""
    echo "=== Contenu du conteneur ==="
    az storage blob list \
        --container-name "$CONTAINER" \
        --account-name "$STORAGE_ACCOUNT" \
        --account-key "$cle" \
        --output table
}

main() {
    create_storage_account
    CLE=$(get_storage_key)
    create_container "$CLE"
    upload_blob "$CLE"
    list_blobs "$CLE"
}

main
