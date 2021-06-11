local Keys = {
  ["ESC"] = 322,
  ["F1"] = 288,
  ["F2"] = 289,
  ["F3"] = 170,
  ["F5"] = 166,
  ["F6"] = 167,
  ["F7"] = 168,
  ["F8"] = 169,
  ["F9"] = 56,
  ["F10"] = 57,
  ["~"] = 243,
  ["1"] = 157,
  ["2"] = 158,
  ["3"] = 160,
  ["4"] = 164,
  ["5"] = 165,
  ["6"] = 159,
  ["7"] = 161,
  ["8"] = 162,
  ["9"] = 163,
  ["-"] = 84,
  ["="] = 83,
  ["BACKSPACE"] = 177,
  ["TAB"] = 37,
  ["Q"] = 44,
  ["W"] = 32,
  ["E"] = 38,
  ["R"] = 45,
  ["T"] = 245,
  ["Y"] = 246,
  ["U"] = 303,
  ["P"] = 199,
  ["["] = 39,
  ["]"] = 40,
  ["ENTER"] = 18,
  ["CAPS"] = 137,
  ["A"] = 34,
  ["S"] = 8,
  ["D"] = 9,
  ["F"] = 23,
  ["G"] = 47,
  ["H"] = 74,
  ["K"] = 311,
  ["L"] = 182,
  ["LEFTSHIFT"] = 21,
  ["Z"] = 20,
  ["X"] = 73,
  ["C"] = 26,
  ["V"] = 0,
  ["B"] = 29,
  ["N"] = 249,
  ["M"] = 244,
  [","] = 82,
  ["."] = 81,
  ["LEFTCTRL"] = 36,
  ["LEFTALT"] = 19,
  ["SPACE"] = 22,
  ["RIGHTCTRL"] = 70,
  ["HOME"] = 213,
  ["PAGEUP"] = 10,
  ["PAGEDOWN"] = 11,
  ["DELETE"] = 178,
  ["LEFT"] = 174,
  ["RIGHT"] = 175,
  ["TOP"] = 27,
  ["DOWN"] = 173,
  ["NENTER"] = 201,
  ["N4"] = 108,
  ["N5"] = 60,
  ["N6"] = 107,
  ["N+"] = 96,
  ["N-"] = 97,
  ["N7"] = 117,
  ["N8"] = 61,
  ["N9"] = 118
}

local PlayerData = {}
local GUI = {}
local HasAlreadyEnteredMarker = false
local LastStation = nil
local LastPart = nil
local LastPartNum = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local IsHandcuffed = false
local DragStatus = {}
DragStatus.IsDragged = false
DragStatus.draganim = false
local IsShackles = false
local isInMarker = false
local moneyInPoliceBank = false
local Complete = nil

ESX = nil
GUI.Time = 0

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

function SetVehicleMaxMods(vehicle)

  local props = {
    modEngine = 2,
    modBrakes = 2,
    modTransmission = 2,
    modSuspension = 3,
    modTurbo = true,
    modArmor = 4,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)
end

function OpenVehicleSpawnerMenu(station, partNum)

  local vehicles = Config.PoliceStations[station].Vehicles

  ESX.UI.Menu.CloseAll()

    local elements = {}

    for i = 1, #Config.PoliceStations[station].AuthorizedVehicles, 1 do
      local vehicle = Config.PoliceStations[station].AuthorizedVehicles[i]
      table.insert(elements, { label = vehicle.label, value = vehicle.name, rank = vehicle.rank })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title = _U('vehicle_menu'),
        align = 'right',
        elements = elements,
      },
      function(data, menu)
        menu.close()

        local model = data.current
        local vehicle = GetClosestVehicle(
          vehicles[partNum].SpawnPoint.x,
          vehicles[partNum].SpawnPoint.y,
          vehicles[partNum].SpawnPoint.z, 3.0, 0, 71)

        if not DoesEntityExist(vehicle) then
          local playerPed = PlayerPedId()

            if (PlayerData.job.grade >= data.current.rank) then
              if model.value == 'npolvic' then
                TriggerServerEvent('getmoney:policevic')
                Citizen.Wait(1000)
                ESX.Game.SpawnVehicle(model.value, {
                x = vehicles[partNum].SpawnPoint.x,
                y = vehicles[partNum].SpawnPoint.y,
                z = vehicles[partNum].SpawnPoint.z
                }, vehicles[partNum].Heading, function(vehicle)
                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                TriggerEvent("ls:newVehicle", GetPlayerServerId(PlayerId()), GetVehicleNumberPlateText(vehicle), nil)
                SetVehicleMaxMods(vehicle)
                TriggerServerEvent('log:policecar', model.value)

                SetVehicleNumberPlateText(vehicle, Config.Plates[PlayerData.job.grade].plate)
                if PlayerData.job.grade == 0 then
                  SetVehicleColours(vehicle, 111, 0) -- Colour -- LSPD
                  SetVehicleMod(vehicle, 48, 0) -- Livery -- LSPD

                  SetVehicleWindowTint(vehicle, 4) -- Window

                  SetVehicleMod(vehicle, 1, 0) -- Bumper -- LSPD
                  SetVehicleMod(vehicle, 43, 0) -- Aerials -- LSPD
                  SetVehicleMod(vehicle, 5, 0) -- Roll Cage (Divider)
                  SetVehicleMod(vehicle, 28, 0) -- Radar Interior
                  SetVehicleMod(vehicle, 29, 0) -- MDT/Radio Interior
                  SetVehicleMod(vehicle, 30, 0) -- Reading Light
                  SetVehicleMod(vehicle, 32, 0) -- Seats
                  SetVehicleMod(vehicle, 37, 2) -- Trunk

                  SetVehicleExtra(vehicle, 1, false)
                  SetVehicleExtra(vehicle, 2, false)
                  SetVehicleExtra(vehicle, 3, false)
                  SetVehicleExtra(vehicle, 4, false)
                  SetVehicleExtra(vehicle, 5, false)
                  SetVehicleExtra(vehicle, 6, false)
                  SetVehicleExtra(vehicle, 7, false)
                elseif PlayerData.job.grade == 1 then
                  SetVehicleColours(vehicle, 117, 117) -- Colour -- SASP

                  SetVehicleWindowTint(vehicle, 1) -- Window
                  
                  SetVehicleExtra(vehicle, 1, true)
                  SetVehicleExtra(vehicle, 2, true)
                  SetVehicleExtra(vehicle, 3, true)
                  SetVehicleExtra(vehicle, 4, true)
                  SetVehicleExtra(vehicle, 5, false)
                  SetVehicleExtra(vehicle, 6, false)
                  SetVehicleExtra(vehicle, 7, false)
                elseif PlayerData.job.grade == 2 then
                  SetVehicleColours(vehicle, 117, 117) -- Colour -- SASP

                  SetVehicleWindowTint(vehicle, 1) -- Window
                  
                  SetVehicleExtra(vehicle, 1, true)
                  SetVehicleExtra(vehicle, 2, true)
                  SetVehicleExtra(vehicle, 3, true)
                  SetVehicleExtra(vehicle, 4, true)
                  SetVehicleExtra(vehicle, 5, false)
                  SetVehicleExtra(vehicle, 6, false)
                  SetVehicleExtra(vehicle, 7, false)
                elseif PlayerData.job.grade == 3 then
                  SetVehicleColours(vehicle, 111, 56) -- Colour -- SASPR
                  SetVehicleMod(vehicle, 48, 7) -- Livery -- SASPR

                  SetVehicleWindowTint(vehicle, 4) -- Window

                  SetVehicleMod(vehicle, 1, 2) -- Bumper -- SASPR
                  SetVehicleMod(vehicle, 43, 2) -- Aerials -- SASPR
                  SetVehicleMod(vehicle, 5, 0) -- Roll Cage (Divider)
                  SetVehicleMod(vehicle, 28, 0) -- Radar Interior
                  SetVehicleMod(vehicle, 29, 0) -- MDT/Radio Interior
                  SetVehicleMod(vehicle, 30, 0) -- Reading Light
                  SetVehicleMod(vehicle, 32, 0) -- Seats
                  SetVehicleMod(vehicle, 37, 2) -- Trunk

                  SetVehicleExtra(vehicle, 1, false)
                  SetVehicleExtra(vehicle, 2, false)
                  SetVehicleExtra(vehicle, 3, false)
                  SetVehicleExtra(vehicle, 4, false)
                  SetVehicleExtra(vehicle, 5, false)
                  SetVehicleExtra(vehicle, 6, false)
                  SetVehicleExtra(vehicle, 7, false)
                elseif PlayerData.job.grade == 4 then
                  SetVehicleColours(vehicle, 111, 0) -- Colour -- BCSO
                  SetVehicleMod(vehicle, 48, 2) -- Livery - BCSO

                  SetVehicleWindowTint(vehicle, 4) -- Window

                  SetVehicleMod(vehicle, 1, 1) -- Bumper -- BCSO
                  SetVehicleMod(vehicle, 43, 1) -- Aerials -- BCSO
                  SetVehicleMod(vehicle, 5, 0) -- Roll Cage (Divider)
                  SetVehicleMod(vehicle, 28, 0) -- Radar Interior
                  SetVehicleMod(vehicle, 29, 0) -- MDT/Radio Interior
                  SetVehicleMod(vehicle, 30, 0) -- Reading Light
                  SetVehicleMod(vehicle, 32, 0) -- Seats
                  SetVehicleMod(vehicle, 37, 2) -- Trunk

                  SetVehicleExtra(vehicle, 1, false)
                  SetVehicleExtra(vehicle, 2, false)
                  SetVehicleExtra(vehicle, 3, false)
                  SetVehicleExtra(vehicle, 4, false)
                  SetVehicleExtra(vehicle, 5, false)
                  SetVehicleExtra(vehicle, 6, false)
                  SetVehicleExtra(vehicle, 7, false)
                elseif PlayerData.job.grade == 5 then
                  SetVehicleColours(vehicle, 62, 62) -- Colour -- SASP
                  SetVehicleMod(vehicle, 48, 4) -- Livery -- SASP

                  SetVehicleWindowTint(vehicle, 4) -- Window

                  SetVehicleMod(vehicle, 1, 2) -- Bumper -- SASP
                  SetVehicleMod(vehicle, 43, 2) -- Aerials -- SASP
                  SetVehicleMod(vehicle, 5, 0) -- Roll Cage (Divider)
                  SetVehicleMod(vehicle, 28, 0) -- Radar Interior
                  SetVehicleMod(vehicle, 29, 0) -- MDT/Radio Interior
                  SetVehicleMod(vehicle, 30, 0) -- Reading Light
                  SetVehicleMod(vehicle, 32, 0) -- Seats
                  SetVehicleMod(vehicle, 37, 2) -- Trunk

                  SetVehicleExtra(vehicle, 1, false)
                  SetVehicleExtra(vehicle, 2, false)
                  SetVehicleExtra(vehicle, 3, false)
                  SetVehicleExtra(vehicle, 4, false)
                  SetVehicleExtra(vehicle, 5, false)
                  SetVehicleExtra(vehicle, 6, false)
                  SetVehicleExtra(vehicle, 7, false)
                elseif PlayerData.job.grade == 6 then
                  SetVehicleColours(vehicle, 58, 58) -- Colour -- DOC
                  SetVehicleMod(vehicle, 48, 6) -- Livery -- DOC

                  SetVehicleWindowTint(vehicle, 4) -- Window

                  SetVehicleExtra(vehicle, 1, true)
                  SetVehicleExtra(vehicle, 2, false)
                  SetVehicleExtra(vehicle, 3, false)
                  SetVehicleExtra(vehicle, 4, false)
                  SetVehicleExtra(vehicle, 5, false)
                  SetVehicleExtra(vehicle, 6, false)
                  SetVehicleExtra(vehicle, 7, false)
                end
              end)
              
              elseif model.value ~= 'npolvic' then
                TriggerServerEvent('getmoney:policecar')
                Citizen.Wait(1000)
                if moneyInPoliceBank then
                moneyInPoliceBank = false
                ESX.Game.SpawnVehicle(model.value, {
                x = vehicles[partNum].SpawnPoint.x,
                y = vehicles[partNum].SpawnPoint.y,
                z = vehicles[partNum].SpawnPoint.z
                }, vehicles[partNum].Heading, function(vehicle)
                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                TriggerEvent("ls:newVehicle", GetPlayerServerId(PlayerId()), GetVehicleNumberPlateText(vehicle), nil)
                SetVehicleMaxMods(vehicle)
                TriggerServerEvent('log:policecar', model.value)

                SetVehicleNumberPlateText(vehicle, Config.Plates[PlayerData.job.grade].plate)
            end)
          end
        end
      end
    end
  end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

AddEventHandler('esx_policejob:hasEnteredMarker', function(station, part, partNum)

  if part == 'VehicleSpawner' then
    CurrentAction = 'menu_vehicle_spawner'
    CurrentActionMsg = _U('vehicle_spawner')
    CurrentActionData = { station = station, partNum = partNum }
  end

  if part == 'HelicopterSpawner' then

    local helicopters = Config.PoliceStations[station].Helicopters

    if not IsAnyVehicleNearPoint(helicopters[partNum].SpawnPoint.x, helicopters[partNum].SpawnPoint.y, helicopters[partNum].SpawnPoint.z, 3.0) then

      ESX.Game.SpawnVehicle('maverick2', {
        x = helicopters[partNum].SpawnPoint.x,
        y = helicopters[partNum].SpawnPoint.y,
        z = helicopters[partNum].SpawnPoint.z
      }, helicopters[partNum].Heading, function(vehicle)
        SetVehicleModKit(vehicle, 0)
        SetVehicleLivery(vehicle, 0)
        TriggerEvent("ls:newVehicle", GetPlayerServerId(PlayerId()), GetVehicleNumberPlateText(vehicle), nil)
      end)
    end
  end

  if part == 'VehicleDeleter' then

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    if IsPedInAnyVehicle(playerPed, false) then

      local vehicle = GetVehiclePedIsIn(playerPed, false)

      if DoesEntityExist(vehicle) then
        CurrentAction = 'delete_vehicle'
        CurrentActionMsg = _U('store_vehicle')
        CurrentActionData = { vehicle = vehicle }
      end
    end
  end
end)

AddEventHandler('esx_policejob:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(copID, _source)
	DragStatus.IsDragged = not DragStatus.IsDragged
	DragStatus.CopId     = tonumber(copID)
end)

Citizen.CreateThread(function()
	local playerPed
	local targetPed

	while true do
		Citizen.Wait(1)

			playerPed = PlayerPedId()

			if DragStatus.IsDragged then
			
				targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))

				if not IsPedSittingInAnyVehicle(targetPed) then
					AttachEntityToEntity(playerPed, targetPed, 11816, -0.06, 0.65, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					DragStatus.IsDragged = false
					DetachEntity(playerPed, true, false)
				end

			else
        if GetPedParachuteState(playerPed) ~= 1 and GetPedParachuteState(playerPed) ~= 2 then
				DetachEntity(playerPed, true, false)
			end
    end
	end
end)

function getClosestEntity()
    local ped = PlayerPedId()
    local coords = GetOffsetFromEntityInWorldCoords(ped,0.0, 0.0, 0.0)
    local coords2 = GetOffsetFromEntityInWorldCoords(ped, 0.0, 8.0, 0.0)
    local rayhandle = CastRayPointToPoint(coords, coords2, 10, ped, 0)
    local _, _, _, _, entityHit = GetRaycastResult(rayhandle)
    if entityHit>0 then
        return entityHit
    else
        local coords = GetOffsetFromEntityInWorldCoords(ped,0.0, 0.0, 0.0)
        local coords2 = GetOffsetFromEntityInWorldCoords(ped, 8.0, 0.0, 0.0)
        local rayhandle = CastRayPointToPoint(coords, coords2, 10, ped, 0)
        local _, _, _, _, entityHit = GetRaycastResult(rayhandle)
        if entityHit>0 then
            return entityHit
        else
            return nil
        end
    end
end

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local closestEntity = getClosestEntity()

    if GetEntityType(closestEntity) == 2 then
        local seat = 2
        for i=3, 0, -1 do
            if IsVehicleSeatFree(closestEntity, i) then
                seat = i
                break
            end
        end
        TaskWarpPedIntoVehicle(ped, closestEntity, seat)
        DragStatus.IsDragged = false
        DetachEntity(playerPed, true, false)
    elseif GetEntityType(closestEntity) == 1 then
        local playerVehicle = GetVehiclePedIsIn(closestEntity, false)
        if playerVehicle ~= nil then
            local seat = 2
            for i=3, 0, -1 do
                if IsVehicleSeatFree(playerVehicle, i) then
                    seat = i
                    break
                end
            end
            TaskWarpPedIntoVehicle(ped, playerVehicle, seat)
            DragStatus.IsDragged = false
			      DetachEntity(playerPed, true, false)
        end
    end
end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(t)
  local ped = GetPlayerPed(t)
  ClearPedTasksImmediately(ped)
  plyPos = GetEntityCoords(PlayerPedId(), true)
  local xnew = plyPos.x + 2
  local ynew = plyPos.y + 2

  SetEntityCoords(PlayerPedId(), xnew, ynew, plyPos.z)
end)

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end    
end

function CuffBar()
  TriggerEvent('cuffbar')
end

function CuffBar2()
    TriggerEvent('cuffbar2')
end

RegisterNetEvent('esx_policejob:putinvehicleclient')
AddEventHandler('esx_policejob:putinvehicleclient', function()
  local player, distance = ESX.Game.GetClosestPlayer()
  if distance ~= -1 and distance <= 3 then
    TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(player))
  else
    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No player nearby.'})
  end
end)

RegisterNetEvent('esx_policejob:outvehicleclient')
AddEventHandler('esx_policejob:outvehicleclient', function()
  local player, distance = ESX.Game.GetClosestPlayer()
  if distance ~= -1 and distance <= 3 then
    TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(player))
  else
    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No player nearby.'})
  end
end)

RegisterNetEvent('esx_policejob:escortclient')
AddEventHandler('esx_policejob:escortclient', function()
  local closestPlayer, distance = ESX.Game.GetClosestPlayer()
  if distance ~= -1 and distance <= 3 then
    TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
    Citizen.Wait(800)
    if DragStatus.draganim then
      TriggerEvent('reload_death:stopAnim')
      TriggerEvent('reload_death:startAnim')
      DragStatus.draganim = false
    else
      TriggerEvent('reload_death:stopAnim')
      TriggerEvent('reload_death:startAnim')
      DragStatus.draganim = true
    end
  else
    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No player nearby.'})
  end
end)

RegisterNetEvent('esx_policejob:uncuffclient')
AddEventHandler('esx_policejob:uncuffclient', function()
  local target, distance = ESX.Game.GetClosestPlayer()
  playerheading = GetEntityHeading(PlayerPedId())
  playerlocation = GetEntityForwardVector(PlayerPedId())
  playerCoords = GetEntityCoords(PlayerPedId())
  local target_id = GetPlayerServerId(target)
  if distance ~= -1 and distance <= 3 then
    TriggerServerEvent('esx_policejob:requestrelease', target_id, playerheading, playerCoords, playerlocation)
  else
    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No player nearby.'})
  end
end)

RegisterNetEvent('esx_policejob:requesthardclient')
AddEventHandler('esx_policejob:requesthardclient', function()
  local target, distance = ESX.Game.GetClosestPlayer()
  playerheading = GetEntityHeading(PlayerPedId())
  playerlocation = GetEntityForwardVector(PlayerPedId())
  playerCoords = GetEntityCoords(PlayerPedId())
  local target_id = GetPlayerServerId(target)
  if distance ~= -1 and distance <= 3 then
    TriggerServerEvent('esx_policejob:requesthard', target_id, playerheading, playerCoords, playerlocation)
  else
    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No player nearby.'})
  end
end)

RegisterNetEvent('esx_policejob:requestarrestclient')
AddEventHandler('esx_policejob:requestarrestclient', function()
  local target, distance = ESX.Game.GetClosestPlayer()
  playerheading = GetEntityHeading(PlayerPedId())
  playerlocation = GetEntityForwardVector(PlayerPedId())
  playerCoords = GetEntityCoords(PlayerPedId())
  local target_id = GetPlayerServerId(target)
  if distance ~= -1 and distance <= 3 then
    TriggerServerEvent('esx_policejob:requestarrest', target_id, playerheading, playerCoords, playerlocation)
  else
    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No player nearby.'})
  end
end)

RegisterNetEvent('esx_policejob:uncuffclient2')
AddEventHandler('esx_policejob:uncuffclient2', function()
  local target, distance = ESX.Game.GetClosestPlayer()
  playerheading = GetEntityHeading(PlayerPedId())
  playerlocation = GetEntityForwardVector(PlayerPedId())
  playerCoords = GetEntityCoords(PlayerPedId())
  local target_id = GetPlayerServerId(target)
  if distance ~= -1 and distance <= 3 then
    TriggerServerEvent('esx_policejob:requestrelease2', target_id, playerheading, playerCoords, playerlocation)
  else
    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No player nearby.'})
  end
end)

RegisterNetEvent('esx_policejob:requesthardclient2')
AddEventHandler('esx_policejob:requesthardclient2', function()
  local target, distance = ESX.Game.GetClosestPlayer()
  playerheading = GetEntityHeading(PlayerPedId())
  playerlocation = GetEntityForwardVector(PlayerPedId())
  playerCoords = GetEntityCoords(PlayerPedId())
  local target_id = GetPlayerServerId(target)
  if distance ~= -1 and distance <= 3 then
    TriggerServerEvent('esx_policejob:requesthard2', target_id, playerheading, playerCoords, playerlocation)
  else
    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No player nearby.'})
  end
end)

RegisterNetEvent('esx_policejob:requestarrestclient2')
AddEventHandler('esx_policejob:requestarrestclient2', function()
  local target, distance = ESX.Game.GetClosestPlayer()
  playerheading = GetEntityHeading(PlayerPedId())
  playerlocation = GetEntityForwardVector(PlayerPedId())
  playerCoords = GetEntityCoords(PlayerPedId())
  local target_id = GetPlayerServerId(target)
  if distance ~= -1 and distance <= 3 then
    TriggerServerEvent('esx_policejob:requestarrest2', target_id, playerheading, playerCoords, playerlocation)
  else
    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No player nearby.'})
  end
end)

RegisterNetEvent('esx_policejob:doarrested')
AddEventHandler('esx_policejob:doarrested', function()
	Citizen.Wait(250)
	LoadAnimDict('mp_arrest_paired')
	TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,5000, 2, 0, 0, 0, 0)
	Citizen.Wait(3000)
end) 

RegisterNetEvent('esx_policejob:douncuffing')
AddEventHandler('esx_policejob:douncuffing', function()
	Citizen.Wait(250)
	LoadAnimDict('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('esx_policejob:getuncuffed')
AddEventHandler('esx_policejob:getuncuffed', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(PlayerPedId(), x, y, z)
	SetEntityHeading(PlayerPedId(), playerheading)
	Citizen.Wait(250)
	LoadAnimDict('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	IsHandcuffed = false
	IsShackles = false
	ClearPedTasks(PlayerPedId())
  TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3, 'cuff', 1.0)
end)

RegisterNetEvent('esx_policejob:getarrested')
AddEventHandler('esx_policejob:getarrested', function(playerheading, playercoords, playerlocation)
	playerPed = PlayerPedId()
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(PlayerPedId(), x, y, z)
	SetEntityHeading(PlayerPedId(), playerheading)
	Citizen.Wait(250)
	LoadAnimDict('mp_arrest_paired')
	TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 5000 , 2, 0, 0, 0, 0)
  Complete = nil
  CuffBar()
  while Complete == nil do
    Wait(0)
  end
  if Complete == true then
    exports['mythic_notify']:SendAlert('inform', 'You broke the cuffs.', 2500)
    ClearPedTasks(playerPed)
    target, distance = ESX.Game.GetClosestPlayer()
    if distance ~= -1 and distance <= 3 then
      local targetPed = PlayerPedId(target)
      ClearPedTasks(targetPed)
      TriggerServerEvent('esx_policejob:alertCuffBreak', GetPlayerServerId(target))
      TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5, 'cuffbreak', 1.0)
    end
  elseif Complete == false then
    IsHandcuffed = true
    IsShackles = false
    LoadAnimDict('mp_arresting')
    TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3, 'cuff', 1.0)
  end
end)

RegisterNetEvent('esx_policejob:getarrestedhard')
AddEventHandler('esx_policejob:getarrestedhard', function(playerheading, playercoords, playerlocation)
	playerPed = PlayerPedId()
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(PlayerPedId(), x, y, z)
	SetEntityHeading(PlayerPedId(), playerheading)
	Citizen.Wait(250)
	LoadAnimDict('mp_arrest_paired')
	TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 5000 , 2, 0, 0, 0, 0)
  Complete = nil
  CuffBar2()
  while Complete == nil do
    Wait(0)
  end
  if Complete == true then
    exports['mythic_notify']:SendAlert('inform', 'You broke the cuffs.', 2500)
    ClearPedTasks(playerPed)
    target, distance = ESX.Game.GetClosestPlayer()
    if distance ~= -1 and distance <= 3 then
      local targetPed = PlayerPedId(target)
      ClearPedTasks(targetPed)
      TriggerServerEvent('esx_policejob:alertCuffBreak', GetPlayerServerId(target))
      TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5, 'cuffbreak', 1.0)
    end
  elseif Complete == false then
    IsHandcuffed = true
    IsShackles = true
    LoadAnimDict('mp_arresting')
    TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3, 'cuff', 1.0)
  end
end)

RegisterNetEvent('esx_policejob:getUncuffedJail')
AddEventHandler('esx_policejob:getUncuffedJail', function()
	IsHandcuffed = false
	IsShackles = false
	ClearPedTasks(PlayerPedId())
end)

-- Handcuff
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPed = PlayerPedId()

		if IsHandcuffed then
      DisableAllControlActions(0)
      EnableControlAction(0, Keys['W'], true) -- W
			EnableControlAction(0, Keys['A'], true) -- A
			EnableControlAction(0, 31, true) -- S
			EnableControlAction(0, 30, true) -- D
      EnableControlAction(0, 22, true) -- Jump
			EnableControlAction(0, 44, true) -- Cover
      EnableControlAction(0, 1)
      EnableControlAction(0, 2)
      EnableControlAction(0, 176)
      EnableControlAction(0, 177)
      EnableControlAction(0, Keys['B'], true)
      EnableControlAction(0, Keys['E'], true)
      EnableControlAction(0, Keys['T'], true)
      EnableControlAction(0, Keys['N'], true)
      EnableControlAction(0, Keys['Z'], true)
      EnableControlAction(0, Keys['~'], true)
      EnableControlAction(0, Keys['X'], true)
      EnableControlAction(0, 21, true)

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if IsShackles then
      DisableAllControlActions(0)
      EnableControlAction(0, 1)
      EnableControlAction(0, 2)
      EnableControlAction(0, 176)
      EnableControlAction(0, 177)
      EnableControlAction(0, Keys['B'], true)
      EnableControlAction(0, Keys['E'], true)
      EnableControlAction(0, Keys['T'], true)
      EnableControlAction(0, Keys['N'], true)
      EnableControlAction(0, Keys['Z'], true)
      EnableControlAction(0, Keys['~'], true)
      EnableControlAction(0, Keys['X'], true)

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Display markers
Citizen.CreateThread(function()
    local currentStation = nil
    local currentPart = nil
    local currentPartNum = nil
    local hasExited = false
    while true do
        if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local InAMarker = false
            for k, v in pairs(Config.PoliceStations) do

                for i = 1, #v.Vehicles, 1 do
                    if #(coords-v.Vehicles[i].Spawner) < 10.0 then
                        DrawMarker(Config.MarkerType, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
                        if #(coords-v.Vehicles[i].Spawner) < 2.0 then
                            isInMarker = true
                            InAMarker = true
                            currentStation = k
                            currentPart = 'VehicleSpawner'
                            currentPartNum = i
                        end
                    end
                end
                for i = 1, #v.VehicleDeleters, 1 do
                    if #(coords-v.VehicleDeleters[i]) < 10.0 then
                        DrawMarker(Config.MarkerType, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
                        if #(coords-v.VehicleDeleters[i]) < 5.0 then
                            isInMarker = true
                            InAMarker = true
                            currentStation = k
                            currentPart = 'VehicleDeleter'
                            currentPartNum = i
                        end
                    end
                end
            end
            if not InAMarker then
                isInMarker = false
            end

            if isInMarker then --and not HasAlreadyEnteredMarker then--or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
      
              if (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
                (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) then
                TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
                --hasExited = true
              end
      
              HasAlreadyEnteredMarker = true
              LastStation = currentStation
              LastPart = currentPart
              LastPartNum = currentPartNum
      
              TriggerEvent('esx_policejob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
            end
      
            if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
      
              HasAlreadyEnteredMarker = false
      
              TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
            end
        end
      Wait(0)
    end
end)

RegisterNetEvent('esx_policejob:coprevive')
AddEventHandler('esx_policejob:coprevive', function()
  target, distance = ESX.Game.GetClosestPlayer()
  if distance ~= -1 and distance <= 3 then
    TriggerEvent("mythic_progbar:client:progress", {
      name = "medical_revive",
      duration = 7500,
      label = "Giving Medical Treatment...",
      useWhileDead = false,
      canCancel = true,
      controlDisables = {
          disableMovement = true,
          disableCarMovement = true,
          disableMouse = false,
          disableCombat = true,
        },
        animation = {
            animDict = "amb@medic@standing@tendtodead@base",
            anim = "base",
        }
  }, function(status)
      if not status then
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('esx_policejob:copreviveServer', GetPlayerServerId(target))
      end
    end)
  else
    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No player nearby.'})
  end
end)

local bac = 0.0

RegisterNetEvent('esx_policejob:updateBac')
AddEventHandler('esx_policejob:updateBac', function()
    bac = bac + 0.04
    if bac >= 0.40 then
      TriggerEvent('esx_admin:kill', source)
    end
end)

RegisterNetEvent('esx_policejob:bacChecked')
AddEventHandler('esx_policejob:bacChecked', function(targetid)
    TriggerServerEvent("esx_policejob:SetState", bac)
    exports['mythic_notify']:SendAlert('inform', 'You have a BAC of '..bac, 5000)
end)

RegisterNetEvent('esx_policejob:bac')
AddEventHandler('esx_policejob:bac', function()
  local player, distance = ESX.Game.GetClosestPlayer()
  if distance ~= -1 and distance <= 3 then
      TriggerServerEvent("esx_policejob:CheckBAC", GetPlayerServerId(player))
  else
    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No player nearby.'})
  end
end)

RegisterNetEvent('esx_policejob:lockpick')
AddEventHandler('esx_policejob:lockpick', function()
  local playerPed = PlayerPedId()
  local coords = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then

    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)

    if DoesEntityExist(vehicle) then

      TriggerEvent("mythic_progbar:client:progress", {
        name = "mecano_repair",
        duration = 5000,
        label = "Lockpicking...",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
          }
    }, function(status)
        if not status then
          ClearPedTasks(playerPed)
    
          SetVehicleDoorsLocked(vehicle, 1)
          SetVehicleDoorsLockedForAllPlayers(vehicle, false)
  
          exports['mythic_notify']:SendAlert('inform', 'Vehicle Unlocked', 2500)
        end
      end)

      RequestAnimDict('veh@break_in@0h@p_m_one@')
      Citizen.Wait(100)
      Wait(300)
      while not HasAnimDictLoaded('veh@break_in@0h@p_m_one@') do
        Citizen.Wait(100)
      end
      TaskPlayAnim(playerPed, 'veh@break_in@0h@p_m_one@', 'low_force_entry_ds', 8.0, -8, -1, 0, 0, 0, 0, 0)
      Wait(1500)
      TaskPlayAnim(playerPed, 'veh@break_in@0h@p_m_one@', 'low_force_entry_ds', 8.0, -8, -1, 17, 0, 0, 0, 0)
      Wait(1500)
      TaskPlayAnim(playerPed, 'veh@break_in@0h@p_m_one@', 'low_force_entry_ds', 8.0, -8, -1, 17, 0, 0, 0, 0)
      Wait(1500)
    end
  end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do
    if IsControlPressed(0, 38) and IsControlJustPressed(0, Keys['LEFT']) then
      TriggerEvent('esx_policejob:escortclient')
    end
    if IsControlPressed(0, 38) and IsControlJustPressed(0, 27) and PlayerData.job ~= nil and PlayerData.job.name == 'police' then
      if IsControlPressed(0, Keys['LEFTSHIFT']) then
        TriggerEvent('esx_policejob:requesthardclient')
      else
        TriggerEvent('esx_policejob:requestarrestclient')
      end
    end
    if IsControlPressed(0, 38) and IsControlJustPressed(0, 173) and PlayerData.job ~= nil and PlayerData.job.name == 'police' then
      TriggerEvent('esx_policejob:uncuffclient')
    end
    if IsControlPressed(0, 38) and IsControlJustPressed(0, 175) then
      TriggerEvent('esx_policejob:putinvehicleclient')
    end
    if IsControlPressed(0, 38) and IsControlPressed(0, 21) and IsControlJustPressed(0, 175) then
      TriggerEvent('esx_policejob:outvehicleclient')
    end

    if IsControlPressed(0, 38) and IsControlJustPressed(0, 27) and PlayerData.job ~= nil and PlayerData.job.name ~= 'police' then
      if IsControlPressed(0, Keys['LEFTSHIFT']) then
        TriggerEvent('esx_policejob:requesthardclient2')
      else
        TriggerEvent('esx_policejob:requestarrestclient2')
      end
    end
    if IsControlPressed(0, 38) and IsControlJustPressed(0, 173) and PlayerData.job ~= nil and PlayerData.job.name ~= 'police' then
      TriggerEvent('esx_policejob:uncuffclient2')
    end
    Citizen.Wait(0)

    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlPressed(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'police' and (GetGameTimer() - GUI.Time) > 150 then

        if CurrentAction == 'menu_vehicle_spawner' then
          OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
        end

        if CurrentAction == 'delete_vehicle' then

          local vehengine = GetVehicleEngineHealth(CurrentActionData.vehicle)
          ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
          if vehengine < 700.0 then
          TriggerServerEvent('addmoney:policecar', "false")
          else
            TriggerServerEvent('addmoney:policecar', "true")
          end
        end

        CurrentAction = nil
        GUI.Time = GetGameTimer()
      end
    end
  end
end)

RegisterNetEvent('reload-cuff:complete')
AddEventHandler('reload-cuff:complete', function()
  Complete = true
end)

RegisterNetEvent('reload-cuff:fail')
AddEventHandler('reload-cuff:fail', function()
  Complete = false
end)

RegisterNetEvent('esx_policejob:hasMoney')
AddEventHandler('esx_policejob:hasMoney', function()
    moneyInPoliceBank = true
end)

--------Judge License--------

RegisterNetEvent('judge:givefishlicense')
AddEventHandler('judge:givefishlicense', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
	    TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'fishing')
        exports['mythic_notify']:SendAlert('inform', 'You gave a fishing license.', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
    else
 	    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No player nearby.'})
    end
end)

RegisterNetEvent('judge:givehuntlicense')
AddEventHandler('judge:givehuntlicense', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
	    TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'hunting')
        exports['mythic_notify']:SendAlert('inform', 'You gave a hunting license.', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
    else
 	    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No player nearby.'})
    end
end)

RegisterNetEvent('judge:givegunlicense')
AddEventHandler('judge:givegunlicense', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
	    TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'weapon')
        exports['mythic_notify']:SendAlert('inform', 'You gave a weapon license.', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
    else
 	    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No player nearby.'})
    end
end)

RegisterNetEvent('judge:givebeerlicense')
AddEventHandler('judge:givebeerlicense', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
	    TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'liquor')
        exports['mythic_notify']:SendAlert('inform', 'You gave a liquor license.', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
    else
 	    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No player nearby.'})
    end
end)

RegisterNetEvent('judge:givebarlicense')
AddEventHandler('judge:givebarlicense', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
	    TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'bar')
        exports['mythic_notify']:SendAlert('inform', 'You gave a bar certification.', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
    else
 	    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No player nearby.'})
    end
end)

RegisterNetEvent('judge:givepilicense')
AddEventHandler('judge:givepilicense', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
	    TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'picert')
        exports['mythic_notify']:SendAlert('inform', 'You gave a private investigator license.', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
    else
 	    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No player nearby.'})
    end
end)

RegisterNetEvent('judge:givesecuritylicense')
AddEventHandler('judge:givesecuritylicense', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
	    TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'security')
        exports['mythic_notify']:SendAlert('inform', 'You gave a security license.', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
    else
 	    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No player nearby.'})
    end
end)

RegisterNetEvent('judge:givepilotlicense')
AddEventHandler('judge:givepilotlicense', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
	    TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'pilot')
        exports['mythic_notify']:SendAlert('inform', 'You gave a pilots license.', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
    else
 	    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No player nearby.'})
    end
end)