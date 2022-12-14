ESX = nil
GiveDirty = true


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('Payout')
AddEventHandler('Payout', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer == xPlayer then
		xPlayer.addInventoryItem('aluminium', math.random(5, 10))
		xPlayer.addInventoryItem('radio', 1)
		xPlayer.addInventoryItem('battery', 1)
		xPlayer.addInventoryItem('wheel_rim', math.random(3,4))
		xPlayer.addInventoryItem('airbag', 2)
		price = math.random(1000,100000) 
		if GiveDirty ~= false then
			xPlayer.addMoney(price)
		else
			xPlayer.addMoney(price)
		end
	end
end)

ScrapTraderPrices = {
    aluminium = 100,
    airbag = 250,
    radio = 600,
    wheel_rim = 300,
    battery = 440,
}

RegisterServerEvent('sellScrap')
AddEventHandler('sellScrap', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = ScrapTraderPrices[itemName]
	local xItem = xPlayer.getInventoryItem(itemName)

	if not price then
		print(('esx_chopshop %s attempted to sell an invalid item!'):format(xPlayer.identifier))
		return
	end

	if xItem.count < amount then
		xPlayer.showNotification("~r~You do not have enough of this item.")
		return
	end

	price = ESX.Math.Round(price * amount)

	if GiveDirty then
		xPlayer.addMoney(price)
	else
		xPlayer.addMoney(price)
	end

	xPlayer.removeInventoryItem(xItem.name, amount)
	xPlayer.showNotification('you\'ve sold ~b~'..amount..'x~s~ ~y~'..xItem.name..'~s~ for ~g~$'..price..'~s~', amount, xItem.label, ESX.Math.GroupDigits(price))
end)
