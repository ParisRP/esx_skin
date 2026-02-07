
# ESX Skin - Documentation

## Fonctionnalités ajoutées
1. Support oxmysql pour les requêtes SQL
2. Intégration ox_lib pour les dialogues et notifications
3. Support ox_target pour l'interaction
4. Système de caméra amélioré
5. Localisation avec ox_lib
6. Commandes admin améliorées

## Installation
1. Placer dans le dossier `resources/[esx]`
2. Lancer la requête SQL fournie
3. Ajouter `ensure esx_skin` dans server.cfg
4. Configurer les paramètres dans config.lua

## Commandes
- `/skinmenu` - Ouvrir le menu de personnalisation
- `/skin [playerId]` (admin) - Ouvrir le menu pour un joueur

## API Serveur
```lua
TriggerClientEvent('esx_skin:openSaveableMenu', playerId)
TriggerEvent('esx_skin:save', skinData)
