RESOURCE_GROUP="ntesseyreRG"
VM_NAME="vm-nexacloud-tp"
VM_IMAGE="Ubuntu2204"
VM_SIZE="Standard_D2s_v3"

# Créer une VM avec clé SSH générée automatiquement
az vm create \
    --resource-group "$RESOURCE_GROUP" \
    --name "$VM_NAME" \
    --image "$VM_IMAGE" \
    --size "$VM_SIZE" \
    --location "swedencentral" \
    --admin-username "debian" \
    --generate-ssh-keys \
    --output json

# Récupérer l'IP publique
IP=$(az vm show \
    --resource-group "$RESOURCE_GROUP" \
    --name "$VM_NAME" \
    --show-details \
    --query "publicIps" \
    --output tsv)

echo "IP de la VM : $IP"