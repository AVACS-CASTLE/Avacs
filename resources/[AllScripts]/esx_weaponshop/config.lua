Config               = {}

Config.DrawDistance  = 100
Config.Size          = { x = 1.5, y = 1.5, z = 1.2 }
Config.Color         = { r = 255, g = 0, b = 0 }
Config.Type          = 21

Config.Locale        = 'en'

Config.LicenseEnable = true -- only turn this on if you are using esx_license
Config.LicensePrice  = 20000

Config.Zones = {

	GunShop = {
		Legal = true,
		Items = {},
		Locations = {
			vector3(-662.1, -935.3, 21.8),
			vector3(810.2, -2157.3, 29.6),
			vector3(1693.4, 3759.5, 34.7),
			vector3(-330.2, 6083.8, 31.4),
			vector3(252.3, -50.0, 69.9),
			vector3(22.0, -1107.2, 29.8),
			vector3(2567.6, 294.3, 108.7),
			vector3(-1117.5, 2698.6, 18.5),
			vector3(842.4, -1033.4, 28.1)
		}
	},

	BlackWeashop = {
		Legal = true,
		Items = {},
		Locations = {
			vector3(-1306.2, -394.0, 35.6)
		}
	}

}
