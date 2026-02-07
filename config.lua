Config = {}

Config.Locale = GetConvar("esx:locale", "en")

-- Poids des sacs selon le modèle
Config.BackpackWeight = {
    [40] = 16,  -- Sac à dos 1
    [41] = 20,  -- Sac à dos 2
    [44] = 25,  -- Sac militaire
    [45] = 23,  -- Sac de sport
}

-- Options de personnalisation
Config.EnablePeds = true  -- Activer les modèles de PNJ
Config.EnableTarget = true  -- Activer ox_target
Config.TargetDistance = 2.0  -- Distance d'interaction
Config.UseOxNotify = true  -- Utiliser ox_lib pour les notifications

-- Positions des miroirs/salons (exemple)
Config.SkinShops = {
    {
        coords = vector3(132.0, -1711.0, 29.0),
        label = "Salon de beauté",
        event = "esx_skin:openSaveableMenu"
    }
}
