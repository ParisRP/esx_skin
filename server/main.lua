ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent("esx_skin:save", function(skin)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    if not skin or type(skin) ~= "table" then
        return lib.notify(src, {
            title = 'Erreur',
            description = 'Données de skin invalides',
            type = 'error'
        })
    end

    -- Gestion du poids avec sac à dos
    if not ESX.GetConfig().CustomInventory then
        local defaultMaxWeight = ESX.GetConfig().MaxWeight
        local backpackModifier = Config.BackpackWeight[skin.bags_1]
        
        local newWeight = defaultMaxWeight
        if backpackModifier then
            newWeight = defaultMaxWeight + backpackModifier
        end
        
        xPlayer.setMaxWeight(newWeight)
    end

    -- Sauvegarde dans la base de données
    MySQL.update('UPDATE users SET skin = ? WHERE identifier = ?', {
        json.encode(skin),
        xPlayer.identifier
    })
    
    -- Log avec ox_lib
    lib.logger(xPlayer.identifier, 'saveSkin', 'Skin sauvegardé pour le joueur')
    
    lib.notify(src, {
        title = 'Succès',
        description = 'Apparence sauvegardée',
        type = 'success'
    })
end)

RegisterNetEvent("esx_skin:setWeight", function(skin)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then return end
    
    if not ESX.GetConfig().CustomInventory and skin then
        local defaultMaxWeight = ESX.GetConfig().MaxWeight
        local backpackModifier = Config.BackpackWeight[skin.bags_1]
        
        local newWeight = defaultMaxWeight
        if backpackModifier then
            newWeight = defaultMaxWeight + backpackModifier
        end
        
        xPlayer.setMaxWeight(newWeight)
    end
end)

ESX.RegisterServerCallback("esx_skin:getPlayerSkin", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then
        cb(nil, {})
        return
    end

    MySQL.single('SELECT skin FROM users WHERE identifier = ?', {xPlayer.identifier}, function(result)
        local skin = nil
        local jobSkin = {
            skin_male = xPlayer.getJob().skin_male,
            skin_female = xPlayer.getJob().skin_female,
        }

        if result and result.skin then
            skin = json.decode(result.skin)
        end

        cb(skin, jobSkin)
    end)
end)

-- Nouvelle commande admin avec ox_lib
ESX.RegisterCommand("skin", "admin", function(xPlayer, args, showError)
    local target = args.playerId or xPlayer.source
    
    TriggerClientEvent("esx_skin:openSaveableMenu", target)
    
    lib.notify(xPlayer.source, {
        title = 'Admin',
        description = 'Menu skin ouvert pour le joueur',
        type = 'info'
    })
end, false, { 
    help = 'Ouvrir le menu skin', 
    arguments = {
        { 
            name = 'playerId', 
            help = 'ID du joueur', 
            type = 'player' 
        }
    }
})

-- Événement pour réinitialiser le skin
RegisterNetEvent("esx_skin:resetSkin", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if xPlayer then
        exports['skinchanger']:LoadSkin({ sex = 0 }, src)
        MySQL.update('UPDATE users SET skin = NULL WHERE identifier = ?', {xPlayer.identifier})
        
        lib.notify(src, {
            title = 'Skin réinitialisé',
            description = 'Votre apparence a été réinitialisée',
            type = 'success'
        })
    end
end)
