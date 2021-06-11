ESX                           = nil

local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local cops = 0

RegisterNetEvent('vulcan_store_rob:start:safe')
AddEventHandler('vulcan_store_rob:start:safe', function()
    local closestPlayer, dist = ESX.Game.GetClosestPlayer()
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "mini@safe_cracking", "dial_turn_anti_fast_1", 3) then
            exports['mythic_notify']:SendAlert('inform', 'This is being cracked by someone else.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        else
            local cops = exports.esx_scoreboard:GetPlayerCounts().police
            if cops >= Config.CopsRequired then
                TriggerServerEvent('vulcan_store_rob:itemCheck')
        elseif cops < Config.CopsRequired then
            exports['mythic_notify']:SendAlert('inform', 'There needs to be more police!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        end
    end
end)

RegisterNetEvent('vulcan_store_rob:start:cashRegister')
AddEventHandler('vulcan_store_rob:start:cashRegister', function()
    local closestPlayer, dist = ESX.Game.GetClosestPlayer()
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "mini@safe_cracking", "dial_turn_anti_fast_1", 3) then
            exports['mythic_notify']:SendAlert('inform', 'This is being cracked by someone else.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        else
            local cops = exports.esx_scoreboard:GetPlayerCounts().police
            if cops >= Config.CopsRequired then
                TriggerServerEvent('vulcan_store_rob:itemCheck2')
        elseif cops < Config.CopsRequired then
            exports['mythic_notify']:SendAlert('inform', 'There needs to be more police!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        end
    end
end)

RegisterNetEvent('vulcan_store_rob:Progbar')
AddEventHandler('vulcan_store_rob:Progbar', function(source)
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

    local dict = "mini@safe_cracking"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
    if not IsEntityPlayingAnim(playerPed, dict, 'dial_turn_anti_fast_1', 3) then
    TaskPlayAnim(playerPed, dict, "dial_turn_anti_fast_1", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)

    exports['wp_dispatch']:addCall("10-90", "Store Is Being Robbed", {
        {icon="fas fa-road", info = streetName},
        {icon="fa-venus-mars", info=gender}
    }, {cord[1], cord[2], cord[3]}, "police", 3000, 118, 1 )
    exports['wp_dispatch']:addCall("10-90", "Store Is Being Robbed", {
        {icon="fas fa-road", info = streetName},
        {icon="fa-venus-mars", info=gender}
    }, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 118, 1 )

        exports['mythic_notify']:SendAlert('inform', 'Press [W] to submit your answer.', 2500, { ['background-color'] = '#2F5C73', ['color'] = '#ffffff' })
        local minigame = exports["pd-safe"]:createSafe({math.random(0,99),math.random(0,99),math.random(0,99),math.random(0,99)})
        if minigame then
            TriggerServerEvent('vulcan_store_rob:removeItem:Reward')
            local playerPed = PlayerPedId()
            ClearPedTasks(playerPed)
        else
            TriggerServerEvent('vulcan_store_rob:removeItem')
            local playerPed = PlayerPedId()
            ClearPedTasks(playerPed)
       end
    end
end)

RegisterNetEvent('vulcan_store_rob:Progbar2')
AddEventHandler('vulcan_store_rob:Progbar2', function(source)
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

    local dict = "mini@safe_cracking"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
    if not IsEntityPlayingAnim(playerPed, dict, 'dial_turn_anti_fast_1', 3) then
    TaskPlayAnim(playerPed, dict, "dial_turn_anti_fast_1", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)

    exports['wp_dispatch']:addCall("10-90", "Cash Register Is Being Robbed", {
        {icon="fas fa-road", info = streetName},
        {icon="fa-venus-mars", info=gender}
    }, {cord[1], cord[2], cord[3]}, "police", 3000, 76, 1 )
    exports['wp_dispatch']:addCall("10-90", "Cash Register Is Being Robbed", {
        {icon="fas fa-road", info = streetName},
        {icon="fa-venus-mars", info=gender}
    }, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 76, 1 )

        exports['mythic_notify']:SendAlert('inform', 'Press [W] to submit your answer.', 2500, { ['background-color'] = '#2F5C73', ['color'] = '#ffffff' })
        local minigame = exports["pd-safe"]:createSafe({math.random(0,99),math.random(0,99)})
        if minigame then
            TriggerServerEvent('vulcan_store_rob:removeItem:Reward2')
            local playerPed = PlayerPedId()
            ClearPedTasks(playerPed)
        elseif not minigame then
            local oldHealth = GetEntityHealth(playerPed)
            SetEntityHealth(playerPed, oldHealth - 50)
            SetPedToRagdoll(PlayerPedId(), 2000, 2000, 0, 0, 0, 0)
            exports['mythic_notify']:SendAlert('inform', 'The cash register malfunctioned and electrocuted you injuring you slightly.', 2500, { ['background-color'] = '#2F5C73', ['color'] = '#ffffff' })
        end
    end
end)