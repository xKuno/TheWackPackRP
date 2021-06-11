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

local PlayerData              = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local CurrentlyTowedVehicle   = nil

ESX                           = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
  
  Citizen.Wait(5000)
  PlayerData = ESX.GetPlayerData()
end)

function SetVehicleMaxMods(vehicle)
  local props = {
    modArmor    = 4,
    modEngine       = 3,
    modBrakes       = 2,
    modTransmission = 2,
    modSuspension   = 3,
    modTurbo        = true,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)
end

function OpenMecanoActionsMenu()

  local elements = {
    {label = _U('vehicle_list'), value = 'vehicle_list'}
  }

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mecano_actions',
    {
      title    = _U('mechanic'),
      align    = 'right',
      elements = elements
    },
    function(data, menu)
      if data.current.value == 'vehicle_list' then

            local elements = {
              {label = 'Flatbed', value = 'ct660tow'}
            }

            ESX.UI.Menu.CloseAll()

            ESX.UI.Menu.Open(
              'default', GetCurrentResourceName(), 'spawn_vehicle',
              {
                title    = _U('service_vehicle'),
                align    = 'right',
                elements = elements
              },
              function(data, menu)
                for i=1, #elements, 1 do
                    ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 180.285, function(vehicle)
                      local playerPed = PlayerPedId()
                      TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                      SetVehicleMaxMods(vehicle)
                    end)
                end
                menu.close()
              end,
              function(data, menu)
                menu.close()
                OpenMecanoActionsMenu()
              end
            )

      end

    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'mecano_actions_menu'
      CurrentActionMsg  = _U('open_actions')
      CurrentActionData = {}
    end
  )
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

AddEventHandler('esx_mecanojob:hasEnteredMarker', function(zone)

  if zone == 'MecanoActions' then
    CurrentAction     = 'mecano_actions_menu'
    CurrentActionMsg  = _U('open_actions')
    CurrentActionData = {}
  end

  if zone == 'Garage' then
    CurrentAction     = 'mecano_harvest_menu'
    CurrentActionMsg  = _U('harvest_menu')
    CurrentActionData = {}
  end

  if zone == 'VehicleDeleter' then

    local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(playerPed,  false) then

      local vehicle = GetVehiclePedIsIn(playerPed,  false)

      CurrentAction     = 'delete_vehicle'
      CurrentActionMsg  = _U('veh_stored')
      CurrentActionData = {vehicle = vehicle}
    end
  end

end)

-- Display markers
Citizen.CreateThread(function()
  while true do
    Wait(0)
    if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then

      local coords = GetEntityCoords(PlayerPedId())

      for k,v in pairs(Config.Zones) do
        if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
          DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
        end
      end
    end
  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
  while true do
    Wait(0)
    if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
      local coords      = GetEntityCoords(PlayerPedId())
      local isInMarker  = false
      local currentZone = nil
      for k,v in pairs(Config.Zones) do
        if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
          isInMarker  = true
          currentZone = k
        end
      end
      if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
        HasAlreadyEnteredMarker = true
        LastZone                = currentZone
        TriggerEvent('esx_mecanojob:hasEnteredMarker', currentZone)
      end
      if not isInMarker and HasAlreadyEnteredMarker then
        HasAlreadyEnteredMarker = false
      end
    end
  end
end)

-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if CurrentAction ~= nil then

          SetTextComponentFormat('STRING')
          AddTextComponentString(CurrentActionMsg)
          DisplayHelpTextFromStringLabel(0, 0, 1, -1)

          if IsControlJustReleased(0, 38) and PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then

            if CurrentAction == 'mecano_actions_menu' then
                OpenMecanoActionsMenu()
            end

            if CurrentAction == 'delete_vehicle' then
              ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
            end

            CurrentAction = nil
          end
        end

    end
end)

RegisterNetEvent('esx_mecanojob:repairclient')
AddEventHandler('esx_mecanojob:repairclient', function()
        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)

        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

          local vehicle = nil

          if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
          else
            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
          end

          if DoesEntityExist(vehicle) and not IsPedInAnyVehicle(playerPed) then
            SetVehicleDoorOpen(vehicle, 4, false, true)
            SetVehicleEngineOn(vehicle,  false,  true)
            TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
            TriggerEvent("mythic_progbar:client:progress", {
              name = "mecano_repair",
              duration = 20000,
              label = "Repairing...",
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
                  SetVehicleFixed(vehicle)
                  SetVehicleDeformationFixed(vehicle)
                  SetVehicleUndriveable(vehicle, false)
                  SetVehicleEngineOn(vehicle,  true,  true)
                  ClearPedTasksImmediately(playerPed)
                  ESX.ShowNotification('Vehicle Repaired')
              end
          end)
        elseif IsPedInAnyVehicle(playerPed) then
          ESX.ShowNotification('You need to be outside of the vehicle.')
      end
    end
end)

RegisterNetEvent('esx_mecanojob:cleanclient')
AddEventHandler('esx_mecanojob:cleanclient', function()
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)

    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

      local vehicle = nil

      if IsPedInAnyVehicle(playerPed, false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)
      else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
      end

      if DoesEntityExist(vehicle) and not IsPedInAnyVehicle(playerPed) then
        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
        TriggerEvent("mythic_progbar:client:progress", {
          name = "mecano_repair",
          duration = 5000,
          label = "Cleaning...",
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
            SetVehicleDirtLevel(vehicle, 0)
            ClearPedTasksImmediately(playerPed)
            ESX.ShowNotification('Vehicle Cleaned')
          end
      end)
      elseif IsPedInAnyVehicle(playerPed) then
        ESX.ShowNotification('You need to be outside of the vehicle.')
      end
    end
end)

RegisterNetEvent('esx_mecanojob:towclient')
AddEventHandler('esx_mecanojob:towclient', function()
    local playerped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerped, true)

    local towmodel = GetHashKey('ct660tow')
    local isVehicleTow = IsVehicleModel(vehicle, towmodel)

    if isVehicleTow then
      local targetVehicle = ESX.Game.GetVehicleInDirection()

      if CurrentlyTowedVehicle == nil then
        if targetVehicle ~= 0 then
          if not IsPedInAnyVehicle(playerped, true) then
            if vehicle ~= targetVehicle then
              TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3, 'towtruck', 0.5)
              Wait(2000)
              AttachEntityToEntity(targetVehicle, vehicle, GetEntityBoneIndexByName(vehicle, 'scoop'), 0.0 + 0.0, -1.5 + 2.2, 0.0 + 22.5, 0, 0, 0, 1, 1, 0, 1, 0, 1)
              CurrentlyTowedVehicle = targetVehicle
              ESX.ShowNotification('Vehicle successfully attached.')
            else
              ESX.ShowNotification('You can\'t attach your own tow truck.')
            end
          end
        else
          ESX.ShowNotification('There is no vehicle to be attached.')
        end
      else
        AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
        DetachEntity(CurrentlyTowedVehicle, true, true)

        CurrentlyTowedVehicle = nil

        ESX.ShowNotification('Vehicle successfully detached.')
      end
    else
      ESX.ShowNotification('Action impossible! You need a Flatbed.')
    end
end)

--REPAIR KIT

RegisterNetEvent('Reload_Repair:onUse')
AddEventHandler('Reload_Repair:onUse', function()
  local playerPed   = PlayerPedId()
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
      ESX.ShowNotification('You must be outside of the vehicle.')
    else
      vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end

    local d1,d2 = GetModelDimensions(GetEntityModel(vehicle))
    local moveto = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d2["y"]+0.5,0.2)
    local dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(PlayerPedId()))
    local count = 1000
    
    while dist > 1.5 and count > 0 do
      dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(PlayerPedId()))
      Citizen.Wait(1)
      count = count - 1
      DrawText3Ds(moveto["x"],moveto["y"],moveto["z"],"Move here to repair.")
    end

    if DoesEntityExist(vehicle) and count > 0 then
      Citizen.Wait(100)

      SetVehicleDoorOpen(vehicle, 4, 0, 0)
      Citizen.Wait(100)
      RepairVehicleAnimation()

      Citizen.CreateThread(function()
        
        ThreadID = GetIdOfThisThread()
        fixingvehicle = true

        local vehbody = GetVehicleBodyHealth(vehicle)
        local vehengine = GetVehicleEngineHealth(vehicle)
        if Complete == false then
          Complete = nil
        elseif Complete == true then

          if vehbody < 945.0 then
            SetVehicleBodyHealth(vehicle, 945.0)
          end
          if vehengine < 700.0 then
            SetVehicleEngineHealth(vehicle, 700.0)
          end
          if GetEntityModel(vehicle) == GetHashKey("BLAZER") then
            SetVehicleEngineHealth(vehicle, 600.0)
            SetVehicleBodyHealth(vehicle, 800.0)
          end
          for i = 0, 5 do
          if IsVehicleTyreBurst(vehicle, i) then
            SetVehicleTyreFixed(vehicle, i) 
          end
          SetVehicleUndriveable(vehicle, false)
          SetVehicleDeformationFixed(vehicle)
          SetVehicleDoorShut(vehicle, 4, 1, 1)
        end
      end

          ClearPedTasksImmediately(playerPed)
          TriggerServerEvent('Reload_Repair:removeKit')
          fixingvehicle = false
          Complete = nil
        end)
      end
    end
  end)
  
RegisterNetEvent('Reload_Repair:onUse2')
AddEventHandler('Reload_Repair:onUse2', function()
  local playerPed   = PlayerPedId()
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
      ESX.ShowNotification('You must be outside of the vehicle.')
    else
      vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end
  
    local d1,d2 = GetModelDimensions(GetEntityModel(vehicle))
    local moveto = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,d2["y"]+0.5,0.2)
    local dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(PlayerPedId()))
    local count = 1000
    
    while dist > 1.5 and count > 0 do
      dist = #(vector3(moveto["x"],moveto["y"],moveto["z"]) - GetEntityCoords(PlayerPedId()))
      Citizen.Wait(1)
      count = count - 1
      DrawText3Ds(moveto["x"],moveto["y"],moveto["z"],"Move here to repair.")
    end

    if DoesEntityExist(vehicle) and count > 0 then
      Citizen.Wait(100)

      SetVehicleDoorOpen(vehicle, 4, 0, 0)
      Citizen.Wait(100)
      RepairVehicleAnimation()

      Citizen.CreateThread(function()
        
        ThreadID = GetIdOfThisThread()
        fixingvehicle = true

        local vehbody = GetVehicleBodyHealth(vehicle)
        local vehengine = GetVehicleEngineHealth(vehicle)
        if Complete == false then
          Complete = nil
        elseif Complete == true then

          if vehbody < 945.0 then
            SetVehicleBodyHealth(vehicle, 1000.0)
          end
          if vehengine < 700.0 then
            SetVehicleEngineHealth(vehicle, 1000.0)
          end
          if GetEntityModel(vehicle) == GetHashKey("BLAZER") then
            SetVehicleEngineHealth(vehicle, 1000.0)
            SetVehicleBodyHealth(vehicle, 1000.0)
          end
          for i = 0, 5 do
          if IsVehicleTyreBurst(vehicle, i) then
            SetVehicleTyreFixed(vehicle, i) 
          end
          SetVehicleFixed(vehicle)
          SetVehicleDeformationFixed(vehicle)
          SetVehicleUndriveable(vehicle, false)
        end
      end
      
          ClearPedTasksImmediately(playerPed)
          TriggerServerEvent('Reload_Repair:removeKit2')
          fixingvehicle = false
          Complete = nil
        end)
      end
    end
  end)

-- Animations
function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function RepairVehicleAnimation()
  local playerPed = PlayerPedId()
  local vehicle = nil
  local coords    = GetEntityCoords(playerPed)

  vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
  TaskTurnPedToFaceEntity(playerPed, vehicle, Config.RepairTime * 1000)
  loadAnimDict( "mini@repair" )     
  TaskPlayAnim( playerPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
  TriggerEvent('repairbar')
  while Complete == nil do
    Wait(0)
  end
  ClearPedSecondaryTask(playerPed)
end

-- Stops player from doing anything except stuff needed
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

      if fixingvehicle then
      DisableAllControlActions(0)
      EnableControlAction(0, Keys['G'], true)
      EnableControlAction(0, Keys['T'], true)
      EnableControlAction(0, Keys['N'], true)
      EnableControlAction(0, Keys['DEL'], true)
      EnableControlAction(0, Keys['F10'], true)
      EnableControlAction(0, Keys['CAPS'], true)
      EnableControlAction(0, 1, true) -- Disable pan
      EnableControlAction(0, 2, true) -- Disable tilt
        end
    end
end)

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

RegisterNetEvent('reload-repair:complete')
AddEventHandler('reload-repair:complete', function()
  Complete = true
end)

RegisterNetEvent('reload-repair:fail')
AddEventHandler('reload-repair:fail', function()
  Complete = false
end)