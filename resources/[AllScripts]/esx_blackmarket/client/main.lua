local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                           = nil
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)

	ESX.TriggerServerCallback('esx_blackmarket:requestDBItems', function(ShopItems)
		for k,v in pairs(ShopItems) do
			Config.Zones[k].Items = v
		end
	end)
end)

function OpenShopMenu(zone)
	local elements = {}
	for i=1, #Config.Zones[zone].Items, 1 do
		local item = Config.Zones[zone].Items[i]

		if item.limit == -1 then
			item.limit = 100
		end

		table.insert(elements, {
			label      = ('%s - <span style="color:green;">%s</span>'):format(item.label, _U('shop_item', ESX.Math.GroupDigits(item.price))),
			label_real = item.label,
			item       = item.item,
			price      = item.price,

			-- menu properties
			value      = 1,
			type       = 'slider',
			min        = 1,
			max        = item.limit
		})
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop', {
		title    = _U('shop'),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title    = _U('shop_confirm', data.current.value, data.current.label_real, ESX.Math.GroupDigits(data.current.price * data.current.value)),
			align    = 'bottom-right',
			elements = {
				{label = _U('no'),  value = 'no'},
				{label = _U('yes'), value = 'yes'}
			}
		}, function(data2, menu2)
			if data2.current.value == 'yes' then
				TriggerServerEvent('esx_blackmarket:buyItem', data.current.item, data.current.value, zone)
			end

			menu2.close()
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_menu')
		CurrentActionData = {zone = zone}
	end)
end

AddEventHandler('esx_blackmarket:hasEnteredMarker', function(zone)

	if zone == "blackmarket" then

		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_menu')
		CurrentActionData = {zone = zone}

	elseif zone == "craftdrill" then

		CurrentAction     = 'craft_drill'
		CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid ta ~y~Drill~s~ besazid."
		CurrentActionData = {zone = zone}

	elseif zone == "craftblowtorch" then

		CurrentAction     = 'craft_blowtorch'
		CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid ta ~y~BlowTorch~s~ besazid."
		CurrentActionData = {zone = zone}

	end

end)

AddEventHandler('esx_blackmarket:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.DrawDistance) then
					DrawMarker(Config.Type, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if(GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.Size.x) then
					isInMarker  = true
					ShopItems   = v.Items
					currentZone = k
					LastZone    = k
				end
			end
		end
		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			
				TriggerEvent('esx_blackmarket:hasEnteredMarker', currentZone)

		end
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_blackmarket:hasExitedMarker', LastZone)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) then
				if CurrentAction == 'shop_menu' then

					OpenShopMenu(CurrentActionData.zone)

				elseif CurrentAction == 'craft_drill' then

						local inventory = ESX.GetPlayerData().inventory
						local mattezakhim = 0
						local drillsharji = 0
						local battrey = 0
						local drill = 0

						for i=1, #inventory, 1 do

							if inventory[i].name == "drillsharji" then
								drillsharji = inventory[i].count
							end

							if inventory[i].name == "mattezakhim" then
								mattezakhim = inventory[i].count
							end

							if inventory[i].name == "battrey" then
								battrey = inventory[i].count
							end

							if inventory[i].name == "drill" then
								drill = inventory[i].count
							end

						end
					
					if mattezakhim > 0 and drillsharji > 0 and battrey > 0 then

						if drill == 0 then

							TriggerEvent("mythic_progbar:client:progress", {
								name = "craft_drill",
								duration = 60000,
								label = "Dar hale sakhtane Drill",
								useWhileDead = false,
								canCancel = true,
								controlDisables = {
									disableMovement = true,
									disableCarMovement = true,
									disableMouse = false,
									disableCombat = true,
								},
								animation = {
									animDict = "missheistdockssetup1clipboard@idle_a",
           							anim = "idle_a",
									}
							}, function(status)
								if not status then
			
									TriggerServerEvent('esx_customItems:remove', "drillsharji")
									TriggerServerEvent('esx_customItems:remove', "mattezakhim")
									TriggerServerEvent('esx_customItems:remove', "battrey")
									TriggerServerEvent('esx_blackmarket:additem', "drill")
									ClearPedTasksImmediately(GetPlayerPed(-1))
						
								elseif status then
		
									ClearPedTasksImmediately(GetPlayerPed(-1))
		
								end
							end)

						else

							ESX.ShowNotification("Shoma fazaye ~r~khali~s~ baraye ~y~Drill~s~ nadarid!")

						end

					else

						ESX.ShowNotification("~r~Shoma vasayel kafi baraye sakht ~y~drill ~r~nadarid")

					end

				elseif CurrentAction == 'craft_blowtorch' then

						local inventory = ESX.GetPlayerData().inventory
						local loole = 0
						local fanar = 0
						local capsul = 0
						local lighter = 0
						local lockpick = 0
						local blowtorch = 0

						for i=1, #inventory, 1 do

							if inventory[i].name == "loole" then
								loole = inventory[i].count
							end

							if inventory[i].name == "fanar" then
								fanar = inventory[i].count
							end

							if inventory[i].name == "capsul" then
								capsul= inventory[i].count
							end

							if inventory[i].name == "lighter" then
								lighter = inventory[i].count
							end

							if inventory[i].name == "lockpick" then
								lockpick= inventory[i].count
							end

							if inventory[i].name == "blowtorch" then
								blowtorch = inventory[i].count
							end

						end
					
					if loole > 0 and fanar > 0 and capsul > 0 and lighter > 0 and lockpick > 0 then

						if blowtorch == 0 then

							TriggerEvent("mythic_progbar:client:progress", {
								name = "craft_blowtorch",
								duration = 10000,
								label = "Dar hale sakhtane BlowTorch",
								useWhileDead = false,
								canCancel = true,
								controlDisables = {
									disableMovement = true,
									disableCarMovement = true,
									disableMouse = false,
									disableCombat = true,
								},
								animation = {
									animDict = "missheistdockssetup1clipboard@idle_a",
           							anim = "idle_a",
									}
							}, function(status)
								if not status then
			
									TriggerServerEvent('esx_customItems:remove', "loole")
									TriggerServerEvent('esx_customItems:remove', "fanar")
									TriggerServerEvent('esx_customItems:remove', "capsul")
									TriggerServerEvent('esx_customItems:remove', "lighter")
									TriggerServerEvent('esx_customItems:remove', "lockpick")
									TriggerServerEvent('esx_blackmarket:additem', "blowtorch")
									ClearPedTasksImmediately(GetPlayerPed(-1))
						
								elseif status then
		
									ClearPedTasksImmediately(GetPlayerPed(-1))
		
								end
							end)
						
						else

							ESX.ShowNotification("Shoma fazaye ~r~khali~s~ baraye ~y~BlowTorch~s~ nadarid!")
						
						end

					else

						ESX.ShowNotification("~r~Shoma vasayel kafi baraye sakht ~y~blowtorch ~r~nadarid")

					end

				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)