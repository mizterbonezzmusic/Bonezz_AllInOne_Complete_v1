fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'mizterbonezzmusic'
description 'Corrupt Cops - LEO can broker illegal deals; chance for shootout & gang intervention'

shared_scripts { 'config.lua' }
client_scripts { 'client.lua' }
server_scripts { '@oxmysql/lib/MySQL.lua', 'server.lua' }

dependencies { 'qb-core' }
