fx_version 'cerulean'
game 'gta5'

name 'esx_skin'
version '2.0.0'
description 'Système de personnalisation de personnage avec support oxmysql/ox_lib'
author 'ESX-Framework'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua',
    'locales/*.lua'
}

client_scripts {
    'client/main.lua',
    'client/target.lua'  -- Nouveau fichier pour ox_target
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

dependencies {
    'es_extended',
    'skinchanger',
    'oxmysql',
    'ox_lib',
    'ox_target'
}
