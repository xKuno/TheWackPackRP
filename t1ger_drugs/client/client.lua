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

local police_count = 0	-- get online police count:
RegisterNetEvent('t1ger_drugs:getPoliceCount')
AddEventHandler('t1ger_drugs:getPoliceCount', function(police_online)
	police_count = police_online
end)

-- ## DRUG JOBS SECTION -- ##

-- Update Config on Clients:
RegisterNetEvent('t1ger_drugs:updateConfigCL')
AddEventHandler('t1ger_drugs:updateConfigCL',function(data)
    Config.DrugJobs = data
end)

-- Usable Item Event:
RegisterNetEvent('t1ger_drugs:itemUseCL')
AddEventHandler('t1ger_drugs:itemUseCL',function()
	local is_allowed = false
	if isCop and Config.AllowCopsToDoJobs then is_allowed = true end
	if not isCop then is_allowed = true end
	if is_allowed then 
		if police_count >= Config.RequiredCopsForJob then
			if IsPedInAnyVehicle(player) then
				exports['progressBars']:startUI(4000, Lang['usb_connecting'])
			else
				FreezeEntityPosition(player, true)
				TaskStartScenarioInPlace(player, 'WORLD_HUMAN_STAND_MOBILE', 0, true)
				exports['progressBars']:startUI(4000, Lang['usb_connecting'])
			end
			Citizen.Wait(4000)
			if Config.mHacking.enable then
				TriggerEvent("mhacking:show")
				TriggerEvent("mhacking:start", Config.mHacking.blocks, Config.mHacking.time, mHacking_callback)
			else
				SelectDrugJobMenu()
			end
		else
			exports['mythic_notify']:SendAlert('inform', 'Need More Cops', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
		end
	else
		exports['mythic_notify']:SendAlert('inform', 'You have no clue how to use it!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
	end
end)

-- Callback function for mHacking:
function mHacking_callback(success)
    TriggerEvent('mhacking:hide')
    if success then
		Citizen.Wait(250)
		exports['mythic_notify']:SendAlert('inform', 'You cracked the code', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
		SelectDrugJobMenu()
	else
		exports['mythic_notify']:SendAlert('inform', 'You Failed', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
		FreezeEntityPosition(player, false)
		ClearPedTasks(player)
	end
end

-- Select Drug Job Menu:
function SelectDrugJobMenu()
	local elements = {}
	for k,v in ipairs(Config.DrugMenu) do
		if v.enable then
			local list_label = ('%s <span style="color:MediumSeaGreen;"> [ $%s ]</span>'):format(v.label, v.job_fees)
			table.insert(elements,{label = list_label, value = v.drug, job_fees = v.job_fees, reward = v.reward})
		end
	end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "drugs_select_job",
		{
			title    = Lang['select_job'],
			align    = "center",
			elements = elements
		},
	function(data, menu)
		menu.close()
		ClearPedTasks(player)
		FreezeEntityPosition(player, false)
		ESX.TriggerServerCallback('t1ger_drugs:checkPlyMoney', function(has_money)
			if has_money then
				ESX.TriggerServerCallback('t1ger_drugs:checkPlyCooldown', function(has_cooldown)
					if not has_cooldown then
						local cur = data.current
						GetAvailableJob(cur.value, cur.job_fees, cur.reward)
					end
				end)
			else
				exports['mythic_notify']:SendAlert('inform', 'You need more money', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
			end
		end, data.current.job_fees)
	end, function(data, menu)
		menu.close()
		ClearPedTasks(player)
		FreezeEntityPosition(player, false)
	end)
end

function GetAvailableJob(drug_type, fees, reward)
	local id = math.random(1, #Config.DrugJobs)
    local i = 0
    while Config.DrugJobs[id].inUse and i < 100 do
        i = i + 1
        id = math.random(1, #Config.DrugJobs)
    end
    if i == 100 then
		exports['mythic_notify']:SendAlert('inform', 'No deals try later.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
    else
        Config.DrugJobs[id].inUse = true
		TriggerServerEvent('t1ger_drugs:JobDataSV', Config.DrugJobs)
		local ran_veh = math.random(1, #Config.JobVehicles)
		local veh_model = Config.JobVehicles[ran_veh]
		TriggerServerEvent('t1ger_drugs:prepareJobSV', id, drug_type, fees, reward, veh_model)
    end
end

job_veh = nil
job_goons = {}
veh_lockpicked = false
delivery_created = false
delivery_blip = nil
veh_delivered = false
drugs_taken = false
package_in_hand = false
job_end = false
RegisterNetEvent('t1ger_drugs:startTheDrugJob')
AddEventHandler('t1ger_drugs:startTheDrugJob', function(id, drug_type, fees, reward, veh_model)
	if Config.UsePhoneMSG then JobNotifyMSG(Lang['go_to_the_location']) else exports['mythic_notify']:SendAlert('inform', 'Follow your GPS and steal the vehicle with drugs.', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' }) end
	local job = Config.DrugJobs[id]
	local job_complete = false
	local job_blip = CreateJobBlip(job.pos,job.blip)

	while not job_complete do
		Citizen.Wait(1)
		local sleep = true
		if job.inUse then 
			-- distance check for carthief job pos
			local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, job.pos[1], job.pos[2], job.pos[3], false)
			if distance < 150.0 then 
				sleep = false
				-- Spawn Job Vehicle:
				if distance < 100.0 and not job.veh_spawned then
					ClearAreaOfVehicles(job.pos[1], job.pos[2], job.pos[3], 10.0, false, false, false, false, false)
					job_veh = CreateJobVehicle(veh_model, job.pos)
					job.veh_spawned = true
					TriggerServerEvent('t1ger_drugs:updateConfigSV', Config.DrugJobs)
				end
				-- Spawn Goons:
				if distance < 300.0 and not job.goons_spawned then
					ClearAreaOfPeds(job.pos[1], job.pos[2], job.pos[3], 10.0, 1)
					SetPedRelationshipGroupHash(player, GetHashKey("PLAYER"))
					AddRelationshipGroup('JobNPCs')
					for i = 1, #job.goons do
						job_goons[i] = CreateJobPed(job.goons[i])
					end
					job.goons_spawned = true
					TriggerServerEvent('t1ger_drugs:updateConfigSV', Config.DrugJobs)
				end
				-- Activate NPC's:
				if distance < 60.0 and job.goons_spawned and not job.player then
					SetPedRelationshipGroupHash(player, GetHashKey("PLAYER"))
					AddRelationshipGroup('JobNPCs')
					for i = 1, #job_goons do 
						ClearPedTasksImmediately(job_goons[i])
						TaskCombatPed(job_goons[i], player, 0, 16)
						if Config.EnableHeadshotKills then SetPedSuffersCriticalHits(job_goons[i], true) else SetPedSuffersCriticalHits(job_goons[i], false) end
						SetPedFleeAttributes(job_goons[i], 0, false)
						SetPedCombatAttributes(job_goons[i], 5, true)
						SetPedCombatAttributes(job_goons[i], 16, true)
						SetPedCombatAttributes(job_goons[i], 46, true)
						SetPedCombatAttributes(job_goons[i], 26, true)
						SetPedSeeingRange(job_goons[i], 75.0)
						SetPedHearingRange(job_goons[i], 50.0)
						SetPedEnableWeaponBlocking(job_goons[i], true)
					end
					SetRelationshipBetweenGroups(0, GetHashKey("JobNPCs"), GetHashKey("JobNPCs"))
					SetRelationshipBetweenGroups(5, GetHashKey("JobNPCs"), GetHashKey("PLAYER"))
					SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("JobNPCs"))
					job.player = true
					TriggerServerEvent('t1ger_drugs:updateConfigSV', Config.DrugJobs)
				end
				-- Lockpick Vehicle:
				local veh_pos = GetEntityCoords(job_veh) 
				local veh_dist = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, veh_pos.x, veh_pos.y, veh_pos.z, false)
				if veh_dist < 2.5 and not veh_lockpicked then
					DrawText3Ds(veh_pos.x, veh_pos.y, veh_pos.z, Lang['press_to_lockpick'])
					if IsControlJustPressed(0, 47) then 
						LockpickJobVehicle(job)
					end
				end
				-- Create Delivery Blip & Route:
				if veh_lockpicked and not delivery_created then
					if GetEntityModel(GetVehiclePedIsIn(player, false)) == GetHashKey(veh_model) then
						if DoesBlipExist(job_blip) then RemoveBlip(job_blip) end 
						delivery = Config.Delivery[math.random(1,#Config.Delivery)]
						if Config.UsePhoneMSG then JobNotifyMSG(Lang['deliver_veh_msg']) else exports['mythic_notify']:SendAlert('inform', 'Deliver the vehicle at the new GPS I have sent to you!', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' }) end
						if DoesBlipExist(delivery_blip) then RemoveBlip(delivery_blip) end
						delivery_blip = AddBlipForCoord(delivery.pos[1], delivery.pos[2], delivery.pos[3])
						SetBlipSprite(delivery_blip, delivery.blip.sprite)
						SetBlipColour(delivery_blip, delivery.blip.color)
						SetBlipRoute(delivery_blip, delivery.blip.route)
						SetBlipRouteColour(delivery_blip, delivery.blip.color)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(delivery.blip.label)
						EndTextCommandSetBlipName(delivery_blip)
						delivery_created = true
					end
				end
			end
			-- distance check for drugs delivery pos
			if delivery_created then 
				local delivery_dist = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, delivery.pos[1], delivery.pos[2], delivery.pos[3], false)
				if delivery_dist < 75.0 then 
					sleep = false 
					-- Delivery spot & marker:
					if not veh_delivered then
						local mk = delivery.marker
						if delivery_dist < mk.drawDist then
							if DoesEntityExist(job_veh) then
								if GetEntityModel(GetVehiclePedIsIn(player, false)) == GetHashKey(veh_model) then
									DrawMarker(mk.type, delivery.pos[1], delivery.pos[2], delivery.pos[3]-0.97, 0, 0, 0, 180.0, 0, 0, mk.scale.x, mk.scale.y, mk.scale.z,mk.color.r,mk.color.g,mk.color.b,mk.color.a, false, true, 2, false, false, false, false)
									if delivery_dist < 2.0 then
										DrawText3Ds(delivery.pos[1], delivery.pos[2], delivery.pos[3], Lang['press_to_deliver'])
										if IsControlJustPressed(0, 38) then
											if DoesBlipExist(delivery_blip) then RemoveBlip(delivery_blip) end
											SetVehicleForwardSpeed(job_veh, 0)
											SetVehicleEngineOn(job_veh, false, false, true)
											SetVehicleDoorOpen(job_veh, 2 , false, false)
											SetVehicleDoorOpen(job_veh, 3 , false, false)
											if IsPedInAnyVehicle(player, true) then
												TaskLeaveVehicle(player, job_veh, 4160)
												SetVehicleDoorsLockedForAllPlayers(job_veh, true)
											end
											Citizen.Wait(700)
											FreezeEntityPosition(job_veh, true)
											veh_delivered = true
										end
									end
								end
							end
						end
					end
					if veh_delivered and not drugs_taken then
						if not IsPedInAnyVehicle(player, true) then
							if DoesEntityExist(job_veh) and GetEntityModel(job_veh) == GetHashKey(veh_model) then
								local d1 = GetModelDimensions(GetEntityModel(job_veh))
								local trunk_pos = GetOffsetFromEntityInWorldCoords(job_veh, 0.0,d1["y"]+0.60,0.0)
								local trunk_dist = GetDistanceBetweenCoords(trunk_pos.x, trunk_pos.y, trunk_pos.z, coords.x, coords.y, coords.z, false)
								if trunk_dist < 2.0 and not package_in_hand then
									DrawText3Ds(trunk_pos.x, trunk_pos.y, trunk_pos.z, Lang['press_to_grab_pack'])
									if IsControlJustPressed(0, 38) then
										LoadAnim("anim@heists@box_carry@")
										TaskPlayAnim(PlayerPedId(),"anim@heists@box_carry@","idle",1.0, -1.0, -1, 49, 0, 0, 0, 0)
										Citizen.Wait(300)
										local prop = GetHashKey('prop_cs_cardbox_01')
										SetCurrentPedWeapon(player, 0xA2719263) 
										local bone = GetPedBoneIndex(player, 28422)
										LoadModel(prop)
										package_obj = CreateObject(prop, 1.0, 1.0, 1.0, 1, 1, 0)
										AttachEntityToEntity(package_obj, player, bone, 0.0, 0.0, 0.0, 135.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
										package_in_hand = true
									end
								end
								local ply_vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 6.0, 0, 70)
								if GetEntityModel(ply_vehicle) ~= GetHashKey(veh_model) then
									local d2 = GetModelDimensions(GetEntityModel(ply_vehicle))
									local veh_pos = GetOffsetFromEntityInWorldCoords(ply_vehicle, 0.0,d2["y"]+0.60,0.0)
									local veh_dist = GetDistanceBetweenCoords(veh_pos.x, veh_pos.y, veh_pos.z, coords.x, coords.y, coords.z, false)
									if veh_dist < 2.0 and package_in_hand then 
										DrawText3Ds(veh_pos.x, veh_pos.y, veh_pos.z, Lang['press_to_put_pack'])
										if IsControlJustPressed(0, 47) then
											ClearPedTasks(player)
											DeleteEntity(package_obj)
											TriggerServerEvent('t1ger_drugs:giveJobReward', drug_type, reward)
											drugs_taken = true
											job_end = true
										end
									end
								end
							end
						end
					end
				end
			end
			-- End Job if these are true:
			if job.veh_spawned then
				if not DoesEntityExist(job_veh) then
					job_end = true
					if Config.UsePhoneMSG then JobNotifyMSG(Lang['veh_is_taken']) else exports['mythic_notify']:SendAlert('inform', 'The car was taken by someone, maybe the police?', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) end
				end
			end
			if veh_lockpicked and DoesEntityExist(job_veh) then
				local veh_pos = GetEntityCoords(job_veh)
				if GetDistanceBetweenCoords(coords, veh_pos.x, veh_pos.y, veh_pos.z, false) > 150.0 then 
					job_end = true
					if Config.UsePhoneMSG then JobNotifyMSG(Lang['too_far_from_veh']) else exports['mythic_notify']:SendAlert('inform', 'you went too far from the car', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) end	
				end
			end
			if job_end then
				-- reset config data:
				Config.DrugJobs[id].inUse = false
				Config.DrugJobs[id].goons_spawned = false
				Config.DrugJobs[id].veh_spawned = false
				Config.DrugJobs[id].player = false
				TriggerServerEvent('t1ger_drugs:updateConfigSV', Config.DrugJobs)
				Citizen.Wait(500)
				-- Delete Job Vehicle:
				DeleteVehicle(job_veh)
				job_veh = nil
				-- blip:
				if DoesBlipExist(job_blip) then RemoveBlip(job_blip) end 
				if DoesBlipExist(delivery_blip) then RemoveBlip(delivery_blip) end
				blip = nil
				delivery_blip = nil
				-- goons:
				local i = 0
                for k,v in pairs(Config.DrugJobs[id].goons) do
                    if DoesEntityExist(job_goons[i]) then
                        DeleteEntity(job_goons[i])
                    end
                    i = i +1
				end
				job_goons = {}
				veh_lockpicked = false
				delivery_created = false
				veh_delivered = false
				drugs_taken = false
				package_in_hand = false
				job_complete = true
				job_end = false
				break
			end
		end
		if sleep then Citizen.Wait(1000) end
	end
end)

-- Lockpick Job Vehicle:
function LockpickJobVehicle(job)
	local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
	local animName = "machinic_loop_mechandplayer"
	LoadAnim(animDict)	
	if Config.PoliceAlerts then AlertPoliceFunction() end
	SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"),true)
	Citizen.Wait(250)
	FreezeEntityPosition(player, true)
	TaskPlayAnimAdvanced(player, animDict, animName, job.lockpick[1], job.lockpick[2], job.lockpick[3], 0.0, 0.0, job.lockpick[4], 3.0, 1.0, -1, 31, 0, 0, 0 )
	-- Car Alarm:
	if Config.EnableVehicleAlarm then
		SetVehicleAlarm(job_veh, true)
		SetVehicleAlarmTimeLeft(job_veh, (Config.VehicleAlarmTime * 1000))
		StartVehicleAlarm(job_veh)
	end
	exports['progressBars']:startUI((Config.LockpickTime * 1000), Lang['lockpicking_veh'])
	Citizen.Wait(Config.LockpickTime * 1000)
	ClearPedTasks(player)
	FreezeEntityPosition(player, false)
	veh_lockpicked = true
	SetVehicleDoorsLockedForAllPlayers(job_veh, false)
	TriggerServerEvent('t1ger_drugs:LockPickReward')
end

-- Function to create job vehicle:
function CreateJobVehicle(model, pos)
	LoadModel(model)
    local vehicle = CreateVehicle(model, pos[1], pos[2], pos[3], pos[4], true, false)
    SetVehicleNeedsToBeHotwired(vehicle, true)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleDoorsLockedForAllPlayers(vehicle, true)
    SetVehicleIsStolen(vehicle, false)
    SetVehicleIsWanted(vehicle, false)
    SetVehRadioStation(vehicle, 'OFF')
    SetVehicleFuelLevel(vehicle, 80.0)
    DecorSetFloat(vehicle, "_FUEL_LEVEL", GetVehicleFuelLevel(vehicle))
    return vehicle
end

-- Function to create job ped(s):
function CreateJobPed(goon)
	LoadModel(goon.ped)
	local NPC = CreatePed(4, GetHashKey(goon.ped), goon.pos[1], goon.pos[2], goon.pos[3], goon.pos[4], false, true)
	NetworkRegisterEntityAsNetworked(NPC)
	SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(NPC), true)
	SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(NPC), true)
	SetPedCanSwitchWeapon(NPC, true)
	SetPedArmour(NPC, goon.armour)
	SetPedAccuracy(NPC, goon.accuracy)
	SetEntityInvincible(NPC, false)
	SetEntityVisible(NPC, true)
	SetEntityAsMissionEntity(NPC)
	LoadAnim(goon.anim.dict)
	TaskPlayAnim(NPC, goon.anim.dict, goon.anim.lib, 8.0, -8, -1, 49, 0, 0, 0, 0)
	GiveWeaponToPed(NPC, GetHashKey(goon.weapon), 255, false, false)
	SetPedDropsWeaponsWhenDead(NPC, false)
	SetPedCombatAttributes(NPC, false)
	SetPedFleeAttributes(NPC, 0, false)
	SetPedEnableWeaponBlocking(NPC, true)
	SetPedRelationshipGroupHash(NPC, GetHashKey("JobNPCs"))	
	TaskGuardCurrentPosition(NPC, 15.0, 15.0, 1)
	return NPC
end

-- Function for drug job blip:
function CreateJobBlip(pos, mk)
	local blip = AddBlipForCoord(pos[1], pos[2], pos[3])
	SetBlipSprite(blip, mk.sprite)
	SetBlipColour(blip, mk.color)
	AddTextEntry('MYBLIP', mk.label)
	BeginTextCommandSetBlipName('MYBLIP')
	AddTextComponentSubstringPlayerName(name)
	EndTextCommandSetBlipName(blip)
	SetBlipScale(blip, mk.scale) -- set scale
	SetBlipAsShortRange(blip, true)
	if mk.route then 
		SetBlipRoute(blip, mk.route)
		SetBlipRouteColour(mk.color)
	end
	return blip
end

AddEventHandler('esx:onPlayerDeath', function(data)
	job_end = true
	Citizen.Wait(5000)
	job_end = false
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

RegisterCommand('drugs_cancel', function(source, args)
	job_end = true
	exports['mythic_notify']:SendAlert('inform', 'You cancelled the job!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
end, false)


-- ## DRUG EFFECTS SECTION ## --

RegisterNetEvent('t1ger_drugs:DrugEffects')
AddEventHandler('t1ger_drugs:DrugEffects', function(k,v)
    local playerPed = PlayerId()
	if not IsPedInAnyVehicle(PlayerPedId()) then
		TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_SMOKING_POT", 0, true)
		exports['progressBars']:startUI(v.UsableTime, v.ProgressBarText)
		Citizen.Wait(v.UsableTime)
		ClearPedTasks(PlayerPedId())
	else
		exports['progressBars']:startUI(v.UsableTime, v.ProgressBarText)
		Citizen.Wait(v.UsableTime)
	end
	if v.BodyArmor then
		if GetPedArmour(player) <= (100-v.AddArmorValue) then
			AddArmourToPed(player,v.AddArmorValue)
		elseif GetPedArmour(player) <= 99 then
			SetPedArmour(player,100)
		end
	end
	if v.PlayerHealth then
		if GetEntityHealth(player) <= (200-v.AddHealthValue) then
			SetEntityHealth(player,GetEntityHealth(player)+v.AddHealthValue)
		elseif GetEntityHealth(player) <= 199 then
			SetEntityHealth(player,200)
		end
	end
	local timer = 0
	while timer < v.EffectDuration do
		if v.FasterSprint then
			SetRunSprintMultiplierForPlayer(playerPed,v.SprintValue)
		end
		if v.TimeCycleModifier then
			SetTimecycleModifier(v.TimeCycleModifierType)
		end
		if v.MotionBlur then
			SetPedMotionBlur(playerPed, true)
		end
		if v.UnlimitedStamina then
			ResetPlayerStamina(playerPed)
		end
		Citizen.Wait(1000)
		timer = timer + 1
	end
    SetTimecycleModifier("default")
	SetPedMotionBlur(playerPed, false)
    SetRunSprintMultiplierForPlayer(playerPed,1.0)
end)

-- ## DRUG CONVERSION SECTION ## --

RegisterNetEvent('t1ger_drugs:ConvertProcess')
AddEventHandler('t1ger_drugs:ConvertProcess', function(k,v)
	local animDict = "misscarsteal1car_1_ext_leadin"
	local animName = "base_driver2"
	LoadAnim(animDict)
	if not IsPedInAnyVehicle(player) then
		TaskPlayAnim(player,"misscarsteal1car_1_ext_leadin","base_driver2",8.0, -8, -1, 49, 0, 0, 0, 0)
		FreezeEntityPosition(player, true)
		exports['progressBars']:startUI(v.ConversionTime, v.ProgressBarText)
		Citizen.Wait(v.ConversionTime)
		FreezeEntityPosition(player, false)
		ClearPedTasks(player)
	else
		exports['progressBars']:startUI(v.ConversionTime, v.ProgressBarText)
		Citizen.Wait(v.ConversionTime)
	end
end)

-- ## DRUG SALE SECTION ## --

local drug_ped = false
local old_ped = nil
local can_sell_drugs = false
local selling_drugs = false

-- thread to get drug sell state:
Citizen.CreateThread(function()
    Citizen.Wait(10000)
    TriggerServerEvent('t1ger_drugs:sellStateSV')
    while true do
        Citizen.Wait(5 * 60000)
        TriggerServerEvent('t1ger_drugs:sellStateSV')
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local sleep = true
		if not IsPedInAnyVehicle(player, true) then
			if can_sell_drugs then
				local found_ped = false 
				local handle, NPC = FindFirstPed()
				local success
				repeat
					local npc_pos = GetEntityCoords(NPC)
					if NPC_Accepted(NPC) and GetDistanceBetweenCoords(coords, npc_pos, false) < 5.0 then
						sleep = false
						found_ped = NPC
						break
					end
					success, NPC = FindNextPed(handle, NPC)
				until not success 
				EndFindPed(handle)
				drug_ped = found_ped
			end
		else
			drug_ped = false
			Citizen.Wait(5000)
		end
		if sleep then Citizen.Wait(1000) end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local sleep = true
		if can_sell_drugs then 
			if drug_ped then
				sleep = false
				local ped_pos = GetEntityCoords(drug_ped) 
				if GetDistanceBetweenCoords(coords, ped_pos, true) < 2.0 and not selling_drugs then
					if police_count >= Config.MinCopsOnlineToSell then 
						DrawText3Ds(ped_pos.x, ped_pos.y, ped_pos.z, Lang['press_to_sell_drugs'])
						if (IsControlJustPressed(1,74) and not selling_drugs) then
							selling_drugs = true
							SellDrugsToNPC(drug_ped, ped_pos)
						end
					end
				end
			end
		end
		if sleep then Citizen.Wait(1000) end
	end
end)

function SellDrugsToNPC(drug_ped, ped_pos)
	ESX.TriggerServerCallback('t1ger_drugs:getUserInventory', function(inv_drugs)
		if #inv_drugs > 0 then
			ESX.TriggerServerCallback('t1ger_drugs:getPlayerMaxCap', function(maxCap)
				if not maxCap then
					old_ped = drug_ped
					TaskStandStill(old_ped, 5000.0)
					SetEntityAsMissionEntity(old_ped)
					FreezeEntityPosition(old_ped, true)
					FreezeEntityPosition(player, true)
					SetEntityHeading(old_ped, GetHeadingFromVector_2d(ped_pos.x-coords.x,ped_pos.y-coords.y)+180)
					SetEntityHeading(player, GetHeadingFromVector_2d(ped_pos.x-coords.x,ped_pos.y-coords.y))
					-- Progress Bars:
					exports['progressBars']:startUI((Config.SellDrugsTimer * 1000), Lang['progbar_selling_drugs'])
					Citizen.Wait((Config.SellDrugsTimer * 1000))
					-- Chances:
					if math.random(0,100) <= Config.Sell_Chance then
						LoadAnim("mp_common")
						TaskPlayAnim(player, "mp_common", "givetake2_a", 8.0, 8.0, 2000, 0, 1, 0,0,0)
						TaskPlayAnim(old_ped, "mp_common", "givetake2_a", 8.0, 8.0, 2000, 0, 1, 0,0,0)
						math.randomseed(GetGameTimer())
						local num = math.random(1,#inv_drugs)
						local drug = inv_drugs[num]
						TriggerServerEvent('t1ger_drugs:sellDrugsToNPC', drug)
					else
						if math.random(0,100) <= Config.CallCopsChance then
							AlertPoliceFunction(true)
							exports['mythic_notify']:SendAlert('inform', 'Im calling the police I dont want that crap!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
						else
							exports['mythic_notify']:SendAlert('inform', 'Im good homie find someone else.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
						end 
					end
					FreezeEntityPosition(old_ped, false)
					FreezeEntityPosition(player, false)
					SetPedAsNoLongerNeeded(old_ped)
					Citizen.Wait(Config.DrugSaleCooldown * 1000)
					selling_drugs = false
				else
					exports['mythic_notify']:SendAlert('inform', 'After a long day of trapping you feel tired.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
					selling_drugs = false
				end
			end)
		else
			exports['mythic_notify']:SendAlert('inform', 'You gonna sell me air? find me when you have drugs!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
			can_sell_drugs = false
			selling_drugs = false
		end
	end)
end

-- Sell Drug State:
RegisterNetEvent('t1ger_drugs:sellStateCL')
AddEventHandler('t1ger_drugs:sellStateCL', function(state)
	can_sell_drugs = state
end)

-- NPC Checks before sale:
function NPC_Accepted(entity)
	if not IsPedAPlayer(entity) and not IsPedInAnyVehicle(entity,false) and not IsEntityDead(entity) and IsPedHuman(entity) and not isEntityBlacklisted(entity) and entity ~= old_ped then 
		return true
	end
	return false
end

-- Blacklsited NPC's:
function isEntityBlacklisted(entity)
	for k,v in pairs(Config.BlackListedPeds) do
		if GetEntityModel(entity) == GetHashKey(v) then 
			return true 
		end
	end
	return false
end

