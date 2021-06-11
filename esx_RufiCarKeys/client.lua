Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 48, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["-"] = 84,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

TempPlates = {}     --- DON'T TOUCH!
HotwiredPlates = {} --- DON'T TOUCH!




ESX                           = nil
JobBypassed = false   ---- DON'T TOUCH THIS!!!
playerdata = {}
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
     
	PlayerData = ESX.GetPlayerData()
	Citizen.Wait(math.random(2000, 4000))
    TriggerServerEvent('RufiCarkey:getKeys')
	
  if Config.JobBypass then
	if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
	JobBypassed = true
	end
  end	
	
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job

 if Config.JobBypass then

	if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
	JobBypassed = true
	else
	JobBypassed = false
	end
 end	
	
end)


function PlateBypass(plate)
lotengo = false
	
	for i = 1, #Config.AllowedPlates do
		if type(plate) ~= 'nil' and type(Config.AllowedPlates[i]) ~= 'nil' then
			if plate == Config.AllowedPlates[i] then	
				lotengo = true
				break
			end
		end
	end
	
	
	
	return lotengo
end


plates = {}
steam = nil
RegisterNetEvent('RufiCarkey:getplatesCK')
AddEventHandler('RufiCarkey:getplatesCK', function(steamid, isAdmin)
steam = steamid
if isAdmin and Config.AllowGroupAdminBypass then
JobBypassed = true
end


    ESX.TriggerServerCallback('ruficarkey:getPlatesInit', function(platesi)


     plates = {}
        for k, matri in pairs(platesi) do
		table.insert(plates, {owner = matri.owner, name = matri.name, plate = matri.plate, model = matri.model})
	    end
		print('All car keys loaded')
	end)	
	
end)

RegisterNetEvent('RufiCarkey:refreshplates')
AddEventHandler('RufiCarkey:refreshplates', function()
Wait(math.random(500, 2000))
    TriggerServerEvent('RufiCarkey:getKeys')
end)

RegisterNetEvent('RufiCarkey:OpenMenu')
AddEventHandler('RufiCarkey:OpenMenu', function()
	Wait(100)
	OpenKeyMenu()
end)

RegisterCommand("keys", function()
	OpenKeyMenu()
end)

function OpenKeyMenu()

	local elements = {}

	local carSpots = nil
	ESX.TriggerServerCallback('CarSpots', function(cb)
		carSpots = cb
	end, i)
	while carSpots == nil do
		Wait(0)
	end
	
	for i=1, #carSpots, 1 do 
		if carSpots[i].impound == 1 then
			table.insert(elements, {
				label = ('<span style="color:lawngreen;">%s</span> - %s: - <span style="color:yellow;">%s</span>'):format(string.upper(carSpots[i].model), carSpots[i].plate, carSpots[i].garage),  
				value = carSpots[i].plate,
				model = carSpots[i].model,
				owner = carSpots[i].owner
			})
		else
			table.insert(elements, {
				label = ('<span style="color:lawngreen;">%s</span> - %s: - <span style="color:yellow;">%s</span>'):format(string.upper(carSpots[i].model), carSpots[i].plate, 'impound'),  
				value = carSpots[i].plate,
				model = carSpots[i].model,
				owner = carSpots[i].owner
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), '',
	{
		title    = 'Car Keys',
		align    = 'right',
		elements = elements
	}, function(data, menu)
		menu.close()
		if data.current.owner ~= steam then
			TriggerEvent('esx:showNotification', 'You cannot manage this key.') 
		else
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), '',
			{
				title    = 'Give Or Remove?',
				align    = 'right',
				elements = {
					{label = 'Give', value = 'give'},
			
					{label = 'Remove',  value = 'remove'}
				}
			}, function(data5, menu5)
			menu.close()

			if data5.current.value == 'give' then
				OpenPlayerMenu(data.current.value, data.current.model)
			end
				
			if data5.current.value == 'remove' then
				menu5.close()
				QuitMyKeys(data.current.value)
			end
	
			end, function(data, menu)
				menu.close()
			end)
		end
	end, function(data5, menu5)
		menu5.close()
	end)
	carSpots = nil
end

function QuitMyKeys(matric)

 if Config.RemoveToNearestPlayersOnly then
 
     local playerPed = PlayerPedId()
	 local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
     local foundPlayers = false
     local elements = {}

     for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            foundPlayers = true

            table.insert(
                elements,
                {
                    label = GetPlayerName(players[i]),
                    value = GetPlayerServerId(players[i]),
					name = GetPlayerName(players[i])
                }
            )
        end
     end
	
	   ESX.UI.Menu.Open('default', GetCurrentResourceName(), '',
		{
			title    = 'To who?',
			align    = 'right',
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), '--',
			{
				title    = 'Are you sure?', data.current.name,
				align    = 'right',
				elements = {
					{label = 'No',  value = 'no'},
					{label = 'Yes', value = 'yesi'}
				}
			}, function(data3, menu3)

			

				if data3.current.value == 'yesi' then
                        menu3.close()

                    exports['mythic_notify']:SendAlert('inform', 'Key Removed!', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
					
					TriggerServerEvent('RufiCarkey:QuitPlateOther', data.current.value, matric)
					

					

				end
				if data3.current.value == 'no' then
                        menu3.close()

					

					

				end

			end, function(data3, menu3)
				menu3.close()
			end)

		end, function(data, menu)
			menu.close()
		end)


 else

	ESX.TriggerServerCallback('ruficarkey:getPlayers', function(players)

		local elements = {}

		for i=1, #players, 1 do
			
				table.insert(elements, {
					label = players[i].name,
					value = players[i].source,
					name = players[i].name,
					identifier = players[i].identifier
				})
			
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), '',
		{
			title    = 'To who?',
			align    = 'right',
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), '--',
			{
				title    = 'Are you sure?', data.current.name,
				align    = 'right',
				elements = {
					{label = 'No',  value = 'no'},
					{label = 'Yes', value = 'yesi'}
				}
			}, function(data3, menu3)

			

				if data3.current.value == 'yesi' then
                        menu3.close()

                    exports['mythic_notify']:SendAlert('inform', 'Key Removed!', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
					
					TriggerServerEvent('RufiCarkey:QuitPlateOther', data.current.value, matric)
					

					

				end
				if data3.current.value == 'no' then
                        menu3.close()

					

					

				end

			end, function(data3, menu3)
				menu3.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end)

 end
end



function OpenOwnrMenu(matric, model)

 if Config.GiveOwnershipToNearestPlayersOnly then
 
     local playerPed = PlayerPedId()
	 local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
     local foundPlayers = false
     local elements = {}

     for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            foundPlayers = true

            table.insert(
                elements,
                {
                    label = GetPlayerName(players[i]),
                    value = GetPlayerServerId(players[i]),
					name = GetPlayerName(players[i])
                }
            )
        end
     end
 
     ESX.UI.Menu.Open('default', GetCurrentResourceName(), '--',
		{
			title    = 'To who?',
			align    = 'right',
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), '',
			{
				title    = 'Are you sure?', data.current.name,
				align    = 'right',
				elements = {
					{label = 'No',  value = 'no'},
					{label = 'Yes', value = 'yesi'}
				}
			}, function(data3, menu3)

			

				if data3.current.value == 'yesi' then

                    exports['mythic_notify']:SendAlert('inform', 'Gave Key Ownership', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
					
					TriggerServerEvent('RufiCarkey:ChangeOwner', data.current.value, matric, model)
					menu3.close()
					menu.close()
					

					

				end
				
				if data3.current.value == 'no' then

					
					menu3.close()
					

					

				end
				

			end, function(data3, menu3)
				menu3.close()
			end)

		end, function(data, menu)
			menu.close()
		end)
 
 

 else
	ESX.TriggerServerCallback('ruficarkey:getPlayers', function(players)

		local elements = {}

		for i=1, #players, 1 do
			
				table.insert(elements, {
					label = players[i].name,
					value = players[i].source,
					name = players[i].name,
					identifier = players[i].identifier
				})
			
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), '--',
		{
			title    = 'To who?',
			align    = 'right',
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), '',
			{
				title    = 'Are you sure?', data.current.name,
				align    = 'right',
				elements = {
					{label = 'No',  value = 'no'},
					{label = 'Yes', value = 'yesi'}
				}
			}, function(data3, menu3)

			

				if data3.current.value == 'yesi' then

                    exports['mythic_notify']:SendAlert('inform', 'Key Ownership Given', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
					
					TriggerServerEvent('RufiCarkey:ChangeOwner', data.current.value, matric, model)
					menu3.close()
					menu.close()
					

					

				end
				
				if data3.current.value == 'no' then

					
					menu3.close()
					

					

				end
				

			end, function(data3, menu3)
				menu3.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end)
 end
end



function OpenPlayerMenu(matric, model)

 if Config.GiveToNearestPlayersOnly then
 
    local playerPed = PlayerPedId()
	 local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
     local foundPlayers = false
     local elements = {}

     for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            foundPlayers = true

            table.insert(
                elements,
                {
                    label = GetPlayerName(players[i]),
                    value = GetPlayerServerId(players[i]),
					name = GetPlayerName(players[i])
                }
            )
        end
     end
 
 
 
 
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), '--',
		{
			title    = 'To who?',
			align    = 'right',
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), '',
			{
				title    = 'Are you sure?', data.current.name,
				align    = 'right',
				elements = {
					{label = 'No',  value = 'no'},
					{label = 'Yes', value = 'yesi'}
				}
			}, function(data3, menu3)

			

				if data3.current.value == 'yesi' then

                    exports['mythic_notify']:SendAlert('inform', 'Gave Key.', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
					
					TriggerServerEvent('RufiCarkey:RegisterPlateOther', data.current.value, matric, model)
					menu3.close()
					

					

				end
				
				if data3.current.value == 'no' then

					
					menu3.close()
					

					

				end
				

			end, function(data3, menu3)
				menu3.close()
			end)

		end, function(data, menu)
			menu.close()
		end)
 
 
 
 
 
 else

	ESX.TriggerServerCallback('ruficarkey:getPlayers', function(players)

		local elements = {}

		for i=1, #players, 1 do
			
				table.insert(elements, {
					label = players[i].name,
					value = players[i].source,
					name = players[i].name,
					identifier = players[i].identifier
				})
			
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), '--',
		{
			title    = 'To who?',
			align    = 'right',
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), '',
			{
				title    = 'Are you sure?', data.current.name,
				align    = 'right',
				elements = {
					{label = 'No',  value = 'no'},
					{label = 'Yes', value = 'yesi'}
				}
			}, function(data3, menu3)

			

				if data3.current.value == 'yesi' then

                    exports['mythic_notify']:SendAlert('inform', 'Given Key.', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
					
					TriggerServerEvent('RufiCarkey:RegisterPlateOther', data.current.value, matric, model)
					menu3.close()
					

					

				end
				
				if data3.current.value == 'no' then

					
					menu3.close()
					

					

				end
				

			end, function(data3, menu3)
				menu3.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end)
 end
end






function comprobarmatri(plate)
lotengo = false
	
	for i = 1, #plates do
		if type(plate) ~= 'nil' and type(plates[i].plate) ~= 'nil' then
			if plate == plates[i].plate then	
				lotengo = true
				break
			end
		end
	end
	return lotengo
end

function NpcTempKey()

    if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId(PlayerPedId()))) and Config.GetKeyOnStealNpcCars then
   
   
     
			local vehicle = GetVehiclePedIsTryingToEnter(PlayerPedId())
			if GetPedInVehicleSeat(vehicle, -1) ~= 0 then
				if not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1)) then
				
			      local platen = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
		  
		          TriggerEvent('RufiCarkey:TempKey', platen)
				  
				end
			end
			
	end	
		
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

trigger = true
nokey = false
EngOff = false
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10)
	
	if (IsControlJustPressed(1, Keys["F"])) then
	NpcTempKey()
	end
		
	if (IsControlJustPressed(1, Config.MenuOpenKey)) and Config.MenuOpenKeyAllow then
	
	TriggerEvent('RufiCarkey:OpenMenu')
	
	end
   
  if Config.EnableKeyEngine then
    
	if IsPedInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() then
	     if trigger then
		 trigger = false 
		 nokey = true
		 end
	 
	 
   if (IsControlJustPressed(1, Config.IgnitionKey)) then
	      local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		  local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
		  local model = GetEntityModel(vehicle)    
          local namelower = string.lower(GetDisplayNameFromVehicleModel(model))
          local nameupper = string.upper(GetDisplayNameFromVehicleModel(model))   
	 
	 if comprobarmatri(plate) or comprobarmatrihw(plate) or JobBypassed or Config.PlateBypass and PlateBypass(plate) or comprobarmatriTMP(plate) or Config.ModelBypass and table.contains(Config.AllowedModels, namelower) or Config.ModelBypass and table.contains(Config.AllowedModels, nameupper) then
                     
        
	 nokey = false
	  if GetIsVehicleEngineRunning(GetVehiclePedIsIn(PlayerPedId(), false)) then
	  SetVehicleEngineOn(vehicle, false, false, false, true)
	  EngOff = true
	  else
	  EngOff = false
	  SetVehicleEngineOn(vehicle, false, true, false, true)
	  end
	 else
      exports['mythic_notify']:SendAlert('inform', 'You don\'t have the vehicle key.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
	 end
	 
	 end
  else
	 trigger = true
	 EngOff = false
  end		
	
	if nokey or EngOff then
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	SetVehicleEngineOn(vehicle, false, false, false, true)
	end
	
		end		
	end
end)

RegisterKeyMapping('togglelock', 'Toggle Car Lock', 'keyboard', 'l')

local doing = false

RegisterCommand('togglelock', function()
	local playerPed = PlayerPedId()
	local dict = "anim@mp_player_intmenu@key_fob@"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(0)
	end
	local coords = GetEntityCoords(playerPed)
	local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
	local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
	local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
	if DoesEntityExist(vehicle) and not IsPedInAnyVehicle(playerPed) then
		if comprobarmatri(plate) or comprobarmatriTMP(plate) or JobBypassed or PlateBypass and PlateBypass(plate) then
			local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
			vehicleLabel = GetLabelText(vehicleLabel)
			local lock = GetVehicleDoorLockStatus(vehicle)
			if lock == 1 or lock == 0 then
				local networkId = VehToNet(vehicle)
				SetVehicleDoorShut(vehicle, 0, false)
				SetVehicleDoorShut(vehicle, 1, false)
				SetVehicleDoorShut(vehicle, 2, false)
				SetVehicleDoorShut(vehicle, 3, false)
				SetVehicleDoorsLocked(vehicle, 2)
				PlayVehicleDoorCloseSound(vehicle, 1)
				exports['mythic_notify']:SendAlert('inform', 'Vehicle Locked', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
				TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5.0, 'lock', 0.7)
				if not doing then
					vehicleKeys = CreateObject(GetHashKey("prop_cuff_keys_01"), 0, 0, 0, true, true, true) -- creates object
					AttachEntityToEntity(vehicleKeys, playerPed, GetPedBoneIndex(playerPed, 57005), 0.11, 0.03, -0.03, 90.0, 0.0, 0.0, true, true, false, true, 1, true) -- object is attached to right hand
				end
				doing = true
				TaskPlayAnim(playerPed, dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
				SetVehicleLights(vehicle, 2)
				Citizen.Wait(150)
				SetVehicleLights(vehicle, 0)
				Citizen.Wait(150)
				SetVehicleLights(vehicle, 2)
				Citizen.Wait(150)
				SetVehicleLights(vehicle, 0)
				Locked = true
				Wait(500)
				DeleteObject(vehicleKeys)
				doing = false
			elseif lock == 2 then
				local networkId = VehToNet(vehicle)
				SetVehicleDoorsLocked(vehicle, 1)
				PlayVehicleDoorOpenSound(vehicle, 0)
				exports['mythic_notify']:SendAlert('inform', 'Vehicle Unlocked', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
				TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5.0, 'unlock', 0.3)
				if not doing then
					vehicleKeys = CreateObject(GetHashKey("prop_cuff_keys_01"), 0, 0, 0, true, true, true) -- creates object
					AttachEntityToEntity(vehicleKeys, playerPed, GetPedBoneIndex(playerPed, 57005), 0.11, 0.03, -0.03, 90.0, 0.0, 0.0, true, true, false, true, 1, true) -- object is attached to right hand
				end
				doing = true
				TaskPlayAnim(playerPed, dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
				TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
				SetVehicleLights(vehicle, 2)
				Citizen.Wait(150)
				SetVehicleLights(vehicle, 0)
				Citizen.Wait(150)
				SetVehicleLights(vehicle, 2)
				Citizen.Wait(150)
				SetVehicleLights(vehicle, 0)
				Locked = true
				Wait(500)
				DeleteObject(vehicleKeys)
				doing = false
			end
		end
	end

	if IsPedInAnyVehicle(playerPed) then
		vehicle = GetVehiclePedIsIn(playerPed)
		playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
		vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
		plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
		if comprobarmatri(plate) or comprobarmatriTMP(plate) or JobBypassed or PlateBypass and PlateBypass(plate) then
			local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
			vehicleLabel = GetLabelText(vehicleLabel)
			local lock = GetVehicleDoorLockStatus(vehicle)
			if lock == 1 or lock == 0 then
			local networkId = VehToNet(vehicle)
				SetVehicleDoorShut(vehicle, 0, false)
				SetVehicleDoorShut(vehicle, 1, false)
				SetVehicleDoorShut(vehicle, 2, false)
				SetVehicleDoorShut(vehicle, 3, false)
				SetVehicleDoorsLocked(vehicle, 2)
				PlayVehicleDoorCloseSound(vehicle, 1)
				exports['mythic_notify']:SendAlert('inform', 'Vehicle Locked', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
				TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5.0, 'lock', 0.7)
				SetVehicleLights(vehicle, 2)
				Citizen.Wait(150)
				SetVehicleLights(vehicle, 0)
				Citizen.Wait(150)
				SetVehicleLights(vehicle, 2)
				Citizen.Wait(150)
				SetVehicleLights(vehicle, 0)
				Locked = true
			elseif lock == 2 then
			local networkId = VehToNet(vehicle)
				SetVehicleDoorsLocked(vehicle, 1)
				PlayVehicleDoorOpenSound(vehicle, 0)
				exports['mythic_notify']:SendAlert('inform', 'Vehicle Unlocked', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
				TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5.0, 'unlock', 0.3)
				SetVehicleLights(vehicle, 2)
				Citizen.Wait(150)
				SetVehicleLights(vehicle, 0)
				Citizen.Wait(150)
				SetVehicleLights(vehicle, 2)
				Citizen.Wait(150)
				SetVehicleLights(vehicle, 0)
				Locked = true
			end
		end
	end	
end)

function comprobarmatrihw(plate)
lotengo = false
	
	for i = 1, #HotwiredPlates do
		if type(plate) ~= 'nil' and type(HotwiredPlates[i]) ~= 'nil' then
			if plate == HotwiredPlates[i] then	
				lotengo = true
				break
			end
		end
	end
	
	
	
	return lotengo
end


RegisterNetEvent('RufiCarkey:UseLockpick')
AddEventHandler('RufiCarkey:UseLockpick', function()
--Wait(math.random(500, 2000))

    HotWiring = false
    local playerPed = PlayerPedId()
  if not IsPedInAnyVehicle(playerPed, false) then

     local playerPed = PlayerPedId()
	            local coords = GetEntityCoords(playerPed)
	            local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
				local vehpos = GetEntityCoords(vehicle)
                local pos = GetEntityCoords(PlayerPedId())
                local streetName,_ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
                local streetName = GetStreetNameFromHashKey(streetName)
                local model = GetDisplayNameFromVehicleModel(vehicle)
                local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                vehicleLabel = GetLabelText(vehicleLabel)
                local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
                local gender = "unknown"
                local playermodel = GetEntityModel(playerPed)
                if (playermodel == GetHashKey("mp_f_freemode_01")) then
                    gender = "female"
                end
                if (playermodel == GetHashKey("mp_m_freemode_01")) then
                    gender = "male"
                end
                
 if vehicle ~= nil and vehicle ~= 0 then
   
     if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 2.5 then
	 
         if GetVehicleDoorLockStatus(vehicle) ~= 1 then
 
           time = Config.LockPickingTime
		   
		     if Config.UseProgressbar then
                            TriggerEvent("mythic_progbar:client:progress", {
                            name = "unique_action_name",
                            duration = time * 1000,
                            label = "Lockpicking...",
                            useWhileDead = false,
                            canCancel = false,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = false,
                                disableMouse = false,
                                disableCombat = true,
                                },

                            }, function(status)
                                if not status then
                                    exports['wp_dispatch']:addCall("10-31", "Grand Theft Auto", {
                                        {icon = "fas fa-road", info = streetName},
                                        {icon="fa-venus-mars", info=gender},
                                        {icon = "fa-car", info = vehicleLabel},
                                        {icon = "fa-car", info = plate}
                                        }, {pos.x, pos.y, pos.z}, "police", 3000, 186, 1 )
                                    exports['wp_dispatch']:addCall("10-31", "Grand Theft Auto", {
                                        {icon = "fas fa-road", info = streetName},
                                        {icon="fa-venus-mars", info=gender},
                                        {icon = "fa-car", info = vehicleLabel},
                                        {icon = "fa-car", info = plate}
                                        }, {pos.x, pos.y, pos.z}, "dispatch", 3000, 186, 1 )
                                end
                        end)
						
                   
                  end				   



    loadAnimDict("veh@break_in@0h@p_m_one@")
    TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(1000)
            time = time - 1
			if not Config.UseProgressbar then
             exports['mythic_notify']:SendAlert('inform', 'Lockpicking...', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
			end
            if time <= 0 then
                openingDoor = false
                StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
            end
        end
    end)
	       Citizen.Wait(time * 1000)
		   
		   probabilidad = math.random(1,4)
		
		if probabilidad ~= 3 then
		
        
        SetVehicleAlarm(vehicle, true)
		    SetVehicleAlarmTimeLeft(vehicle, 30 * 1000)
		    SetVehicleDoorsLocked(vehicle, 1)
        ClearPedTasksImmediately(playerPed)
        TaskEnterVehicle(playerPed, vehicle, 10.0, -1, 1.0, 1, 0)
		else
		ClearPedTasksImmediately(playerPed)
        exports['mythic_notify']:SendAlert('inform', 'Your lockpick has broken', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
		TriggerServerEvent('remove:lockpick')
		
		end
		   
	
	       else
		   
           exports['mythic_notify']:SendAlert('inform', 'The vehicle door is not closed.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
	
	     end
	      else
		  
          exports['mythic_notify']:SendAlert('inform', 'You are too far from the vehicle.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
		  
		  end
		  
	else
	
    exports['mythic_notify']:SendAlert('inform', 'There is not vehicle to lockpick!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
 end

end 
end)



function hotWire(vehicle)



	      local vehicle1 = GetVehiclePedIsIn(PlayerPedId(), false)
        local pPed = PlayerPedId()
        local pPos = GetEntityCoords(pPed)
        local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle1))
		
		local modelo = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle1))
        local name = GetPlayerName(PlayerId())
        local ped = GetPlayerPed(PlayerId())
        
    HW = true
	Config.HotWiringTimeS = Config.HotWiringTime / 1000 
	loadAnimDict("veh@break_in@0h@p_m_one@")
    while HW do
	        
            
            TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
            Citizen.Wait(1000)
            Config.HotWiringTimeS = Config.HotWiringTimeS - 1
			
            if Config.HotWiringTimeS <= 0 then
              HW = false
                StopAnimTask(PlayerPedId(), "nim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
            end
    end
    
    if HotWiring then
	  
      
	 SetVehicleRadioEnabled(vehicle, false)
	
      Citizen.Wait(1000)
	 prob = math.random(1, 5)
	 
	 if prob ~= 5 then
	 
	  table.insert(HotwiredPlates, plate)
	  HotWiring = false
      HW = false
      exports['mythic_notify']:SendAlert('inform', 'Hot Wired Vehicle!', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
	  else
      exports['mythic_notify']:SendAlert('inform', 'You broke the lockpick.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
	  HotWiring = false
      HW = false
	  end
	  
    end
   
   
    
	                    
	
	
end

RegisterNetEvent('RufiCarkey:TempKey')
AddEventHandler('RufiCarkey:TempKey', function(plate)
TempKey(plate)

end)


function comprobarmatriTMP(plate)
lotengo = false
	
	for i = 1, #TempPlates do
		if type(plate) ~= 'nil' and type(TempPlates[i]) ~= 'nil' then
			if plate == TempPlates[i] then	
				lotengo = true
				break
			end
		end
	end
	
	
	
	return lotengo
end



function TempKey(plateT)



    if plateT == nil then

	      local vehicle1 = GetVehiclePedIsIn(PlayerPedId(), false)
          local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle1))
		  
		  table.insert(TempPlates, plate)
      
	else
 
		
	 
	  table.insert(TempPlates, plateT)
	  
	  
    end
   
   
    
	                    
	
	
end



HW = false
tiempo = 1000
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(tiempo)
	tiempo = 1000
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    if HotWiring then
	tiempo = 0
      local veh = GetVehiclePedIsIn(playerPed, false)
      local vehPos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "bonnet"))
      if IsPedInAnyVehicle(playerPed, false) then
	  
	    if not HW then
        -- DrawText3Ds(vehPos.x, vehPos.y, vehPos.z, "Press [H] to hotwire")
	  
		
		end
        if IsControlJustPressed(0, 104) then
          SetVehicleNeedsToBeHotwired(veh, true)
          hotWire(veh)
		  
        end
      end
	 
    end
  end
end)

tiempo5 = 1000

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(tiempo5)
	tiempo5 = 1000
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    if HW then
	tiempo5 = 0
      local veh = GetVehiclePedIsIn(playerPed, false)
      local vehPos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "bonnet"))
      if IsPedInAnyVehicle(playerPed, false) then
		DrawText3Ds(vehPos.x, vehPos.y, vehPos.z, "Hotwiring... " .. Config.HotWiringTimeS .. " Seconds left" )
      end
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


function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end