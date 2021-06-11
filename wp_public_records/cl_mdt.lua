local isVisible = false
local tabletObject = nil

local Keys = {
    ["E"] = 38
}

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
                if dst < 20 then
                    DrawText3D(v.coords[1], v.coords[2], v.coords[3] - 0.8, Config.Text["view_record"])
                end
                if dst < 2 then
                    if IsControlJustReleased(0, Keys["E"]) then
                        TriggerServerEvent('records:hotKeyOpen')
                    end
                end
            end
        end
    end
)

TriggerServerEvent("records:getOffensesAndOfficer")

RegisterNetEvent("records:sendNUIMessage")
AddEventHandler("records:sendNUIMessage", function(messageTable)
    SendNUIMessage(messageTable)
end)

RegisterNetEvent("records:toggleVisibilty")
AddEventHandler("records:toggleVisibilty", function(reports, warrants, bolos, officer)
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

RegisterCommand('closerecords', function(source, args)
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
    TriggerServerEvent("records:performOffenderSearch", data.query)
    cb('ok')
end)

RegisterNUICallback("viewOffender", function(data, cb)
    TriggerServerEvent("records:getOffenderDetails", data.offender)
    cb('ok')
end)

RegisterNUICallback("saveOffenderChanges", function(data, cb)
    TriggerServerEvent("records:saveOffenderChanges", data.id, data.changes, data.identifier)
    cb('ok')
end)

RegisterNUICallback("submitNewReport", function(data, cb)
    TriggerServerEvent("records:submitNewReport", data)
    cb('ok')
end)

RegisterNUICallback("performReportSearch", function(data, cb)
    TriggerServerEvent("records:performReportSearch", data.query)
    cb('ok')
end)

RegisterNUICallback("getOffender", function(data, cb)
    TriggerServerEvent("records:getOffenderDetailsById", data.char_id)
    cb('ok')
end)

RegisterNUICallback("deleteReport", function(data, cb)
    TriggerServerEvent("records:deleteReport", data.id)
    cb('ok')
end)

RegisterNUICallback("saveReportChanges", function(data, cb)
    TriggerServerEvent("records:saveReportChanges", data)
    cb('ok')
end)

RegisterNUICallback("vehicleSearch", function(data, cb)
    TriggerServerEvent("records:performVehicleSearch", data.plate)
    cb('ok')
end)

RegisterNUICallback("getVehicle", function(data, cb)
    TriggerServerEvent("records:getVehicle", data.vehicle)
    cb('ok')
end)

RegisterNUICallback("getWarrants", function(data, cb)
    TriggerServerEvent("records:getWarrants")
    cb('ok')
end)

RegisterNUICallback("submitNewWarrant", function(data, cb)
    TriggerServerEvent("records:submitNewWarrant", data)
    cb('ok')
end)

RegisterNUICallback("deleteWarrant", function(data, cb)
    TriggerServerEvent("records:deleteWarrant", data.id)
    cb('ok')
end)

RegisterNUICallback("getBolos", function(data, cb)
    TriggerServerEvent("records:getBolos")
    cb('ok')
end)

RegisterNUICallback("submitNewBolo", function(data, cb)
    TriggerServerEvent("records:submitNewBolo", data)
    cb('ok')
end)

RegisterNUICallback("deleteBolo", function(data, cb)
    TriggerServerEvent("records:deleteBolo", data.id)
    cb('ok')
end)

RegisterNUICallback("getReport", function(data, cb)
    TriggerServerEvent("records:getReportDetailsById", data.id)
    cb('ok')
end)

RegisterNUICallback("sentencePlayer", function(data, cb)
    TriggerServerEvent("records:sentencePlayer", data.id, data.char_id, data.jailtime, data.charges, data.fine, data.zlist)
    cb('ok')
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
end)

RegisterNetEvent("records:returnOffenderSearchResults")
AddEventHandler("records:returnOffenderSearchResults", function(results)
    SendNUIMessage({
        type = "returnedPersonMatches",
        matches = results
    })
end)

RegisterNetEvent("records:returnOffenderDetails")
AddEventHandler("records:returnOffenderDetails", function(data)
    SendNUIMessage({
        type = "returnedOffenderDetails",
        details = data
    })
end)

RegisterNetEvent("records:returnOffensesAndOfficer")
AddEventHandler("records:returnOffensesAndOfficer", function(data, name)
    SendNUIMessage({
        type = "offensesAndOfficerLoaded",
        offenses = data,
        name = name
    })
end)

RegisterNetEvent("records:returnReportSearchResults")
AddEventHandler("records:returnReportSearchResults", function(results)
    SendNUIMessage({
        type = "returnedReportMatches",
        matches = results
    })
end)

RegisterNetEvent("records:returnVehicleSearchInFront")
AddEventHandler("records:returnVehicleSearchInFront", function(results, plate)
    SendNUIMessage({
        type = "returnedVehicleMatchesInFront",
        matches = results,
        plate = plate
    })
end)

RegisterNetEvent("records:returnVehicleSearchResults")
AddEventHandler("records:returnVehicleSearchResults", function(results)
    SendNUIMessage({
        type = "returnedVehicleMatches",
        matches = results
    })
end)

RegisterNetEvent("records:returnVehicleDetails")
AddEventHandler("records:returnVehicleDetails", function(data)
    data.model = GetLabelText(GetDisplayNameFromVehicleModel(data.model))
    SendNUIMessage({
        type = "returnedVehicleDetails",
        details = data
    })
end)

RegisterNetEvent("records:returnWarrants")
AddEventHandler("records:returnWarrants", function(data)
    SendNUIMessage({
        type = "returnedWarrants",
        warrants = data
    })
end)

RegisterNetEvent("records:returnBolos")
AddEventHandler("records:returnBolos", function(data)
    SendNUIMessage({
        type = "returnedBolos",
        bolos = data
    })
end)

RegisterNetEvent("records:completedWarrantAction")
AddEventHandler("records:completedWarrantAction", function(data)
    SendNUIMessage({
        type = "completedWarrantAction"
    })
end)

RegisterNetEvent("records:completedBoloAction")
AddEventHandler("records:completedBoloAction", function(data)
    SendNUIMessage({
        type = "completedBoloAction"
    })
end)

RegisterNetEvent("records:returnReportDetails")
AddEventHandler("records:returnReportDetails", function(data)
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

RegisterNetEvent("tp:mdtvehiclesearch")
AddEventHandler("tp:mdtvehiclesearch", function()
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false)
    if not isVisible and IsPedInAnyPoliceVehicle(playerPed) and GetEntitySpeed(playerVeh) < 10.0 then
        if GetVehicleNumberPlateText(getVehicleInFront()) then
            TriggerServerEvent("records:performVehicleSearchInFront", GetVehicleNumberPlateText(getVehicleInFront()))
        end
    elseif IsControlJustPressed(0, 311) then
        TriggerServerEvent("records:hotKeyOpen")
    end
    if DoesEntityExist(playerPed) and IsPedUsingActionMode(playerPed) then -- disable action mode/combat stance when engaged in combat (thing which makes you run around like an idiot when shooting)
        SetPedUsingActionMode(playerPed, -1, -1, 1)
    end
end)
