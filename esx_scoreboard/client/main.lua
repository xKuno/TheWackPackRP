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

local idVisable = true
ESX = nil
local job_counts = {}
local hide_id = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(2000)
	ESX.TriggerServerCallback('esx_scoreboard:getConnectedPlayers', function(connectedPlayers)
		UpdatePlayerTable(connectedPlayers)
	end)
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		SendNUIMessage({
			action = 'close'
		})
		SetNuiFocus(false, false)
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(500)
	SendNUIMessage({
		action = 'updateServerInfo',

		maxPlayers = GetConvarInt('sv_maxclients', 64),
		uptime = 'unknown',
		playTime = '00h 00m'
	})
end)

RegisterNetEvent('esx_scoreboard:updateConnectedPlayers')
AddEventHandler('esx_scoreboard:updateConnectedPlayers', function(connectedPlayers)
	UpdatePlayerTable(connectedPlayers)
end)

RegisterNetEvent('esx_scoreboard:updatePing')
AddEventHandler('esx_scoreboard:updatePing', function(connectedPlayers)
	SendNUIMessage({
		action  = 'updatePing',
		players = connectedPlayers
	})
end)

RegisterNetEvent('esx_scoreboard:toggleID')
AddEventHandler('esx_scoreboard:toggleID', function(state)
	if state then
		idVisable = state
	else
		idVisable = not idVisable
	end

	SendNUIMessage({
		action = 'toggleID',
		state = idVisable
	})
end)

RegisterNetEvent('esx_scoreboard:showID')
AddEventHandler('esx_scoreboard:showID', function(state)

	idVisable = state
	SendNUIMessage({
		action = 'showID',
		state = idVisable
	})
end)

RegisterNetEvent('uptime:tick')
AddEventHandler('uptime:tick', function(uptime)
	SendNUIMessage({
		action = 'updateServerInfo',
		uptime = uptime
	})
end)

function pairsByKeys (t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0      -- iterator variable
	local iter = function ()   -- iterator function
	  i = i + 1
	  if a[i] == nil then return nil
	  else return a[i], t[a[i]]
	  end
	end
	return iter
  end

function UpdatePlayerTable(connectedPlayers)
	local formattedPlayerList, num = {}, 1
	local police, ems, taxi, mechanic, cardealer, estate, gavel, districta, players = 0, 0, 0, 0, 0, 0, 0, 0, 0

	for k,v in pairsByKeys(connectedPlayers) do

		if v.identifier == 'steam:110000102a6a9d1' then
			hide_id = v.id
		end
		--print(k)
		if num == 1 then
			table.insert(formattedPlayerList, ('<tr><td>%s</td><td class="player-id" style="display: none;">%s</td><td>%s</td>'):format(v.name, v.id, v.ping))
			num = 2
		elseif num == 2 then
			table.insert(formattedPlayerList, ('<td>%s</td><td class="player-id" style="display: none;">%s</td><td>%s</td>'):format(v.name, v.id, v.ping))
			num = 3
		elseif num == 3 then
			table.insert(formattedPlayerList, ('<td>%s</td><td class="player-id" style="display: none;">%s</td><td>%s</td></tr>'):format(v.name, v.id, v.ping))
			num = 1
		end


		players = players + 1

		if v.job == 'ambulance' then
			ems = ems + 1
		elseif v.job == 'police' then
			police = police + 1
		elseif v.job == 'taxi' then
			taxi = taxi + 1
		elseif v.job == 'mecano' then
			mechanic = mechanic + 1
		elseif v.job == 'cardealer' then
			cardealer = cardealer + 1
		elseif v.job == 'doj' then
			estate = estate + 1
		elseif v.job == 'judge' then
			gavel = gavel + 1
		elseif v.job == 'district' then
			districta = districta + 1
		end
	end

	if num == 1 then
		table.insert(formattedPlayerList, '</tr>')
	end

	SendNUIMessage({
		action  = 'updatePlayerList',
		players = table.concat(formattedPlayerList)
	})
	job_counts = {police = police, ems = ems, taxi = taxi, mechanic = mechanic, cardealer = cardealer, estate = estate, gavel = gavel, districta = districta, player_count = players}
	SendNUIMessage({
		action = 'updatePlayerJobs',
		jobs   = job_counts
	})
end

--[[
	exports.esx_scoreboard:GetPlayerJobCounts('police',function(data)
		print(json.encode(data))
	end)
]]

function GetPlayerJobCounts(select, cb)
	ESX.TriggerServerCallback('esx_scoreboard:getConnectedPlayers', function(connectedPlayers)

		print('updating table for job check')


		local player_counts = {total = #connectedPlayers}

		for k,v in pairsByKeys(connectedPlayers) do

			if player_counts[v.job] == nil then
				player_counts[v.job] = 0
			end

			player_counts[v.job] = player_counts[v.job] + 1
		end
		if player_counts[select] == nil then
			player_counts[select] = 0
		end
		cb(player_counts)
	end)
end

function GetPlayerCounts()
	return job_counts
end

function GetPlayerCountsB()
	return jobs
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, Keys['Z']) and IsInputDisabled(0) then
			TriggerServerEvent('esx_scoreboard:server_showID')
			ToggleScoreBoard()
			ShowID()
			Citizen.Wait(200)

		-- D-pad up on controllers works, too!
		elseif IsControlJustReleased(0, 172) and not IsInputDisabled(0) then
			TriggerServerEvent('esx_scoreboard:server_showID')
			ToggleScoreBoard()
			ShowID()
			Citizen.Wait(200)
		end
	end
end)

-- Close scoreboard when game is paused
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300)

		if IsPauseMenuActive() and not IsPaused then
			IsPaused = true
			SendNUIMessage({
				action  = 'close'
			})
			ShowID('close')
		elseif not IsPauseMenuActive() and IsPaused then
			IsPaused = false
		end
	end
end)

function ToggleScoreBoard(toggle)
	local lPed = PlayerPedId()
	local playerPed = PlayerPedId()
	local TogglingScoreBoard = false

	if (TogglingScoreBoard ~= toggle) then
		SendNUIMessage({
			action = 'toggle'
		})
		TogglingScoreBoard = toggle
	else
		SendNUIMessage({
			action = 'toggle'
		})
		TogglingScoreBoard = false
	end
end

local ShowingID = false
function ShowID(toggle) --Displays numbers over head when menu is open

	local ShowingID = false

	if toggle ~= 'close' and (showingID ~= true) then
		showingID = true
		local prop_name = prop_name or ''
		local lPed = PlayerPedId()
		local playerPed = PlayerPedId()
		if DoesEntityExist(lPed) then
			Citizen.CreateThread(function()
				if GetPlayerServerId(PlayerId()) ~= hide_id then
					local x,y,z = table.unpack(GetEntityCoords(playerPed))
					prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
					AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005),--[[forward and back]] 0.18, --[[up and down]] 0.08, --[[left and right]] -0.06, --[[rotate front and back]] -45.0, -100.0, --[[rotate anti/clockwise]] -9.0, true, true, false, true, 1, true)
					RequestAnimDict("")
					while not HasAnimDictLoaded("") do
						Citizen.Wait(100)
					end
					TaskPlayAnim(lPed, "", "", 4.0, -8, -1, 49, 0, 0, 0, 0)  
				end
			end)
		end
		Citizen.CreateThread(function()
			local showID = false
			x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
			x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
			distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
			local disPlayerNames = 40
			while showingID == true do
				Wait(0)
				for id = 0, 255 do
					if hide_id ~= GetPlayerServerId(id) then 
						x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
						x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
						distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))

						if  ((distance < disPlayerNames) and (NetworkIsPlayerActive( id )) and HasEntityClearLosToEntity(PlayerPedId(), GetPlayerPed(id), 17 )) then
							ped = GetPlayerPed( id )
							blip = GetBlipFromEntity( ped ) 
		
							x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
							x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
							distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))

							if NetworkIsPlayerTalking( id ) then
								DrawText3D(x2, y2, z2+1, GetPlayerServerId(id), 255,227,0)
							else
								DrawText3D(x2, y2, z2+1, GetPlayerServerId(id), 255,255,255)
							end
						end
					end
				end
			end
		end)
	else
		local prop_name = prop_name or ''
		local lPed = PlayerPedId()
		local playerPed = PlayerPedId()
		if DoesEntityExist(lPed) then
			Citizen.CreateThread(function()
				if GetPlayerServerId(PlayerId()) ~= hide_id then
					RequestAnimDict("")
					while not HasAnimDictLoaded("") do
						Citizen.Wait(100)
					end
					StopAnimTask(playerPed, '')
					ClearPedTasks(playerPed)
					DeleteObject(prop)
				end
			end)
		end
		showingID = false
	end

	if toggle == 'close' then
		if GetPlayerServerId(PlayerId()) ~= hide_id then
			local prop_name = prop_name or ''
			local lPed = PlayerPedId()
			local playerPed = PlayerPedId()
			StopAnimTask(playerPed, '')
			ClearPedTasks(playerPed)
			DeleteObject(prop)
		end
		showingID = false
	end
end

Citizen.CreateThread(function()
	local playMinute, playHour = 0, 0

	while true do
		Citizen.Wait(1000 * 60) -- every minute
		playMinute = playMinute + 1
	
		if playMinute == 60 then
			playMinute = 0
			playHour = playHour + 1
		end

		SendNUIMessage({
			action = 'updateServerInfo',
			playTime = string.format("%02dh %02dm", playHour, playMinute)
		})
	end
end)

local disPlayerNames = 40
local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

function DrawText3D(x,y,z, text, r,g,b) 
    local onScreen,_x,_y=SetDrawOrigin(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    if onScreen then
        SetTextScale(0.3, 0.3)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
		DrawText(_x,_y)
		ClearDrawOrigin()
    end
end


function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end