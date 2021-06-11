local policeDog = false
ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(0) end
    while ESX.GetPlayerData().job == nil do Wait(0) end
    PlayerData = ESX.GetPlayerData()
    if Config.Command then
        RegisterCommand(Config.Command, function()
            TriggerEvent('esx_policedog:openMenu')
        end)
    end
    while true do
        local sleep = 250
        if DoesEntityExist(policeDog) then
            sleep = 0
            if GetDistanceBetweenCoords(GetEntityCoords(policeDog), GetEntityCoords(PlayerPedId()), true) >= Config.TpDistance and not IsEntityPlayingAnim(policeDog, Config.Sit.dict, Config.Sit.anim, 3) and not IsPedInAnyVehicle(policeDog, false) then
                SetEntityCoords(policeDog, GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -1.0, -0.98))
            end
            if GetDistanceBetweenCoords(GetEntityCoords(policeDog), GetEntityCoords(PlayerPedId()), true) >= 2.0 and not IsPedInAnyVehicle(policeDog, true) and not IsEntityPlayingAnim(policeDog, Config.Sit.dict, Config.Sit.anim, 3) and IsPedStill(policeDog) then
                TaskGoToCoordAnyMeans(policeDog, GetEntityCoords(PlayerPedId()), 5.0, 0, 0, 786603, 0xbf800000)
                sleep = 500
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('esx_policedog:openMenu')
AddEventHandler('esx_policedog:openMenu', function()
    mainMenu()
end)

RegisterNetEvent('esx_policedog:hasDrugs')
AddEventHandler('esx_policedog:hasDrugs', function(hadIt)
    if hadIt then
        exports['mythic_notify']:SendAlert('inform', 'Drugs found!', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
        loadDict('missfra0_chop_find')
        TaskPlayAnim(policeDog, 'missfra0_chop_find', 'chop_bark_at_ballas', 8.0, -8, -1, 0, 0, false, false, false)
    else
        exports['mythic_notify']:SendAlert('inform', 'No drugs were found.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
    end
end)

RegisterNetEvent('K9:Create')
AddEventHandler('K9:Create', function()
if not DoesEntityExist(policeDog) then
    RequestModel(Config.Model)
    while not HasModelLoaded(Config.Model) do Wait(0) end
    policeDog = CreatePed(4, Config.Model, GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, -0.98), 0.0, true, false)
    SetEntityAsMissionEntity(policeDog, true, true)
    exports['mythic_notify']:SendAlert('inform', 'K9 in service.', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
else
    exports['mythic_notify']:SendAlert('inform', 'K9 out of service.', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
    DeleteEntity(policeDog)
    end
end)

RegisterNetEvent('K9:Attack')
AddEventHandler('K9:Attack', function()
if DoesEntityExist(policeDog) then
    if not IsPedDeadOrDying(policeDog) then
        if GetDistanceBetweenCoords(GetEntityCoords(policeDog), GetEntityCoords(PlayerPedId()), true) <= 15.0 then
            local player, distance = ESX.Game.GetClosestPlayer()
            if distance ~= -1 then
                if distance <= 3.0 then
                    local playerPed = GetPlayerPed(player)
                    if not IsPedInCombat(policeDog, playerPed) then
                        if not IsPedInAnyVehicle(playerPed, true) then
                            TaskCombatPed(policeDog, playerPed, 0, 16)
                        end
                    else
                        ClearPedTasksImmediately(policeDog)
                    end
                end
            end
        end
    else
        exports['mythic_notify']:SendAlert('inform', 'Your dog is now 10-7 10-42 permanently.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
    end
else
    exports['mythic_notify']:SendAlert('inform', 'You do not have a K9 currently.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
    end
end)

RegisterNetEvent('K9:Sit')
AddEventHandler('K9:Sit', function()
if DoesEntityExist(policeDog) then
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(policeDog), true) <= 5.0 then
        if IsEntityPlayingAnim(policeDog, Config.Sit.dict, Config.Sit.anim, 3) then
            ClearPedTasks(policeDog)
        else
            loadDict('rcmnigel1c')
            TaskPlayAnim(PlayerPedId(), 'rcmnigel1c', 'hailing_whistle_waive_a', 8.0, -8, -1, 120, 0, false, false, false)
            Wait(2000)
            loadDict(Config.Sit.dict)
            TaskPlayAnim(policeDog, Config.Sit.dict, Config.Sit.anim, 8.0, -8, -1, 1, 0, false, false, false)
        end
    else
        exports['mythic_notify']:SendAlert('inform', 'The dog is too far away.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
    end
else
    exports['mythic_notify']:SendAlert('inform', 'You do not have a K9 currently.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
    end
end)

RegisterNetEvent('K9:Sniff')
AddEventHandler('K9:Sniff', function()
if DoesEntityExist(policeDog) then
    if not IsPedDeadOrDying(policeDog) then
        if GetDistanceBetweenCoords(GetEntityCoords(policeDog), GetEntityCoords(PlayerPedId()), true) <= 3.0 then
            local player, distance = ESX.Game.GetClosestPlayer()
            if distance ~= -1 then
                if distance <= 3.0 then
                    local playerPed = GetPlayerPed(player)
                    if not IsPedInAnyVehicle(playerPed, true) then
                        TriggerServerEvent('esx_policedog:hasClosestDrugs', GetPlayerServerId(player))
                    end
                end
            end
        end
    else
        exports['mythic_notify']:SendAlert('inform', 'Your dog is now 10-7 10-42 permanently.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
    end
else
    exports['mythic_notify']:SendAlert('inform', 'You do not have a K9 currently.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
    end
end)

mainMenu = function()
    if PlayerData.job.name == 'police' then
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'buy_storage',
            {
                title = Strings['menu_title'],
                align = 'right',
                elements = {{label = Strings['take_out_remove'], value = 'take_out_remove'}, {label = Strings['get_in_out'], value = 'get_in_out'}, {label = Strings['sit_stand'], value = 'sit_stand'}, {label = Strings['search_drugs'], value = 'search_drugs'}, {label = Strings['attack_closest'], value = 'attack_closest'}}
            },
            function(data, menu)
                if data.current.value == 'take_out_remove' then
                    if not DoesEntityExist(policeDog) then
                        RequestModel(Config.Model)
                        while not HasModelLoaded(Config.Model) do Wait(0) end
                        policeDog = CreatePed(4, Config.Model, GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, -0.98), 0.0, true, false)
                        SetEntityAsMissionEntity(policeDog, true, true)
                        exports['mythic_notify']:SendAlert('inform', 'K9 in service.', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
                    else
                        exports['mythic_notify']:SendAlert('inform', 'K9 out of service.', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
                        DeleteEntity(policeDog)
                    end
                elseif data.current.value == 'get_in_out' then
                    if not IsPedInAnyVehicle(policeDog, false) then
                        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(policeDog)) <= 10.0 then
                            local vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 7.5, 0, 70)
                            print(vehicle)
                            if DoesEntityExist(vehicle) then
                                for i = 0, GetVehicleMaxNumberOfPassengers(vehicle) do
                                    if IsVehicleSeatFree(vehicle, i) then
                                        TaskEnterVehicle(policeDog, vehicle, 15.0, i, 1.0, 1, 0)
                                        break
                                    end
                                end
                            end
                        else
                            exports['mythic_notify']:SendAlert('inform', 'The dog is too far away.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
                        end
                    else
                        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(policeDog)) <= 5.0 then
                            TaskLeaveVehicle(policeDog, GetVehiclePedIsIn(policeDog, false), 0)
                        else
                            exports['mythic_notify']:SendAlert('inform', 'The dog is too far away.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
                        end
                    end
                elseif data.current.value == 'attack_closest' then
                    if DoesEntityExist(policeDog) then
                        if not IsPedDeadOrDying(policeDog) then
                            if GetDistanceBetweenCoords(GetEntityCoords(policeDog), GetEntityCoords(PlayerPedId()), true) <= 15.0 then
                                local player, distance = ESX.Game.GetClosestPlayer()
                                if distance ~= -1 then
                                    if distance <= 3.0 then
                                        local playerPed = GetPlayerPed(player)
                                        if not IsPedInCombat(policeDog, playerPed) then
                                            if not IsPedInAnyVehicle(playerPed, true) then
                                                TaskCombatPed(policeDog, playerPed, 0, 16)
                                            end
                                        else
                                            ClearPedTasksImmediately(policeDog)
                                        end
                                    end
                                end
                            end
                        else
                            exports['mythic_notify']:SendAlert('inform', 'Your dog is now 10-7 10-42 permanently.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
                        end
                    else
                        exports['mythic_notify']:SendAlert('inform', 'You do not have a K9 currently.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
                    end
                elseif data.current.value == 'sit_stand' then
                    if DoesEntityExist(policeDog) then
                        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(policeDog), true) <= 5.0 then
                            if IsEntityPlayingAnim(policeDog, Config.Sit.dict, Config.Sit.anim, 3) then
                                ClearPedTasks(policeDog)
                            else
                                loadDict('rcmnigel1c')
                                TaskPlayAnim(PlayerPedId(), 'rcmnigel1c', 'hailing_whistle_waive_a', 8.0, -8, -1, 120, 0, false, false, false)
                                Wait(2000)
                                loadDict(Config.Sit.dict)
                                TaskPlayAnim(policeDog, Config.Sit.dict, Config.Sit.anim, 8.0, -8, -1, 1, 0, false, false, false)
                            end
                        else
                            exports['mythic_notify']:SendAlert('inform', 'The dog is too far away.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
                        end
                    else
                        exports['mythic_notify']:SendAlert('inform', 'You do not have a K9 currently.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
                    end
                elseif data.current.value == 'search_drugs' then
                    if DoesEntityExist(policeDog) then
                        if not IsPedDeadOrDying(policeDog) then
                            if GetDistanceBetweenCoords(GetEntityCoords(policeDog), GetEntityCoords(PlayerPedId()), true) <= 3.0 then
                                local player, distance = ESX.Game.GetClosestPlayer()
                                if distance ~= -1 then
                                    if distance <= 3.0 then
                                        local playerPed = GetPlayerPed(player)
                                        if not IsPedInAnyVehicle(playerPed, true) then
                                            TriggerServerEvent('esx_policedog:hasClosestDrugs', GetPlayerServerId(player))
                                        end
                                    end
                                end
                            end
                        else
                            exports['mythic_notify']:SendAlert('inform', 'Your dog is now 10-7 10-42 permanently.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
                        end
                    else
                        exports['mythic_notify']:SendAlert('inform', 'You do not have a K9 currently.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
                    end
                end
            end,
        function(data, menu)
            menu.close()
        end)
    else
        exports['mythic_notify']:SendAlert('inform', 'You are not a police officer.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
    end
end

loadDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
end