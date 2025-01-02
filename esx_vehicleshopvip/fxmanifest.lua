fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'ESX VIP Vehicle Shop'
version '1.0.0'

shared_script '@es_extended/imports.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server/main.lua'
}

client_scripts {
    'config.lua',
    'client/main.lua'
}

dependency 'es_extended'
