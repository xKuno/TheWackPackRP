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

ESX                           = nil

local PlayerData = {}
local roboestado = false


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/steal', 'Attempt to mug a player.')
end)

RegisterCommand('steal', function()
	local ped = PlayerPedId()
	if IsPedArmed(ped, 4) then
		robo()
	else
		exports['mythic_notify']:SendAlert('inform', 'You don\'t have a weapon out!')
	end
end)

function robo()
 	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer ~= -1 and closestDistance <= 1.5 then

			playerheading = GetEntityHeading(PlayerPedId())
			playerlocation = GetEntityForwardVector(PlayerPedId())
			playerCoords = GetEntityCoords(PlayerPedId())
			local target_id = GetPlayerServerId(closestPlayer)
            local searchPlayerPed = GetPlayerPed(closestPlayer)


			if IsEntityPlayingAnim(searchPlayerPed, 'missminuteman_1ig_2', 'handsup_base', 3) or IsEntityPlayingAnim(searchPlayerPed, 'dead', 'dead_a', 3) or IsEntityPlayingAnim(searchPlayerPed, 'mp_arresting', 'idle', 3) or IsEntityDead(searchPlayerPed) or GetEntityHealth(searchPlayerPed) <= 0 then

				TriggerServerEvent('robo:jugador', target_id, playerheading, playerCoords, playerlocation)
				Citizen.Wait(4500)
				TriggerServerEvent('wp_steal:log', target_id)
				TriggerEvent('police:removeMask')
			else
				exports['mythic_notify']:SendAlert('inform', 'Hands are not up!')	
			end
		else
			exports['mythic_notify']:SendAlert('inform', 'No player nearby!')
    end	  
end

RegisterNetEvent('robo:getarrested')
AddEventHandler('robo:getarrested', function(playerheading, playercoords, playerlocation)
	playerPed = PlayerPedId()
	roboestado = true
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) 
	local x, y, z   = table.unpack(playercoords + playerlocation * 0.85)
	SetEntityCoords(PlayerPedId(), x, y, z-0.50)
	SetEntityHeading(PlayerPedId(), playerheading)
	Citizen.Wait(250)
	loadanimdict('missminuteman_1ig_2')
	TaskPlayAnim(PlayerPedId(), 'missminuteman_1ig_2', 'handsup_base', 8.0, -8, -1, 49, 0.0, false, false, false)
	roboestado = true
	Citizen.Wait(12500)
	roboestado = false
end)

RegisterNetEvent('robo:doarrested')
AddEventHandler('robo:doarrested', function()
	local target, distance = ESX.Game.GetClosestPlayer()
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
	Citizen.Wait(250)
	TriggerEvent("mythic_progbar:client:progress", {
        name = "steal_reaching_pocket",
        duration = 10000,
        label = "Reaching into pockets!",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "combat@aim_variations@arrest",
            anim = "cop_med_arrest_01",
        },
    }, function(status)
        if not status then
            exports['wp_dispatch']:addCall("10-32", "Robbery At Gunpoint", {
                {icon="fas fa-road", info = streetName},
                {icon="fa-venus-mars", info=gender},
            }, {cord[1], cord[2], cord[3]}, "police", 3000, 313, 1 )
            exports['wp_dispatch']:addCall("10-32", "Robbery At Gunpoint", {
                {icon="fas fa-road", info = streetName},
                {icon="fa-venus-mars", info=gender},
            }, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 313, 1 )
			OpenBodySearchMenu(target)
        end
    end)	
end)

RegisterNetEvent('robo:copsearch')
AddEventHandler('robo:copsearch', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 1.5 then
		Citizen.Wait(250)
		TriggerEvent("mythic_progbar:client:progress", {
			name = "SearchingSuspect",
			duration = 3000,
			label = "Searching...",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
		}, function(status)
			if not status then
				OpenBodySearchMenu(closestPlayer)
			end
		end)
	else
		exports['mythic_notify']:SendAlert('inform', 'No player nearby!')
	end
end) 

function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
	end
end

function OpenBodySearchMenu(player)
	TriggerEvent("DP_Inventory:openPlayerInventory", GetPlayerServerId(player), GetPlayerName(player))
end

function playAnim(animDict, animName, duration)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
	TaskPlayAnim(PlayerPedId(), animDict, animName,8.0, -8.0, -1, 49, 0, false, false, false)
	RemoveAnimDict(animDict)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if roboestado then
			DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 32, true) -- W
			DisableControlAction(0, 34, true) -- A
			DisableControlAction(0, 31, true) -- S
			DisableControlAction(0, 30, true) -- D
			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
		    DisableControlAction(0, 263, true) -- Melee Attack 1
	        DisableControlAction(0, 217, true) -- Also 'enter'?
		    DisableControlAction(0, 137, true) -- Also 'enter'?		
			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job
			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen
			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle
			DisableControlAction(2, 36, true) -- Disable going stealth
			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		end
	end
end)