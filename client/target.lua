local ESX = exports['es_extended']:getSharedObject()

-- Création des zones cibles
CreateThread(function()
    if not Config.EnableTarget then return end
    
    for _, shop in ipairs(Config.SkinShops) do
        exports.ox_target:addBoxZone({
            coords = shop.coords,
            size = vec3(2, 2, 2),
            rotation = 45,
            debug = false,
            options = {
                {
                    name = 'skin_shop',
                    event = shop.event,
                    icon = 'fas fa-user-edit',
                    label = shop.label,
                    distance = Config.TargetDistance
                }
            }
        })
        
        -- Optionnel: Ajouter un blip
        if shop.blip then
            local blip = AddBlipForCoord(shop.coords.x, shop.coords.y, shop.coords.z)
            SetBlipSprite(blip, 365)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 4)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(shop.label)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

-- Commande pour ouvrir le menu skin
RegisterCommand('skinmenu', function()
    TriggerEvent('esx_skin:openSaveableMenu')
    
    if Config.UseOxNotify then
        lib.notify({
            title = 'Menu Skin',
            description = 'Utilisez Q/E pour tourner, molette pour zoomer',
            type = 'info',
            duration = 5000
        })
    else
        ESX.ShowNotification('Utilisez Q/E pour tourner, molette pour zoomer')
    end
end, false)

-- Suggestions de commande
TriggerEvent('chat:addSuggestion', '/skinmenu', 'Ouvrir le menu de personnalisation')
