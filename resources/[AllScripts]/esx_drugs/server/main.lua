ESX = nil
local playersProcessing = {}
local DrugHandeler
local DrugPrices = {
	marijuana = 0,
	crack = 0,
	cocaine = 0,
	heroine = 0,
	meth = 0
}

-- exports.ghmattimysql:execute('SELECT * FROM capture WHERE name = "drug"', {}
-- , function(drug)
-- 	DrugHandeler = 'gang_' .. string.lower(drug[1].handeler)
-- end)

RegisterServerEvent('drug:ChangeHandeler')
AddEventHandler('drug:ChangeHandeler', function(newHandler)
	DrugHandeler = 'gang_' .. string.lower(newHandler)
	exports.ghmattimysql:execute('UPDATE capture SET handeler = @handeler WHERE name = "drug"', {
		['@handeler']	= newHandler
	})
end)

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- function CountCops()

-- 	local xPlayers = ESX.GetPlayers()

-- 	CopsConnected = 0

-- 	for i=1, #xPlayers, 1 do
-- 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
-- 		if xPlayer.job.name == 'police' then
-- 			CopsConnected = CopsConnected + 1
-- 		end
-- 	end

-- 	SetTimeout(120 * 1000, CountCops)
-- end

RegisterServerEvent('esx_jk_drugsirs:pickedUpCannabis')
AddEventHandler('esx_jk_drugsirs:pickedUpCannabis', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('cannabis')

	if Config.MultiPlant then
		local picked = math.random(3)
		if xItem.limit ~= -1 and (xItem.count + picked) > xItem.limit then
			TriggerClientEvent('esx:showNotification', _source, _U('weed_inventoryfull'))
		else
			xPlayer.addInventoryItem(xItem.name, picked)
		end
	elseif xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('weed_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

ESX.RegisterServerCallback('esx_jk_drugsirs:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(item)

	if xItem.limit ~= -1 and xItem.count >= xItem.limit then
		cb(false)
	else
		cb(true)
	end
end)

RegisterServerEvent('esx_jk_drugsirs:pickedUpCocaPlant')
AddEventHandler('esx_jk_drugsirs:pickedUpCocaPlant', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('coca')
	local multi = true

	if multi then
		local picked = math.random(3)
		if xItem.limit ~= -1 and (xItem.count + picked) > xItem.limit then
			TriggerClientEvent('esx:showNotification', _source, _U('cocaine_inventoryfull'))
		else
			xPlayer.addInventoryItem(xItem.name, picked)
		end
	elseif xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('cocaine_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

RegisterServerEvent('esx_jk_drugsirs:pickedUpEphedra')
AddEventHandler('esx_jk_drugsirs:pickedUpEphedra', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('ephedra')

	if Config.MultiPlant then
		local picked = math.random(3)
		if xItem.limit ~= -1 and (xItem.count + picked) > xItem.limit then
			TriggerClientEvent('esx:showNotification', _source, _U('ephedra_inventoryfull'))
		else
			xPlayer.addInventoryItem(xItem.name, picked)
		end
	elseif xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('ephedra_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

RegisterServerEvent('esx_jk_drugsirs:pickedUpPoppy')
AddEventHandler('esx_jk_drugsirs:pickedUpPoppy', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('poppy')

	if Config.MultiPlant then
		local picked = math.random(3)
		if xItem.limit ~= -1 and (xItem.count + picked) > xItem.limit then
			TriggerClientEvent('esx:showNotification', _source, _U('opium_inventoryfull'))
		else
			xPlayer.addInventoryItem(xItem.name, picked)
		end
	elseif xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('opium_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
	end
end)

RegisterServerEvent('esx_jk_drugsirs:processCannabis')
AddEventHandler('esx_jk_drugsirs:processCannabis', function()
	if not playersProcessing[source] then
		local _source = source

			local xPlayer = ESX.GetPlayerFromId(_source)

		if xPlayer then

			local xCannabis, xMarijuana = xPlayer.getInventoryItem('cannabis'), xPlayer.getInventoryItem('marijuana')

			if xMarijuana.limit ~= -1 and (xMarijuana.count + 1) >= xMarijuana.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('weed_processingfull'))
			elseif xCannabis.count < 1 then
				TriggerClientEvent('esx:showNotification', _source, _U('weed_processingenough'))
			else
				xPlayer.removeInventoryItem('cannabis', 1)
				xPlayer.addInventoryItem('marijuana', 5)

				TriggerClientEvent('esx:showNotification', _source, _U('weed_processed'))
			end
			TriggerEvent('esx_jk_drugsirs:processCannabis', _source)

			playersProcessing[_source] = nil

		end

	else
		print(('esx_jk_drugsirs: %s attempted to exploit weed processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

function CancelProcessing(playerID)
	if playersProcessing[playerID] then
		ESX.ClearTimeout(playersProcessing[playerID])
		playersProcessing[playerID] = nil
	end
end

RegisterServerEvent('esx_jk_drugsirs:processCocaPlant')
AddEventHandler('esx_jk_drugsirs:processCocaPlant', function()
	if not playersProcessing[source] then
		local _source = source

			local xPlayer = ESX.GetPlayerFromId(_source)
			local xCocaPlant, xCocaine = xPlayer.getInventoryItem('coca'), xPlayer.getInventoryItem('cocaine')

			if xCocaine.limit ~= -1 and (xCocaine.count + 1) >= xCocaine.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('cocaine_processingfull'))
			elseif xCocaPlant.count >= 3 then
				xPlayer.removeInventoryItem('coca', 3)
				xPlayer.addInventoryItem('cocaine', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('cocaine_processed'))
			else
				TriggerClientEvent('esx:showNotification', _source, _U('cocaine_processingenough'))
			end

			playersProcessing[_source] = nil

	else
		print(('esx_jk_drugsirs: %s attempted to exploit cocaine processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

RegisterServerEvent('esx_jk_drugsirs:processEphedra')
AddEventHandler('esx_jk_drugsirs:processEphedra', function()
	if not playersProcessing[source] then
		local _source = source

			local xPlayer = ESX.GetPlayerFromId(_source)
			local xEphedra, xEphedrine = xPlayer.getInventoryItem('ephedra'), xPlayer.getInventoryItem('ephedrine')

			if xEphedrine.limit ~= -1 and (xEphedrine.count + 1) >= xEphedrine.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('ephedrine_processingfull'))
			elseif xEphedra.count < 1 then
				TriggerClientEvent('esx:showNotification', _source, _U('ephedrine_processingenough'))
			else
				xPlayer.removeInventoryItem('ephedra', 1)
				xPlayer.addInventoryItem('ephedrine', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('ephedrine_processed'))
			end

			playersProcessing[_source] = nil
	else
		print(('esx_jk_drugsirs: %s attempted to exploit ephedrine processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

RegisterServerEvent('esx_jk_drugsirs:processEphedrine')
AddEventHandler('esx_jk_drugsirs:processEphedrine', function()
	if not playersProcessing[source] then
		local _source = source

			local xPlayer = ESX.GetPlayerFromId(_source)
			local xEphedrine, xMeth = xPlayer.getInventoryItem('ephedrine'), xPlayer.getInventoryItem('meth')

			if xMeth.limit ~= -1 and (xMeth.count + 1) >= xMeth.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('meth_processingfull'))
			elseif xEphedrine.count < 1 then
				TriggerClientEvent('esx:showNotification', _source, _U('meth_processingenough'))
			else
				xPlayer.removeInventoryItem('ephedrine', 2)
				xPlayer.addInventoryItem('meth', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('meth_processed'))
			end

			playersProcessing[_source] = nil
	else
		print(('esx_jk_drugsirs: %s attempted to exploit meth processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

RegisterServerEvent('esx_jk_drugsirs:processCoke')
AddEventHandler('esx_jk_drugsirs:processCoke', function()
	if not playersProcessing[source] then
		local _source = source

			local xPlayer = ESX.GetPlayerFromId(_source)
			local xCocaine, xCrack = xPlayer.getInventoryItem('cocaine'), xPlayer.getInventoryItem('crack')

			if xCrack.limit ~= -1 and (xCrack.count + 1) >= xCrack.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('crack_processingfull'))
			elseif xCocaine.count < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('crack_processingenough'))
			else
				xPlayer.removeInventoryItem('cocaine', 2)
				xPlayer.addInventoryItem('crack', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('crack_processed'))
			end

			playersProcessing[_source] = nil

	else
		print(('esx_jk_drugsirs: %s attempted to exploit meth processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

RegisterServerEvent('esx_jk_drugsirs:processPoppy')
AddEventHandler('esx_jk_drugsirs:processPoppy', function()
	if not playersProcessing[source] then
		local _source = source

			local xPlayer = ESX.GetPlayerFromId(_source)
			local xPoppy, xOpium = xPlayer.getInventoryItem('poppy'), xPlayer.getInventoryItem('opium')

			if xOpium.limit ~= -1 and (xOpium.count + 1) >= xOpium.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('opium_processingfull'))
			elseif xPoppy.count < 2 then
				TriggerClientEvent('esx:showNotification', _source, _U('opium_processingenough'))
			else
				xPlayer.removeInventoryItem('poppy', 2)
				xPlayer.addInventoryItem('opium', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('opium_processed'))
			end

			playersProcessing[_source] = nil
	else
		print(('esx_jk_drugsirs: %s attempted to exploit Opium processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

RegisterServerEvent('esx_jk_drugsirs:processOpium')
AddEventHandler('esx_jk_drugsirs:processOpium', function()
	if not playersProcessing[source] then
		local _source = source

			local xPlayer = ESX.GetPlayerFromId(_source)
			local xOpium, xHeroine = xPlayer.getInventoryItem('opium'), xPlayer.getInventoryItem('heroine')

			if xHeroine.limit ~= -1 and (xHeroine.count + 1) >= xHeroine.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('heroine_processingfull'))
			elseif xOpium.count < 5 then
				TriggerClientEvent('esx:showNotification', _source, _U('heroine_processingenough'))
			else
				xPlayer.removeInventoryItem('opium', 5)
				xPlayer.addInventoryItem('heroine', 1)

				TriggerClientEvent('esx:showNotification', _source, _U('heroine_processed'))
			end

			playersProcessing[_source] = nil

	else
		print(('esx_jk_drugsirs: %s attempted to exploit Heroine processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

RegisterServerEvent('esx_jk_drugsirs:cancelProcessing')
AddEventHandler('esx_jk_drugsirs:cancelProcessing', function()
	CancelProcessing(source)
end)

-- RegisterServerEvent('esx_jk_drugsirs:restrictedArea')
-- AddEventHandler('esx_jk_drugsirs:restrictedArea', function()
-- 	local _source = source
-- 	local xPlayers = ESX.GetPlayers()

-- 	for i=1, #xPlayers, 1 do
-- 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

-- 		if xPlayer.job.name == 'police' then
-- 			TriggerClientEvent('esx:showNotification', xPlayers[i], (_U('restricted_zone')))
-- 		end
-- 	end
-- end)

-- RegisterServerEvent('esx_jk_drugsirs:testResultsFail')
-- AddEventHandler('esx_jk_drugsirs:testResultsFail', function()
-- 	local _source = source
-- 	local xPlayers = ESX.GetPlayers()

-- 	for i=1, #xPlayers, 1 do
-- 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

-- 		if xPlayer.job.name == 'police' then
-- 			TriggerClientEvent('esx:showNotification', xPlayers[i], (_U('drug_fail')))
-- 		end
-- 	end
-- end)

-- RegisterServerEvent('esx_jk_drugsirs:testResultsFailTipsy')
-- AddEventHandler('esx_jk_drugsirs:testResultsFailTipsy', function()
-- 	local _source = source
-- 	local xPlayers = ESX.GetPlayers()

-- 	for i=1, #xPlayers, 1 do
-- 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

-- 		if xPlayer.job.name == 'police' then
-- 			TriggerClientEvent('esx:showNotification', xPlayers[i], (_U('fail_tipsy')))
-- 		end
-- 	end
-- end)

-- RegisterServerEvent('esx_jk_drugsirs:testResultsFailDrunk')
-- AddEventHandler('esx_jk_drugsirs:testResultsFailDrunk', function()
-- 	local _source = source
-- 	local xPlayers = ESX.GetPlayers()

-- 	for i=1, #xPlayers, 1 do
-- 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

-- 		if xPlayer.job.name == 'police' then
-- 			TriggerClientEvent('esx:showNotification', xPlayers[i], (_U('fail_drunk')))
-- 		end
-- 	end
-- end)

-- RegisterServerEvent('esx_jk_drugsirs:testResultsPass')
-- AddEventHandler('esx_jk_drugsirs:testResultsPass', function()
-- 	local _source = source
-- 	local xPlayers = ESX.GetPlayers()

-- 	for i=1, #xPlayers, 1 do
-- 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

-- 		if xPlayer.job.name == 'police' then
-- 			TriggerClientEvent('esx:showNotification', xPlayers[i], (_U('drug_pass')))
-- 		end
-- 	end
-- end)

-- RegisterServerEvent('esx_jk_drugsirs:testResultsPassBCA')
-- AddEventHandler('esx_jk_drugsirs:testResultsPassBCA', function()
-- 	local _source = source
-- 	local xPlayers = ESX.GetPlayers()

-- 	for i=1, #xPlayers, 1 do
-- 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

-- 		if xPlayer.job.name == 'police' then
-- 			TriggerClientEvent('esx:showNotification', xPlayers[i], (_U('bca_pass')))
-- 		end
-- 	end
-- end)

-- RegisterServerEvent('esx_jk_drugsirs:policeAlert')
-- AddEventHandler('esx_jk_drugsirs:policeAlert', function()
-- 	local _source = source
-- 	local xPlayers = ESX.GetPlayers()

-- 	for i=1, #xPlayers, 1 do
-- 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

-- 		if xPlayer.job.name == 'police' then
-- 			TriggerClientEvent('esx:showNotification', xPlayers[i], (_U('police_alert')))
-- 		end
-- 	end
-- end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)

ESX.RegisterServerCallback('esx_jk_drugsirs:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

RegisterServerEvent('esx_jk_drugsirs:removeItem')
AddEventHandler('esx_jk_drugsirs:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem(item, 1)
end)

RegisterServerEvent('esx_jk_drugsirs:giveItem')
AddEventHandler('esx_jk_drugsirs:giveItem', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(itemName)
	local count = 1

	if xItem.limit ~= -1 then
		count = xItem.limit - xItem.count
	end

	if xItem.count < xItem.limit then
		xPlayer.addInventoryItem(itemName, count)
	else
		TriggerClientEvent('esx:showNotification', source, "You're at maximum items")
	end
end)

RegisterServerEvent('esx_drugs:sellDrug')
AddEventHandler('esx_drugs:sellDrug', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = DrugPrices[itemName]
	local xItem = xPlayer.getInventoryItem(itemName)

	if not price then
		print(('esx_drugs: %s attempted to sell an invalid drug!'):format(xPlayer.identifier))
		return
	end

	if xItem.count < amount then
		TriggerClientEvent('esx:showNotification', source, _U('dealer_notenough'))
		return
	end

	price = ESX.Math.Round(price * amount)

	xPlayer.addMoney(price)

	xPlayer.removeInventoryItem(xItem.name, amount)

	-- TriggerEvent('gangaccount:getGangAccount', DrugHandeler, function(account)
	-- 	account.addMoney(price)
	-- end)

	TriggerClientEvent('esx:showNotification', source, _U('dealer_sold', amount, xItem.label, ESX.Math.GroupDigits(price)))
end)

ESX.RegisterUsableItem('marijuana', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('marijuana', 1)

		TriggerClientEvent('esx_jk_drugsirs:useItem', source, 'marijuana')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('cocaine', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('cocaine', 1)

		TriggerClientEvent('esx_jk_drugsirs:useItem', source, 'cocaine')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('crack', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('crack', 1)

		TriggerClientEvent('esx_jk_drugsirs:useItem', source, 'crack')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('meth', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('meth', 1)

		TriggerClientEvent('esx_jk_drugsirs:useItem', source, 'meth')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('heroine', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('heroine', 1)

		TriggerClientEvent('esx_jk_drugsirs:useItem', source, 'heroine')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('drugtest', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('drugtest', 1)

		TriggerClientEvent('esx_jk_drugsirs:useItem', source, 'drugtest')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('fakepee', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('fakepee', 1)

		TriggerClientEvent('esx_jk_drugsirs:useItem', source, 'fakepee')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('beer', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('beer', 1)

		TriggerClientEvent('esx_jk_drugsirs:useItem', source, 'beer')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('tequila', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('tequila', 1)

		TriggerClientEvent('esx_jk_drugsirs:useItem', source, 'tequila')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('vodka', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('vodka', 1)

		TriggerClientEvent('esx_jk_drugsirs:useItem', source, 'vodka')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('whiskey', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('whiskey', 1)

		TriggerClientEvent('esx_jk_drugsirs:useItem', source, 'whiskey')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('breathalyzer', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('breathalyzer', 1)

		TriggerClientEvent('esx_jk_drugsirs:useItem', source, 'breathalyzer')

		Citizen.Wait(1000)
end)

--==================Kose shers Eclipse====================
AddEventHandler('esx:playerLoaded', function(source)
	TriggerClientEvent('esx_jk_drugsirs:getPrice', source, DrugPrices)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		restartPrices()
	end
end)

function restartPrices()
	DrugPrices.marijuana = math.random(200, 300)
	DrugPrices.crack = math.random(5000, 5500)
	DrugPrices.cocaine = math.random(2500, 2700)
	DrugPrices.heroine = math.random(30000, 35000)
	DrugPrices.meth = math.random(7900, 8200)

	for _, id in pairs(GetPlayers()) do
		TriggerClientEvent('esx_jk_drugsirs:getPrice', id, DrugPrices)
	end


  	SetTimeout(3600000, restartPrices)
end

restartPrices()
