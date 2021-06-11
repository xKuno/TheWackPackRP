ESX                           = nil

local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local isVisible = false
local tabletObject = nil

local cops = 0
local tabletObject = nil
local firstHack = false
local secondHack = false

RegisterNetEvent('vulcan_townhall_rob:start')
AddEventHandler('vulcan_townhall_rob:start', function()
    local closestPlayer, dist = ESX.Game.GetClosestPlayer()
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "amb@world_human_seat_wall_tablet@female@base", "base", 3) then
            exports['mythic_notify']:SendAlert('inform', 'This is being hacked by someone else.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        else
            local ped = PlayerPedId()
            local cops = exports.esx_scoreboard:GetPlayerCounts().police
            local vehicle = IsPedSittingInAnyVehicle(ped)
            if not vehicle and cops >= Config.CopsRequired then
                TriggerServerEvent('vulcan_townhall_rob:itemCheck')
            elseif cops < Config.CopsRequired then
                exports['mythic_notify']:SendAlert('inform', 'There needs to be more police!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        elseif vehicle then
            exports['mythic_notify']:SendAlert('inform', 'You can\'t hack while in a vehicle!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        end
    end
end)

function mycb(success, timeremaining)
	if success then
        if not firstHack and not secondHack then
            TriggerEvent('mhacking:hide')
            TriggerEvent("mhacking:show")
            TriggerEvent("mhacking:start",2,30,mycb)
            local playerPed = PlayerPedId()
            firstHack = true
        elseif firstHack and not secondHack then
            TriggerEvent('mhacking:hide')
            TriggerEvent("mhacking:show")
            TriggerEvent("mhacking:start",2,30,mycb)
            local playerPed = PlayerPedId()
            secondHack = true
        elseif firstHack and secondHack then
            TriggerEvent('mhacking:hide')
            TriggerServerEvent('townhall:hotKeyOpen')
            local playerPed = PlayerPedId()
            DeleteEntity(tabletObject)
            ClearPedTasks(playerPed)
            tabletObject = nil
            firstHack = false 
            secondHack = false

            Citizen.Wait(Config.TimeUntilMDTIsClosed * 1000)
            TriggerEvent('townhall:closeMDT')
        end
    else
        TriggerServerEvent('vulcan_townhall_rob:removeItem')
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
        exports['mythic_notify']:SendAlert('inform', 'The system malfunctioned and electrocuted you injuring you slightly.', 2500, { ['background-color'] = '#2F5C73', ['color'] = '#ffffff' })
    end
end

RegisterNetEvent('vulcan_townhall_rob:Progbar')
AddEventHandler('vulcan_townhall_rob:Progbar', function(source)
    local playerPed = PlayerPedId()
    local cord = GetEntityCoords(PlayerPedId())
    local streetName,_ = GetStreetNameAtCoord(cord[1], cord[2], cord[3])
    local streetName = GetStreetNameFromHashKey(streetName)
    local zone = tostring(GetNameOfZone(cord[1], cord[2], cord[3]))
    local area = GetLabelText(zone)

    local dict = "amb@world_human_seat_wall_tablet@female@base"
    RequestAnimDict(dict)
    tabletObject = CreateObject(GetHashKey('prop_cs_tablet'), GetEntityCoords(playerPed), 1, 1, 1)
    AttachEntityToEntity(tabletObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
    while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
    if not IsEntityPlayingAnim(playerPed, dict, 'base', 3) then
    TaskPlayAnim(playerPed, dict, "base", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)

        TriggerEvent("mhacking:show")
        TriggerEvent("mhacking:start",2,30,mycb)
        Citizen.Wait(5000)
        exports['wp_dispatch']:addCall("10-90", "Federal Database Breach Alert", {
            {icon = "fas fa-road", info = streetName ..", ".. area}
        }, {cord[1], cord[2], cord[3]}, "police", 3000, 357, 1 )
        exports['wp_dispatch']:addCall("10-90", "Federal Database Breach Alert", {
            {icon = "fas fa-road", info = streetName ..", ".. area}
        }, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 357, 1 )
    end
end)

TriggerServerEvent("townhall:getOffensesAndOfficer")

RegisterNetEvent("townhall:sendNUIMessage")
AddEventHandler("townhall:sendNUIMessage", function(messageTable)
    SendNUIMessage(messageTable)
end)

RegisterNetEvent("townhall:toggleVisibilty")
AddEventHandler("townhall:toggleVisibilty", function(reports, warrants, bolos, officer)
    local playerPed = PlayerPedId()
    if not isVisible then
        local dict = "amb@world_human_seat_wall_tablet@female@base"
        RequestAnimDict(dict)
        if tabletObject == nil then
            tabletObject = CreateObject(GetHashKey('prop_cs_tablet'), GetEntityCoords(playerPed), 1, 1, 1)
            AttachEntityToEntity(tabletObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        end
        while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
        if not IsEntityPlayingAnim(playerPed, dict, 'base', 3) then
            TaskPlayAnim(playerPed, dict, "base", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
        end
    else
        DeleteEntity(tabletObject)
        ClearPedTasks(playerPed)
        tabletObject = nil
    end
    if #warrants == 0 then warrants = false end
    if #bolos == 0 then bolos = false end
    if #reports == 0 then reports = false end
    SendNUIMessage({
        type = "recentReportsAndWarrantsLoaded",
        reports = reports,
        warrants = warrants,
        bolos = bolos,
        officer = officer
    })
    ToggleGUI()
end)

RegisterCommand('closetownhallrob', function(source, args)
    local playerPed = PlayerPedId()
    DeleteEntity(tabletObject)
    ClearPedTasks(playerPed)
    tabletObject = nil
    ToggleGUI(false)
end)

RegisterNetEvent('townhall:closeMDT')
AddEventHandler('townhall:closeMDT', function()
    local playerPed = PlayerPedId()
    DeleteEntity(tabletObject)
    ClearPedTasks(playerPed)
    tabletObject = nil
    ToggleGUI(false)
end)

RegisterNUICallback("close", function(data, cb)
    local playerPed = PlayerPedId()
    DeleteEntity(tabletObject)
    ClearPedTasks(playerPed)
    tabletObject = nil
    ToggleGUI(false)
    cb('ok')
end)

RegisterNUICallback("performOffenderSearch", function(data, cb)
    TriggerServerEvent("townhall:performOffenderSearch", data.query)
    cb('ok')
end)

RegisterNUICallback("viewOffender", function(data, cb)
    TriggerServerEvent("townhall:getOffenderDetails", data.offender)
    cb('ok')
end)

RegisterNUICallback("saveOffenderChanges", function(data, cb)
    TriggerServerEvent("townhall:saveOffenderChanges", data.id, data.changes, data.identifier)
    cb('ok')
end)

RegisterNUICallback("submitNewReport", function(data, cb)
    TriggerServerEvent("townhall:submitNewReport", data)
    cb('ok')
end)

RegisterNUICallback("performReportSearch", function(data, cb)
    TriggerServerEvent("townhall:performReportSearch", data.query)
    cb('ok')
end)

RegisterNUICallback("getOffender", function(data, cb)
    TriggerServerEvent("townhall:getOffenderDetailsById", data.char_id)
    cb('ok')
end)

RegisterNUICallback("deleteReport", function(data, cb)
    TriggerServerEvent("townhall:deleteReport", data.id)
    cb('ok')
end)

RegisterNUICallback("saveReportChanges", function(data, cb)
    TriggerServerEvent("townhall:saveReportChanges", data)
    cb('ok')
end)

RegisterNUICallback("vehicleSearch", function(data, cb)
    TriggerServerEvent("townhall:performVehicleSearch", data.plate)
    cb('ok')
end)

RegisterNUICallback("getVehicle", function(data, cb)
    TriggerServerEvent("townhall:getVehicle", data.vehicle)
    cb('ok')
end)

RegisterNUICallback("getWarrants", function(data, cb)
    TriggerServerEvent("townhall:getWarrants")
    cb('ok')
end)

RegisterNUICallback("submitNewWarrant", function(data, cb)
    TriggerServerEvent("townhall:submitNewWarrant", data)
    cb('ok')
end)

RegisterNUICallback("deleteWarrant", function(data, cb)
    TriggerServerEvent("townhall:deleteWarrant", data.id)
    cb('ok')
end)

RegisterNUICallback("getBolos", function(data, cb)
    TriggerServerEvent("townhall:getBolos")
    cb('ok')
end)

RegisterNUICallback("submitNewBolo", function(data, cb)
    TriggerServerEvent("townhall:submitNewBolo", data)
    cb('ok')
end)

RegisterNUICallback("deleteBolo", function(data, cb)
    TriggerServerEvent("townhall:deleteBolo", data.id)
    cb('ok')
end)

RegisterNUICallback("getReport", function(data, cb)
    TriggerServerEvent("townhall:getReportDetailsById", data.id)
    cb('ok')
end)

RegisterNUICallback("sentencePlayer", function(data, cb)
    TriggerServerEvent("townhall:sentencePlayer", data.id, data.char_id, data.jailtime, data.charges, data.fine, data.zlist)
    cb('ok')
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
end)

RegisterNetEvent("townhall:returnOffenderSearchResults")
AddEventHandler("townhall:returnOffenderSearchResults", function(results)
    SendNUIMessage({
        type = "returnedPersonMatches",
        matches = results
    })
end)

RegisterNetEvent("townhall:returnOffenderDetails")
AddEventHandler("townhall:returnOffenderDetails", function(data)
    SendNUIMessage({
        type = "returnedOffenderDetails",
        details = data
    })
end)

RegisterNetEvent("townhall:returnOffensesAndOfficer")
AddEventHandler("townhall:returnOffensesAndOfficer", function(data, name)
    SendNUIMessage({
        type = "offensesAndOfficerLoaded",
        offenses = data,
        name = name
    })
end)

RegisterNetEvent("townhall:returnReportSearchResults")
AddEventHandler("townhall:returnReportSearchResults", function(results)
    SendNUIMessage({
        type = "returnedReportMatches",
        matches = results
    })
end)

RegisterNetEvent("townhall:returnVehicleSearchInFront")
AddEventHandler("townhall:returnVehicleSearchInFront", function(results, plate)
    SendNUIMessage({
        type = "returnedVehicleMatchesInFront",
        matches = results,
        plate = plate
    })
end)

RegisterNetEvent("townhall:returnVehicleSearchResults")
AddEventHandler("townhall:returnVehicleSearchResults", function(results)
    SendNUIMessage({
        type = "returnedVehicleMatches",
        matches = results
    })
end)

RegisterNetEvent("townhall:returnVehicleDetails")
AddEventHandler("townhall:returnVehicleDetails", function(data)
    data.model = GetLabelText(GetDisplayNameFromVehicleModel(data.model))
    SendNUIMessage({
        type = "returnedVehicleDetails",
        details = data
    })
end)

RegisterNetEvent("townhall:returnWarrants")
AddEventHandler("townhall:returnWarrants", function(data)
    SendNUIMessage({
        type = "returnedWarrants",
        warrants = data
    })
end)

RegisterNetEvent("townhall:returnBolos")
AddEventHandler("townhall:returnBolos", function(data)
    SendNUIMessage({
        type = "returnedBolos",
        bolos = data
    })
end)

RegisterNetEvent("townhall:completedWarrantAction")
AddEventHandler("townhall:completedWarrantAction", function(data)
    SendNUIMessage({
        type = "completedWarrantAction"
    })
end)

RegisterNetEvent("townhall:completedBoloAction")
AddEventHandler("townhall:completedBoloAction", function(data)
    SendNUIMessage({
        type = "completedBoloAction"
    })
end)

RegisterNetEvent("townhall:returnReportDetails")
AddEventHandler("townhall:returnReportDetails", function(data)
    SendNUIMessage({
        type = "returnedReportDetails",
        details = data
    })
end)

function ToggleGUI(explicit_status)
    if explicit_status ~= nil then
        isVisible = explicit_status
    else
        isVisible = not isVisible
    end

    SetNuiFocus(isVisible, isVisible)
    SendNUIMessage({
        type = "enable",
        isVisible = isVisible
    })
end