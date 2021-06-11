---------------------------NewsPaper----------------------------
---------------------Made by NuketheWhales7 --------------------
----------------------Development Roleplay----------------------
local display, toggleDisplay, paperon, param = false, true, true, ""

Citizen.CreateThread(function(); if Config.usingESX then; ESX = nil; PlayerData = {}; Citizen.CreateThread(function()
while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end); Citizen.Wait(0); end;
while ESX.GetPlayerData().job == nil do Citizen.Wait(10); end; PlayerData = ESX.GetPlayerData(); end);

Citizen.CreateThread(function() Citizen.Wait(10000); TriggerEvent("newspaper:off"); TriggerServerEvent("newspaper:update"); end)
else Citizen.CreateThread(function() Citizen.Wait(10000); TriggerEvent("newspaper:off"); TriggerServerEvent("newspaper:update"); end); end; end)

RegisterNetEvent("newspaper:openClient")
AddEventHandler("newspaper:openClient", function()
    if toggleDisplay then 
        TriggerEvent("newspaper:on")
        toggleDisplay = false
        paperon = true
    else 
        TriggerEvent("newspaper:off")
        toggleDisplay = true
        paperon = false
    end
end)

RegisterNetEvent("newspaper:off")
AddEventHandler("newspaper:off", function(value)
    SendNUIMessage({
        type = 'ui',
        display = false
    })
end)

RegisterNetEvent("newspaper:on")
AddEventHandler("newspaper:on", function(value)
    SendNUIMessage({
        type = 'ui',
        display = true
    })
end)

RegisterNetEvent("newspaper:headlineTitle1")
AddEventHandler("newspaper:headlineTitle1", function(param)
    SendNUIMessage({
        type = 'updateTitle1',
        headlineTitle1 = param
    })
end)

RegisterNetEvent("newspaper:headlineTitle2")
AddEventHandler("newspaper:headlineTitle2", function(param)
    SendNUIMessage({
        type = 'updateTitle2',
        headlineTitle2 = param
    })
end)

RegisterNetEvent("newspaper:headline1")
AddEventHandler("newspaper:headline1", function(param)
    SendNUIMessage({
        type = 'updateHeadline1',
        headline1 = param
    })
end)

RegisterNetEvent("newspaper:headline2")
AddEventHandler("newspaper:headline2", function(param)
    SendNUIMessage({
        type = 'updateHeadline2',
        headline2 = param
    })
end)

RegisterNetEvent("newspaper:arrest1")
AddEventHandler("newspaper:arrest1", function(param)
    SendNUIMessage({
        type = 'updateArrest1',
        arrest1 = param
    })
end)

RegisterNetEvent("newspaper:arrest2")
AddEventHandler("newspaper:arrest2", function(param)
    SendNUIMessage({
        type = 'updateArrest2',
        arrest2 = param
    })
end)

RegisterNetEvent("newspaper:arrest3")
AddEventHandler("newspaper:arrest3", function(param)
    SendNUIMessage({
        type = 'updateArrest3',
        arrest3 = param
    })
end)