ESX                           = nil

local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local cops = 0
local tabletObject = nil

RegisterNetEvent('vulcan_park_rob:start')
AddEventHandler('vulcan_park_rob:start', function()
	local closestPlayer, dist = ESX.Game.GetClosestPlayer()
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "random@mugging4", "struggle_loop_b_thief", 3) then
            exports['mythic_notify']:SendAlert('inform', 'This is being done by someone else.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        else
            local ped = PlayerPedId()
            local vehicle = IsPedSittingInAnyVehicle(ped)
            if not vehicle then
                TriggerEvent('vulcan_park_rob:progBar')
        elseif vehicle then
            exports['mythic_notify']:SendAlert('inform', 'You can\'t rob this while in a vehicle!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        end
    end
end)

RegisterNetEvent('vulcan_atm_rob:start')
AddEventHandler('vulcan_atm_rob:start', function()
	local closestPlayer, dist = ESX.Game.GetClosestPlayer()
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "amb@world_human_seat_wall_tablet@female@base", "base", 3) then
            exports['mythic_notify']:SendAlert('inform', 'This ATM is being hacked by someone else.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        else
            local ped = PlayerPedId()
            local cops = exports.esx_scoreboard:GetPlayerCounts().police
            local vehicle = IsPedSittingInAnyVehicle(ped)
            if not vehicle and cops >= Config.CopsRequired then
                TriggerServerEvent('vulcan_atm_rob:itemCheck')
            elseif cops < Config.CopsRequired then
                exports['mythic_notify']:SendAlert('inform', 'There needs to be more police!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        elseif vehicle then
            exports['mythic_notify']:SendAlert('inform', 'You can\'t rob an ATM while in a vehicle!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        end
    end
end)

function mycb(success, timeremaining)
	if success then
		TriggerServerEvent('vulcan_atm_rob:removeItem:Reward')
		TriggerEvent('mhacking:hide')
        local playerPed = PlayerPedId()
        DeleteEntity(tabletObject)
        ClearPedTasks(playerPed)
        tabletObject = nil
	else
        TriggerServerEvent('vulcan_atm_rob:removeItem')
		TriggerEvent('mhacking:hide')
        local playerPed = PlayerPedId()
        DeleteEntity(tabletObject)
        ClearPedTasks(playerPed)
        tabletObject = nil
	end
end

RegisterNetEvent('vulcan_atm_rob:Progbar')
AddEventHandler('vulcan_atm_rob:Progbar', function(source)
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

    local dict = "amb@world_human_seat_wall_tablet@female@base"
    RequestAnimDict(dict)
    tabletObject = CreateObject(GetHashKey('prop_cs_tablet'), GetEntityCoords(playerPed), 1, 1, 1)
    AttachEntityToEntity(tabletObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
    while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
    if not IsEntityPlayingAnim(playerPed, dict, 'base', 3) then
    TaskPlayAnim(playerPed, dict, "base", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)

        TriggerEvent("mhacking:show")
        TriggerEvent("mhacking:start",3,35,mycb)
        Citizen.Wait(5000)
        exports['wp_dispatch']:addCall("10-90", "ATM Is Being Hacked", {
            {icon="fas fa-road", info = streetName},
            {icon="fa-venus-mars", info=gender}
        }, {cord[1], cord[2], cord[3]}, "police", 3000, 76, 1 )
        exports['wp_dispatch']:addCall("10-90", "ATM Is Being Hacked", {
            {icon="fas fa-road", info = streetName},
            {icon="fa-venus-mars", info=gender}
        }, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 76, 1 )
    end
end)

RegisterNetEvent('vulcan_park_rob:progBar')
AddEventHandler('vulcan_park_rob:progBar', function(source)
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

    exports['wp_dispatch']:addCall("10-31", "Parking Meter Is Being Tampered", {
        {icon="fas fa-road", info = streetName},
        {icon="fa-venus-mars", info=gender}
    }, {cord[1], cord[2], cord[3]}, "police", 3000, 76, 1 )
    exports['wp_dispatch']:addCall("10-31", "Parking Meter Is Being Tampered", {
        {icon="fas fa-road", info = streetName},
        {icon="fa-venus-mars", info=gender}
    }, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 76, 1 )

    TriggerEvent("mythic_progbar:client:progress", {
        name = "parking_meter_tamper",
        duration = 20000,
        label = "Tampering With Parking Meter",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "random@mugging4",
            anim = "struggle_loop_b_thief",
        }
    }, function(status)
        if not status then
            ClearPedTasks(playerPed)
            TriggerServerEvent('vulcan_park_rob:removeItem:Reward')
        end
    end)
end)