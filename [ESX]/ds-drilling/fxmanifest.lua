fx_version 'cerulean'
games { 'gta5' }

description 'ds-drilling'
version '1.0.0'

shared_scripts {
    'config.lua',
}

client_scripts {
    'client/*.lua',
}
server_scripts {
    'server/platform.lua',
    'server/*.lua',
}
files {
    'html/*.html',
    'html/*.png',
    'html/static/**/*',
    'Platforms.json'
} 

ui_page 'html/index.html'

escrow_ignore {
    'config.lua',
    'client/standalone.lua',
    'server/standalone.lua',
    'Platforms.json'
}

lua54 'yes'

