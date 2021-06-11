local ESX = nil
local FrontDoorW = { ['x'] = 746.822,['y'] = -1399.398,['z'] = 26.56702,['h'] = 219, ['info'] = 'Enter' }
local BackDoorE = { ['x'] = 992.5846,['y'] = -3097.754,['z'] = -39.01245,['h'] = 219, ['info'] = 'Exit'}
local DropOff = { ['x'] = 994.5231,['y'] = -3108.949,['z'] = -39.01245,['h'] = 219, ['info'] = 'DropOff'}
local Boxes = {
    [1] = {x = 1003.688, y = -3108.607, z = -39.01245, isSearched = false},
    [2] = {x = 1006.22, y = -3108.594, z = -39.01245, isSearched = false},
    [3] = {x = 1008.593, y = -3108.528, z = -39.01245, isSearched = false},
    [4] = {x = 1011.073, y = -3108.673, z = -39.01245, isSearched = false},
    [5] = {x = 1013.407, y = -3091.45, z = -39.01245, isSearched = false},
    [6] = {x = 1015.793, y = -3091.424, z = -39.01245, isSearched = false},
    [7] = {x = 1018.088, y = -3091.622, z = -39.01245, isSearched = false},
    [8] = {x = 1026.891, y = -3091.345, z = -39.01245, isSearched = false},
    [9] = {x = 1015.688, y = -3102.541, z = -39.01245, isSearched = false},
    [10] = {x = 1010.954, y = -3103.121, z = -39.01245, isSearched = false},
}
local hasBox = false
local box = nil
local objProp = "prop_cs_cardbox_01"
local ped = nil


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000)
        ped = PlayerPedId()
    end
end)

--- 3D text

Citizen.CreateThread(function()

    while true do

	    Citizen.Wait(1)
        if isOpen() then
            local DoorSpot = #(GetEntityCoords(ped) - vector3(FrontDoorW["x"],FrontDoorW["y"],FrontDoorW["z"]))
            if DoorSpot < 1.6 then
            
                DrawText3Ds(FrontDoorW["x"],FrontDoorW["y"],FrontDoorW["z"], "~w~Press ~g~[E]~s~ To ~g~Enter Warehouse~s~") 
                if IsControlJustReleased(0,38) then
                    TriggerEvent("mythic_progbar:client:progress", {
                        name = "DoorOpen",
                        duration = 2500,
                        label = "Opening Door",
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        },
                        animation = {
                            animDict = "mp_common",
                            anim = "givetake2_a",
                        },
                    }, function(status)
                        if not status then
                            DoScreenFadeOut(1)
                            CreateObject("v_ind_cf_meatbox", 1003.688, -3108.607, -40.2, true, 0, false)
                            CreateObject("v_ind_cf_meatbox", 1006.22,  -3108.594, -40.2, true, 0, false)
                            CreateObject("v_ind_cf_meatbox", 1008.593, -3108.528, -40.2, true, 0, false)
                            CreateObject("v_ind_cf_meatbox", 1011.073, -3108.673, -40.2, true, 0, false)
                            CreateObject("v_ind_cf_meatbox", 1013.407, -3091.45,  -40.2, true, 0, false)
                            CreateObject("v_ind_cf_meatbox", 1015.793, -3091.424, -40.2, true, 0, false)
                            CreateObject("v_ind_cf_meatbox", 1018.088, -3091.622, -40.2, true, 0, false)
                            CreateObject("v_ind_cf_meatbox", 1026.891, -3091.345, -40.2, true, 0, false)
                            CreateObject("v_ind_cf_meatbox", 1015.688, -3102.541, -40.2, true, 0, false)
                            CreateObject("v_ind_cf_meatbox", 1010.954, -3103.121, -40.2, true, 0, false)
                            SetEntityCoords(ped, 992.4923, -3097.675, -39.01245)
                            Citizen.Wait(2000)
                            DoScreenFadeIn(1)
                        end
                    end)
                end
            end
        end
    end

end)

Citizen.CreateThread(function()

    while true do

	    Citizen.Wait(1)
	    local Drop = #(GetEntityCoords(ped) - vector3(DropOff["x"],DropOff["y"],DropOff["z"]))
        if Drop < 1.6 then
            if hasBox then
                
                DrawText3Ds(DropOff["x"],DropOff["y"],DropOff["z"], "~w~Press ~g~[E]~s~ To ~g~Drop Boxes~s~") 
                if IsControlJustReleased(0,38) then
                    TriggerEvent("mythic_progbar:client:progress", {
                        name = "DropBox",
                        duration = 2500,
                        label = "Dropping Box",
                        useWhileDead = false,
                        canCancel = false,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        },
                        animation = {
                            animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                            anim = "machinic_loop_mechandplayer",
                        },
                    }, function(status)
                        if not status then
                            TriggerServerEvent("Ahouse:StartServerTimer")
                            TriggerServerEvent("Ahouse:reward")
                            hasBox = false
                            StopAnimTask(ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)

                            DeleteObject(box)
                            StopAnimTask(ped, "anim@heists@box_carry@", "idle", 1.0)
                        end
                    end)
                end
            end
        end
    end

end)

Citizen.CreateThread(function()

    while true do

	    Citizen.Wait(1)
	    local ExitSpot = #(GetEntityCoords(ped) - vector3(BackDoorE["x"],BackDoorE["y"],BackDoorE["z"]))
        if ExitSpot < 1.6 then

            DrawText3Ds(BackDoorE["x"],BackDoorE["y"],BackDoorE["z"], "~w~Press ~g~[E]~s~ To ~g~Exit Warehouse~s~") 
            if IsControlJustReleased(0,38) then
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "DoorClose",
                    duration = 2500,
                    label = "Opening Door",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                    animation = {
                        animDict = "mp_common",
                        anim = "givetake2_a",
                    },
                }, function(status)
                    if not status then
                        DoScreenFadeOut(1)
                        SetEntityCoords(ped, 746.822, -1399.398, 26.56702)
                        Citizen.Wait(2000)
                        DoScreenFadeIn(1)
                    end
                end)
            end
        end
    end

end)

function isOpen()
    local hour = GetClockHours()
    if hour >= 12 then
     return true
    end
   end

RegisterNetEvent("Ahouse:TotalReset")
AddEventHandler("Ahouse:TotalReset", function(Boxesid, status)
    Boxes[Boxesid].isSearched = status
end)

RegisterNetEvent("Ahouse:BoxHit")
AddEventHandler("Ahouse:BoxHit", function(Boxesid, status)
    Boxes[Boxesid].isSearched = status
end)

Citizen.CreateThread(function()
    CanBoxes = Boxes

    while true do
        
        Citizen.Wait(1)
        local coords = GetEntityCoords(ped)
        if isOpen() and not hasBox then
            for i=1,#CanBoxes do
                if (GetDistanceBetweenCoords(CanBoxes[i]["x"],CanBoxes[i]["y"],CanBoxes[i]["z"], GetEntityCoords(PlayerPedId())) < 1.4) and not CanBoxes[i]['isSearched'] then 
                    DrawText3Ds(CanBoxes[i]["x"],CanBoxes[i]["y"],CanBoxes[i]["z"], "~w~Press ~g~[E]~s~ To ~y~Pick Up Box~s~")                         
                    if IsControlJustReleased(0,38) then
                        TriggerEvent("mythic_progbar:client:progress", {
                            name = "SM4SHER",
                            duration = 3000,
                            label = "Picking Up Box",
                            useWhileDead = false,
                            canCancel = false,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            animation = {
                                animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                                anim = "machinic_loop_mechandplayer",
                            },
                        }, function(status)
                            if not status then
                                TriggerServerEvent("Ahouse:BoxUpdate", i)
                                StopAnimTask(ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                                exports['mythic_notify']:SendAlert('inform', 'You picked up a box.', 2500)
                                hasBox = true

                                LoadModel(objProp)
                                box = CreateObject(GetHashKey(objProp), coords.x, coords.y, coords.z, true, true, true)
                                AttachEntityToEntity(box, ped, GetPedBoneIndex(ped,  28422), 0.0, -0.03, 0.0, 5.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
                                LoadAnim("anim@heists@box_carry@")
                                TaskPlayAnim(ped, "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
                            end
                        end)
                        Citizen.Wait(2000)
                    end
                end
            end
        end

    end

end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function LoadAnim(animDict)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(10)
	end
end

function LoadModel(model)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(10)
	end
end