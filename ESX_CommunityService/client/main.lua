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

  ESX = nil
  INPUT_CONTEXT = 51

  local isSentenced = false
  local communityServiceFinished = false
  local actionsRemaining = 0
  local availableActions = {}
  local disable_actions = false
  local lastActionRemoveTime = 0
  local vassoumodel = "prop_tool_broom"
  local vassour_net = nil
  local jailBreak = false

  local spatulamodel = "bkr_prop_coke_spatula_04"
  local spatula_net = nil

  Citizen.CreateThread(function()
	  while ESX == nil do
		  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		  Citizen.Wait(0)
	  end
  end)

  Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/comserv [ID] [Time]', 'Give player community service.')
    TriggerEvent('chat:addSuggestion', '/endcomserv [ID]', 'Unjail people.')
end)


  Citizen.CreateThread(function()
	  Citizen.Wait(2000)
	  TriggerServerEvent('esx_communityservice:checkIfSentenced')
  end)

  function FillActionTable(last_action)

	  while #availableActions < 5 do

		  local service_does_not_exist = true

		  local random_selection = Config.ServiceLocations[math.random(1,#Config.ServiceLocations)]

		  for i = 1, #availableActions do
			  if random_selection.coords.x == availableActions[i].coords.x and random_selection.coords.y == availableActions[i].coords.y and random_selection.coords.z == availableActions[i].coords.z then

				  service_does_not_exist = false

			  end
		  end

		  if last_action ~= nil and random_selection.coords.x == last_action.coords.x and random_selection.coords.y == last_action.coords.y and random_selection.coords.z == last_action.coords.z then
			  service_does_not_exist = false
		  end

		  if service_does_not_exist then
			  table.insert(availableActions, random_selection)
		  end

	  end

  end


RegisterNetEvent('esx_communityservice:inCommunityService')
AddEventHandler('esx_communityservice:inCommunityService', function(actions_remaining)
	  local playerPed = PlayerPedId()

	  if isSentenced then
		  return
	  end

	  JailIntro()

	  actionsRemaining = actions_remaining
	  lastActionRemoveTime = GetGameTimer()

	  FillActionTable()

	  ESX.Game.Teleport(playerPed, Config.ServiceLocation)
	  isSentenced = true
	  communityServiceFinished = false

	  while actionsRemaining > 0 and communityServiceFinished ~= true do

		  if IsPedInAnyVehicle(playerPed, false) then
			  ClearPedTasksImmediately(playerPed)
		  end

		  Citizen.Wait(20000)

		  if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.ServiceLocation.x, Config.ServiceLocation.y, Config.ServiceLocation.z) > 130 then
			  ESX.Game.Teleport(playerPed, Config.ServiceLocation)
			  TriggerEvent('chat:addMessage', { args = { _U('judge'), _U('escape_attempt') }, color = { 147, 196, 109 } })
			  TriggerServerEvent('esx_communityservice:extendService')
			  actionsRemaining = actionsRemaining + Config.ServiceExtensionOnEscape
		  end

	  end

	if jailBreak == false or jailBreak == nil then
		TriggerServerEvent('esx_communityservice:finishCommunityService', -1)
		ESX.Game.Teleport(playerPed, Config.ReleaseLocation)
		exports['mythic_notify']:SendAlert('inform', 'You are free! remember to pickup your items.', 5000)
		isSentenced = false
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
		end)
	end
	
	jailBreak = false
end)

RegisterNetEvent('esx_communityservice:finishCommunityService')
AddEventHandler('esx_communityservice:finishCommunityService', function(source)
	communityServiceFinished = true
	isSentenced = false
	actionsRemaining = 0
end)

RegisterNetEvent('esx_communityservice:BreakOutLocal')
AddEventHandler('esx_communityservice:BreakOutLocal', function(source)

	if actionsRemaining >= 1 then
		local playerPed = PlayerPedId()
		local cord = GetEntityCoords(PlayerPedId())
		local streetName,_ = GetStreetNameAtCoord(cord[1], cord[2], cord[3])
		local streetName = GetStreetNameFromHashKey(streetName)
		local gender = "unknown"
		local model = GetEntityModel(playerPed)
		if (model == GetHashKey("mp_f_freemode_01")) then
			gender = "female"
		end
		if (model == GetHashKey("mp_m_freemode_01")) then
			gender = "male"
		end
	
		exports['wp_dispatch']:addCall("10-99", "Jailbreak In Progress", {
			{icon="fas fa-road", info = streetName},
			{icon="fa-venus-mars", info=gender}
		}, {cord[1], cord[2], cord[3]}, "police", 3000, 118, 1 )
		exports['wp_dispatch']:addCall("10-99", "Jailbreak In Progress", {
			{icon="fas fa-road", info = streetName},
			{icon="fa-venus-mars", info=gender}
		}, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 118, 1 )

		communityServiceFinished = true
		isSentenced = false
		actionsRemaining = 0
		jailBreak = true
	end
end)

RegisterNetEvent('esx_communityservice:BreakOut')
AddEventHandler('esx_communityservice:BreakOut', function(source)
	local player, distance = ESX.Game.GetClosestPlayer()

	if distance ~= -1 and distance <= 3.0 then
		TriggerServerEvent('esx_communityservice:breakOutServer', GetPlayerServerId(player))
		TriggerServerEvent('esx_communityservice:removeHackerDevice', source)
		exports['mythic_notify']:SendAlert('inform', 'You used a modified phone in an attempt to break someone out of jail.', 5000)
	else
		exports['mythic_notify']:SendAlert('inform', 'No players nearby.', 2500)
	end
end)

  Citizen.CreateThread(function()
	  while true do
		  :: start_over ::
		  Citizen.Wait(1)

		  if actionsRemaining > 0 and isSentenced then
			  local time = GetGameTimer()

			  if (time - lastActionRemoveTime) >= 60000 then
				  TriggerServerEvent('esx_communityservice:completeServiceAlt')
				  actionsRemaining = actionsRemaining - 2
				  lastActionRemoveTime = time
			  end

			  draw2dText( _U('remaining_msg', ESX.Math.Round(actionsRemaining)), { 0.370, 0.955 } )
			  DrawAvailableActions()
			  DisableViolentActions()

			  local pCoords    = GetEntityCoords(PlayerPedId())

			  for i = 1, #availableActions do
				  local distance = GetDistanceBetweenCoords(pCoords, availableActions[i].coords, true)

				  if distance < 1.5 then
					  DisplayHelpText("Press ~INPUT_CONTEXT~ to start.")


					  if(IsControlJustReleased(1, 38))then
						  tmp_action = availableActions[i]
						  RemoveAction(tmp_action)
						  FillActionTable(tmp_action)
						  disable_actions = true

						  TriggerServerEvent('esx_communityservice:completeService')
						  actionsRemaining = actionsRemaining - 1

						  if (tmp_action.type == "cleaning") then
							  local cSCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
							  local vassouspawn = CreateObject(GetHashKey(vassoumodel), cSCoords.x, cSCoords.y, cSCoords.z, 1, 1, 1)
							  local netid = ObjToNet(vassouspawn)

							  ESX.Streaming.RequestAnimDict("amb@world_human_janitor@male@idle_a", function()
									  TaskPlayAnim(PlayerPedId(), "amb@world_human_janitor@male@idle_a", "idle_a", 8.0, -8.0, -1, 0, 0, false, false, false)
									  AttachEntityToEntity(vassouspawn,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),-0.005,0.0,0.0,360.0,360.0,0.0,1,1,0,1,0,1)
									  vassour_net = netid
								  end)

								  ESX.SetTimeout(10000, function()
									  disable_actions = false
									  DetachEntity(NetToObj(vassour_net), 1, 1)
									  DeleteEntity(NetToObj(vassour_net))
									  vassour_net = nil
									  ClearPedTasks(PlayerPedId())
								  end)

						  end

						  if (tmp_action.type == "gardening") then
							  local cSCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
							  local spatulaspawn = CreateObject(GetHashKey(spatulamodel), cSCoords.x, cSCoords.y, cSCoords.z, 1, 1, 1)
							  local netid = ObjToNet(spatulaspawn)

							  TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_plant", 0, false)
							  AttachEntityToEntity(spatulaspawn,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),-0.005,0.0,0.0,190.0,190.0,-50.0,1,1,0,1,0,1)
							  spatula_net = netid

							  ESX.SetTimeout(14000, function()
								  disable_actions = false
								  DetachEntity(NetToObj(spatula_net), 1, 1)
								  DeleteEntity(NetToObj(spatula_net))
								  spatula_net = nil
								  ClearPedTasks(PlayerPedId())
							  end)
						  end

						  goto start_over
					  end
				  end
			  end
		  else
			  Citizen.Wait(1000)
		  end
	  end
  end)


  function RemoveAction(action)

	  local action_pos = -1

	  for i=1, #availableActions do
		  if action.coords.x == availableActions[i].coords.x and action.coords.y == availableActions[i].coords.y and action.coords.z == availableActions[i].coords.z then
			  action_pos = i
		  end
	  end

	  if action_pos ~= -1 then
		  table.remove(availableActions, action_pos)
	  else
		  print("User tried to remove an unavailable action")
	  end

  end







  function DisplayHelpText(str)
	  SetTextComponentFormat("STRING")
	  AddTextComponentString(str)
	  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
  end


  function DrawAvailableActions()

	  for i = 1, #availableActions do
  --{ r = 50, g = 50, b = 204 }
		  --DrawMarker(21, Config.ServiceLocations[i].coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 100, false, true, 2, true, false, false, true)
		  DrawMarker(21, availableActions[i].coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 50, 50, 204, 100, false, true, 2, true, false, false, false)

		  --DrawMarker(20, Config.ServiceLocations[i].coords, -1, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 162, 250, 80, true, true, 2, 0, 0, 0, 0)
	  end

  end






  function DisableViolentActions()

	  local playerPed = PlayerPedId()

	  if disable_actions == true then
		  DisableAllControlActions(0)
	  end

	  RemoveAllPedWeapons(playerPed, true)

	  DisableControlAction(2, 37, true) -- disable weapon wheel (Tab)
	  DisablePlayerFiring(playerPed,true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
	  DisableControlAction(0, 106, true) -- Disable in-game mouse controls
	  DisableControlAction(0, 140, true)
	  DisableControlAction(0, 141, true)
	  DisableControlAction(0, 142, true)

	  if IsDisabledControlJustPressed(2, 37) then --if Tab is pressed, send error message
		  SetCurrentPedWeapon(playerPed,GetHashKey("WEAPON_UNARMED"),true) -- if tab is pressed it will set them to unarmed (this is to cover the vehicle glitch until I sort that all out)
	  end

	  if IsDisabledControlJustPressed(0, 106) then --if LeftClick is pressed, send error message
		  SetCurrentPedWeapon(playerPed,GetHashKey("WEAPON_UNARMED"),true) -- If they click it will set them to unarmed
	  end

  end


  function ApplyPrisonerSkin()

	  local playerPed = PlayerPedId()

	  if DoesEntityExist(playerPed) then

		  Citizen.CreateThread(function()

			TriggerEvent('skinchanger:getSkin', function(skin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['prison_wear'].male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['prison_wear'].female)
				end
			end)

			SetPedComponentVariation(playerPed, 1, 0, 0, 0)
			SetPedComponentVariation(playerPed, 9, 0, 0, 0)
			SetPedPropIndex(playerPed, 0, 8, 0, 0)
			SetPedPropIndex(playerPed, 1, 0, 0, 0)
			SetPedArmour(playerPed, 0)
			ClearPedBloodDamage(playerPed)
			ResetPedVisibleDamage(playerPed)
			ClearPedLastWeaponDamage(playerPed)
			ResetPedMovementClipset(playerPed, 0)

		  end)
	  end
  end

  function draw2dText(text, pos)
	  SetTextFont(4)
	  SetTextProportional(1)
	  SetTextScale(0.45, 0.45)
	  SetTextColour(255, 255, 255, 255)
	  SetTextDropShadow(0, 0, 0, 0, 255)
	  SetTextEdge(1, 0, 0, 0, 255)
	  SetTextDropShadow()
	  SetTextOutline()

	  BeginTextCommandDisplayText('STRING')
	  AddTextComponentSubstringPlayerName(text)
	  EndTextCommandDisplayText(table.unpack(pos))
  end

  function DrawText3D(x,y,z, text) -- some useful function, use it if you want!
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

  RegisterNetEvent('fixjail')
  AddEventHandler('fixjail', function(target)
	local targetPed = PlayerPedId(target)
	SetEntityCoords(targetPed, 1849.76, 2586.29, 45.65)
	exports['mythic_notify']:SendAlert('inform', 'A staff member has teleported you to the entrance of the jail.', 5000)
  end)

  Citizen.CreateThread(function()
    while true do
		local playerCoords = GetEntityCoords(PlayerPedId())
        local waitCheck = #(playerCoords - vector3(Config.Locations["reclaim_items"]["x"], Config.Locations["reclaim_items"]["y"], Config.Locations["reclaim_items"]["z"]))
        if waitCheck < 15 then
            DrawText3D(Config.Locations["reclaim_items"]["x"], Config.Locations["reclaim_items"]["y"], Config.Locations["reclaim_items"]["z"]+1, 'Press [E] to re-claim your possessions.')
            DrawMarker(27,vector3(Config.Locations["reclaim_items"]["x"], Config.Locations["reclaim_items"]["y"], Config.Locations["reclaim_items"]["z"]), 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255, 255, 255, 55, 0, 0, 0, 0)
        end
        if waitCheck < 1.5 then
            if IsControlJustPressed(0,46) then
                TriggerServerEvent("jail:reclaimPossessions")
				exports['mythic_notify']:SendAlert('inform', 'You have re-claimed your possessions.', 5000)
                Wait(15000)
            end
        end
        waitCheck = (waitCheck < 15 and 1 or waitCheck)
        Wait(math.ceil(waitCheck))
    end
end)

local mugshotProp = nil
local objProp = "prop_police_id_board"

function JailIntro()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
    DoScreenFadeOut(10)
    FreezeEntityPosition(playerPed, true)
    TriggerEvent('InteractSound_CL:PlayOnOne', 'handcuff', 1.0)

	ApplyPrisonerSkin()

	RequestModel(objProp)
	while not HasModelLoaded(objProp) do
		Citizen.Wait(10)
	end
	mugshotProp = CreateObject(GetHashKey(objProp), coords.x, coords.y, coords.z, true, true, true)
	AttachEntityToEntity(mugshotProp, playerPed, GetPedBoneIndex(playerPed,  58868), 0.12, 0.24, 0.0, 5.0, 0.0, 70.0, 1, 1, 0, 1, 0, 1)
	
    Citizen.Wait(1000)

    SetEntityCoords(playerPed,Config.Locations["takephotos"]["x"],Config.Locations["takephotos"]["y"],Config.Locations["takephotos"]["z"])
    SetEntityHeading(playerPed,270.0)

	RequestAnimDict("mp_character_creation@customise@male_a")
    while (not HasAnimDictLoaded("mp_character_creation@customise@male_a")) do Citizen.Wait(0) end
    TaskPlayAnim(playerPed, "mp_character_creation@customise@male_a", "loop", 2.0, 2.0, -1, 51, 0, false, false, false)

    Citizen.Wait(1500) 
    DoScreenFadeIn(500)
    TriggerEvent('InteractSound_CL:PlayOnOne', 'photo', 0.4)
    Citizen.Wait(2000) 
    TriggerEvent('InteractSound_CL:PlayOnOne', 'photo', 0.4)
    Citizen.Wait(2000)     
    SetEntityHeading(playerPed,-355.74) 

    TaskPlayAnim(playerPed, "mp_character_creation@customise@male_a", "loop", 2.0, 2.0, -1, 51, 0, false, false, false)

    TriggerEvent('InteractSound_CL:PlayOnOne', 'photo', 0.4)
    Citizen.Wait(2000)  
    TriggerEvent('InteractSound_CL:PlayOnOne', 'photo', 0.4)
    Citizen.Wait(2000)         
    SetEntityHeading(playerPed,170.74) 

    TaskPlayAnim(playerPed, "mp_character_creation@customise@male_a", "loop", 2.0, 2.0, -1, 51, 0, false, false, false)

    TriggerEvent('InteractSound_CL:PlayOnOne', 'photo', 0.4)
    Citizen.Wait(2000) 
    TriggerEvent('InteractSound_CL:PlayOnOne', 'photo', 0.4)    

    Citizen.Wait(2000)
    DoScreenFadeOut(1100)   
    Citizen.Wait(2000)
    TriggerEvent('InteractSound_CL:PlayOnOne', 'jaildoor', 1.0)
	Citizen.Wait(3000)
	DoScreenFadeIn(1000)

	FreezeEntityPosition(playerPed, false)
	exports['mythic_notify']:SendAlert('inform', 'You have been jailed. You can pick up your shit when you leave.', 5000)

	StopAnimTask(playePed, 'mp_character_creation@customise@male_a', 'loop')
	DeleteObject(mugshotProp)
end

RegisterNetEvent('vulcan_prison:checkTime')
AddEventHandler('vulcan_prison:checkTime', function()
	if actionsRemaining == 0 then
		exports['mythic_notify']:SendAlert('inform', 'You are currently not serving a sentence in Boiling Broke Penitentiary.', 5000)
	else
		exports['mythic_notify']:SendAlert('inform', 'You have '..actionsRemaining..' months remaining in Boiling Broke Penitentiary.', 5000)
	end
end)

RegisterNetEvent('vulcan_prison:checkLaw')
AddEventHandler('vulcan_prison:checkLaw', function()
	local lawyer = exports.esx_scoreboard:GetPlayerCounts().estate
	local judge = exports.esx_scoreboard:GetPlayerCounts().gavel
	exports['mythic_notify']:SendAlert('inform', 'Currently '..lawyer..' lawyers\'s on-duty and '..judge..' judges\'s on-duty.', 5000)
end)

RegisterNetEvent('vulcan_prison:requestLaw')
AddEventHandler('vulcan_prison:requestLaw', function()
	local sendTo = nil
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vulcan_prison_callLaw', {
        title    = 'Choose A Radio',
        align    = 'right',
        elements = {
            {label = 'Call Lawyer', value = 'lawyer'},
            {label = 'Call Judge', value = 'judge'},
        }
    }, function(data1, menu1)
        if data1.current.value == 'lawyer' then 
            sendTo = 'doj'
			menu1.close()
        elseif data1.current.value == 'judge' then 
            sendTo = 'judge'
			menu1.close()
        end

		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'vulcan_prison_callLaw_text', {
			title = "Enter Message"
		},
		function(data2, menu2)
			local text = data2.value
			if text == nil or text == "" then
				exports['mythic_notify']:SendAlert('inform', 'No message specified.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
				menu2.close()
				sendTo = nil
			else
				menu2.close()

				TriggerEvent('vulcan_prison:sendToLawText', sendTo, text)

				sendTo = nil
			end

		end, function(data1, menu1)
			menu2.close()
		end)

    end, function(data1, menu1)
        menu1.close()
    end)
end)