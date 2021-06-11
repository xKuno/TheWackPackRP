ESX = nil
local hasShot = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/gsr', _U('help_gsr'), {{name = _U('help_gsr_value'), help = _U('help_gsr')}})
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        ped = PlayerPedId()
        if IsPedShooting(ped) then
            TriggerServerEvent('esx_gsr:SetGSR', timer)
            hasShot = true
            Citizen.Wait(Config.gsrUpdate)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(2000)
        if Config.waterClean and hasShot then
            ped = PlayerPedId()
            if IsEntityInWater(ped) then
                TriggerEvent('esx_gsr:Notify', _U('gsr_clean_wait'), "error")
                Citizen.Wait(Config.waterCleanTime)
                if IsEntityInWater(ped) then
                    hasShot = false
                    TriggerServerEvent('esx_gsr:Remove')
                    exports['mythic_notify']:SendAlert('inform', 'You have cleaned your gsr', 2500, { ['background-color'] = '#009c0d', ['color'] = '#ffffff' })
                else
                    exports['mythic_notify']:SendAlert('inform', 'You failed to clean your GSR.', 2500, { ['background-color'] = '#9c0000', ['color'] = '#ffffff' })
                end
            end
        end
    end
end)

function status()
    if hasShot then
        ESX.TriggerServerCallback('esx_gsr:Status', function(cb)
            if not cb then
                hasShot = false
            end
        end)
    end
    SetTimeout(Config.gsrUpdateStatus, status)
end

status()
