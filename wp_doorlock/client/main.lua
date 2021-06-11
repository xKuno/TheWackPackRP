ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function()
	TriggerServerEvent("td-doorlock:server:setupDoors")
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local closestDoorKey, closestDoorValue = nil, nil

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
	SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

Citizen.CreateThread(function()
	while true do
		for key, doorID in ipairs(TD.Doors) do
			if doorID.doors then
				for k,v in ipairs(doorID.doors) do
					if not v.object or not DoesEntityExist(v.object) then
						v.object = GetClosestObjectOfType(v.objCoords, 1.0, GetHashKey(v.objName), false, false, false)
					end
				end
			else
				if not doorID.object or not DoesEntityExist(doorID.object) then
					doorID.object = GetClosestObjectOfType(doorID.objCoords, 1.0, GetHashKey(doorID.objName), false, false, false)
				end
			end
		end

		Citizen.Wait(2500)
	end
end)

local maxDistance = 1.25

Citizen.CreateThread(function()
	local distance = 1000.0
	while true do
		Citizen.Wait(1)
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local nearby =  false
		for k,doorID in ipairs(TD.Doors) do
			local distance

			if doorID.doors then
				if doorID.objName == 'gabz_mrpd_bollards1' or doorID.objName == 'gabz_mrpd_bollards2' then
					distance = #(playerCoords - doorID.doors[1].textCoords) 
				else
					distance = #(playerCoords - doorID.doors[1].objCoords) 
				end
			else
				if doorID.objName == 'gabz_mrpd_bollards1' or doorID.objName == 'gabz_mrpd_bollards2' then
					distance = #(playerCoords - doorID.textCoords)
				else
					distance = #(playerCoords - doorID.objCoords)
				end
			end

			if doorID.distance then
				maxDistance = doorID.distance
			end
			if distance < 50 then

				if doorID.doors then
					for _,v in ipairs(doorID.doors) do
						FreezeEntityPosition(v.object, doorID.locked)

						if doorID.locked and v.objYaw and GetEntityRotation(v.object).z ~= v.objYaw then
							if doorID.objName ~= 'gabz_mrpd_bollards1' and doorID.objName ~= 'gabz_mrpd_bollards2' then
								SetEntityRotation(v.object, 0.0, 0.0, v.objYaw, 2, true)
							end
							SetEntityCoords(v.object, v.objCoords.x, v.objCoords.y, v.objCoords.z, false, false, false, false) 
						end
					end
				else
					FreezeEntityPosition(doorID.object, doorID.locked)

					if doorID.locked and doorID.objYaw and GetEntityRotation(doorID.object).z ~= doorID.objYaw then
						if doorID.objName ~= 'gabz_mrpd_bollards1' and doorID.objName ~= 'gabz_mrpd_bollards2' then
							SetEntityRotation(doorID.object, 0.0, 0.0, doorID.objYaw, 2, true)
						end
						SetEntityCoords(doorID.object, doorID.objCoords.x, doorID.objCoords.y, doorID.objCoords.z, false, false, false, false) 
					end
				end
				if distance < 20 then
					nearby = true
				end
			end

			if distance < maxDistance then
				nearby = true
				if doorID.size then
					size = doorID.size
				end

				local isAuthorized = IsAuthorized(doorID)

				if isAuthorized then
					if doorID.locked then
						displayText = "[~r~E~w~] - Locked"
					elseif not doorID.locked then
						displayText = "[~g~E~w~] - Unlocked"
					end
				elseif not isAuthorized then
					if doorID.locked then
						displayText = " ~r~Locked"
					elseif not doorID.locked then
						displayText = "~g~Unlocked"
					end
				end

				if doorID.locking then
					if doorID.locked then
						displayText = "Unlocking..."
					else
						displayText = "Locking..."
					end
				end

				if doorID.objCoords == nil then
					doorID.objCoords = doorID.textCoords
				end

				DrawText3Ds(doorID.textCoords.x, doorID.textCoords.y, doorID.textCoords.z, displayText)

				DisableControlAction(0,86)

				if IsControlJustReleased(0, 38) then
					if isAuthorized then
						Citizen.Wait(150)
						setDoorLocking(doorID, k)
						if doorID.sound then
							PlaySoundFromEntity(-1, "Keycard_Success", PlayerPedId(), "DLC_HEISTS_BIOLAB_FINALE_SOUNDS", 1, 5.0);
						end
					end
				end
			end
		end

		if not nearby then
			Citizen.Wait(distance)
		end
	end
end)

function setDoorLocking(doorId, key)
	doorId.locking = true
	if not IsPedInAnyVehicle(PlayerPedId()) then
		openDoorAnim()
	end
    SetTimeout(400, function()
		doorId.locking = false
		doorId.locked = not doorId.locked
		Citizen.Wait(100)
		TriggerServerEvent("td-doorlock:server:updateState", key, doorId.locked)
	end)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(100)
    end
end

function IsAuthorized(doorID)
	if ESX.PlayerData.job == nil then
		return false
	end
	for _,job in pairs(doorID.authorizedJobs) do
		if job == ESX.PlayerData.job.name then
			return true
		end
	end
	
	return false
end

function openDoorAnim()
    loadAnimDict("anim@heists@keycard@") 
    TaskPlayAnim( PlayerPedId(), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
	SetTimeout(400, function()
		ClearPedTasks(PlayerPedId())
	end)
end

RegisterNetEvent("td-doorlock:client:setState")
AddEventHandler("td-doorlock:client:setState", function(doorID, state)
	TD.Doors[doorID].locked = state
end)

RegisterNetEvent("td-doorlock:client:setDoors")
AddEventHandler("td-doorlock:client:setDoors", function(doorList)
	TD.Doors = doorList
end)

