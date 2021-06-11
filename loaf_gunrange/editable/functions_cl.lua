Loaded = false
ESX = nil
Job = 'unemployed'

CreateThread(function()
    
    while ESX == nil do 
        TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end)
        Wait(0) 
    end

    while ESX['GetPlayerData']()['job'] == nil do 
        Wait(0) 
    end

    Loaded = true

    while true do
        Job = ESX['GetPlayerData']()['job']['name']
        Wait(5000)
    end
end)

Notify = function(msg)
    ESX['ShowNotification'](msg)
end

AddBlip = function(coords, sprite, colour, label)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)

    return blip
end

HelpText = function(msg)
    AddTextEntry(GetCurrentResourceName(), msg)
    DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
end

IsSomeoneNearby = function(pos, dist)
    for k, v in pairs(GetActivePlayers()) do
        if GetPlayerPed(v) ~= PlayerPedId() then
            local coords = GetEntityCoords(GetPlayerPed(v))
            if #(pos - coords) <= dist then return true end
        end
    end
    return false
end

LoadModel = function(model)
    while not HasModelLoaded(model) do Wait(0) RequestModel(model) end
    return model
end

LoadDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
    return dict
end