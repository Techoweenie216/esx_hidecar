fx_version 'adamant'

game 'gta5'

description 'Hide your stolen Cars'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua'
}

client_scripts {
	'client/main.lua'
}
