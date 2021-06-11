
local ESX = nil

local markers = {

    ["Chop Shop 1"]={name="Chop Shop 1",
        chopping = false,
        marker = {-516.13, -1709.98, 18.34},
    },
    ["Chop Shop 2"]={name="Chop Shop 2",
        chopping = false,
        marker = {954.18, -1548.3, 29.76},
    },
    ["Chop Shop 3"]={name="Chop Shop 3",
        chopping = false,
        marker = {1651.44, 3806.13, 33.99},
    },
    ["Chop Shop 4"]={name="Chop Shop 4",
        chopping = false,
        marker = {1904.01,  4922.14, 48.82-1},
    },
    ["Chop Shop 5"]={name="Chop Shop 5",
        chopping = false,
        marker = {-441.08, 6341.47, 11.73},
    },
}
TriggerEvent('esx:getSharedObject', function(obj) while ESX == nil do ESX = obj end end)

local gi = 0
local location = false

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0, 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

local distance_until_text_disappears = 2

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for name,m in pairs(markers)do
            local coords = GetEntityCoords(PlayerPedId())
            if not m.chopping and Vdist(coords, m.marker[1], m.marker[2], m.marker[3]) < 10 then
                DrawMarker(27, m.marker[1], m.marker[2], m.marker[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 6.0, 1.0, 255, 255, 255, 100, false, true, 2, nil, nil, false)
            end
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local player = GetPlayerPed(PlayerId());
        local coords = GetEntityCoords(player)
        local veh = GetVehiclePedIsIn(player)

        local driver = GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()
        --Wait (1000)
        for name,m in pairs(markers)do
            if not m.chopping then
                if Vdist(coords,  m.marker[1], m.marker[2], m.marker[3]) < 5  and veh ~= 0 and driver then
                    ESX.ShowHelpNotification('Hit ~INPUT_CONTEXT~ to start chopping car')

                    if IsControlJustPressed (0, 51) then
                        m.chopping = true
                    end
                end
            end
            if m.chopping then
                if Vdist(coords, m.marker[1], m.marker[2], m.marker[3]) > 5  or not driver then
                    exports['mythic_notify']:SendAlert('inform', 'You got out of the car.', 2500, { ['background-color'] = '#0095ff', ['color'] = '#ffffff' })
                    m.chopping  = false
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local player = GetPlayerPed(PlayerId());
        local coords = GetEntityCoords(player)
        local veh = GetVehiclePedIsIn(player)

        local frontLeft = DoesVehicleHaveDoor(veh, 0)
        local frontRight = DoesVehicleHaveDoor(veh, 1)
        local backLeft = DoesVehicleHaveDoor(veh, 2)
        local backRight = DoesVehicleHaveDoor(veh, 3)
        local hood = DoesVehicleHaveDoor(veh, 4)
        local trunk = DoesVehicleHaveDoor(veh, 5)

        local numberDoors = GetNumberOfVehicleDoors(veh)
        local carBodyHP = GetVehicleBodyHealth(veh)
        local carEngineHP = GetVehicleEngineHealth(veh)
        local class = GetVehicleClass(veh)

        --[[
        0: Compacts  
        1: Sedans  
        2: SUVs  
        3: Coupes  
        4: Muscle  
        5: Sports Classics  
        6: Sports  
        7: Super  
        8: Motorcycles  
        9: Off-road 
        ]]

        for name,m in pairs(markers)do
            if m.chopping then
                SetVehicleNumberPlateText(veh, "CHOPSHOP")
                SetVehicleEngineOn(veh, false, false, true)
                SetVehicleUndriveable(veh, false)
                SetEntityMaxSpeed(veh, 0)
                local chopSpeed = 13800

                --Front Left
                if m.chopping and frontLeft then

                    TriggerEvent("mythic_progbar:client:progress", {
                    name = "fLeft",
                    duration = chopSpeed,
                    label = "Opening Front Left Door",
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    },
                    animation = {
                    animDict = "",
                    anim = "",
                    },
                    prop = {
                    model = "",
                    }
                })
                    Citizen.Wait(chopSpeed)
                    SetVehicleDoorOpen(veh, 0, false, false)

                    Citizen.Wait(500)
                end

                if m.chopping and frontLeft then
                    TriggerEvent("mythic_progbar:client:progress", {
                    name = "fLeftR",
                    duration = chopSpeed,
                    label = "Removing Front Left Door",
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    },
                    animation = {
                    animDict = "",
                    anim = "",
                    },
                    prop = {
                    model = "",
                    }
                })
                    Citizen.Wait(chopSpeed)
                    SetVehicleDoorBroken(veh, 0, true)

                    Citizen.Wait(500)
                end

                --Front Right
                if m.chopping and frontRight then
                    TriggerEvent("mythic_progbar:client:progress", {
                    name = "fRight",
                    duration = chopSpeed,
                    label = "Opening Front Right Door",
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    },
                    animation = {
                    animDict = "",
                    anim = "",
                    },
                    prop = {
                    model = "",
                    }
                })
                    Citizen.Wait(chopSpeed)
                    SetVehicleDoorOpen(veh, 1, false, false)

                    Citizen.Wait(500)
                end

                if m.chopping and frontRight then
                    TriggerEvent("mythic_progbar:client:progress", {
                    name = "fRightR",
                    duration = chopSpeed,
                    label = "Removing Front Right Door",
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    },
                    animation = {
                    animDict = "",
                    anim = "",
                    },
                    prop = {
                    model = "",
                    }
                })
                    Citizen.Wait(chopSpeed)
                    SetVehicleDoorBroken(veh, 1, true)

                    Citizen.Wait(500)
                end

                --Back Left
                if m.chopping and backLeft then
                    TriggerEvent("mythic_progbar:client:progress", {
                    name = "bLeft",
                    duration = chopSpeed,
                    label = "Opening Back Left Door",
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    },
                    animation = {
                    animDict = "",
                    anim = "",
                    },
                    prop = {
                    model = "",
                    }
                })
                    Citizen.Wait(chopSpeed)
                    SetVehicleDoorOpen(veh, 2, false, false)

                    Citizen.Wait(500)
                end

                if m.chopping and backLeft then
                    TriggerEvent("mythic_progbar:client:progress", {
                    name = "bLeftR",
                    duration = chopSpeed,
                    label = "Removing Back Left Door",
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    },
                    animation = {
                    animDict = "",
                    anim = "",
                    },
                    prop = {
                    model = "",
                    }
                })
                    Citizen.Wait(chopSpeed)
                    SetVehicleDoorBroken(veh, 2, true)

                    Citizen.Wait(500)
                end

                --Back Right
                if m.chopping and backRight then
                    TriggerEvent("mythic_progbar:client:progress", {
                    name = "bRight",
                    duration = chopSpeed,
                    label = "Opening Back Right Door",
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    },
                    animation = {
                    animDict = "",
                    anim = "",
                    },
                    prop = {
                    model = "",
                    }
                })
                    Citizen.Wait(chopSpeed)
                    SetVehicleDoorOpen(veh, 3, false, false)

                    Citizen.Wait(500)
                end

                if m.chopping and backRight then
                    TriggerEvent("mythic_progbar:client:progress", {
                    name = "bRightR",
                    duration = chopSpeed,
                    label = "Removing Back Right Door",
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    },
                    animation = {
                    animDict = "",
                    anim = "",
                    },
                    prop = {
                    model = "",
                    }
                })
                    Citizen.Wait(chopSpeed)
                    SetVehicleDoorBroken(veh, 3, true)

                    Citizen.Wait(500)
                end

                --Hood
                if m.chopping and hood then
                    TriggerEvent("mythic_progbar:client:progress", {
                    name = "pHood",
                    duration = chopSpeed,
                    label = "Popping the Hood",
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    },
                    animation = {
                    animDict = "",
                    anim = "",
                    },
                    prop = {
                    model = "",
                    }
                })
                    Citizen.Wait(chopSpeed)
                    SetVehicleDoorOpen(veh, 4, false, false)

                    Citizen.Wait(500)
                end

                if m.chopping and hood then
                    TriggerEvent("mythic_progbar:client:progress", {
                    name = "pHoodR",
                    duration = chopSpeed,
                    label = "Removing the Hood",
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    },
                    animation = {
                    animDict = "",
                    anim = "",
                    },
                    prop = {
                    model = "",
                    }
                })
                    Citizen.Wait(chopSpeed)
                    SetVehicleDoorBroken(veh, 4, true)

                    Citizen.Wait(500)
                end

                --Trunk
                if m.chopping and trunk then
                    TriggerEvent("mythic_progbar:client:progress", {
                    name = "pTrunk",
                    duration = chopSpeed,
                    label = "Popping the Trunk",
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    },
                    animation = {
                    animDict = "",
                    anim = "",
                    },
                    prop = {
                    model = "",
                    }
                })
                    Citizen.Wait(chopSpeed)
                    SetVehicleDoorOpen(veh, 5, false, false)

                    Citizen.Wait(500)
                end

                if m.chopping and trunk then
                    --exports['progressBars']:startUI(chopSpeed, "Removing Trunk Door")
                    TriggerEvent("mythic_progbar:client:progress", {
                    name = "pTrunkR",
                    duration = chopSpeed,
                    label = "Removing the Trunk",
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                    },
                    animation = {
                    animDict = "",
                    anim = "",
                    },
                    prop = {
                    model = "",
                    }
                })
                    Citizen.Wait(chopSpeed)
                    SetVehicleDoorBroken(veh, 5, true)

                    Citizen.Wait(500)
                end



                if m.chopping then

                    local health = math.floor((carBodyHP + carEngineHP) / 20)
                    local doorParts = 7 - numberDoors
                    local parts = math.ceil(health / 20)
                    parts = math.ceil(parts / doorParts)

                    TriggerServerEvent("car:chop_shop", parts, class)
                    SetEntityAsMissionEntity(veh, true, true)
                    DeleteVehicle(veh)
                    -- exports['progressBars']:startUI(chopSpeed, "Deleting Vehicle If Allowed")

                    exports['mythic_notify']:SendAlert('inform', 'Vehicle chopped successfully!', 2500, { ['background-color'] = '#0095ff', ['color'] = '#ffffff' })
                    m.chopping = false
                    --Citizen.Wait(180000)
                end
            end
        end
    end
end)