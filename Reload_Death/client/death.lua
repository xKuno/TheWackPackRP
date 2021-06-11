Keys = {
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

local isDead = false
local Playdeadanim = false

RegisterNetEvent('reload_death:onPlayerDeath')
RegisterNetEvent('reload_death:onPlayerRevive')

RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
    Playdeadanim = true
end)

RegisterNetEvent('reload_death:stopAnim')
AddEventHandler('reload_death:stopAnim', function()
    Playdeadanim = false
end)
RegisterNetEvent('reload_death:startAnim')
AddEventHandler('reload_death:startAnim', function()
    Playdeadanim = true
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(data)
    ESX.TriggerServerCallback('reload_death:getDead', function(dead)
        isDead = dead
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local playerPed = PlayerPedId()
        if isDead or GetEntityHealth(playerPed) <= 0 then
            Playdeadanim = true
            TriggerEvent('reload_death:onPlayerDeath')
            TriggerServerEvent('reload_death:setDead', true)
            TriggerEvent('menu:isDead', true)
            ClearPedTasksImmediately(playerPed)
			TriggerEvent('esx_status:set', 'hunger', 500000)
			TriggerEvent('esx_status:set', 'thirst', 500000)
            SetEntityInvincible(playerPed, true)
            Citizen.CreateThread(function()
                while isDead do
                    DisableAllControlActions(0)
                    EnableControlAction(0, 1)
                    EnableControlAction(0, 2)
                    EnableControlAction(0, 172)
                    EnableControlAction(0, 173)
                    EnableControlAction(0, 174)
                    EnableControlAction(0, 175)
                    EnableControlAction(0, 176)
                    EnableControlAction(0, 177)
					EnableControlAction(0, Keys['B'], true)
                    EnableControlAction(0, Keys['E'], true)
                    EnableControlAction(0, Keys['M'], true)
                    EnableControlAction(0, Keys['H'], true)
                    EnableControlAction(0, Keys['T'], true)
                    EnableControlAction(0, Keys['N'], true)
                    EnableControlAction(0, Keys['Z'], true)
                    EnableControlAction(0, Keys['F1'], true)
                    EnableControlAction(0, Keys['U'], true)
                    EnableControlAction(0, Keys['~'], true)
                    Citizen.Wait(0)
                end
                EnableAllControlActions(0)
            end)
            Citizen.Wait(2000)
            SetEntityHealth(playerPed, GetPedMaxHealth(playerPed))
            ClearPedTasksImmediately(playerPed)
            --local lib, anim = 'random@drunk_driver_1', 'drunk_fall_over'
            local lib, anim = 'dead', 'dead_a'
            local lib2, anim2 = 'anim@veh@std@issi3@ps@base', 'die'
            local lib3, anim3 = 'dam_ko', 'drown'
            local count = 0
            -- ESX.Streaming.RequestAnimDict(lib, function()
            --     TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 2, 1, 0, 0, 0)
                Citizen.Wait(1000)
                while isDead do
                    if Playdeadanim then
                        if IsEntityInWater(PlayerPedId(), true) then
                            if not IsEntityPlayingAnim(playerPed, lib3, anim3, 3) then
                                ESX.Streaming.RequestAnimDict(lib3, function()
                                    TaskPlayAnim(playerPed, lib3, anim3, 8.0, 8.0, -1, 2, 1, 0, 0, 0)
                                end)
                            end
                        elseif IsPedInAnyVehicle(PlayerPedId(), true) then
                            if not IsEntityPlayingAnim(playerPed, lib2, anim2, 3) then
                                ESX.Streaming.RequestAnimDict(lib2, function()
                                    TaskPlayAnim(playerPed, lib2, anim2, 8.0, 8.0, -1, 2, 1, 0, 0, 0)
                                end)
                            end
                        else
                            if not IsEntityPlayingAnim(playerPed, lib, anim, 3) then
                                count = count + 1
                                ESX.Streaming.RequestAnimDict(lib, function()
                                    TaskPlayAnim(playerPed, lib, anim, 8.0, 8.0, -1, 2, 1, 0, 0, 0)
                                end)
                                -- if count >= 3 then 
                                --     ExecuteCommand('fixdead')
                                --     count = 0
                                -- end
                            end
                        end
                        if IsEntityPlayingAnim(playerPed, 'cellphone@', 'cellphone_text_in', 3) or IsEntityPlayingAnim(playerPed, 'random@mugging3', 'handsup_standing_base', 3) or IsEntityPlayingAnim(playerPed, 'mp_arrest_paired', 'crook_p2_back_right', 3) or IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) then
                            StopEntityAnim(playerPed, 'cellphone_text_in', 'cellphone@', 3)
                            StopEntityAnim(playerPed, 'handsup_standing_base', 'random@mugging3', 3)
                            StopEntityAnim(playerPed, 'mp_arrest_paired', 'crook_p2_back_right', 3)
                            StopEntityAnim(playerPed, 'mp_arresting', 'idle', 3)
                        end
                    end
                    Citizen.Wait(500)
                end
            -- end)
        end
    end
end)

RegisterCommand('fixdead', function()
    local playerPed = PlayerPedId()
    TriggerEvent('reload_death:revive')
    FreezeEntityPosition(PlayerPedId(), true)
    Citizen.Wait(1000)
    FreezeEntityPosition(PlayerPedId(), false)
    SetEntityHealth(playerPed, 0)
    TriggerServerEvent('Reload_Death:FixDeadLog')
end)

function Revive(playerPed)
    Coords = GetEntityCoords(playerPed)
    Heading = GetEntityHeading(playerPed)
    
    SetEntityCoordsNoOffset(playerPed, Coords.x, Coords.y, Coords.z, false, false, false, true)
    NetworkResurrectLocalPlayer(Coords.x, Coords.y, Coords.z, Heading, true, false)

    TriggerServerEvent('reload_death:setDead', false)
    TriggerEvent('menu:notIsDead', true)
    TriggerEvent('reload_death:onPlayerRevive')
    isDead = false
    ClearPedTasksImmediately(playerPed)
    SetEntityInvincible(playerPed, false)
    TriggerEvent('esx_ambulancejob:multicharacter', Coords.x, Coords.y, Coords.z)
    ClearPedBloodDamage(playerPed)
    TriggerEvent('esx_status:set', 'hunger', 500000)
    TriggerEvent('esx_status:set', 'thirst', 500000)
    SetEntityHealth(playerPed, GetPedMaxHealth(playerPed))
end

RegisterNetEvent('reload_death:revive')
AddEventHandler('reload_death:revive', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

    DoScreenFadeOut(200)
    while IsScreenFadingOut() do
        Citizen.Wait(100)
    end

    local formattedCoords = {
        x = ESX.Math.Round(coords.x, 1),
        y = ESX.Math.Round(coords.y, 1),
        z = ESX.Math.Round(coords.z, 1)
    }

    ESX.SetPlayerData('lastPosition', formattedCoords)

    TriggerServerEvent('esx:updateLastPosition', formattedCoords)

    Revive(playerPed, formattedCoords, 0.0)
    DoScreenFadeIn(3000)
    ESX.Streaming.RequestAnimDict('get_up@directional@movement@from_knees@action', function()
        TaskPlayAnim(playerPed, 'get_up@directional@movement@from_knees@action', 'getup_r_0', 8.0, -8.0, -1, 0, 0, 0, 0, 0)
    end)
    while IsScreenFadingIn() do
        Citizen.Wait(100)
    end
end)

RegisterNetEvent('reload_death:reviveRPDeath')
AddEventHandler('reload_death:reviveRPDeath', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

    DoScreenFadeOut(200)
    while IsScreenFadingOut() do
        Citizen.Wait(100)
    end

    local formattedCoords = {
        x = ESX.Math.Round(coords.x, 1),
        y = ESX.Math.Round(coords.y, 1),
        z = ESX.Math.Round(coords.z, 1)
    }

    ESX.SetPlayerData('lastPosition', formattedCoords)

    TriggerServerEvent('esx:updateLastPosition', formattedCoords)

    Revive(playerPed, formattedCoords, 0.0)
    DoScreenFadeIn(3000)
    ESX.Streaming.RequestAnimDict('get_up@directional@movement@from_knees@action', function()
        TaskPlayAnim(playerPed, 'get_up@directional@movement@from_knees@action', 'getup_r_0', 8.0, -8.0, -1, 0, 0, 0, 0, 0)
    end)
    while IsScreenFadingIn() do
        Citizen.Wait(100)
    end
end)