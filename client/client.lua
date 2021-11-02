local isRecolecting = false
local isProcessing = false
local menuOpen = false
local wasOpen = false

--Load ESX
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)
--Load ESX

--Mayor Job
function IsJobMayor()
    if PlayerData ~= nil then
        local IsJobMayor = false

        if PlayerData.job ~= nil and PlayerData.job.name == 'mayor' then
            IsJobMayor = true
        end

        return IsJobMayor
    end
end
--Mayor Job

--Give Coke
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CokeField.coords, true) < 2 then
			if not isRecolecting then
				ESX.ShowHelpNotification(_U('coke_pickupprompt'))
			end

			if IsControlJustReleased(0, 38) and not isRecolecting then
				GiveCoke()
			end
		end
	end
end)

function GiveCoke()
	while true do
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CokeField.coords, true) < 2 then
			isRecolecting = true
			TriggerServerEvent('esx_coke:giveCoke')
			Citizen.Wait(Config.Delays.CokeRecolecting)
		else
			isRecolecting = false
			ESX.ShowNotification(_U('coke_recolectingtoofar'))
			break
		end
	end
end
--Give Coke

--Proccess Coke
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CokeProcessing.coords, true) < 2 then
			if not isProcessing then
				ESX.ShowHelpNotification(_U('coke_processprompt'))
			end

			if IsControlJustReleased(0, 38) and not isProcessing then
				ProcessCoke()
			end
		end
	end
end)

function ProcessCoke()
	while true do
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CokeProcessing.coords, true) < 2 then
			isProcessing = true
			ESX.ShowNotification(_U('coke_processingstarted'))
			Citizen.Wait(Config.Delays.CokeProcessing)
			TriggerServerEvent('esx_coke:processCoke')
		else
			isProcessing = false
			ESX.ShowNotification(_U('coke_processingtoofar'))
			break
		end
	end
end
--Proccess Coke

--Sell Coke
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.DrugDealer.coords, true) < 2 then
			if not menuOpen then
				ESX.ShowHelpNotification(_U('dealer_prompt'))

				if IsControlJustReleased(0, 38) then
					wasOpen = true
					OpenDrugShop()
				end
			else
				Citizen.Wait(500)
			end
		else
			if wasOpen then
				wasOpen = false
				ESX.UI.Menu.CloseAll()
			end

			Citizen.Wait(500)
		end
	end
end)

function OpenDrugShop()
	ESX.UI.Menu.CloseAll()
	local elements = {}
	menuOpen = true

	for k, v in pairs(ESX.GetPlayerData().inventory) do
		local price = Config.DrugDealerItems[v.name]

		if price and v.count > 0 then
			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(v.label, _U('dealer_item', ESX.Math.GroupDigits(price))),
				name = v.name,
				price = price,

				-- menu properties
				type = 'slider',
				value = v.count,
				min = 1,
				max = v.count
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'drug_shop', {
		title    = _U('dealer_title'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('esx_coke:sellDrug', data.current.name, data.current.value)
	end, function(data, menu)
		menu.close()
		menuOpen = false
	end)
end
--Sell Coke

--Marcadores
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPos = GetEntityCoords(PlayerPedId(), true)

		for k,v in pairs(Config.CircleZones) do
			local CircleZonesPos = v.coords
			local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, CircleZonesPos.x, CircleZonesPos.y, CircleZonesPos.z)

			if distance < Config.DrawDistance then
				DrawMarker(Config.MarkerType, CircleZonesPos.x, CircleZonesPos.y, CircleZonesPos.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerScale.x, Config.MarkerScale.y, Config.MarkerScale.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100,  false, false, 2, false, false, false, false)
			end
		end
	end
end)
--Marcadores

--Blips
Citizen.CreateThread(function()
	Citizen.Wait(1000)

	if IsJobMayor() then
		for k,zone in pairs(Config.CircleZones) do
			CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
		end
	end
end)

function CreateBlipCircle(coords, text, radius, color, sprite)
	local blip = AddBlipForRadius(coords, radius)

	SetBlipHighDetail(blip, true)
	SetBlipColour(blip, 1)
	SetBlipAlpha (blip, 128)

	blip = AddBlipForCoord(coords)

	SetBlipHighDetail(blip, true)
	SetBlipSprite (blip, sprite)
	SetBlipScale  (blip, 0.8)
	SetBlipColour (blip, color)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)
end
--Blips
