# TP Bash — Scripting et automatisation

**Durée estimée :** 6h  
**Prérequis :** savoir utiliser `cd`, `ls`, lancer Python et npm, avoir Git installé  
**Environnement :**
- macOS / Linux → Terminal natif
- Windows → **Git Bash** (déjà installé avec Git — chercher "Git Bash" dans le menu Démarrer)

---

## Objectifs de la journée

À la fin de ce TP vous saurez naviguer dans le terminal, manipuler des fichiers, écrire des scripts Bash réutilisables et automatiser des tâches répétitives comme le font les équipes DevOps en production.

---

## Mise en place

```bash
# Cloner le repo du TP
git clone <url-fournie>
cd TP-Bash-Scripting

# Vérifier que vous êtes bien dans le dossier
pwd
ls
```

Le dossier `ressources/` contient un fichier `server.log` que vous utiliserez tout au long du TP.

---

## Étape 1 — Le terminal : navigation et fichiers (45 min)

### Concept

Le terminal est une interface textuelle pour donner des ordres à votre système. Chaque commande suit la même logique :

```
commande  [options]  [cible]
```

### Commandes essentielles

| Commande | Rôle | Exemple |
|----------|------|---------|
| `pwd` | Afficher le dossier courant | `pwd` |
| `ls` | Lister les fichiers | `ls -la` |
| `mkdir` | Créer un dossier | `mkdir mon-dossier` |
| `touch` | Créer un fichier vide | `touch notes.txt` |
| `cp` | Copier | `cp fichier.txt copie.txt` |
| `mv` | Déplacer / renommer | `mv ancien.txt nouveau.txt` |
| `rm` | Supprimer | `rm fichier.txt` |
| `cat` | Afficher le contenu | `cat notes.txt` |
| `echo` | Afficher du texte | `echo "Bonjour"` |
| `clear` | Vider le terminal | `clear` |

> **Astuce :** La touche `Tab` complète automatiquement les noms de fichiers et dossiers.  
> **Astuce :** La flèche `↑` rappelle la dernière commande.

---

### Exercice 1.1 — Créer une arborescence de projet

Créez la structure suivante **uniquement avec des commandes Bash** (pas de clic droit) :

```
mon-projet/
├── src/
│   └── app.sh
├── logs/
│   └── app.log
├── config/
│   └── settings.txt
└── README.txt
```

**Instructions :**
1. Créez le dossier `mon-projet` et déplacez-vous dedans
2. Créez les sous-dossiers `src`, `logs`, `config`
3. Créez les fichiers vides dans chaque dossier
4. Écrivez `# Mon projet Bash` dans `README.txt` avec `echo`
5. Vérifiez votre arborescence avec `ls -la` dans chaque dossier

---

### Exercice 1.2 — Manipuler les fichiers

```bash
# 1. Copiez server.log depuis le dossier ressources/ vers votre dossier logs/
cp ressources/server.log mon-projet/logs/

# 2. Renommez la copie en app.log
mv mon-projet/logs/server.log mon-projet/logs/app.log

# 3. Affichez le contenu de app.log
cat mon-projet/logs/app.log

# 4. Créez une deuxième copie nommée app.log.bak
cp mon-projet/logs/app.log mon-projet/logs/app.log.bak

# 5. Listez le dossier logs/ pour vérifier
ls -lh mon-projet/logs/
```

---

### Pour aller plus loin — Étape 1

```bash
# Afficher l'arborescence complète (si tree est installé)
tree mon-projet/

# Connaître la taille d'un fichier
du -h mon-projet/logs/app.log

# Afficher les 10 derniers fichiers modifiés dans le dossier courant
ls -lt | head -10

# Créer plusieurs dossiers en une seule commande
mkdir -p projet/{src,tests,docs,logs}
```

---

## Étape 2 — Lire, filtrer et rediriger (45 min)

### Concept

En DevOps on manipule constamment des fichiers de logs, de config, de résultats. Les outils de filtrage et les **redirections** sont essentiels.

### Commandes de lecture et filtrage

| Commande | Rôle | Exemple |
|----------|------|---------|
| `cat` | Tout afficher | `cat server.log` |
| `head -n 5` | 5 premières lignes | `head -n 5 server.log` |
| `tail -n 5` | 5 dernières lignes | `tail -n 5 server.log` |
| `tail -f` | Suivre en temps réel | `tail -f server.log` |
| `grep "mot"` | Chercher un mot | `grep "ERROR" server.log` |
| `grep -i "mot"` | Sans tenir compte de la casse | `grep -i "error" server.log` |
| `grep -c "mot"` | Compter les occurrences | `grep -c "ERROR" server.log` |
| `wc -l` | Compter les lignes | `wc -l server.log` |
| `sort` | Trier | `sort noms.txt` |
| `uniq` | Supprimer les doublons | `sort noms.txt \| uniq` |

### Redirections et pipes

```bash
# > redirige la sortie vers un fichier (écrase)
echo "Bonjour" > fichier.txt

# >> ajoute à la fin du fichier
echo "Monde" >> fichier.txt

# | (pipe) envoie la sortie d'une commande vers une autre
grep "ERROR" server.log | wc -l
```

---

### Exercice 2.1 — Analyser server.log

Travaillez avec le fichier `ressources/server.log` et répondez aux questions suivantes **avec une commande Bash** :

```bash
# 1. Combien de lignes contient server.log ?

# 2. Affichez uniquement les 5 premières lignes

# 3. Affichez uniquement les 3 dernières lignes

# 4. Combien de lignes contiennent le mot ERROR ?

# 5. Affichez toutes les lignes WARNING

# 6. Affichez toutes les lignes CRITICAL

# 7. Combien d'erreurs ET de critiques y a-t-il au total ?
#    (indice : grep -E "ERROR|CRITICAL")
```

---

### Exercice 2.2 — Générer un rapport dans un fichier

```bash
# 1. Créez un fichier rapport.txt qui contient :
#    - Le titre "=== RAPPORT DE LOGS ==="
#    - Le nombre total de lignes
#    - Le nombre d'erreurs
#    - Le nombre de warnings
#    - Le nombre de critiques
#    Utilisez >> pour construire le fichier ligne par ligne

# 2. Affichez le contenu de rapport.txt pour vérifier

# 3. Extrayez uniquement les lignes ERROR dans un fichier erreurs.txt
grep "ERROR" ressources/server.log > erreurs.txt
cat erreurs.txt
```

---

### Pour aller plus loin — Étape 2

```bash
# Afficher les lignes qui contiennent ERROR mais pas Azure
grep "ERROR" ressources/server.log | grep -v "Azure"

# Extraire uniquement le niveau de log (4e champ) de chaque ligne
cut -d' ' -f3 ressources/server.log | sort | uniq -c

# Chercher un mot dans tous les fichiers .log du dossier
grep -r "CRITICAL" ressources/

# Afficher le numéro de ligne avec chaque résultat
grep -n "ERROR" ressources/server.log
```

---

## Étape 3 — Variables et conditions (1h)

### Concept

Un script Bash, c'est une suite de commandes enregistrées dans un fichier `.sh`. On ajoute des **variables** pour stocker des valeurs et des **conditions** pour prendre des décisions.

### Variables

```bash
# Déclarer une variable (pas d'espace autour du =)
NOM="NexaCloud"
PORT=5001

# Utiliser une variable (toujours avec $)
echo "Projet : $NOM"
echo "Port : $PORT"

# Variable de commande (résultat d'une commande)
NB_ERREURS=$(grep -c "ERROR" ressources/server.log)
echo "Nombre d'erreurs : $NB_ERREURS"

# Variables spéciales
echo "Nom du script : $0"
echo "Premier argument : $1"
echo "Nombre d'arguments : $#"
```

### Conditions

```bash
if [ condition ]; then
    # commandes si vrai
elif [ autre_condition ]; then
    # commandes si autre condition
else
    # commandes si faux
fi
```

**Opérateurs de comparaison :**

| Opérateur | Signification | Exemple |
|-----------|--------------|---------|
| `-eq` | égal (nombres) | `[ $A -eq $B ]` |
| `-ne` | différent (nombres) | `[ $A -ne $B ]` |
| `-gt` | supérieur | `[ $A -gt 5 ]` |
| `-lt` | inférieur | `[ $A -lt 10 ]` |
| `-z` | chaîne vide | `[ -z "$VAR" ]` |
| `-f` | fichier existe | `[ -f "fichier.txt" ]` |
| `-d` | dossier existe | `[ -d "dossier/" ]` |
| `=` | égal (chaînes) | `[ "$A" = "$B" ]` |

---

### Exercice 3.1 — Premier script avec variables

Créez le fichier `mon-projet/src/info.sh` :

```bash
#!/bin/bash
# info.sh — Affiche des informations sur l'environnement

NOM_PROJET="NexaCloud"
VERSION="1.1.0"
LOG_FILE="ressources/server.log"

echo "==============================="
echo "  Projet   : $NOM_PROJET"
echo "  Version  : $VERSION"
echo "==============================="

# Vérifier que le fichier de log existe
if [ -f "$LOG_FILE" ]; then
    NB_LIGNES=$(wc -l < "$LOG_FILE")
    echo "  Log      : $LOG_FILE ($NB_LIGNES lignes)"
else
    echo "  Log      : fichier introuvable !"
fi

echo "==============================="
```

Rendez le script exécutable et lancez-le :
```bash
chmod +x mon-projet/src/info.sh
./mon-projet/src/info.sh
```

---

### Exercice 3.2 — Script avec conditions sur les logs

Créez `mon-projet/src/check-logs.sh` :

```bash
#!/bin/bash
# check-logs.sh — Vérifie l'état des logs et alerte si nécessaire

LOG_FILE="ressources/server.log"
SEUIL_ERREURS=3

if [ ! -f "$LOG_FILE" ]; then
    echo "ERREUR : le fichier $LOG_FILE n'existe pas."
    exit 1
fi

NB_ERREURS=$(grep -c "ERROR" "$LOG_FILE")
NB_CRITIQUES=$(grep -c "CRITICAL" "$LOG_FILE")
NB_WARNINGS=$(grep -c "WARNING" "$LOG_FILE")

echo "=== Analyse de $LOG_FILE ==="
echo "  INFO     : $(grep -c "INFO" "$LOG_FILE")"
echo "  WARNING  : $NB_WARNINGS"
echo "  ERROR    : $NB_ERREURS"
echo "  CRITICAL : $NB_CRITIQUES"
echo "==========================="

# Vérifier le seuil d'erreurs
if [ $NB_CRITIQUES -gt 0 ]; then
    echo "ALERTE CRITIQUE : $NB_CRITIQUES incident(s) critique(s) détecté(s) !"
elif [ $NB_ERREURS -gt $SEUIL_ERREURS ]; then
    echo "ATTENTION : $NB_ERREURS erreurs détectées (seuil : $SEUIL_ERREURS)"
else
    echo "OK : les logs sont dans les normes."
fi
```

```bash
chmod +x mon-projet/src/check-logs.sh
./mon-projet/src/check-logs.sh
```

---

### Pour aller plus loin — Étape 3

```bash
# Passer le fichier de log en argument du script
# Modifier check-logs.sh pour utiliser $1 comme chemin du fichier
# Appel : ./check-logs.sh ressources/server.log

# Vérifier que l'argument est bien fourni
if [ -z "$1" ]; then
    echo "Usage : $0 <fichier.log>"
    exit 1
fi

# Tester plusieurs conditions avec &&  et ||
[ -f "$LOG_FILE" ] && echo "Fichier trouvé" || echo "Fichier absent"
```

---

## Étape 4 — Boucles et fonctions (1h)

### Les boucles

```bash
# Boucle for sur une liste
for FRUIT in pomme poire cerise; do
    echo "Fruit : $FRUIT"
done

# Boucle for sur des fichiers
for FICHIER in *.log; do
    echo "Traitement de $FICHIER"
done

# Boucle for numérique
for i in $(seq 1 5); do
    echo "Itération $i"
done

# Boucle while
COMPTEUR=0
while [ $COMPTEUR -lt 3 ]; do
    echo "Compteur : $COMPTEUR"
    COMPTEUR=$((COMPTEUR + 1))
done
```

### Les fonctions

```bash
# Déclarer une fonction
ma_fonction() {
    echo "Bonjour depuis la fonction"
    echo "Argument reçu : $1"
}

# Appeler la fonction
ma_fonction "NexaCloud"

# Fonction qui retourne une valeur
compter_erreurs() {
    local fichier="$1"
    grep -c "ERROR" "$fichier"
}

NB=$(compter_erreurs "ressources/server.log")
echo "Erreurs : $NB"
```

> **Astuce :** `local` dans une fonction crée une variable locale — elle n'existe que dans la fonction.

---

### Exercice 4.1 — Boucle sur les niveaux de log

Créez `mon-projet/src/analyse-niveaux.sh` :

```bash
#!/bin/bash
# analyse-niveaux.sh — Compte chaque niveau de log

LOG_FILE="ressources/server.log"

echo "=== Analyse par niveau ==="

for NIVEAU in INFO WARNING ERROR CRITICAL; do
    NB=$(grep -c "$NIVEAU" "$LOG_FILE")
    echo "  $NIVEAU : $NB occurrence(s)"
done

echo "=========================="
echo "  TOTAL : $(wc -l < "$LOG_FILE") lignes"
```

```bash
chmod +x mon-projet/src/analyse-niveaux.sh
./mon-projet/src/analyse-niveaux.sh
```

---

### Exercice 4.2 — Script avec fonctions

Créez `mon-projet/src/rapport.sh` :

```bash
#!/bin/bash
# rapport.sh — Génère un rapport complet avec des fonctions

LOG_FILE="${1:-ressources/server.log}"
RAPPORT="mon-projet/logs/rapport-$(date +%Y%m%d-%H%M%S).txt"

# ── Fonctions ──────────────────────────────────────────────────────

afficher_titre() {
    echo "==========================================="
    echo "  $1"
    echo "==========================================="
}

compter_niveau() {
    local niveau="$1"
    local fichier="$2"
    grep -c "$niveau" "$fichier" 2>/dev/null || echo 0
}

ecrire_section() {
    local titre="$1"
    local contenu="$2"
    echo "" >> "$RAPPORT"
    echo "--- $titre ---" >> "$RAPPORT"
    echo "$contenu" >> "$RAPPORT"
}

# ── Script principal ───────────────────────────────────────────────

if [ ! -f "$LOG_FILE" ]; then
    echo "Fichier introuvable : $LOG_FILE"
    exit 1
fi

afficher_titre "RAPPORT D'ANALYSE — $(date '+%d/%m/%Y %H:%M')"

INFO=$(compter_niveau "INFO" "$LOG_FILE")
WARNING=$(compter_niveau "WARNING" "$LOG_FILE")
ERROR=$(compter_niveau "ERROR" "$LOG_FILE")
CRITICAL=$(compter_niveau "CRITICAL" "$LOG_FILE")

echo "  INFO     : $INFO"
echo "  WARNING  : $WARNING"
echo "  ERROR    : $ERROR"
echo "  CRITICAL : $CRITICAL"

# Écrire le rapport dans un fichier
echo "RAPPORT D'ANALYSE — $(date '+%d/%m/%Y %H:%M')" > "$RAPPORT"
ecrire_section "Compteurs" "INFO=$INFO  WARNING=$WARNING  ERROR=$ERROR  CRITICAL=$CRITICAL"
ecrire_section "Incidents critiques" "$(grep 'CRITICAL' "$LOG_FILE")"
ecrire_section "Erreurs" "$(grep 'ERROR' "$LOG_FILE")"

echo ""
echo "Rapport sauvegardé : $RAPPORT"
```

```bash
chmod +x mon-projet/src/rapport.sh
./mon-projet/src/rapport.sh
```

---

### Pour aller plus loin — Étape 4

```bash
# Traiter plusieurs fichiers de log en argument
for FICHIER in "$@"; do
    echo "=== Traitement de $FICHIER ==="
    grep -c "ERROR" "$FICHIER"
done
# Appel : ./script.sh logs/app.log logs/backup.log

# Boucle avec break et continue
for i in $(seq 1 10); do
    [ $i -eq 5 ] && continue   # sauter le 5
    [ $i -eq 8 ] && break      # arrêter au 8
    echo $i
done
```

---

## Étape 5 — Script DevOps complet (1h30)

### Concept

En production, les scripts DevOps automatisent des tâches répétitives : vérifier l'environnement, installer les dépendances, analyser les logs, déployer. Vous allez construire ce script **progressivement**, bloc par bloc.

### Deux notions à retenir avant de commencer

**1. `set -e` — arrêter le script si une commande échoue**
```bash
#!/bin/bash
set -e   # Si une commande retourne une erreur, le script s'arrête immédiatement
         # Sans ça, le script continue même en cas d'erreur silencieuse
```

**2. Les couleurs dans le terminal**

Les codes couleur ANSI permettent d'afficher du texte coloré. Vous n'avez pas à les mémoriser — copiez cette section au début de vos scripts :

```bash
VERT="\033[0;32m"
ROUGE="\033[0;31m"
JAUNE="\033[0;33m"
CYAN="\033[0;36m"
RESET="\033[0m"   # Remet la couleur par défaut — TOUJOURS finir avec ça

# echo -e active l'interprétation des codes couleur
echo -e "${VERT}Tout va bien${RESET}"
echo -e "${ROUGE}Erreur détectée${RESET}"
```

---

### Exercice 5.1 — Fonctions d'affichage coloré

Avant d'écrire un grand script, créez des fonctions d'affichage réutilisables. C'est ce que font tous les scripts DevOps professionnels.

Créez `mon-projet/src/couleurs.sh` et **complétez les parties manquantes** :

```bash
#!/bin/bash
# couleurs.sh — Tester les fonctions d'affichage

# Les codes couleur sont fournis
VERT="\033[0;32m"
ROUGE="\033[0;31m"
JAUNE="\033[0;33m"
CYAN="\033[0;36m"
RESET="\033[0m"

# Ces fonctions sont déjà écrites — observez leur structure
ok()   { echo -e "${VERT}[OK]${RESET}   $1"; }
info() { echo -e "${CYAN}[INFO]${RESET} $1"; }

# TODO: écrivez les fonctions warn() et err() sur le même modèle
# warn() doit afficher en jaune avec le préfixe [WARN]
# err()  doit afficher en rouge avec le préfixe [ERR]



# Test — ces lignes doivent afficher chacune dans la bonne couleur
ok   "Installation réussie"
info "Démarrage du serveur..."
warn "Mémoire basse : 78%"
err  "Connexion échouée"
```

> 💡 **Indice :** regardez comment `ok()` et `info()` sont écrites — vos fonctions `warn()` et `err()` ont exactement la même structure, seule la couleur et le préfixe changent.

```bash
chmod +x mon-projet/src/couleurs.sh
./mon-projet/src/couleurs.sh
```

**Résultat attendu :** chaque ligne s'affiche dans une couleur différente avec son préfixe entre crochets.

---

### Exercice 5.2 — Script de vérification de l'environnement

Créez `mon-projet/src/check-env.sh` à partir de ce squelette. **Complétez les blocs marqués TODO :**

```bash
#!/bin/bash
# check-env.sh — Vérifie que l'environnement est prêt pour NexaCloud

set -e

VERT="\033[0;32m"
ROUGE="\033[0;31m"
JAUNE="\033[0;33m"
RESET="\033[0m"

ok()   { echo -e "${VERT}  [OK]${RESET}   $1"; }
warn() { echo -e "${JAUNE}  [WARN]${RESET} $1"; }
err()  { echo -e "${ROUGE}  [ERR]${RESET}  $1"; }

# Cette fonction vérifie si une commande est installée
# $1 = nom de la commande  |  $2 = nom à afficher (optionnel)
verifier_commande() {
    local cmd="$1"
    local nom="${2:-$1}"
    # La commande "command -v" vérifie si un programme existe
    # &>/dev/null redirige la sortie pour ne rien afficher
    if command -v "$cmd" &>/dev/null; then
        ok "$nom installé"
    else
        err "$nom non trouvé"
    fi
}

echo ""
echo "=== Vérification de l'environnement NexaCloud ==="
echo ""

# TODO: appelez verifier_commande pour tester python3, node, npm et git
# Exemple : verifier_commande "python3" "Python"



echo ""

# TODO: vérifiez que ces deux fichiers existent avec [ -f ]
# et affichez ok ou warn selon le résultat
# Fichiers à vérifier : "config.json" et "ressources/server.log"



echo ""
echo "=== Vérification terminée ==="
echo ""
```

> 💡 **Indice :** pour la vérification des fichiers, vous avez déjà utilisé `[ -f "$FICHIER" ]` à l'étape 3. La logique est identique — si le fichier existe → `ok`, sinon → `warn`.

```bash
chmod +x mon-projet/src/check-env.sh
./mon-projet/src/check-env.sh
```

---

### Exercice 5.3 — Assembler le script de setup complet

Vous avez maintenant toutes les briques. Créez `setup.sh` **à la racine du repo** en assemblant ce que vous avez appris.

Le squelette ci-dessous vous donne la structure et les parties techniques complexes. **À vous de remplir la logique de chaque section :**

```bash
#!/bin/bash
# setup.sh — Prépare le projet NexaCloud en une commande

set -e

VERT="\033[0;32m"
ROUGE="\033[0;31m"
CYAN="\033[0;36m"
BOLD="\033[1m"
RESET="\033[0m"

info() { echo -e "${CYAN}[INFO]${RESET} $1"; }
ok()   { echo -e "${VERT}[OK]${RESET}   $1"; }
warn() { echo -e "${JAUNE}[WARN]${RESET} $1"; }
err()  { echo -e "${ROUGE}[ERR]${RESET}  $1"; exit 1; }

# ── Bannière (fournie) ────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${CYAN}============================================${RESET}"
echo -e "${BOLD}${CYAN}   SETUP NEXACLOUD — $(date '+%d/%m/%Y %H:%M')${RESET}"
echo -e "${BOLD}${CYAN}============================================${RESET}"
echo ""

# ── 1. Vérification des prérequis ─────────────────────────────────────
info "Vérification des prérequis..."

# TODO: vérifiez que python3, node et npm sont installés
# Si l'une des commandes est absente, appelez err() pour stopper le script
# Indice : command -v python3 &>/dev/null vérifie si python3 existe
# Indice : l'opérateur || execute la commande à droite si celle de gauche échoue



ok "Prérequis : Python3, Node.js, npm présents"

# ── 2. Installation des dépendances Python ────────────────────────────
info "Installation des dépendances Python..."

# TODO: vérifiez si le fichier python-api/requirements.txt existe
# Si oui  → lancez pip install -r python-api/requirements.txt --quiet
#            puis affichez ok()
# Si non  → affichez warn() pour prévenir sans bloquer



# ── 3. Installation des dépendances Node ─────────────────────────────
info "Installation des dépendances Node..."

# TODO: même logique pour node-client/package.json
# Si le fichier existe → cd node-client && npm install --silent && cd ..
# Indice : en Bash, on peut chaîner des commandes avec &&



# ── 4. Analyse des logs ───────────────────────────────────────────────
info "Analyse des logs..."
LOG="ressources/server.log"

# TODO: vérifiez que $LOG existe, puis :
# - comptez les ERROR avec grep -c et stockez dans NB_ERR
# - comptez les CRITICAL avec grep -c et stockez dans NB_CRIT
# - affichez ok() avec les deux compteurs
# - si NB_CRIT > 0, affichez un message d'alerte rouge
#   et listez les lignes CRITICAL avec grep + une boucle while



# ── 5. Message de fin (fourni) ────────────────────────────────────────
echo ""
echo -e "${BOLD}${VERT}============================================${RESET}"
echo -e "${BOLD}${VERT}   SETUP TERMINÉ AVEC SUCCÈS              ${RESET}"
echo -e "${BOLD}${VERT}============================================${RESET}"
echo ""
echo "  Lancer l'API Python  : cd python-api && python3 app.py"
echo "  Lancer le client Node: cd node-client && node app.js"
echo ""
```

```bash
chmod +x setup.sh
./setup.sh
```

> 💡 **Rappels utiles :**
> - Tester si un fichier existe : `[ -f "chemin/fichier" ]`
> - Compter des occurrences : `$(grep -c "MOT" "$FICHIER")`
> - Comparer des nombres : `[ $NB -gt 0 ]`
> - Lire ligne par ligne : `grep "MOT" "$FICHIER" | while read -r ligne; do ... done`

---

### Pour aller plus loin — Étape 5

```bash
# Créer un fichier .env pour stocker la configuration
echo "PORT=5001" > .env
echo "ENV=development" >> .env

# Charger les variables du .env dans le script
# (grep ignore les lignes commentées, xargs les exporte)
export $(grep -v '^#' .env | xargs)
echo "Port configuré : $PORT"
```

---

## BONUS — Azure CLI et automatisation cloud (1h)

> Cette section nécessite un accès Azure actif. Si ce n'est pas le cas, lisez les commandes et simulez les résultats attendus.

### Prérequis

```bash
# Vérifier que Azure CLI est installé
az --version

# Se connecter à Azure
az login

# Vérifier le compte actif
az account show

# Sélectionner un abonnement si vous en avez plusieurs
az account set --subscription "Nom ou ID de l'abonnement"
```

---

### Bonus 1 — Créer et gérer des ressources avec Azure CLI

```bash
# Variables réutilisables
RESOURCE_GROUP="rg-nexacloud-tp"
LOCATION="francecentral"
STORAGE_ACCOUNT="stnexacloud$RANDOM"   # Nom unique obligatoire

# Créer un resource group
az group create \
    --name "$RESOURCE_GROUP" \
    --location "$LOCATION"

# Lister les resource groups
az group list --output table

# Vérifier que le groupe a été créé
az group show --name "$RESOURCE_GROUP" --query "properties.provisioningState"
```

---

### Bonus 2 — Script Azure : créer un compte de stockage et uploader un fichier

Créez `mon-projet/src/azure-storage.sh` :

```bash
#!/bin/bash
# azure-storage.sh — Crée un compte de stockage et uploade server.log

set -e

RESOURCE_GROUP="rg-nexacloud-tp"
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
```

```bash
chmod +x mon-projet/src/azure-storage.sh
./mon-projet/src/azure-storage.sh
```

---

### Bonus 3 — Azure Key Vault : gérer des secrets

```bash
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
```

---

### Bonus 4 — Connexion à une VM Azure en SSH

```bash
VM_NAME="vm-nexacloud-tp"
VM_IMAGE="Ubuntu2204"
VM_SIZE="Standard_B1s"

# Créer une VM avec clé SSH générée automatiquement
az vm create \
    --resource-group "$RESOURCE_GROUP" \
    --name "$VM_NAME" \
    --image "$VM_IMAGE" \
    --size "$VM_SIZE" \
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

# Se connecter en SSH
ssh azureuser@$IP

# Sur la VM : exécuter des commandes Bash
# ls /home/azureuser
# cat /etc/os-release
```

> **Nettoyage :** Pour supprimer toutes les ressources créées et éviter des coûts :
> ```bash
> az group delete --name "$RESOURCE_GROUP" --yes --no-wait
> ```


---

*Formation DevSecOps Azure — Simplon*
