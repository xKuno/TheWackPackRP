

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

-- Function for 3D text:
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

function SetVehicleMaxMods(veh)

	local props = {
		modEngine = 2,
		modBrakes = 2,
		modTransmission = 2,
		modSuspension = 3,
		modTurbo = true,
		modArmor = 4,
	}

	ESX.Game.SetVehicleProperties(veh, props)
end

local insideMarker = false
local moneyInEMSBank = false

-- Core Thread Function:
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local coords = GetEntityCoords(PlayerPedId())
		local veh = GetVehiclePedIsIn(PlayerPedId(), false)
		local pedInVeh = IsPedInAnyVehicle(PlayerPedId(), true)
		
		if (ESX.PlayerData.job and ESX.PlayerData.job.name == Config.ambulanceDatabaseName) then
			for k,v in pairs(Config.CarZones) do
				for i = 1, #v.Pos, 1 do
					local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
					if (distance < 10.0) and insideMarker == false then
						DrawMarker(Config.ambulanceCarMarker, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-0.97, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.ambulanceCarMarkerScale.x, Config.ambulanceCarMarkerScale.y, Config.ambulanceCarMarkerScale.y, Config.ambulanceCarMarkerColor.r,Config.ambulanceCarMarkerColor.g,Config.ambulanceCarMarkerColor.b,Config.ambulanceCarMarkerColor.a, false, true, 2, true, false, false, false)						
					end
					if (distance < 2.5 ) and insideMarker == false then
						DrawText3Ds(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, Config.CarDraw3DText)
						if IsControlJustPressed(0, Config.KeyToOpenCarGarage) then
							ambulanceGarage('car')
							insideMarker = true
							Citizen.Wait(500)
						end
					end
				end
			end

			for k,v in pairs(Config.HeliZones) do
				for i = 1, #v.Pos, 1 do
					local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
					if (distance < 10.0) and insideMarker == false then
						DrawMarker(Config.ambulanceHeliMarker, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-0.95, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.ambulanceHeliMarkerScale.x, Config.ambulanceHeliMarkerScale.y, Config.ambulanceHeliMarkerScale.z, Config.ambulanceHeliMarkerColor.r,Config.ambulanceHeliMarkerColor.g,Config.ambulanceHeliMarkerColor.b,Config.ambulanceHeliMarkerColor.a, false, true, 2, true, false, false, false)						
					end
					if (distance < 3.0 ) and insideMarker == false then
						DrawText3Ds(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, Config.HeliDraw3DText)
						if IsControlJustPressed(0, Config.KeyToOpenHeliGarage) then
							ambulanceGarage('helicopter')
							insideMarker = true
							Citizen.Wait(500)
						end
					end
				end
			end

			for k,v in pairs(Config.BoatZones) do
				for i = 1, #v.Pos, 1 do
					local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
					if (distance < 20.0) and insideMarker == false then
						DrawMarker(Config.ambulanceBoatMarker, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.ambulanceBoatMarkerScale.x, Config.ambulanceBoatMarkerScale.y, Config.ambulanceBoatMarkerScale.z, Config.ambulanceBoatMarkerColor.r,Config.ambulanceBoatMarkerColor.g,Config.ambulanceBoatMarkerColor.b,Config.ambulanceBoatMarkerColor.a, false, true, 2, true, false, false, false)						
					end
					if (distance < 3.0 ) and insideMarker == false then
						DrawText3Ds(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, Config.BoatDraw3DText)
						if IsControlJustPressed(0, Config.KeyToOpenBoatGarage) then
							ambulanceGarage('boat')
							insideMarker = true
							Citizen.Wait(500)
						end
					end
				end
			end
		end
	end
end)

-- ambulance Garage Menu:
ambulanceGarage = function(type)
	local elements = {
		{ label = Config.LabelStoreVeh, action = "store_vehicle" },
		{ label = Config.LabelGetVeh, action = "get_vehicle" },
	}
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_ambulanceGarage_menu",
		{
			title    = Config.TitleambulanceGarage,
			align    = "right",
			elements = elements
		},
	function(data, menu)
		menu.close()
		local action = data.current.action
		if action == "get_vehicle" then
			if type == 'car' then
				VehicleMenu('car')
			elseif type == 'helicopter' then
				VehicleMenu('helicopter')
			elseif type == 'boat' then
				VehicleMenu('boat')
			end
		elseif data.current.action == 'store_vehicle' then
			local veh,dist = ESX.Game.GetClosestVehicle(playerCoords)
			if dist < 3 then
				DeleteEntity(veh)
				ESX.ShowNotification(Config.VehicleParked)
			else
				ESX.ShowNotification(Config.NoVehicleNearby)
			end
			insideMarker = false
		end
	end, function(data, menu)
		menu.close()
		insideMarker = false
	end, function(data, menu)
	end)
end

-- Vehicle Spawn Menu:
VehicleMenu = function(type)
	local storage = nil
	local elements = {}
	local ped = PlayerPedId()
	local playerPed = PlayerPedId()
	local pos = GetEntityCoords(ped)
	local emsa = GetHashKey('emsa')
	
	if type == 'car' then
		for k,v in pairs(Config.ambulanceVehicles) do
			table.insert(elements,{label = v.label, name = v.label, model = v.model, price = v.price, type = 'car'})
		end
	elseif type == 'helicopter' then
		for k,v in pairs(Config.ambulanceHelicopters) do
			table.insert(elements,{label = v.label, name = v.label, model = v.model, price = v.price, type = 'helicopter'})
		end
	elseif type == 'boat' then
		for k,v in pairs(Config.ambulanceBoats) do
			table.insert(elements,{label = v.label, name = v.label, model = v.model, price = v.price, type = 'boat'})
		end
	end
		
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_ambulanceGarage_vehicle_garage",
		{
			title    = Config.TitleambulanceGarage,
			align    = "right",
			elements = elements
		},
	function(data, menu)
		menu.close()
		insideMarker = false
		if data.current.model == 'emsa' then
		TriggerServerEvent('log:emscar', data.current.model)
		TriggerEvent("ls:newVehicle", GetPlayerServerId(PlayerId()), GetVehicleNumberPlateText(vehicle), nil)
		VehicleLoadTimer(data.current.model)
		local veh = CreateVehicle(data.current.model,pos.x,pos.y,pos.z,GetEntityHeading(playerPed),true,false)
		SetPedIntoVehicle(PlayerPedId(),veh,-1)
		SetVehicleMaxMods(veh)
		SetVehicleNumberPlateText(veh,plate)
		
		elseif data.current.model ~= 'emsa' then
		TriggerServerEvent('getmoney:emscar')
		Citizen.Wait(1000)
		if moneyInEMSBank then
		moneyInEMSBank = false
		TriggerServerEvent('log:emscar', data.current.model)
		TriggerEvent("ls:newVehicle", GetPlayerServerId(PlayerId()), GetVehicleNumberPlateText(vehicle), nil)
		VehicleLoadTimer(data.current.model)
		local veh = CreateVehicle(data.current.model,pos.x,pos.y,pos.z,GetEntityHeading(playerPed),true,false)
		SetPedIntoVehicle(PlayerPedId(),veh,-1)
		SetVehicleMaxMods(veh)
		SetVehicleNumberPlateText(veh,plate)
		
		if type == 'car' then
            exports['mythic_notify']:SendAlert('inform', 'You took out a vehicle.', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
		elseif type == 'helicopter' then
            exports['mythic_notify']:SendAlert('inform', 'You took out a helicopter.', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
		elseif type == 'boat' then
            exports['mythic_notify']:SendAlert('inform', 'You took out a boat.', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
		end
	end
end
		
		SetVehicleDirtLevel(veh, 0.1)
	end, function(data, menu)
		menu.close()
		insideMarker = false
	end, function(data, menu)
	end)
end

-- Load Timer Function for Vehicle Spawn:
function VehicleLoadTimer(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
			DisableAllControlActions(0)

			drawLoadingText(Config.VehicleLoadText, 255, 255, 255, 255)
		end
	end
end

-- Loading Text for Vehicles Function:
function drawLoadingText(text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(red, green, blue, alpha)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.5)
end

RegisterNetEvent('esx_ambulancejob:hasMoney')
AddEventHandler('esx_ambulancejob:hasMoney', function()
    moneyInEMSBank = true
end)