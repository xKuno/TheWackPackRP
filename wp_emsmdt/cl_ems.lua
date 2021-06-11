local isVisible = false
local tabletObject = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerVeh = GetVehiclePedIsIn(playerPed, false)
        if not isVisible and IsPedInAnyPoliceVehicle(playerPed) and IsControlJustPressed(0, 47) and GetEntitySpeed(playerVeh) < 10.0 then
                TriggerServerEvent("ems:performVehicleSearchInFront", GetVehicleNumberPlateText(getVehicleInFront()))
        --elseif IsControlJustPressed(0, 311) then
            --TriggerServerEvent("ems:hotKeyOpen")
        end
        if DoesEntityExist(playerPed) and IsPedUsingActionMode(playerPed) then -- disable action mode/combat stance when engaged in combat (thing which makes you run around like an idiot when shooting)
            SetPedUsingActionMode(playerPed, -1, -1, 1)
        end
    end
end)

TriggerServerEvent("ems:getOffensesAndOfficer")

RegisterNetEvent("ems:sendNUIMessage")
AddEventHandler("ems:sendNUIMessage", function(messageTable)
    SendNUIMessage(messageTable)
end)

RegisterNetEvent("ems:toggleVisibilty")
AddEventHandler("ems:toggleVisibilty", function(reports, warrants, bolos, officer)
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

RegisterCommand('closeemsmdt', function(source, args)
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
    TriggerServerEvent("ems:performOffenderSearch", data.query)
    cb('ok')
end)

RegisterNUICallback("viewOffender", function(data, cb)
    TriggerServerEvent("ems:getOffenderDetails", data.offender)
    cb('ok')
end)

RegisterNUICallback("saveOffenderChanges", function(data, cb)
    TriggerServerEvent("ems:saveOffenderChanges", data.id, data.changes, data.identifier)
    cb('ok')
end)

RegisterNUICallback("submitNewReport", function(data, cb)
    TriggerServerEvent("ems:submitNewReport", data)
    cb('ok')
end)

RegisterNUICallback("performReportSearch", function(data, cb)
    TriggerServerEvent("ems:performReportSearch", data.query)
    cb('ok')
end)

RegisterNUICallback("getOffender", function(data, cb)
    TriggerServerEvent("ems:getOffenderDetailsById", data.char_id)
    cb('ok')
end)

RegisterNUICallback("deleteReport", function(data, cb)
    TriggerServerEvent("ems:deleteReport", data.id)
    cb('ok')
end)

RegisterNUICallback("saveReportChanges", function(data, cb)
    TriggerServerEvent("ems:saveReportChanges", data)
    cb('ok')
end)

RegisterNUICallback("vehicleSearch", function(data, cb)
    TriggerServerEvent("ems:performVehicleSearch", data.plate)
    cb('ok')
end)

RegisterNUICallback("getVehicle", function(data, cb)
    TriggerServerEvent("ems:getVehicle", data.vehicle)
    cb('ok')
end)

RegisterNUICallback("getWarrants", function(data, cb)
    TriggerServerEvent("ems:getWarrants")
    cb('ok')
end)

RegisterNUICallback("submitNewWarrant", function(data, cb)
    TriggerServerEvent("ems:submitNewWarrant", data)
    cb('ok')
end)

RegisterNUICallback("deleteWarrant", function(data, cb)
    TriggerServerEvent("ems:deleteWarrant", data.id)
    cb('ok')
end)

RegisterNUICallback("getBolos", function(data, cb)
    TriggerServerEvent("ems:getBolos")
    cb('ok')
end)

RegisterNUICallback("submitNewBolo", function(data, cb)
    TriggerServerEvent("ems:submitNewBolo", data)
    cb('ok')
end)

RegisterNUICallback("deleteBolo", function(data, cb)
    TriggerServerEvent("ems:deleteBolo", data.id)
    cb('ok')
end)

RegisterNUICallback("getReport", function(data, cb)
    TriggerServerEvent("ems:getReportDetailsById", data.id)
    cb('ok')
end)

RegisterNUICallback("sentencePlayer", function(data, cb)
    TriggerServerEvent("ems:sentencePlayer", data.id, data.char_id, data.jailtime, data.charges, data.fine, data.zlist)
    cb('ok')
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
end)

RegisterNetEvent("ems:returnOffenderSearchResults")
AddEventHandler("ems:returnOffenderSearchResults", function(results)
    SendNUIMessage({
        type = "returnedPersonMatches",
        matches = results
    })
end)

RegisterNetEvent("ems:returnOffenderDetails")
AddEventHandler("ems:returnOffenderDetails", function(data)
    SendNUIMessage({
        type = "returnedOffenderDetails",
        details = data
    })
end)

RegisterNetEvent("ems:returnOffensesAndOfficer")
AddEventHandler("ems:returnOffensesAndOfficer", function(data, name)
    SendNUIMessage({
        type = "offensesAndOfficerLoaded",
        offenses = data,
        name = name
    })
end)

RegisterNetEvent("ems:returnReportSearchResults")
AddEventHandler("ems:returnReportSearchResults", function(results)
    SendNUIMessage({
        type = "returnedReportMatches",
        matches = results
    })
end)

RegisterNetEvent("ems:returnVehicleSearchInFront")
AddEventHandler("ems:returnVehicleSearchInFront", function(results, plate)
    SendNUIMessage({
        type = "returnedVehicleMatchesInFront",
        matches = results,
        plate = plate
    })
end)

RegisterNetEvent("ems:returnVehicleSearchResults")
AddEventHandler("ems:returnVehicleSearchResults", function(results)
    SendNUIMessage({
        type = "returnedVehicleMatches",
        matches = results
    })
end)

RegisterNetEvent("ems:returnVehicleDetails")
AddEventHandler("ems:returnVehicleDetails", function(data)
    data.model = GetLabelText(GetDisplayNameFromVehicleModel(data.model))
    SendNUIMessage({
        type = "returnedVehicleDetails",
        details = data
    })
end)

RegisterNetEvent("ems:returnWarrants")
AddEventHandler("ems:returnWarrants", function(data)
    SendNUIMessage({
        type = "returnedWarrants",
        warrants = data
    })
end)

RegisterNetEvent("ems:returnBolos")
AddEventHandler("ems:returnBolos", function(data)
    SendNUIMessage({
        type = "returnedBolos",
        bolos = data
    })
end)

RegisterNetEvent("ems:completedWarrantAction")
AddEventHandler("ems:completedWarrantAction", function(data)
    SendNUIMessage({
        type = "completedWarrantAction"
    })
end)

RegisterNetEvent("ems:completedBoloAction")
AddEventHandler("ems:completedBoloAction", function(data)
    SendNUIMessage({
        type = "completedBoloAction"
    })
end)

RegisterNetEvent("ems:returnReportDetails")
AddEventHandler("ems:returnReportDetails", function(data)
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

function getVehicleInFront()
    local playerPed = PlayerPedId()
    local coordA = GetEntityCoords(playerPed, 1)
    local coordB = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 10.0, 0.0)
    local targetVehicle = getVehicleInDirection(coordA, coordB)
    return targetVehicle
end

function getVehicleInDirection(coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, PlayerPedId(), 0)
    local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

RegisterNetEvent("tp:emsvehiclesearch")
AddEventHandler("tp:emsvehiclesearch", function()
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false)
    if not isVisible and IsPedInAnyPoliceVehicle(playerPed) and GetEntitySpeed(playerVeh) < 10.0 then
        if GetVehicleNumberPlateText(getVehicleInFront()) then
            TriggerServerEvent("ems:performVehicleSearchInFront", GetVehicleNumberPlateText(getVehicleInFront()))
        end
    elseif IsControlJustPressed(0, 311) then
        TriggerServerEvent("ems:hotKeyOpen")
    end
    if DoesEntityExist(playerPed) and IsPedUsingActionMode(playerPed) then -- disable action mode/combat stance when engaged in combat (thing which makes you run around like an idiot when shooting)
        SetPedUsingActionMode(playerPed, -1, -1, 1)
    end
end)
