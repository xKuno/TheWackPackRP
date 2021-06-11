ESX                           = nil

local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local cops = 0
local drillObject = nil

RegisterNetEvent('vulcan_truck_rob:start')
AddEventHandler('vulcan_truck_rob:start', function()
    local closestPlayer, dist = ESX.Game.GetClosestPlayer()
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 3) then
            exports['mythic_notify']:SendAlert('inform', 'This truck is being robbed by someone else.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        else
            local ped = PlayerPedId()
            local cops = exports.esx_scoreboard:GetPlayerCounts().police
            local vehicle = IsPedSittingInAnyVehicle(ped)
            if not vehicle and cops >= Config.CopsRequired then
                TriggerServerEvent('vulcan_truck_rob:itemCheck')
            elseif cops < Config.CopsRequired then
                exports['mythic_notify']:SendAlert('inform', 'There needs to be more police!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        elseif vehicle then
            exports['mythic_notify']:SendAlert('inform', 'You can\'t rob a truck while in a vehicle!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        end
    end
end)

local CachedModels = {}

LoadModels = function(models)
	for modelIndex = 1, #models do
		local model = models[modelIndex]

		table.insert(CachedModels, model)

		if IsModelValid(model) then
			while not HasModelLoaded(model) do
				RequestModel(model)
	
				Citizen.Wait(10)
			end
		else
			while not HasAnimDictLoaded(model) do
				RequestAnimDict(model)
	
				Citizen.Wait(10)
			end    
		end
	end
end

TruckPed = function(cord, vehicle, player, state)
        LoadModels({ GetHashKey('mp_s_m_armoured_01') })

        local pedHandle = CreatePed(5, 'mp_s_m_armoured_01', cord[1], cord[2], cord[3] - 0.985, 91.7, true)

        if state == '1' then
            TaskWarpPedIntoVehicle(pedHandle, vehicle, 1)
        elseif state == '2' then
            TaskWarpPedIntoVehicle(pedHandle, vehicle, 2)
        end
        
    Citizen.Wait(500)

    SetPedRelationshipGroupHash(player, GetHashKey("PLAYER"))
    AddRelationshipGroup('TruckNPCs')

    SetRelationshipBetweenGroups(0, GetHashKey("TruckNPCs"), GetHashKey("TruckNPCs"))
    SetRelationshipBetweenGroups(5, GetHashKey("TruckNPCs"), GetHashKey("PLAYER"))
    SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("TruckNPCs"))

    NetworkRegisterEntityAsNetworked(pedHandle)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(pedHandle), true)
    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(pedHandle), true)
    SetPedCanSwitchWeapon(pedHandle, true)
    SetPedArmour(pedHandle, 75)
    SetEntityHealth(pedHandle, 200)
    SetPedAccuracy(pedHandle, 75)
    SetEntityInvincible(pedHandle, false)
    SetEntityVisible(pedHandle, true)
    SetEntityAsMissionEntity(pedHandle)
    GiveWeaponToPed(pedHandle, GetHashKey(Config.PedWeapon), 255, false, false)
    SetPedDropsWeaponsWhenDead(pedHandle, false)

    TaskCombatPed(pedHandle, player, 0, 16)
    SetPedFleeAttributes(pedHandle, 0, false)
    SetPedCombatAttributes(pedHandle, 5, true)
    SetPedCombatAttributes(pedHandle, 16, true)
    SetPedCombatAttributes(pedHandle, 46, true)
    SetPedCombatAttributes(pedHandle, 26, true)
    SetPedSeeingRange(pedHandle, 75.0)
    SetPedHearingRange(pedHandle, 50.0)
    SetPedEnableWeaponBlocking(pedHandle, true)

    SetPedFleeAttributes(pedHandle, 0, 0)                      
    SetBlockingOfNonTemporaryEvents(pedHandle, true)
end

RegisterNetEvent('vulcan_truck_rob:Progbar')
AddEventHandler('vulcan_truck_rob:Progbar', function(source)
    local playerPed = PlayerPedId()
    local cord = GetEntityCoords(PlayerPedId())
    local vehicle = GetClosestVehicle(cord, 5.0, 0, 71)
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

    exports['wp_dispatch']:addCall("10-90", "Truck Robbery In Progress", {
        {icon="fas fa-road", info = streetName},
        {icon="fa-venus-mars", info=gender}
    }, {cord[1], cord[2], cord[3]}, "police", 3000, 67, 2 )
    exports['wp_dispatch']:addCall("10-90", "Truck Robbery In Progress", {
        {icon="fas fa-road", info = streetName},
        {icon="fa-venus-mars", info=gender}
    }, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 67, 2 )

    local dict = "anim@heists@fleeca_bank@drilling"
    RequestAnimDict(dict)
    drillObject = CreateObject(GetHashKey('hei_prop_heist_drill'), GetEntityCoords(playerPed), 1, 1, 1)
    AttachEntityToEntity(drillObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
    while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
    if not IsEntityPlayingAnim(playerPed, dict, 'drill_straight_idle', 3) then
    TaskPlayAnim(playerPed, dict, "drill_straight_idle", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)

    SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"),true)
    RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", 0)
	RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", 0)
	RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", 0)
	PlaySoundFromEntity(GetSoundId(), "Drill", drillObject, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
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
    TaskTurnPedToFaceEntity(playerPed, vehicle, 500)

        FreezeEntityPosition(playerPed, true)
        TriggerServerEvent('vulcan_truck_rob:beginLog')
        TriggerEvent("Drilling:Start",function(drill_status)
            if drill_status == 1 then
                DeleteEntity(drillObject)
                ClearPedTasks(playerPed)
                drillObject = nil
                StopSound(drill_sound)
                ReleaseSoundId(drill_sound)
                StopParticleFxLooped(effect, 0)
                StopGameplayCamShaking(true)

                TruckPed(cord, vehicle, playerPed, '1')
                TruckPed(cord, vehicle, playerPed, '2')

                FreezeEntityPosition(playerPed, false)

                while drill_status == 1 and DoesEntityExist(vehicle) do
                    Wait(0)
                    local moneyCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -4.25, 0.0)
                    local MoneySpot = #(GetEntityCoords(PlayerPedId()) - vector3(moneyCoords.x, moneyCoords.y, moneyCoords.z))
                    if MoneySpot < 1.6 then
                        DrawText3Ds(moneyCoords.x, moneyCoords.y, moneyCoords.z, "~w~Press ~g~E~s~ To ~r~Take Money~s~") 
                        if IsControlJustReleased(0,38) then
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
                        
                            exports['wp_dispatch']:addCall("10-90", "Truck Robbery In Progress", {
                                {icon="fas fa-road", info = streetName},
                                {icon="fa-venus-mars", info=gender}
                            }, {cord[1], cord[2], cord[3]}, "police", 3000, 67, 2 )
                            exports['wp_dispatch']:addCall("10-90", "Truck Robbery In Progress", {
                                {icon="fas fa-road", info = streetName},
                                {icon="fa-venus-mars", info=gender}
                            }, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 67, 2 )
                            TriggerEvent("mythic_progbar:client:progress", {
                                name = "take_money_truck",
                                duration = 25000,
                                label = "Taking Money...",
                                useWhileDead = false,
                                canCancel = true,
                                controlDisables = {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                },
                                animation = {
                                    animDict = "mini@repair",
                                    anim = "fixing_a_player",
                                    flags = 9,
                                },
                            }, function(status)
                                if not status then
                                    StopAnimTask(playerPed, "mini@repair", "fixing_a_player", 1.0)
                                    TriggerServerEvent('vulcan_truck_rob:removeItem:Reward')
                                    drill_status = nil
                                end
                            end)
                        end
                    end
                end
            elseif (drill_status == 3) then
                DeleteEntity(drillObject)
                ClearPedTasks(playerPed)
                drillObject = nil
                StopSound(drill_sound)
                ReleaseSoundId(drill_sound)
                StopParticleFxLooped(effect, 0)
                StopGameplayCamShaking(true)
                exports['mythic_notify']:SendAlert('inform', 'You stopped drilling!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })

                FreezeEntityPosition(playerPed, false)

                drill_status = nil
            elseif (drill_status == 2) then
                TriggerServerEvent('vulcan_truck_rob:removeItem')
                DeleteEntity(drillObject)
                ClearPedTasks(playerPed)
                drillObject = nil
                StopSound(drill_sound)
                ReleaseSoundId(drill_sound)
                StopParticleFxLooped(effect, 0)
                StopGameplayCamShaking(true)

                FreezeEntityPosition(playerPed, false)

                drill_status = nil
            end
        end)
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