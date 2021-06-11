-------------------------------------
------- Created by T1GER#9080 -------
------------------------------------- 
player = nil
coords = {}
Citizen.CreateThread(function()
    while true do
		player = PlayerPedId()
		coords = GetEntityCoords(player)
        Citizen.Wait(500)
    end
end)

local police_count = 0
RegisterNetEvent('t1ger_bankrobbery:getPoliceCount')
AddEventHandler('t1ger_bankrobbery:getPoliceCount', function(police_online)
	police_count = police_online
end)

-- ## SAFES SECTION ## --
local safe_drilling = false
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(3)
		local sleep = true
		for k,v in pairs(Config.Bank_Safes) do
			local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.pos[1], v.pos[2], v.pos[3], false)
			if distance < 5.0 then
				sleep = false
				if distance < 1.0 then
					if not v.robbed then
						if not v.failed then
							if not safe_drilling then 
								DrawText3Ds(v.pos[1], v.pos[2], v.pos[3], Lang['drill_close_safe'])
								if IsControlJustPressed(0, 38) then
									ESX.TriggerServerCallback('t1ger_bankrobbery:removeInvItem', function(has_drill)
										if has_drill then DrillClosestSafe(k,v) else exports['mythic_notify']:SendAlert('inform', 'You need a drill!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) end
									end, Config.Drill_Item, 1)
								end
							end
						else
							DrawText3Ds(v.pos[1], v.pos[2], v.pos[3], Lang['safe_destroyed'])
						end
						if IsControlJustPressed(2, 178) then TriggerEvent("Drilling:Stop") end
					else
						DrawText3Ds(v.pos[1], v.pos[2], v.pos[3], Lang['safe_drilled'])
					end
				end
			end
		end
		if sleep then Citizen.Wait(1000) end
	end
end)

-- Function to Drill Closest Safe:
function DrillClosestSafe(id,val)
	local anim = {dict = "anim@heists@fleeca_bank@drilling", lib = "drill_straight_idle"}
	local closestPlayer, dist = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and dist <= 1.0 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), anim.dict, anim.lib, 3) then
            return exports['mythic_notify']:SendAlert('inform', 'This safe is drilled by someone else..', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
		end
	end
	safe_drilling = true
	FreezeEntityPosition(player, true)
	SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"),true)
	Citizen.Wait(250)
	LoadAnim(anim.dict)
	local drill_prop = GetHashKey('hei_prop_heist_drill')
	local boneIndex = GetPedBoneIndex(player, 28422)
	LoadModel(drill_prop)
	SetEntityCoords(player, val.anim_pos[1], val.anim_pos[2], val.anim_pos[3]-0.95)
	SetEntityHeading(player, val.anim_pos[4])
	TaskPlayAnimAdvanced(player, anim.dict, anim.lib, val.anim_pos[1], val.anim_pos[2], val.anim_pos[3], 0.0, 0.0, val.anim_pos[4], 1.0, -1.0, -1, 2, 0, 0, 0 )
	local drill_obj = CreateObject(drill_prop, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(drill_obj, player, boneIndex, 0.0, 0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
	SetEntityAsMissionEntity(drill_obj, true, true)
	RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", 0)
	RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", 0)
	RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", 0)
	local drill_sound = GetSoundId()
	Citizen.Wait(100)
	PlaySoundFromEntity(drill_sound, "Drill", drill_obj, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
	Citizen.Wait(100)
	local particle_dict = "scr_fbi5a"
	local particle_lib = "scr_bio_grille_cutting"
	RequestNamedPtfxAsset(particle_dict)
	while not HasNamedPtfxAssetLoaded(particle_dict) do
		Citizen.Wait(0)
	end
	SetPtfxAssetNextCall(particle_dict)
	local effect = StartParticleFxLoopedOnEntity(particle_lib, drill_obj, 0.0, -0.6, 0.0, 0.0, 0.0, 0.0, 2.0, 0, 0, 0)
	ShakeGameplayCam("ROAD_VIBRATION_SHAKE", 1.0)
	Citizen.Wait(100)
	TriggerEvent("Drilling:Start",function(drill_status)		
		if drill_status == 1 then
			Config.Bank_Safes[id].robbed = true
			TriggerServerEvent('t1ger_bankrobbery:SafeDataSV', "robbed", id, true)
			TriggerServerEvent('t1ger_bankrobbery:safeReward')
			safe_drilling = false
		elseif (drill_status == 3) then
			exports['mythic_notify']:SendAlert('inform', 'You stopped drilling.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
			TriggerServerEvent('t1ger_bankrobbery:giveItem', Config.Drill_Item, 1)
			safe_drilling = false
		elseif (drill_status == 2) then
			Config.Bank_Safes[id].failed = true
			TriggerServerEvent("t1ger_bankrobbery:SafeDataSV", "failed", id, true)
			exports['mythic_notify']:SendAlert('inform', 'You destroyed the safe!.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
			safe_drilling = false
		end
		ClearPedTasksImmediately(player)
		StopSound(drill_sound)
		ReleaseSoundId(drill_sound)
		DeleteObject(drill_obj)
		DeleteEntity(drill_obj)
		FreezeEntityPosition(player, false)
		StopParticleFxLooped(effect, 0)
		StopGameplayCamShaking(true)
	end)
end

-- ## BANKS SECTION ## --

local keypad_1, keypad_2 = false, false
local vault_door, desk_door = nil, nil
local vault_interacting = false
local deskDoor_using = false
local power_box = {id = 0, timer = 0}
local pacific_safe = nil
local cracking_safe = false
Citizen.CreateThread(function()
	local door_set = false
	while true do
        Citizen.Wait(3)
		local sleep = true
		for k,v in pairs(Config.Banks) do
			if k == 8 then -- ## PACIFIC STANDARD HEIST [ID 8] ##
				-- Freeze & control keypad[1] cell-door:
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.door.pos[1], v.door.pos[2], v.door.pos[3], true) < 10.0 then
					sleep = false
					if door_keypad1 and DoesEntityExist(door_keypad1) then
						if not v.keypads[1].hacked then FreezeEntityPosition(door_keypad1, true) else FreezeEntityPosition(door_keypad1, false) end	
					else
						door_keypad1 = GetClosestObjectOfType(v.door.pos[1], v.door.pos[2], v.door.pos[3], 1.0, v.door.model, false, false, false)
					end
				end
				-- Hack Keypad[1] or Use Access Card:
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.keypads[1].pos[1], v.keypads[1].pos[2], v.keypads[1].pos[3], true) < 2.0 then
					sleep = false
					if not v.keypads[1].hacked and not keypad_1 then 
						if not v.safe.cracked then 
							DrawText3Ds(v.keypads[1].pos[1], v.keypads[1].pos[2], v.keypads[1].pos[3], Lang['hack_keypad_1'])
							if IsControlJustPressed(0, 38) then
								ESX.TriggerServerCallback('t1ger_bankrobbery:removeInvItem', function(has_device)
									if has_device then HackIntoKeypad1(k,v) else exports['mythic_notify']:SendAlert('inform', 'You need a keycard!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) end
								end, Config.Hacker_Device , 1)
							end
						else
							DrawText3Ds(v.keypads[1].pos[1], v.keypads[1].pos[2], v.keypads[1].pos[3], Lang['open_keypad_1'])
							if IsControlJustPressed(0, 47) then
								ESX.TriggerServerCallback('t1ger_bankrobbery:getInvItem', function(has_accessCard)
									if has_accessCard then
										TriggerServerEvent('t1ger_bankrobbery:KeypadStateSV', 1, k, true)
									else
										exports['mythic_notify']:SendAlert('inform', 'You need the access card from the safe!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
									end
								end, Config.Access_Card , 1)
								
							end
						end
					end
				end
				-- Hack Keypad[2] or Use Access Card:
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.keypads[2].pos[1], v.keypads[2].pos[2], v.keypads[2].pos[3], true) < 2.0 then
					sleep = false
					if not v.keypads[2].hacked and v.keypads[1].hacked and not keypad_2 then
						if not v.safe.cracked then 
							DrawText3Ds(v.keypads[2].pos[1], v.keypads[2].pos[2], v.keypads[2].pos[3], Lang['hack_keypad_2'])
							if IsControlJustPressed(0, 311) then
								ESX.TriggerServerCallback('t1ger_bankrobbery:removeInvItem', function(has_device)
									if has_device then HackIntoKeypad2(k,v) else exports['mythic_notify']:SendAlert('inform', 'You need a keycard!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) end
								end, Config.Hacker_Device , 1)
							end	
						else
							DrawText3Ds(v.keypads[2].pos[1], v.keypads[2].pos[2], v.keypads[2].pos[3], Lang['open_keypad_2'])
							if IsControlJustPressed(0,47) and not keypad2 then
								ESX.TriggerServerCallback('t1ger_bankrobbery:getInvItem', function(has_accessCard)
									if has_accessCard then
										TriggerServerEvent('t1ger_bankrobbery:KeypadStateSV', 2, k, true)
									else
										exports['mythic_notify']:SendAlert('inform', 'You need the access card from the safe!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
									end
								end, Config.Access_Card , 1)
							end
						end
					end
				end
				-- Manage vault door:
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.vault.pos[1], v.vault.pos[2], v.vault.pos[3], true) < 8.0 then 
					sleep = false 
					if vault_door and DoesEntityExist(vault_door) then
						FreezeEntityPosition(vault_door, true)
						if v.keypads[1].hacked and v.keypads[2].hacked then
							if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.keypads[2].pos[1], v.keypads[2].pos[2], v.keypads[2].pos[3], false) < 2.0 then
								local vault_heading = GetEntityHeading(vault_door)
								if not vault_interacting then
									if vault_heading > v.vault.oHeadMin and vault_heading < v.vault.oHeadMax then
										DrawText3Ds(v.keypads[2].pos[1], v.keypads[2].pos[2], v.keypads[2].pos[3], Lang['close_vault_dr'])
										if IsControlJustPressed(0, 38) then
											vault_interacting = true
											TriggerServerEvent('t1ger_bankrobbery:VaultDoorHandleSV', "close", k, v, vault_heading, 320)
										end
									elseif vault_heading > v.vault.cHeadMin and vault_heading < v.vault.cHeadMax then
										DrawText3Ds(v.keypads[2].pos[1], v.keypads[2].pos[2], v.keypads[2].pos[3], Lang['open_vault_dr'])
										if IsControlJustPressed(0, 38) then
											vault_interacting = true
											TriggerServerEvent('t1ger_bankrobbery:VaultDoorHandleSV', "open", k, v, vault_heading, 320)
										end
									end
								end
							end
						end
					else
						vault_door = GetClosestObjectOfType(v.vault.pos[1], v.vault.pos[2], v.vault.pos[3], 2.0, v.vault.model, false, false, false)
					end
				end
				-- Desk Door:
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.deskDoor.pos[1], v.deskDoor.pos[2], v.deskDoor.pos[3], true) < 10.0 then
					sleep = false
					if desk_door and DoesEntityExist(desk_door) then
						FreezeEntityPosition(desk_door, true)
						local door_pos = GetEntityCoords(desk_door)
						if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, door_pos.x, door_pos.y, door_pos.z, true) < 2.0 and not deskDoor_using then
							if v.deskDoor.lockpicked then
								local desk_d_heading = GetEntityHeading(desk_door)
								local label = ''
								if desk_d_heading > v.deskDoor.oHeadMin and desk_d_heading < v.deskDoor.oHeadMax then
									if isCop and k == 8 then label = Lang['close_desk_door_pol'] else label = Lang['close_desk_door'] end 
									DrawText3Ds(v.deskDoor.pos[1], v.deskDoor.pos[2], v.deskDoor.pos[3], label)
									if IsControlJustPressed(0, 38) then
										deskDoor_using = true 
										TriggerServerEvent('t1ger_bankrobbery:DeskDoorHandleSV', "open", k, v, desk_d_heading, 200)
									end
								elseif desk_d_heading > v.deskDoor.cHeadMin and desk_d_heading < v.deskDoor.cHeadMax then
									if isCop and k == 8 then label = Lang['open_desk_door_pol'] else label = Lang['open_desk_door'] end 
									DrawText3Ds(v.deskDoor.pos[1], v.deskDoor.pos[2], v.deskDoor.pos[3], label)
									if IsControlJustPressed(0, 38) then 
										deskDoor_using = true 
										TriggerServerEvent('t1ger_bankrobbery:DeskDoorHandleSV', "close", k, v, desk_d_heading, 200)
									end
								end
								if IsControlJustPressed(0, 47) and isCop then
									local vault_d = GetClosestObjectOfType(v.vault.pos[1], v.vault.pos[2], v.vault.pos[3], 2.0, v.vault.model, false, false, false)
									if vault_d and DoesEntityExist(vault_d) then
										local vault_heading = GetEntityHeading(vault_d)
										if vault_heading > v.vault.cHeadMin and vault_heading < v.vault.cHeadMax then
											deskDoor_using = true
											ResetBank(k,v)
										else
											exports['mythic_notify']:SendAlert('inform', 'You need to close the vault door first!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
										end
									else
										print("COULDN'T FIND VAULT DOOR...")
									end
								end
							else
								if not isCop then
									if not v.inUse or (v.inUse and v.powerBox.disabled) then
										if police_count >= v.minCops then 
											DrawText3Ds(v.deskDoor.pos[1], v.deskDoor.pos[2], v.deskDoor.pos[3], Lang['lockpick_desk_door'])
											if IsControlJustPressed(0, 38) then
												ESX.TriggerServerCallback('t1ger_bankrobbery:removeInvItem', function(has_lockpick)
													if has_lockpick then LockpickDeskDoor(k,v,desk_door) else exports['mythic_notify']:SendAlert('inform', 'You need a lockpick!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) end
												end, Config.Lockpick, 1)
											end
										else
											DrawText3Ds(v.deskDoor.pos[1], v.deskDoor.pos[2], v.deskDoor.pos[3], Lang['bank_in_lockdown'])
										end
									end
								end
							end
						end
					else
						desk_door = GetClosestObjectOfType(v.deskDoor.pos[1], v.deskDoor.pos[2], v.deskDoor.pos[3], 1.0, v.deskDoor.model, false, false, false)
					end
				end
				-- Safe Crack:
				if v.safe ~= nil and not v.safe.cracked then
					if DoesEntityExist(pacific_safe) then
						safe_coords = GetEntityCoords(pacific_safe)
						if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, safe_coords.x, safe_coords.y, safe_coords.z, true) < 5.0 and v.powerBox.disabled then
							sleep = false
							if not isCop then 
								if not v.safe.cracked then
									DrawText3Ds(safe_coords.x+0.1, safe_coords.y+0.35, safe_coords.z, Lang['open_pacific_safe'])
									if IsControlJustPressed(0,38) and not cracking_safe then
										CrackPacificSafe(k,v)
									end
								else
									DrawText3Ds(safe_coords.x+0.1, safe_coords.y+0.35, safe_coords.z, Lang['pacific_safe_cracked'])
								end
							end
						end
					end
				end
			end
			if k ~= 8 then -- ## FLEECA BANKS & PALETO ##
				-- Hack Keypad[1]:
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.keypads[1].pos[1], v.keypads[1].pos[2], v.keypads[1].pos[3], true) < 2.0 then
					sleep = false
					if not v.keypads[1].hacked and not keypad_1 then
						if not v.inUse or (v.inUse and v.powerBox.disabled) then
							if police_count >= v.minCops then
								if not isCop then 
									DrawText3Ds(v.keypads[1].pos[1], v.keypads[1].pos[2], v.keypads[1].pos[3], Lang['hack_keypad_1'])
									if IsControlJustPressed(0, 38) then
										ESX.TriggerServerCallback('t1ger_bankrobbery:removeInvItem', function(has_device)
											if has_device then HackIntoKeypad1(k,v) else exports['mythic_notify']:SendAlert('inform', 'You need a keycard!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) end
										end, Config.Hacker_Device , 1)
									end
								end
							else
								DrawText3Ds(v.keypads[1].pos[1], v.keypads[1].pos[2], v.keypads[1].pos[3], Lang['bank_in_lockdown'])
							end
						end
					end
				end
				-- Manage vault door:
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.vault.pos[1], v.vault.pos[2], v.vault.pos[3], true) < 25.0 then 
					sleep = false 
					if vault_door and DoesEntityExist(vault_door) then
						if k == 7 and not door_set then
							SetEntityHeading(vault_door, 45.0)
							door_set = true
						end
						FreezeEntityPosition(vault_door, true)
						if v.inUse and v.keypads[1].hacked then
							if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.keypads[1].pos[1], v.keypads[1].pos[2], v.keypads[1].pos[3], false) < 1.3 then
								local vault_heading = GetEntityHeading(vault_door)
								if not vault_interacting then
									if vault_heading > v.vault.oHeadMin and vault_heading < v.vault.oHeadMax then
										DrawText3Ds(v.keypads[1].pos[1], v.keypads[1].pos[2], v.keypads[1].pos[3], Lang['close_vault_dr'])
										if IsControlJustPressed(0, 38) then
											vault_interacting = true
											local state = "close"; if k == 7 then state = "open" end
											TriggerServerEvent('t1ger_bankrobbery:VaultDoorHandleSV', state, k, v, vault_heading, 280)
										end
									elseif vault_heading > v.vault.cHeadMin and vault_heading < v.vault.cHeadMax then
										local label = Lang['open_vault_dr']; if isCop then label = Lang['open_vault_dr_pol'] end
										DrawText3Ds(v.keypads[1].pos[1], v.keypads[1].pos[2], v.keypads[1].pos[3], label)
										if IsControlJustPressed(0, 38) then
											vault_interacting = true
											local state = "open"; if k == 7 then state = "close" end
											TriggerServerEvent('t1ger_bankrobbery:VaultDoorHandleSV', state, k, v, vault_heading, 280)
										end
										if IsControlJustPressed(0, 47) and isCop then
											vault_interacting = true
											ResetBank(k,v)
										end
									end
								end
							end
						end
					else
						vault_door = GetClosestObjectOfType(v.vault.pos[1], v.vault.pos[2], v.vault.pos[3], 2.0, v.vault.model, false, false, false)
					end
				elseif GetDistanceBetweenCoords(coords.x, coords.y, coords.z, -105.9, 6472.11, 31.9, true) > 25.0 then
					door_set = false
				end
				-- Hack Keypad[2]:
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.keypads[2].pos[1], v.keypads[2].pos[2], v.keypads[2].pos[3], true) < 2.0 then
					sleep = false
					if not isCop then 
						if not v.keypads[2].hacked and v.keypads[1].hacked and not keypad_2 then
							if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.keypads[2].pos[1], v.keypads[2].pos[2], v.keypads[2].pos[3], true) < 1.0 then
								DrawText3Ds(v.keypads[2].pos[1], v.keypads[2].pos[2], v.keypads[2].pos[3], Lang['hack_keypad_2'])
								if IsControlJustPressed(0, 311) then
									ESX.TriggerServerCallback('t1ger_bankrobbery:removeInvItem', function(has_device)
										if has_device then HackIntoKeypad2(k,v) else exports['mythic_notify']:SendAlert('inform', 'You need a keycard!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) end
									end, Config.Hacker_Device , 1)
								end	
							end
						end
					end
				end
				-- Freeze & control keypad[2] cell-door:
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.door.pos[1], v.door.pos[2], v.door.pos[3], true) < 5.0 then
					sleep = false
					if door_keypad2 and DoesEntityExist(door_keypad2) then
						if not v.keypads[2].hacked then FreezeEntityPosition(door_keypad2, true) else FreezeEntityPosition(door_keypad2, false) end	
					else
						door_keypad2 = GetClosestObjectOfType(v.door.pos[1], v.door.pos[2], v.door.pos[3], 1.0, v.door.model, false, false, false)
					end
				end
				-- Desk Door:
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.deskDoor.pos[1], v.deskDoor.pos[2], v.deskDoor.pos[3], true) < 10.0 then
					sleep = false
					if desk_door and DoesEntityExist(desk_door) then
						FreezeEntityPosition(desk_door, true)
						local door_pos = GetEntityCoords(desk_door)
						if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, door_pos.x, door_pos.y, door_pos.z, true) < 2.0 and not deskDoor_using then
							if v.deskDoor.lockpicked then
								local desk_d_heading = GetEntityHeading(desk_door)
								if desk_d_heading > v.deskDoor.oHeadMin and desk_d_heading < v.deskDoor.oHeadMax then
									DrawText3Ds(v.deskDoor.pos[1], v.deskDoor.pos[2], v.deskDoor.pos[3], Lang['close_desk_door'])
									if IsControlJustPressed(0, 38) then
										deskDoor_using = true 
										TriggerServerEvent('t1ger_bankrobbery:DeskDoorHandleSV', "close", k, v, desk_d_heading, 200)
									end
								elseif desk_d_heading > v.deskDoor.cHeadMin and desk_d_heading < v.deskDoor.cHeadMax then
									DrawText3Ds(v.deskDoor.pos[1], v.deskDoor.pos[2], v.deskDoor.pos[3], Lang['open_desk_door'])
									if IsControlJustPressed(0, 38) then 
										deskDoor_using = true 
										TriggerServerEvent('t1ger_bankrobbery:DeskDoorHandleSV', "open", k, v, desk_d_heading, 200)
									end
								end
							else
								if v.inUse and not isCop then 
									DrawText3Ds(v.deskDoor.pos[1], v.deskDoor.pos[2], v.deskDoor.pos[3], Lang['lockpick_desk_door'])
									if IsControlJustPressed(0, 38) then
										ESX.TriggerServerCallback('t1ger_bankrobbery:removeInvItem', function(has_lockpick)
											if has_lockpick then LockpickDeskDoor(k,v,desk_door) else exports['mythic_notify']:SendAlert('inform', 'You need a lockpick!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) end
										end, Config.Lockpick, 1)
									end
								end
							end
						end
					else
						desk_door = GetClosestObjectOfType(v.deskDoor.pos[1], v.deskDoor.pos[2], v.deskDoor.pos[3], 1.0, v.deskDoor.model, false, false, false)
					end
				end
			end
		end
		if sleep then Citizen.Wait(1000) end
	end
end)

-- ## KEYPADS SECTION ## --

-- Keypad[1] Hack Function:
function HackIntoKeypad1(id,val)
	keypad_1 = true
	SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"),true)
	Citizen.Wait(250)
	FreezeEntityPosition(player, true)
	TaskStartScenarioInPlace(player, 'WORLD_HUMAN_STAND_MOBILE', -1, true)
	Citizen.Wait(2000)
	if Config.mHacking then 
		TriggerEvent("mhacking:show")
		TriggerEvent("mhacking:start",3,25,Keypad_Callback_1)
		TriggerServerEvent('t1ger_bankrobbery:wp_log')
	else
		keypad_1 = false
		-- Add your own minigame here and make a callback to Keypad_Callback_1 function.
	end
end
-- Keypad[1] Hack Callback Function:
function Keypad_Callback_1(success)
	TriggerEvent('mhacking:hide')
	for k,v in pairs(Config.Banks) do 
		if GetDistanceBetweenCoords(coords, v.keypads[1].pos[1], v.keypads[1].pos[2], v.keypads[1].pos[3], true) < 10.0 then
			if success then
				-- chance to keep hacker device:
				if math.random(1,100) >= Config.ChanceToKeepDevice then
					exports['mythic_notify']:SendAlert('inform', 'Card has been locked out, hope you have another one!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
				else
					TriggerServerEvent('t1ger_bankrobbery:giveItem', Config.Hacker_Device, 1)
				end
				-- update keypad state:
				TriggerServerEvent('t1ger_bankrobbery:KeypadStateSV', 1, k, true)
				-- update inUse state:
				if k ~= 8 then TriggerServerEvent('t1ger_bankrobbery:inUseSV', true) end
				-- update free rob timer:
				if v.powerBox.disabled then
					if v.powerBox.hackSuccess.enable then
						if power_box.timer ~= 0 then
							local new_timer = power_box.timer + (v.powerBox.hackSuccess.time * 1000)
							exports['mythic_notify']:SendAlert('inform', 'Electric is cut, you gained some more time!', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
							TriggerServerEvent('t1ger_bankrobbery:addRobTimeSV', new_timer)
						end
					end
				else
					NotifyPoliceFunction(v.name)
				end
				break
			else
				TriggerServerEvent('t1ger_bankrobbery:KeypadStateSV', 1, k, false)
				if k ~= 8 then TriggerServerEvent('t1ger_bankrobbery:inUseSV', false) end
				if v.powerBox.disabled then
					if power_box.timer ~= 0 then
						TriggerServerEvent('t1ger_bankrobbery:addRobTimeSV', 2000)
					end
				else
					NotifyPoliceFunction(v.name)
				end
				break
			end
		end
	end
	keypad_1 = false
	ClearPedTasks(player)
	FreezeEntityPosition(player, false)
end
-- Keypad[2] Hack Function:
function HackIntoKeypad2(id,val)
	keypad_2 = true
	SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"),true)
	Citizen.Wait(250)
	FreezeEntityPosition(player, true)
	TaskStartScenarioInPlace(player, 'WORLD_HUMAN_STAND_MOBILE', -1, true)
	Citizen.Wait(2000)
	if Config.utkFingerPrint then 
		TriggerEvent("utk_fingerprint:Start", 3, 3, 2, FingerPrintCallback)
		TriggerServerEvent('t1ger_bankrobbery:wp_log2')
	else
		keypad_2 = false
		-- Add your own minigame here and make a callback to FingerPrintCallback function.
	end
end
-- CALLBACK FOR SECOND DOOR HACKING:
function FingerPrintCallback(outcome,reason)
	local reason = "TEST TEST TEST"
	for k,v in pairs(Config.Banks) do			
		if GetDistanceBetweenCoords(coords, v.keypads[2].pos[1], v.keypads[2].pos[2], v.keypads[2].pos[3], true) < 10.0 then
			if outcome then 
				if math.random(1,100) >= Config.ChanceToKeepDevice then
					exports['mythic_notify']:SendAlert('inform', 'Hacker Device got corrupted, no longer usable!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
				else
					TriggerServerEvent('t1ger_bankrobbery:giveItem', Config.Hacker_Device, 1)
				end
				TriggerServerEvent('t1ger_bankrobbery:KeypadStateSV', 2, k, true)
				if v.powerBox.disabled then
					if v.powerBox.hackSuccess.enable then
						if power_box.timer ~= 0 then
							local new_timer = power_box.timer + (v.powerBox.hackSuccess.time * 1000)
							exports['mythic_notify']:SendAlert('inform', 'Electric is cut, you gained some more time!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
							TriggerServerEvent('t1ger_bankrobbery:addRobTimeSV', new_timer)
						end
					end
				end
				break
			else
				TriggerServerEvent('t1ger_bankrobbery:KeypadStateSV', 2, k, false)
				if v.powerBox.disabled then
					if power_box.timer ~= 0 then
						TriggerServerEvent('t1ger_bankrobbery:addRobTimeSV', 2000)
					end
				end
				break
			end
		end
	end
	keypad_2 = false
	ClearPedTasks(player)
	FreezeEntityPosition(player, false)
end

-- ## DESK DOOR ## --
function LockpickDeskDoor(id,val,door)
	deskDoor_using = true
	local anim = {dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", lib = "machinic_loop_mechandplayer"}
	LoadAnim(anim.dict)
	SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"),true)
	Citizen.Wait(250)
	FreezeEntityPosition(player, true)
	SetEntityHeading(player, GetEntityHeading(door))
	TaskPlayAnim(player, anim.dict, anim.lib, 3.0, 1.0, -1, 31, 0, 0, 0)
	exports['progressBars']:startUI(5000, Lang['progbar_lockpicking'])
	Citizen.Wait(5000)
	TriggerServerEvent('t1ger_bankrobbery:DeskDoorStateSV', id, true)
	if id == 8 then
		TriggerServerEvent('t1ger_bankrobbery:inUseSV', true)
		if not val.powerBox.disabled then 
			NotifyPoliceFunction(val.name)
		end
	end
	ClearPedTasks(player)
	FreezeEntityPosition(player, false)
	deskDoor_using = false
end

RegisterNetEvent('t1ger_bankrobbery:DeskDoorHandleCL')
AddEventHandler('t1ger_bankrobbery:DeskDoorHandleCL', function(action, k, v, door_heading, amount)
	for i = 1, amount do
		Citizen.Wait(10)
		local heading = 0
		if action == "open" then heading = (round(door_heading, 1)-0.4) elseif action == "close" then heading = (round(door_heading, 1)+0.4) end
		SetEntityHeading(desk_door, heading)
		door_heading = GetEntityHeading(desk_door)
	end
	deskDoor_using = false
end)

-- ## VAULT DOOR ## --
RegisterNetEvent('t1ger_bankrobbery:VaultDoorHandleCL')
AddEventHandler('t1ger_bankrobbery:VaultDoorHandleCL', function(action, k, v, door_heading, amount)
	for i = 1, amount do
		Citizen.Wait(10)
		local heading = 0
		if action == "open" then heading = (round(door_heading, 1)-0.4) elseif action == "close" then heading = (round(door_heading, 1)+0.4) end
		SetEntityHeading(vault_door, heading)
		door_heading = GetEntityHeading(vault_door)
	end
	vault_interacting = false
end)

-- ## POWER BOX SECTION ## --
local powerBox_interact = false
Citizen.CreateThread(function()
	local door_set = false
	while true do
		Citizen.Wait(3)
		local sleep = true
		for k,v in pairs(Config.Banks) do
			if v.powerBox ~= nil then
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.powerBox.pos[1], v.powerBox.pos[2], v.powerBox.pos[3], true) < 1.3 then
					sleep = false
					if not v.powerBox.disabled then
						if not powerBox_interact and not isCop then
							DrawText3Ds(v.powerBox.pos[1], v.powerBox.pos[2], v.powerBox.pos[3], Lang['power_box_not_disabled'])
							if IsControlJustPressed(0, 38) then
								ESX.TriggerServerCallback('t1ger_bankrobbery:removeInvItem', function(has_item)
									if has_item then DisablePowerBox(k,v) else exports['mythic_notify']:SendAlert('inform', 'You need a Hammer & Wire Cutter', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) end
								end, Config.HammerWireCutter , 1)
							end
						end
					else
						DrawText3Ds(v.powerBox.pos[1], v.powerBox.pos[2], v.powerBox.pos[3], Lang['power_box_disabled'])
					end
				end
			end
		end
		if sleep then Citizen.Wait(1000) end
	end
end)

-- function to cut electrics:
function DisablePowerBox(id,val)
	powerBox_interact = true 
	SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"),true)
	Citizen.Wait(250)
	SetEntityCoords(player, val.powerBox.animPos[1], val.powerBox.animPos[2], val.powerBox.animPos[3]-0.975, false, false, false, false)
	SetEntityHeading(player, val.powerBox.animHeading)
	TaskStartScenarioInPlace(player, "WORLD_HUMAN_HAMMERING", 0, true)
	exports['progressBars']:startUI(4000, Lang['progbar_open_powerbox'])
	Citizen.Wait(4000)
	-- exports['progressBars']:closeUI()
	Wait(2500)
	TaskStartScenarioInPlace(player, "prop_human_parking_meter", 0, true)
	exports['progressBars']:startUI(4000, Lang['progbar_cut_wires'])
	Citizen.Wait(4000)
	-- exports['progressBars']:closeUI()
	TriggerServerEvent('t1ger_bankrobbery:powerBoxSV', id, true, (val.powerBox.freeTime * 1000))
	TriggerServerEvent('t1ger_bankrobbery:inUseSV', true)
	exports['mythic_notify']:SendAlert('inform', 'Electric is cut, you gained some more time!', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
	ClearPedTasks(player)
	powerBox_interact = false
end

-- Thread to handle free robbing time:
Citizen.CreateThread(function()
	while true do
		if power_box.id ~= 0 then
			sleep = false
			if Config.Banks[power_box.id].powerBox.disabled then
				if power_box.timer == 0 then
					NotifyPoliceFunction(Config.Banks[power_box.id].name)
					power_box.id = 0
					power_box.timer = 0
				else
					power_box.timer = (power_box.timer - 1000)
					print("free rob time left: "..power_box.timer)
				end
			end
		end
		Citizen.Wait(1000)
	end
end)

-- Sync free rob timer:
RegisterNetEvent('t1ger_bankrobbery:addRobTimeCL')
AddEventHandler('t1ger_bankrobbery:addRobTimeCL', function(timer)
	power_box.timer = timer
end)

-- Disable Power Box:
RegisterNetEvent('t1ger_bankrobbery:powerBoxCL')
AddEventHandler('t1ger_bankrobbery:powerBoxCL', function(id, state, timer)
	Config.Banks[id].powerBox.disabled = state
	power_box.timer = timer
	power_box.id = id
end)

-- ## PETTY CASH SECTION ## --
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(3)
		local sleep = true
		for k,v in pairs(Config.Banks) do
			if v.deskDoor.lockpicked then
				for num,desk in pairs(v.deskCash) do
					if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, desk.pos[1], desk.pos[2], desk.pos[3], true) <= 1.0 then
						sleep = false
						if not desk.robbed then
							DrawText3Ds(desk.pos[1], desk.pos[2], desk.pos[3], Lang['desk_cash_not_robbed'])
							if IsControlJustPressed(0,38) then
								GrabCashAnim(k,desk,num)
							end
						else
							DrawText3Ds(desk.pos[1], desk.pos[2], desk.pos[3], Lang['desk_cash_robbed'])
						end
					end
				end
			end
		end
		if sleep then Citizen.Wait(1000) end
    end
end)

function GrabCashAnim(k,desk,num)
	local animDict = "anim@heists@ornate_bank@grab_cash"
	local animName = "grab"
	LoadAnim(animDict)
	local grabHeading = 0
	if k == 7 then
		grabHeading = 134.0
		SetEntityHeading(player, 134.0)
	elseif k == 8 then
		grabHeading = GetClosestObjectOfType(desk.pos[1], desk.pos[2], desk.pos[3], 3.0, -1605837712, false, true, false)
	else
		grabHeading = GetClosestObjectOfType(desk.pos[1], desk.pos[2], desk.pos[3], 3.0, -954257764, false, true, false)
		SetEntityHeading(player, GetEntityHeading(grabHeading))
	end
	TaskPlayAnim(player, animDict, animName, 1.0, -1.0, -1, 2, 0, 0, 0, 0)
	exports['progressBars']:startUI(7500, Lang['progbar_rob_petty_cash'])
	Citizen.Wait(7500)
	ClearPedTasks(player)
	TriggerServerEvent('t1ger_bankrobbery:pettyCashSV', k, num, true)
end

-- ## PACIFIC SAFE SECTION ## --

function SpawnPacificBankSafe()
	local prop = GetHashKey("bkr_prop_biker_safedoor_01a") % 0x100000000
	LoadModel(prop)
	pacific_safe = CreateObject(prop, 264.22, 207.50, 109.39, false, false, false)
	SetEntityAsMissionEntity(pacific_safe, true)
	FreezeEntityPosition(pacific_safe, true)
	SetEntityHeading(pacific_safe, 250.0)
	if HasModelLoaded(prop) then
		SetModelAsNoLongerNeeded(prop)
	end
end

function CrackPacificSafe(k,v)
	cracking_safe = true
	local animDict = "mini@safe_cracking"
	local animName = "dial_turn_anti_fast_3"
	LoadAnim(animDict)
	SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"),true)
	Citizen.Wait(250)
	SetEntityCoords(player, 263.93,208.21,110.29-0.95)
	Wait(100)
	FreezeEntityPosition(player, true)
	SetEntityHeading(player, GetEntityHeading(pacific_safe))
	TaskPlayAnim(player, animDict, animName, 1.0, 1.0, -1, 2, 0, 0, 0)
	exports['progressBars']:startUI(5000, Lang['progbar_cracking_safe'])
	Citizen.Wait(5000)
	TriggerServerEvent('t1ger_bankrobbery:pacificSafeSV', k, true)
	TriggerServerEvent('t1ger_bankrobbery:giveItem', Config.Access_Card, 1)
	exports['mythic_notify']:SendAlert('inform', 'You found a card!', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' }) -- GREEN
	ClearPedTasks(player)
	FreezeEntityPosition(player, false)
	Wait(500)
	cracking_safe = false
end

-- ## RESET BANK ## --
function ResetBank(k,v)
	TriggerServerEvent('t1ger_bankrobbery:ResetBankSV')
	Citizen.Wait(1000)
	exports['mythic_notify']:SendAlert('inform', 'You secured the bank. All banks will be unlocked!', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' }) -- GREEN
	deskDoor_using = false
	vault_interacting = false
	-- Reset Desk Door:
	SetEntityHeading(desk_door, v.deskDoor.heading)
end

RegisterNetEvent('t1ger_bankrobbery:ResetBankCL')
AddEventHandler('t1ger_bankrobbery:ResetBankCL', function()
	for i = 1, #Config.Banks do	-- LOOP THROUGH BANKS:
		Config.Banks[i].inUse = false
		Config.Banks[i].keypads[1].hacked = false
		Config.Banks[i].keypads[2].hacked = false
		Config.Banks[i].deskDoor.lockpicked = false
		for k,v in pairs(Config.Banks[i].deskCash) do
			v.robbed = false
		end
		Config.Banks[i].powerBox.disabled = false
		if i == 8 then
			Config.Banks[i].safe.cracked = false
		end
	end
	for i = 1, #Config.Bank_Safes do -- LOOP THROUGH SAFES:
		Config.Bank_Safes[i].robbed = false
		Config.Bank_Safes[i].failed = false
	end
	power_box = {id = 0, timer = 0}
end)

-- ## CAMERA SECTION ## --
usingCamera = false
cameraID = 0
tablet = nil

RegisterCommand("camera", function(source, args, rawCommand)
	local cameraNum = tonumber(args[1])
	if isCop then
		TriggerEvent('t1ger_bankrobbery:camera', cameraNum)
	else
		exports['mythic_notify']:SendAlert('inform', 'You do not have access to security cameras.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
	end
end, false)

RegisterNetEvent('t1ger_bankrobbery:camera')
AddEventHandler('t1ger_bankrobbery:camera', function(cameraNum)
	local player = PlayerPedId()
	if usingCamera then
		usingCamera = false
		ClearPedTasks(player)
        DeleteObject(tablet)
        SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)
	else
		if cameraNum > 0 and cameraNum <= #Config.Camera then
			-- tablet emote:
			if not IsEntityPlayingAnim(player, "amb@world_human_seat_wall_tablet@female@base", "base", 3) then
				RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
				while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do
					Citizen.Wait(10)
				end
				TaskPlayAnim(player, "amb@world_human_seat_wall_tablet@female@base", "base", 2.0, -2, -1, 49, 0, 0, 0, 0) 
				object = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
				AttachEntityToEntity(object, player, GetPedBoneIndex(player, 57005), 0.17, 0.10, -0.13, 20.0, 180.0, 180.0, true, true, false, true, 1, true)
				tablet = object
				Wait(500)
			end
			Wait(500)
			TriggerEvent('t1ger_bankrobbery:openCameraView',cameraNum)
		else
			exports['mythic_notify']:SendAlert('inform', 'Entered camera ID does not exist.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
		end
	end
end)

-- Camera VIew:
RegisterNetEvent('t1ger_bankrobbery:openCameraView')
AddEventHandler('t1ger_bankrobbery:openCameraView', function(cameraNum)
	local player = PlayerPedId()
	local curCam = Config.Camera[cameraNum]
	local x,y,z,heading = curCam.pos[1],curCam.pos[2],curCam.pos[3],curCam.heading
	usingCamera = true
	SetTimecycleModifier('heliGunCam')
	SetTimecycleModifierStrength(1.0)
	local scaleForm = RequestScaleformMovie('TRAFFIC_CAM')
	while not HasScaleformMovieLoaded(scaleForm) do
		Citizen.Wait(0)
	end
	cameraID = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	SetCamCoord(cameraID, x, y, (z+1.25))						
	SetCamRot(cameraID, -13.0, 0.0, heading)
	SetCamFov(cameraID, 105.0)
	RenderScriptCams(true, false, 0, 1, 0)
	PushScaleformMovieFunction(scaleForm, 'PLAY_CAM_MOVIE')
	SetFocusArea(x, y, z, 0.0, 0.0, 0.0)
	PopScaleformMovieFunctionVoid()
	while usingCamera do
		SetCamCoord(cameraID, x, y, (z+1.25))
		PushScaleformMovieFunction(scaleForm, 'SET_ALT_FOV_HEADING')
		PushScaleformMovieFunctionParameterFloat(GetEntityCoords(heading).z)
		PushScaleformMovieFunctionParameterFloat(1.0)
		PushScaleformMovieFunctionParameterFloat(GetCamRot(cameraID, 2).z)
		PopScaleformMovieFunctionVoid()
		DrawScaleformMovieFullscreen(scaleForm, 255, 255, 255, 255)
		Citizen.Wait(1)
	end

	ClearFocus()
	ClearTimecycleModifier()
	RenderScriptCams(false, false, 0, 1, 0) -- Return to gameplay camera
	SetScaleformMovieAsNoLongerNeeded(scaleForm) -- Cleanly release the scaleform
	DestroyCam(cameraID, false)
	SetNightvision(false)
	SetSeethrough(false)
end)

-- Camera Buttons:
Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(1)
		local sleep = true
		if usingCamera then
			sleep = false
			form = InstructionalButtons("instructional_buttons")
			local camRotation = GetCamRot(cameraID, 2)
			DrawScaleformMovieFullscreen(form, 255, 255, 255, 255, 0)
			if IsControlPressed(0, Config.CamLeft) then -- arrow left
				SetCamRot(cameraID, camRotation.x, 0.0, (camRotation.z+0.25), 2)
			end
			if IsControlPressed(0, Config.CamRight) then -- arrow right
				SetCamRot(cameraID, camRotation.x, 0.0, (camRotation.z-0.25), 2)
			end
			if IsControlPressed(0, Config.CamUp) then -- arrow up
				SetCamRot(cameraID, (camRotation.x+0.25), 0.0, camRotation.z, 2)
			end
			if IsControlPressed(0, Config.CamDown) then -- arrow down
				SetCamRot(cameraID, (camRotation.x-0.25), 0.0, camRotation.z, 2)
			end
			if IsControlPressed(0, Config.CamExit) then -- backspace
				usingCamera = false
				Wait(500)
				ClearPedTasks(player)
				DeleteObject(tablet)
				SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)
			end
		end
		if sleep then Citizen.Wait(1000) end
	end
end)

function InstructionalButtons(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, 174, true))
    ButtonMessage("LEFT")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(2, 175, true))
    ButtonMessage("RIGHT")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(2, 172, true))
    ButtonMessage("UP")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
    Button(GetControlInstructionalButton(2, 173, true))
    ButtonMessage("DOWN")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(4)
    Button(GetControlInstructionalButton(2, 178, true)) -- The button to display
    ButtonMessage("EXIT") -- the message to display next to it
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

-- Event to update safe state:
RegisterNetEvent('t1ger_bankrobbery:SafeDataCL')
AddEventHandler('t1ger_bankrobbery:SafeDataCL', function(type, id, state)
	if type == "robbed" then
		Config.Bank_Safes[id].robbed = state
	elseif type == "failed" then
		Config.Bank_Safes[id].failed = state
	end
end)

-- In Use State:
RegisterNetEvent('t1ger_bankrobbery:inUseCL')
AddEventHandler('t1ger_bankrobbery:inUseCL', function(state)
	for i = 1, #Config.Banks do
		Config.Banks[i].inUse = state
	end
end)

-- Keypad State:
RegisterNetEvent('t1ger_bankrobbery:KeypadStateCL')
AddEventHandler('t1ger_bankrobbery:KeypadStateCL', function(id, state, num)
	Config.Banks[id].keypads[num].hacked = state
end)

-- Desk Door State:
RegisterNetEvent('t1ger_bankrobbery:DeskDoorStateCL')
AddEventHandler('t1ger_bankrobbery:DeskDoorStateCL', function(id, state)
	Config.Banks[id].deskDoor.lockpicked = state
end)

-- Petty Cash Robbed State:
RegisterNetEvent('t1ger_bankrobbery:pettyCashCL')
AddEventHandler('t1ger_bankrobbery:pettyCashCL', function(id, num, state)
	Config.Banks[id].deskCash[num].robbed = state
end)

-- state for pacific safe:
RegisterNetEvent('t1ger_bankrobbery:pacificSafeCL')
AddEventHandler('t1ger_bankrobbery:pacificSafeCL', function(id, state)
	Config.Banks[id].safe.cracked = state
end)