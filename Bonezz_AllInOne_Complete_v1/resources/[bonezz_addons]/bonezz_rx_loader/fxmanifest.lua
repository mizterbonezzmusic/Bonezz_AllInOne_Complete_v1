fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'mizterbonezzmusic'
description 'Bonezz Rx Loader - merges items.lua into QBCore.Shared.Items at runtime'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

dependencies { 'qb-core' }
