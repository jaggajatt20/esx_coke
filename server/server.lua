--Load ESX
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
--Load ESX

--Give Coke
RegisterServerEvent('esx_coke:giveCoke')
AddEventHandler('esx_coke:giveCoke', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.canCarryItem('coke', 1) then
		xPlayer.addInventoryItem('coke', 1)
	else
		xPlayer.showNotification(_U('coke_inventoryfull'))
	end
end)
--Give Coke

--Proccess Coke
RegisterServerEvent('esx_coke:processCoke')
AddEventHandler('esx_coke:processCoke', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xCoke = xPlayer.getInventoryItem('coke')

	local coords = xPlayer.getCoords(true)
	local distance = #(coords - Config.CircleZones.CokeProcessing.coords)

	if distance < 2 then
		if xCoke.count >= 1 then
			if xPlayer.canSwapItem('coke', 1, 'coke_leaf', 1) then
				xPlayer.removeInventoryItem('coke', 1)
				xPlayer.addInventoryItem('coke_leaf', 1)
				xPlayer.showNotification(_U('coke_processed'))
			else
				xPlayer.showNotification(_U('coke_processingfull'))
			end
		else
			xPlayer.showNotification(_U('coke_processingenough'))
		end
	end
end)
--Proccess Coke

--Sell
RegisterServerEvent('esx_coke:sellDrug')
AddEventHandler('esx_coke:sellDrug', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = Config.DrugDealerItems[itemName]
	local xItem = xPlayer.getInventoryItem(itemName)

	if not price then
		print(('esx_coke: %s attempted to sell an invalid drug!'):format(xPlayer.identifier))
		return
	end

	if xItem.count < amount then
		xPlayer.showNotification(_U('dealer_notenough'))
		return
	end

	price = ESX.Math.Round(price * amount)

	if Config.GiveBlack then
		xPlayer.addAccountMoney('black_money', price)
	else
		xPlayer.addMoney(price)
	end

	xPlayer.removeInventoryItem(xItem.name, amount)
	xPlayer.showNotification(_U('dealer_sold', amount, xItem.label, ESX.Math.GroupDigits(price)))
end)
--Sell