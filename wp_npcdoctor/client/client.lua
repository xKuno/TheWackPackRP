ESX = nil

local PlayerData              = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)


Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/doctor', 'Toggle the local doctor on and off.')
end)

local canEms = nil

Citizen.CreateThread(function()
   
    while true do
        local sleep = 5000
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)

        for i = 1, #Config.Doctor, 1 do
            local doctors = Config.Doctor[i]
            local userDst = GetDistanceBetweenCoords(pedCoords, doctors.x, doctors.y, doctors.z, true)

            if userDst <= 15 then
                sleep = 2
                if userDst <= 5 then
                    DrawText3D(vector3(doctors.x, doctors.y, doctors.z), 'Press ~g~[H]~s~ To Checkin For ~b~$'..doctors.price..'~s~')
                    DrawMarker(27, doctors.x, doctors.y, doctors.z-0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 1.0, 255, 195, 18, 100, false, true, 2, false, false, false, false)
                    if userDst <= 1.5 then
                        if IsControlJustPressed(0, 74) then
                            if doctors == Config.Doctor[5] then
                                canEms = true
                            else
                                ESX.TriggerServerCallback('wp_npcdoctor:getEms', function(cb)
                                    canEms = cb
                                end, i)
                                while canEms == nil do
                                    Wait(0)
                                end
                            end
                            if canEms == true then
                                canEms = nil

                                
                                ESX.TriggerServerCallback('wp_npcdoctor:getMoney', function(hasEnoughMoney)
                                    if hasEnoughMoney then
                                        local formattedCoords = {
                                            x = ESX.Math.Round(pedCoords.x, 1),
                                            y = ESX.Math.Round(pedCoords.y, 1),
                                            z = ESX.Math.Round(pedCoords.z, 1)
                                        }
                                        TriggerServerEvent('wp_npcdoctor:takeMoney', doctors)
                                        if doctors == Config.Doctor[1] then
                                            TakeTreatmentPillbox(formattedCoords)
                                        else
                                            TriggerEvent('esx_ambulancejob:revive', formattedCoords)
                                        end
                                    else
                                        exports['mythic_notify']:SendAlert('inform', 'You don\'t have enough money!')
                                    end
                                end)

                            elseif canEms == 'no_ems' then
                                exports['mythic_notify']:SendAlert('inform', 'The doctor is currently disabled by the on-duty ems.')  
                                canEms = nil                        
                            end 
                        end
                    end
                end
            end

        end

        Citizen.Wait(sleep)
    end
end)

DrawText3D = function(coords, text)
    SetDrawOrigin(coords)

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    DrawRect(0.0, 0.0125, 0.015 + text:gsub("~.-~", ""):len() / 370, 0.03, 45, 45, 45, 150)

    ClearDrawOrigin()
end

local ems = 0

RegisterCommand('doctor', function(source)
    ems = exports.esx_scoreboard:GetPlayerCounts().ems
    TriggerServerEvent('doctorStatus:Server', ems)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        ems = exports.esx_scoreboard:GetPlayerCounts().ems
        if ems < Config.minToDisable then
            TriggerServerEvent('doctorStatus:Enable:Server')
        end
    end
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

local isDead = false
local ableToGetUp = false

AddEventHandler('menu:isDead', function()
    isDead = true
end)

AddEventHandler('menu:notIsDead', function()
    isDead = false
end)

local bedTaken = nil

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if IsControlJustReleased(0,38) and ableToGetUp == true then

            exports['mythic_notify']:PersistentAlert('end', 'exitHospital', 'inform', 'Press [E] To Leave The Bed.')
            TriggerServerEvent('wp_npcdoctor:openBed', bedTaken)
            local playerPed = PlayerPedId()
            ClearPedTasksImmediately(playerPed)
            SetEntityCoords(playerPed, 316.03, -583.95, 43.28)
            SetEntityHeading(playerPed, 340.00)
            loadAnimDict("amb@world_human_bum_slumped@male@laying_on_left_side@base") 
            TaskPlayAnim(playerPed, "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 2.0, 2.0, 2500, 51, 0, 0, 0, 0)
            FreezeEntityPosition(playerPed, false)	
            SetEntityInvincible(playerPed, false)
            Citizen.Wait(2500)
            ClearPedTasks(playerPed)
            ableToGetUp = false
        end
    end
end)

TakeTreatmentPillbox = function(formattedCoords)
    local TreatMentDead = isDead
    local playerPed = PlayerPedId()
    TriggerEvent('esx_ambulancejob:revive', formattedCoords)
    ESX.TriggerServerCallback('wp_npcdoctor:getBeds', function(openBeds)
        Citizen.Wait(1500)
        if openBeds[1].taken == false then
            SetEntityCoords(playerPed, 314.48, -584.22, 44.51 - 1)
            SetEntityHeading(playerPed, 340.00)
            TriggerServerEvent('wp_npcdoctor:takeBed', 1)
            bedTaken = 1
        elseif openBeds[2].taken == false then
            SetEntityCoords(playerPed, 317.78, -585.36, 44.51 - 1)
            SetEntityHeading(playerPed, 340.00)
            TriggerServerEvent('wp_npcdoctor:takeBed', 2)
            bedTaken = 2
        elseif openBeds[3].taken == false then
            SetEntityCoords(playerPed, 322.70, -587.24, 44.51 - 1)
            SetEntityHeading(playerPed, 340.00)
            TriggerServerEvent('wp_npcdoctor:takeBed', 3)
            bedTaken = 3
        elseif openBeds[4].taken == false then
            SetEntityCoords(playerPed, 311.11, -583.14, 44.51 - 1)
            SetEntityHeading(playerPed, 340.00)
            TriggerServerEvent('wp_npcdoctor:takeBed', 4)
            bedTaken = 4
        elseif openBeds[5].taken == false then
            SetEntityCoords(playerPed, 307.84, -581.67, 44.51 - 1)
            SetEntityHeading(playerPed, 340.00)
            TriggerServerEvent('wp_npcdoctor:takeBed', 5)
            bedTaken = 5
        elseif openBeds[6].taken == false then
            SetEntityCoords(playerPed, 309.24, -577.27, 44.51 - 1)
            SetEntityHeading(playerPed, 160.00)
            TriggerServerEvent('wp_npcdoctor:takeBed', 6)
            bedTaken = 6
        elseif openBeds[7].taken == false then
            SetEntityCoords(playerPed, 313.91, -578.92, 44.51 - 1)
            SetEntityHeading(playerPed, 160.00)
            TriggerServerEvent('wp_npcdoctor:takeBed', 7)
            bedTaken = 7
        elseif openBeds[8].taken == false then
            SetEntityCoords(playerPed, 319.27, -581.06, 44.51 - 1)
            SetEntityHeading(playerPed, 160.00)
            TriggerServerEvent('wp_npcdoctor:takeBed', 8)
            bedTaken = 8
        elseif openBeds[9].taken == false then
            SetEntityCoords(playerPed, 324.13, -582.89, 44.51 - 1)
            SetEntityHeading(playerPed, 160.00)
            TriggerServerEvent('wp_npcdoctor:takeBed', 9)
            bedTaken = 9
        end
        FreezeEntityPosition(playerPed, true)	
        SetEntityHealth(playerPed, 200.0)
        SetEntityInvincible(playerPed, true)
        loadAnimDict('missfinale_c1@')
        TaskPlayAnim(playerPed, "missfinale_c1@", "lying_dead_player0", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
        if TreatMentDead then
            TriggerEvent("InteractSound_CL:PlayOnOne","ventilator",0.2)
            Citizen.Wait(2000)
            TriggerEvent("InteractSound_CL:PlayOnOne","ventilator",0.2)
            Citizen.Wait(2000)
            TriggerEvent("InteractSound_CL:PlayOnOne","ventilator",0.2)
            Citizen.Wait(2000)
            TriggerEvent("InteractSound_CL:PlayOnOne","ventilator",0.2)
            Citizen.Wait(2000)
            TriggerEvent("InteractSound_CL:PlayOnOne","ventilator",0.2)
            Citizen.Wait(1500)

            ableToGetUp = true
            exports['mythic_notify']:PersistentAlert('start', 'exitHospital', 'inform', 'Press [E] To Leave The Bed.')
        else
            TriggerEvent("InteractSound_CL:PlayOnOne","heartmonbeat",0.2)
            Citizen.Wait(1250)
            TriggerEvent("InteractSound_CL:PlayOnOne","heartmonbeat",0.2)
            Citizen.Wait(1250)
            TriggerEvent("InteractSound_CL:PlayOnOne","heartmonbeat",0.2)
            Citizen.Wait(1250)
            TriggerEvent("InteractSound_CL:PlayOnOne","heartmonbeat",0.2)
            Citizen.Wait(1250)
            TriggerEvent("InteractSound_CL:PlayOnOne","heartmonbeat",0.2)
            Citizen.Wait(1250)
            TriggerEvent("InteractSound_CL:PlayOnOne","heartmonbeat",0.2)
            Citizen.Wait(1250)
            TriggerEvent("InteractSound_CL:PlayOnOne","heartmonbeat",0.2)
            Citizen.Wait(1500)

            ableToGetUp = true
            exports['mythic_notify']:PersistentAlert('start', 'exitHospital', 'inform', 'Press [E] To Leave The Bed.')
        end
    end)
end