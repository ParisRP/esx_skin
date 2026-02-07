local ESX = exports['es_extended']:getSharedObject()
local Skin = {}
local camera = nil
local isCameraActive = false

-- Initialisation
function Skin:init()
    self.firstSpawn = true
    self.zoomOffset = 0.0
    self.camOffset = 0.0
    self.heading = 90.0
    self.customPI = math.pi / 180.0
    self.LastSkin = nil
end

-- Calculs mathématiques pour la caméra
function Skin:CalculateHeading(angle)
    angle = angle % 360
    if angle < 0 then angle = angle + 360 end
    return angle * self.customPI
end

function Skin:CalculatePosition(coords)
    local angle = self.heading * self.customPI
    local theta = {
        x = math.cos(angle),
        y = math.sin(angle),
    }

    local pos = {
        x = coords.x + (self.zoomOffset * theta.x),
        y = coords.y + (self.zoomOffset * theta.y),
        z = coords.z + self.camOffset
    }

    local angleToLook = self:CalculateHeading(self.heading - 140.0)
    local thetaToLook = {
        x = math.cos(angleToLook),
        y = math.sin(angleToLook),
    }

    local posToLook = {
        x = coords.x + (self.zoomOffset * thetaToLook.x),
        y = coords.y + (self.zoomOffset * thetaToLook.y),
        z = coords.z + self.camOffset
    }
    
    return pos, posToLook
end

-- Gestion de la caméra
function Skin:CreateCamera(coords)
    local pos, posToLook = self:CalculatePosition(coords)
    
    if not camera then
        camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    end
    
    SetCamCoord(camera, pos.x, pos.y, pos.z)
    PointCamAtCoord(camera, posToLook.x, posToLook.y, posToLook.z)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 500, true, true)
    isCameraActive = true
end

function Skin:DestroyCamera()
    if camera then
        SetCamActive(camera, false)
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(camera, false)
        camera = nil
        isCameraActive = false
    end
end

-- Contrôles de la caméra
function Skin:HandleControls()
    CreateThread(function()
        while isCameraActive do
            Wait(0)
            
            -- Rotation avec Q/E
            if IsControlPressed(0, 44) then -- Q
                self.heading = self.heading + 0.5
            elseif IsControlPressed(0, 38) then -- E
                self.heading = self.heading - 0.5
            end
            
            -- Zoom avec molette
            local zoomChange = GetControlNormal(0, 14) - GetControlNormal(0, 15)
            if zoomChange ~= 0 then
                self.zoomOffset = self.zoomOffset + (zoomChange * 0.5)
                self.zoomOffset = math.max(0.5, math.min(5.0, self.zoomOffset))
            end
            
            -- Hauteur avec Z/S
            if IsControlPressed(0, 32) then -- Z
                self.camOffset = self.camOffset + 0.01
            elseif IsControlPressed(0, 33) then -- S
                self.camOffset = self.camOffset - 0.01
            end
            
            -- Mise à jour de la caméra
            local coords = GetEntityCoords(PlayerPedId())
            local pos, posToLook = self:CalculatePosition(coords)
            SetCamCoord(camera, pos.x, pos.y, pos.z)
            PointCamAtCoord(camera, posToLook.x, posToLook.y, posToLook.z)
        end
    end)
end

-- Événements
RegisterNetEvent("esx_skin:openMenu", function(submitCb, cancelCb)
    local coords = GetEntityCoords(PlayerPedId())
    Skin:CreateCamera(coords)
    Skin:HandleControls()
    
    -- Interface avec ox_lib
    local input = lib.inputDialog('Menu Skin', {
        {type = 'select', label = 'Type de skin', options = {
            {value = 'default', label = 'Par défaut'},
            {value = 'custom', label = 'Personnalisé'}
        }},
        {type = 'checkbox', label = 'Sauvegarder automatiquement'},
    })
    
    if input then
        if submitCb then submitCb(input) end
    else
        if cancelCb then cancelCb() end
    end
    
    Skin:DestroyCamera()
end)

RegisterNetEvent("esx_skin:openSaveableMenu", function(submitCb, cancelCb)
    TriggerEvent("esx_skin:openMenu", function(data)
        -- Sauvegarde automatique
        TriggerServerEvent("esx_skin:save", exports['skinchanger']:GetSkin())
        if submitCb then submitCb(data) end
    end, cancelCb)
end)

-- Gestion du premier spawn
AddEventHandler("esx:playerLoaded", function(xPlayer, isNew, skin)
    ESX.PlayerLoaded = true
    
    if Skin.firstSpawn then
        ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skinData, jobSkin)
            if not skinData then
                local defaultSkin = { sex = 0 }
                exports["skinchanger"]:LoadSkin(defaultSkin)
            else
                exports["skinchanger"]:LoadSkin(skinData)
            end
            Skin.LastSkin = exports['skinchanger']:GetSkin()
        end)
        
        Skin.firstSpawn = false
    end
    
    TriggerServerEvent("esx_skin:setWeight", skin)
end)

-- Réinitialisation
AddEventHandler("esx_skin:resetFirstSpawn", function()
    Skin.firstSpawn = true
    ESX.PlayerLoaded = false
end)

-- Initialisation
CreateThread(function()
    Skin:init()
end)
