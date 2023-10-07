fx_version 'adamant'

game 'gta5'

Author 'https://github.com/ledepede1/'
description 'Pede juvelrøveri'

version '1.0'

lua54 'yes'

shared_scripts {
  '@ox_lib/init.lua',
  'Configs/Config.lua',
}

client_scripts {
  'Client/Client.lua',
}

server_scripts {
  'Server/Server.lua',
}
