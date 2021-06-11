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
local firstHack = false
local secondHack = false

RegisterNetEvent('vulcan_business_rob:start')
AddEventHandler('vulcan_business_rob:start', function()
    local closestPlayer, dist = ESX.Game.GetClosestPlayer()
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "amb@world_human_seat_wall_tablet@female@base", "base", 3) then
            exports['mythic_notify']:SendAlert('inform', 'This is being hacked by someone else.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        else
            local ped = PlayerPedId()
            local cops = exports.esx_scoreboard:GetPlayerCounts().police
            local vehicle = IsPedSittingInAnyVehicle(ped)
            if not vehicle and cops >= Config.CopsRequired then
                TriggerServerEvent('vulcan_business_rob:itemCheck')
            elseif cops < Config.CopsRequired then
                exports['mythic_notify']:SendAlert('inform', 'There needs to be more police!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        elseif vehicle then
            exports['mythic_notify']:SendAlert('inform', 'You can\'t rob a store while in a vehicle!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        end
    end
end)

RegisterNetEvent('vulcan_business_rob:start:sopranos')
AddEventHandler('vulcan_business_rob:start:sopranos', function()
    local closestPlayer, dist = ESX.Game.GetClosestPlayer()
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "amb@world_human_seat_wall_tablet@female@base", "base", 3) then
            exports['mythic_notify']:SendAlert('inform', 'This is being hacked by someone else.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        else
            local ped = PlayerPedId()
            local cops = exports.esx_scoreboard:GetPlayerCounts().police
            local vehicle = IsPedSittingInAnyVehicle(ped)
            if not vehicle and cops >= Config.CopsRequired then
                TriggerServerEvent('vulcan_business_rob:itemCheck2')
            elseif cops < Config.CopsRequired then
                exports['mythic_notify']:SendAlert('inform', 'There needs to be more police!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        elseif vehicle then
            exports['mythic_notify']:SendAlert('inform', 'You can\'t rob a store while in a vehicle!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        end
    end
end)

RegisterNetEvent('vulcan_business_rob:start:casino')
AddEventHandler('vulcan_business_rob:start:casino', function()
    local closestPlayer, dist = ESX.Game.GetClosestPlayer()
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "amb@world_human_seat_wall_tablet@female@base", "base", 3) then
            exports['mythic_notify']:SendAlert('inform', 'This is being hacked by someone else.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        else
            local ped = PlayerPedId()
            local cops = exports.esx_scoreboard:GetPlayerCounts().police
            local vehicle = IsPedSittingInAnyVehicle(ped)
            if not vehicle and cops >= Config.CopsRequired then
                TriggerServerEvent('vulcan_business_rob:itemCheck3')
            elseif cops < Config.CopsRequired then
                exports['mythic_notify']:SendAlert('inform', 'There needs to be more police!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        elseif vehicle then
            exports['mythic_notify']:SendAlert('inform', 'You can\'t not rob a store while in a vehicle!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        end
    end
end)

local shopID = nil

function mycb(success, timeremaining)
	if success then
        if not firstHack and not secondHack then
            TriggerEvent('mhacking:hide')
            TriggerEvent("mhacking:show")
            TriggerEvent("mhacking:start",3,35,mycb)
            local playerPed = PlayerPedId()
            firstHack = true
        elseif firstHack and not secondHack then
            TriggerEvent('mhacking:hide')
            TriggerEvent("mhacking:show")
            TriggerEvent("mhacking:start",3,35,mycb)
            local playerPed = PlayerPedId()
            secondHack = true
        elseif firstHack and secondHack then
            TriggerEvent('mhacking:hide')
            TriggerServerEvent('vulcan_business_rob:removeItem:Reward', shopID)
            local playerPed = PlayerPedId()
            DeleteEntity(tabletObject)
            ClearPedTasks(playerPed)
            tabletObject = nil
            firstHack = false 
            secondHack = false
        end
    else
        TriggerServerEvent('vulcan_business_rob:removeItem')
        TriggerEvent('mhacking:hide')
        local playerPed = PlayerPedId()
        DeleteEntity(tabletObject)
        ClearPedTasks(playerPed)
        tabletObject = nil
        firstHack = false 
        secondHack = false
        local oldHealth = GetEntityHealth(playerPed)
        SetEntityHealth(playerPed, oldHealth - 50)
        SetPedToRagdoll(PlayerPedId(), 2000, 2000, 0, 0, 0, 0)
        exports['mythic_notify']:SendAlert('inform', 'The cash register malfunctioned and electrocuted you injuring you slightly.', 2500, { ['background-color'] = '#2F5C73', ['color'] = '#ffffff' })
    end
end

RegisterNetEvent('vulcan_business_rob:PDM')
AddEventHandler('vulcan_business_rob:PDM', function(source)
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
        shopID = 'PDM'
        Citizen.Wait(5000)
        exports['wp_dispatch']:addCall("10-90", "PDM Is Being Robbed", {
            {icon="fas fa-road", info = streetName},
            {icon="fa-venus-mars", info=gender}
        }, {cord[1], cord[2], cord[3]}, "police", 3000, 118, 1 )
        exports['wp_dispatch']:addCall("10-90", "PDM Is Being Robbed", {
            {icon="fas fa-road", info = streetName},
            {icon="fa-venus-mars", info=gender}
        }, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 118, 1 )
    end
end)

RegisterNetEvent('vulcan_business_rob:sopranos')
AddEventHandler('vulcan_business_rob:sopranos', function(source)
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
        shopID = 51
        Citizen.Wait(5000)
        exports['wp_dispatch']:addCall("10-90", "Sopranos Is Being Robbed", {
            {icon="fas fa-road", info = streetName},
            {icon="fa-venus-mars", info=gender}
        }, {cord[1], cord[2], cord[3]}, "police", 3000, 118, 1 )
        exports['wp_dispatch']:addCall("10-90", "Sopranos Is Being Robbed", {
            {icon="fas fa-road", info = streetName},
            {icon="fa-venus-mars", info=gender}
        }, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 118, 1 )
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = ((1 / dist) * 2) * (1 / GetGameplayCamFov()) * 100

    if onScreen then
        SetTextColour(255, 255, 255, 255)
        SetTextScale(0.0 * scale, 0.35 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextCentre(true)

        SetTextDropshadow(1, 1, 1, 1, 255)

        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.55 * scale, 4)
        local width = EndTextCommandGetWidth(4)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)

            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)

            for _, v in ipairs(Config.Locations) do
                local dst = #(coords - v.coords)
                if dst < 2 then
                    DrawText3D(v.coords[1], v.coords[2], v.coords[3] - 0.8, Config.Text["begin_robbery"])
                end
                if dst < 2 then
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('vulcan_business_rob:start:casino')
                    end
                end
            end
        end
    end
)

RegisterNetEvent('vulcan_business_rob:casino')
AddEventHandler('vulcan_business_rob:casino', function(source)
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

    exports['wp_dispatch']:addCall("10-90", "The Casino Is Being Robbed", {
        {icon="fas fa-road", info = streetName},
        {icon="fa-venus-mars", info=gender}
    }, {cord[1], cord[2], cord[3]}, "police", 3000, 118, 1 )
    exports['wp_dispatch']:addCall("10-90", "The Casino Is Being Robbed", {
        {icon="fas fa-road", info = streetName},
        {icon="fa-venus-mars", info=gender}
    }, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 118, 1 )

        shopID = 'casino'
        exports['mythic_notify']:SendAlert('inform', 'Press [W] to submit your answer.', 2500, { ['background-color'] = '#2F5C73', ['color'] = '#ffffff' })
        local minigame = exports["pd-safe"]:createSafe({math.random(0,99),math.random(0,99),math.random(0,99),math.random(0,99),math.random(0,99)})
        if minigame then
            TriggerServerEvent('vulcan_business_rob:removeItem:Reward', shopID)
            ClearPedTasks(playerPed)
        else
            TriggerServerEvent('vulcan_business_rob:removeItem')
            ClearPedTasks(playerPed)
            
            local oldHealth = GetEntityHealth(playerPed)
            SetEntityHealth(playerPed, oldHealth - 50)
            SetPedToRagdoll(PlayerPedId(), 2000, 2000, 0, 0, 0, 0)
            exports['mythic_notify']:SendAlert('inform', 'The safe engaged it\'s security procedure and electrocuted you injuring you slightly.', 2500, { ['background-color'] = '#2F5C73', ['color'] = '#ffffff' })
       end
    end
end)