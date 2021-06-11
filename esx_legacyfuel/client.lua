local isNearPump = false
local pumpLocation = nil
local isFueling = false
local currentFuel = 0.0
local currentFuel2 = 0.0
local currentCost = 0.0

local output = nil
RegisterNetEvent('vrp_legacyfuel2:LixeiroCB')
AddEventHandler('vrp_legacyfuel2:LixeiroCB', function(ret)
    output = ret
end)

function close()
	SetNuiFocus(false, false)
	SendNUIMessage({ action = false })
	isFueling = false
end

function open(vehicle,data)
	SetNuiFocus(true, true)
	SendNUIMessage({ action = true, fuel = GetVehicleFuelLevel(vehicle), data = data })
end

AddEventHandler('onResourceStart', function(name)
    if GetCurrentResourceName() ~= name then return end
    close()
end)

RegisterNUICallback('escape', function(data, cb)
    close()
end)

RegisterNetEvent('vrp_legacyfuel2:close')
AddEventHandler('vrp_legacyfuel2:close',function()
	close()
end)

function ManageFuelUsage(vehicle)
	if IsVehicleEngineOn(vehicle) then
		SetVehicleFuelLevel(vehicle,GetVehicleFuelLevel(vehicle) - Config.FuelUsage[Round(GetVehicleCurrentRpm(vehicle),1)] * (Config.Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
		DecorSetFloat(vehicle,Config.FuelDecor,GetVehicleFuelLevel(vehicle))
	end
end

Citizen.CreateThread(function()
	DecorRegister(Config.FuelDecor,1)
	while true do
		Citizen.Wait(5000)
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)
			if GetPedInVehicleSeat(vehicle,-1) == ped then
				ManageFuelUsage(vehicle)
                TriggerServerEvent('setfuellevel', NetworkGetNetworkIdFromEntity(vehicle),GetVehicleFuelLevel(vehicle))
			end
		end
	end
end)

-- Citizen.CreateThread(function()
--     while true do
--         if IsPedGettingIntoAVehicle(PlayerPedId()) then
--             Wait(3000)
--             ESX.TriggerServerCallback("syncfuelserver", function(fuellevel)
--                 SetVehicleFuelLevel(GetVehiclePedIsIn(PlayerPedId(),false),fuellevel)
--                 print(fuellevel)
--             end, NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(PlayerPedId(),false)))
--         end
--         Wait(0)
--     end
-- end)

function FindNearestFuelPump()
	local coords = GetEntityCoords(PlayerPedId())
	local fuelPumps = {}
	local handle,object = FindFirstObject()
	local success

	repeat
		if Config.PumpModels[GetEntityModel(object)] then
			table.insert(fuelPumps,object)
		end

		success,object = FindNextObject(handle,object)
	until not success

	EndFindObject(handle)

	local pumpObject = 0
	local pumpDistance = 1000

	for k,v in pairs(fuelPumps) do
		local dstcheck = GetDistanceBetweenCoords(coords,GetEntityCoords(v))

		if dstcheck < pumpDistance then
			pumpDistance = dstcheck
			pumpObject = v
		end
	end
	return pumpObject,pumpDistance
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local pumpObject,pumpDistance = FindNearestFuelPump()
		if pumpDistance < 2.0 then
			pumpLocation = nil
			for k,v in pairs(Config.GasStationOwner) do
				if GetDistanceBetweenCoords(vector3(v[1],v[2],v[3]),GetEntityCoords(pumpObject)) <= v[4] then
					pumpLocation = k
				end
			end
			isNearPump = pumpObject
		else
			isNearPump = false
			Citizen.Wait(math.ceil(pumpDistance*20))
		end
	end
end)

RegisterNetEvent("syncfuel")
AddEventHandler("syncfuel",function(index,change,FuelDecor)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			SetVehicleFuelLevel(v,(GetVehicleFuelLevel(v) + change))
			DecorSetFloat(v,FuelDecor,GetVehicleFuelLevel(v))
		end
	end
end)

RegisterNetEvent("admfuel")
AddEventHandler("admfuel",function(index,vehicle,fuel)
	local vehicle = GetPlayersLastVehicle()
	if vehicle then
		currentFuel = 100.0
		SetVehicleFuelLevel(vehicle,currentFuel)
	end
end)

RegisterNetEvent('vrp_legacyfuel2:galao')
AddEventHandler('vrp_legacyfuel2:galao',function()
	GiveWeaponToPed(PlayerPedId(),883325847,4500,false,true)
end)

function Round(num,numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num*mult+0.5) / mult
end

AddEventHandler('fuel:refuelFromPump',function(pumpObject,ped,vehicle)
	currentFuel = GetVehicleFuelLevel(vehicle)
	TaskTurnPedToFaceEntity(ped,vehicle,5000)
	LoadAnimDict("timetable@gardener@filling_can")
	TaskPlayAnim(ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",2.0,8.0,-1,50,0,0,0,0)

	Citizen.Wait(2000)

	if GetIsVehicleEngineRunning(vehicle) then
		NetworkExplodeVehicle(vehicle, true, false, 0)

		local cord = GetEntityCoords(PlayerPedId())
		local streetName, _ = GetStreetNameAtCoord(cord[1], cord[2], cord[3])
		local streetName = GetStreetNameFromHashKey(streetName)
		local zone = tostring(GetNameOfZone(cord[1], cord[2], cord[3]))
		local area = GetLabelText(zone)
	
		exports['wp_dispatch']:addCall("10-31", "Explosion Reported At", {
			{icon = "fas fa-road", info = streetName ..", ".. area}
		}, {cord[1], cord[2], cord[3]}, "police", 3000, 486, 1)
		exports['wp_dispatch']:addCall("10-31", "Explosion Reported At", {
			{icon = "fas fa-road", info = streetName ..", ".. area}
		}, {cord[1], cord[2], cord[3]}, "ambulance", 3000, 486, 1)
		exports['wp_dispatch']:addCall("10-31", "Explosion Reported At", {
			{icon = "fas fa-road", info = streetName ..", ".. area}
		}, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 486, 1)
	else
		while isFueling do
			Citizen.Wait(4)
			local oldFuel = DecorGetFloat(vehicle,Config.FuelDecor)
			local fuelToAdd = math.random(1,2) / 100.0

			for k,v in pairs(Config.DisableKeys) do
				DisableControlAction(0,v)
			end

			local vehicleCoords = GetEntityCoords(vehicle)
			if not pumpObject then
				DrawText3Ds(vehicleCoords.x,vehicleCoords.y,vehicleCoords.z + 0.5,"PRESS ~g~E ~w~TO CANCEL")
				DrawText3Ds(vehicleCoords.x,vehicleCoords.y,vehicleCoords.z + 0.34,"GALLON: ~b~"..Round(GetAmmoInPedWeapon(ped,883325847) / 4500 * 100,1).."%~w~    TANK: ~y~"..Round(currentFuel,1).."%")
				if GetAmmoInPedWeapon(ped,883325847) - fuelToAdd * 100 >= 0 then
					currentFuel = oldFuel + fuelToAdd
					SetPedAmmo(ped,883325847,math.floor(GetAmmoInPedWeapon(ped,883325847) - fuelToAdd * 100))
				else
					isFueling = false
				end
			end

			if not IsEntityPlayingAnim(ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",3) then
				TaskPlayAnim(ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",2.0,8.0,-1,50,0,0,0,0)
			end

			if currentFuel > 100.0 then
				currentFuel = 100.0
				isFueling = false
			end

			SetVehicleFuelLevel(vehicle,currentFuel)
			DecorSetFloat(vehicle,Config.FuelDecor,GetVehicleFuelLevel(vehicle))

			if IsControlJustReleased(0,38) or DoesEntityExist(GetPedInVehicleSeat(vehicle,-1)) then
				isFueling = false
			end
		end

		ClearPedTasks(ped)
		RemoveAnimDict("timetable@gardener@filling_can")
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local ped = PlayerPedId()
		while not isFueling and ((isNearPump and GetEntityHealth(isNearPump) > 0) or (GetSelectedPedWeapon(ped) == 883325847 and not isNearPump)) do
			if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped),-1) == ped then
				local pumpCoords = GetEntityCoords(isNearPump)
				DrawText3Ds(pumpCoords.x,pumpCoords.y,pumpCoords.z + 1.2,"GET OUT OF ~y~VEHICLE ~w~TO FUEL")
			else
				local vehicle = GetPlayersLastVehicle()
				local vehicleCoords = GetEntityCoords(vehicle)
				if DoesEntityExist(vehicle) and GetDistanceBetweenCoords(GetEntityCoords(ped),vehicleCoords) < 3.5 then
					if not DoesEntityExist(GetPedInVehicleSeat(vehicle,-1)) then
						local stringCoords = GetEntityCoords(isNearPump)
						local canFuel = true
						if GetSelectedPedWeapon(ped) == 883325847 then
							stringCoords = vehicleCoords
							if GetAmmoInPedWeapon(ped,883325847) < 100 then
								canFuel = false
							end
						end

						if GetVehicleFuelLevel(vehicle) < 99 and canFuel then
							DrawText3Ds(stringCoords.x,stringCoords.y,stringCoords.z + 1.2,"~g~REFUEL YOUR VEHICLE")
							if IsControlJustReleased(0,38) then
								if isNearPump then
									output = nil
									TriggerServerEvent('vrp_legacyfuel2:LixeiroCB',pumpLocation)
									while output == nil do 
										Wait(10)
									end
									open(vehicle,output)
									isFueling = true
									paid = false
								else
									isFueling = true
									TriggerEvent('fuel:refuelFromPump',isNearPump,ped,vehicle)
								end
							end
						elseif not canFuel then
							DrawText3Ds(stringCoords.x,stringCoords.y,stringCoords.z + 1.2,"~g~FULL TANK FULL")
						else
							DrawText3Ds(stringCoords.x,stringCoords.y,stringCoords.z + 1.2,"~g~FULL TANK FULL")
						end
					end
				end
			end
			Citizen.Wait(4)
		end
	end
end)

RegisterNetEvent('esx_legacy_fuel:fuelVehicle')
AddEventHandler('esx_legacy_fuel:fuelVehicle', function()
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped),-1) == ped then
		local pumpCoords = GetEntityCoords(isNearPump)
	else
		local vehicle = GetPlayersLastVehicle()
		local vehicleCoords = GetEntityCoords(vehicle)
		if DoesEntityExist(vehicle) and GetDistanceBetweenCoords(GetEntityCoords(ped),vehicleCoords) < 3.5 then
			if not DoesEntityExist(GetPedInVehicleSeat(vehicle,-1)) then
				local stringCoords = GetEntityCoords(isNearPump)
				local canFuel = true
				if GetSelectedPedWeapon(ped) == 883325847 then
					stringCoords = vehicleCoords
					if GetAmmoInPedWeapon(ped,883325847) < 100 then
						canFuel = false
					end
				end

				if GetVehicleFuelLevel(vehicle) < 99 and canFuel then
					if isNearPump then
						output = nil
						TriggerServerEvent('vrp_legacyfuel2:LixeiroCB',pumpLocation)
						while output == nil do 
							Wait(10)
						end
						open(vehicle,output)
						isFueling = true
						paid = false
					else
						isFueling = true
						TriggerEvent('fuel:refuelFromPump',isNearPump,ped,vehicle)
					end
				end
			end
		end
	end
	Citizen.Wait(4)
end)

RegisterNUICallback('pay', function(data, cb)
	local vehicle = GetPlayersLastVehicle()
    local new_perc = tonumber(data.new_perc)
	if not paid then
		if DoesEntityExist(vehicle) and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GetEntityCoords(vehicle)) < 5 then
			TriggerServerEvent('vrp_legacyfuel2:pagamento',math.floor(new_perc),false,VehToNet(vehicle),math.floor(new_perc),Config.FuelDecor,pumpLocation)
			paid = true
		end
	end
end)

RegisterNUICallback('checkpay', function(data, cb)
    local new_perc = tonumber(data.new_perc)
	TriggerServerEvent('vrp_legacyfuel2:check',math.floor(new_perc))
end)

RegisterNUICallback('notifytext', function(data, cb)
    local text = data.text
	TriggerEvent("gas_station:Notify","importante",text)
end)

RegisterNUICallback('startanim',function(data,cb)
	local ped = PlayerPedId()
	local vehicle = GetPlayersLastVehicle()
	TaskTurnPedToFaceEntity(ped,vehicle,5000)
	LoadAnimDict("timetable@gardener@filling_can")
	TaskPlayAnim(ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",2.0,8.0,-1,50,0,0,0,0)

	Citizen.Wait(2000)

	if GetIsVehicleEngineRunning(vehicle) then
		NetworkExplodeVehicle(vehicle, true, false, 0)
		close()

		local cord = GetEntityCoords(PlayerPedId())
		local streetName, _ = GetStreetNameAtCoord(cord[1], cord[2], cord[3])
		local streetName = GetStreetNameFromHashKey(streetName)
		local zone = tostring(GetNameOfZone(cord[1], cord[2], cord[3]))
		local area = GetLabelText(zone)
	
		exports['wp_dispatch']:addCall("10-31", "Explosion Reported At", {
			{icon = "fas fa-road", info = streetName ..", ".. area}
		}, {cord[1], cord[2], cord[3]}, "police", 3000, 486, 1)
		exports['wp_dispatch']:addCall("10-31", "Explosion Reported At", {
			{icon = "fas fa-road", info = streetName ..", ".. area}
		}, {cord[1], cord[2], cord[3]}, "ambulance", 3000, 486, 1)
		exports['wp_dispatch']:addCall("10-31", "Explosion Reported At", {
			{icon = "fas fa-road", info = streetName ..", ".. area}
		}, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 486, 1)
	end
end)

RegisterNUICallback('removeanim',function(data,cb)
	local ped = PlayerPedId()
	ClearPedTasks(ped)
	RemoveAnimDict("timetable@gardener@filling_can")
end)

function DrawText3Ds(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)

	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/370
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end

function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(10)
		end
	end
end