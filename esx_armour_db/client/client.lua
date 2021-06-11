local citizen = false

RegisterNetEvent('LRP-Armour:Client:SetPlayerArmour')
AddEventHandler('LRP-Armour:Client:SetPlayerArmour', function(armour)
    Citizen.Wait(15000)  -- Give ESX time to load their stuff. Because some how ESX remove the armour when load the ped.
    SetPedArmour(PlayerPedId(), tonumber(armour))
    citizen = true
end)

local TimeFreshCurrentArmour = 30000  -- 30 seconds

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if citizen == true then
            TriggerServerEvent('LRP-Armour:Server:RefreshCurrentArmour', GetPedArmour(PlayerPedId()))
            Citizen.Wait(TimeFreshCurrentArmour)
        end
    end
end)
