local Models = {}
local Zones = {}

Citizen.CreateThread(function()
    RegisterKeyMapping("+playerTarget", "Player Targeting", "keyboard", "LMENU") --Removed Bind System and added standalone version
    RegisterCommand('+playerTarget', playerTargetEnable, false)
    RegisterCommand('-playerTarget', playerTargetDisable, false)
    TriggerEvent("chat:removeSuggestion", "/+playerTarget")
    TriggerEvent("chat:removeSuggestion", "/-playerTarget")
end)

if Config.ESX then
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end

        PlayerJob = ESX.GetPlayerData().job

        RegisterNetEvent('esx:setJob')
		AddEventHandler('esx:setJob', function(job)
		    PlayerJob = job
		end)
    end)
else
    PlayerJob = Config.NonEsxJob()
end

function playerTargetEnable()
    if success then return end

    targetActive = true

    SendNUIMessage({response = "openTarget"})

    while targetActive do
        local plyCoords = GetEntityCoords(PlayerPedId())
        local hit, coords, entity = RayCastGamePlayCamera(20.0)

        if hit == 1 then
            if GetEntityType(entity) ~= 0 then
                for _, model in pairs(Models) do
                    if _ == GetEntityModel(entity) then
                        for k , v in ipairs(Models[_]["job"]) do 
                            if v == "all" or v == PlayerJob.name then
                                if _ == GetEntityModel(entity) then
                                    if #(plyCoords - coords) <= Models[_]["distance"] then

                                        success = true

                                        SendNUIMessage({response = "validTarget", data = Models[_]["options"]})

                                        while success and targetActive do
                                            local plyCoords = GetEntityCoords(PlayerPedId())
                                            local hit, coords, entity = RayCastGamePlayCamera(20.0)

                                            DisablePlayerFiring(PlayerPedId(), true)

                                            if (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24)) then
                                                SetNuiFocus(true, true)
                                                SetCursorLocation(0.5, 0.5)
                                            end

                                            if GetEntityType(entity) == 0 or #(plyCoords - coords) > Models[_]["distance"] then
                                                success = false
                                            end

                                            Citizen.Wait(1)
                                        end
                                        SendNUIMessage({response = "leftTarget"})
                                    end
                                end
                            end
                        end
                    end
                end
            end

            for _, zone in pairs(Zones) do
                if Zones[_]:isPointInside(coords) then
                    for k , v in ipairs(Zones[_]["targetoptions"]["job"]) do 
                        if v == "all" or v == PlayerJob.name then
                            if #(plyCoords - Zones[_].center) <= zone["targetoptions"]["distance"] then

                                success = true

                                SendNUIMessage({response = "validTarget", data = Zones[_]["targetoptions"]["options"]})
                                while success and targetActive do
                                    local plyCoords = GetEntityCoords(PlayerPedId())
                                    local hit, coords, entity = RayCastGamePlayCamera(20.0)

                                    DisablePlayerFiring(PlayerPedId(), true)

                                    if (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24)) then
                                        SetNuiFocus(true, true)
                                        SetCursorLocation(0.5, 0.5)
                                    elseif not Zones[_]:isPointInside(coords) or #(vector3(Zones[_].center.x, Zones[_].center.y, Zones[_].center.z) - plyCoords) > zone.targetoptions.distance then
                                    end
        
                                    if not Zones[_]:isPointInside(coords) or #(plyCoords - Zones[_].center) > zone.targetoptions.distance then
                                        success = false
                                    end
        

                                    Citizen.Wait(1)
                                end
                                SendNUIMessage({response = "leftTarget"})
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(250)
    end
end

function playerTargetDisable()
    if success then return end

    targetActive = false

    SendNUIMessage({response = "closeTarget"})
end

--NUI CALL BACKS

RegisterNUICallback('selectTarget', function(data, cb)
    SetNuiFocus(false, false)

    success = false

    targetActive = false

    TriggerEvent(data.event)
end)

RegisterNUICallback('closeTarget', function(data, cb)
    SetNuiFocus(false, false)

    success = false

    targetActive = false
end)

--Functions from https://forum.cfx.re/t/get-camera-coordinates/183555/14

function RotationToDirection(rotation)
    local adjustedRotation =
    {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction =
    {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)
    local destination =
    {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
    return b, c, e
end

--Exports

function AddCircleZone(name, center, radius, options, targetoptions)
    Zones[name] = CircleZone:Create(center, radius, options)
    Zones[name].targetoptions = targetoptions
end

function AddBoxZone(name, center, length, width, options, targetoptions)
    Zones[name] = BoxZone:Create(center, length, width, options)
    Zones[name].targetoptions = targetoptions
end

function AddPolyzone(name, points, options, targetoptions)
    Zones[name] = PolyZone:Create(points, options)
    Zones[name].targetoptions = targetoptions
end

function AddTargetModel(models, parameteres)
    for _, model in pairs(models) do
        Models[model] = parameteres
    end
end

function AddEntityZone(name, entity, options, targetoptions)
    Zones[name] = EntityZone:Create(entity, options)
    Zones[name].targetoptions = targetoptions
end

exports("AddCircleZone", AddCircleZone)

exports("AddBoxZone", AddBoxZone)

exports("AddPolyzone", AddPolyzone)

exports("AddTargetModel", AddTargetModel)

Citizen.CreateThread(function()
	AddBoxZone("PoliceDuty", vector3(441.79, -982.07, 30.69), 0.4, 0.6, {
		name="PoliceDuty",
		heading=91,
		debugPoly=false,
		minZ=30.79,
		maxZ=30.99
    }, {
        options = {
            {
                event = "police:duty",
                icon = "far fa-clipboard",
                label = "Police Sign On",
            },
            {
                event = "offpolice:duty",
                icon = "far fa-clipboard",
                label = "Sign Off-Police",
            },
            {
                event = "offpolice:duty2",
                icon = "far fa-clipboard",
                label = "Sign Off-Duty",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    AddBoxZone("PoliceDutyVespucci", vector3(-1087.15, -814.19, 20.54), 0.4, 0.6, {
		name="PoliceDutyVespucci",
		heading=108.05,
		debugPoly=false,
		minZ=19.50,
		maxZ=19.70
    }, {
        options = {
            {
                event = "police:duty",
                icon = "far fa-clipboard",
                label = "Police Sign On",
            },
            {
                event = "offpolice:duty",
                icon = "far fa-clipboard",
                label = "Sign Off-Police",
            },
            {
                event = "offpolice:duty2",
                icon = "far fa-clipboard",
                label = "Sign Off-Duty",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    AddBoxZone("PoliceDutySandyPD", vector3(1853.85, 3689.93, 34.27), 0.25, 0.35, {
        name="PoliceDutySandyPD",
        heading=350,
        debugPoly=false,
        minZ=34.07,
        maxZ=34.12
    }, {
        options = {
            {
                event = "police:duty",
                icon = "far fa-clipboard",
                label = "Police Sign On",
            },
            {
                event = "offpolice:duty",
                icon = "far fa-clipboard",
                label = "Sign Off-Police",
            },
            {
                event = "offpolice:duty2",
                icon = "far fa-clipboard",
                label = "Sign Off-Duty",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    AddBoxZone("PoliceDutyPaletoPD", vector3(-449.46, 6013.22, 31.52), 0.4, 0.35, {
        name="PoliceDutyPaletoPD",
        heading=350,
        debugPoly=false,
        minZ=31.45,
        maxZ=31.60
    }, {
        options = {
            {
                event = "police:duty",
                icon = "far fa-clipboard",
                label = "Police Sign On",
            },
            {
                event = "offpolice:duty",
                icon = "far fa-clipboard",
                label = "Sign Off-Police",
            },
            {
                event = "offpolice:duty2",
                icon = "far fa-clipboard",
                label = "Sign Off-Duty",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    AddBoxZone("RangerDuty", vector3(382.84, 797.98, 187.39), 0.4, 0.5, {
        name = "RangerDuty",
        heading = 29.77,
        debugPoly = false,
        minZ = 187.2,
        maxZ = 188.2
    }, {
        options = {
            {
                event = "police:duty",
                icon = "far fa-clipboard",
                label = "Police Sign On",
            },
            {
                event = "offpolice:duty",
                icon = "far fa-clipboard",
                label = "Sign Off-Police",
            },
            {
                event = "offpolice:duty2",
                icon = "far fa-clipboard",
                label = "Sign Off-Duty",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    AddBoxZone("PBDuty", vector3(307.0979, -597.1328, 43.70432), 0.4, 0.9, {
        name = "PBDuty",
        heading = 340,
        debugPoly = false,
        minZ = 43.0,
        maxZ = 44.0
    }, {
        options = {
            {
                event = "ems:duty",
                icon = "far fa-clipboard",
                label = "Sign On",
            },
            {
                event = "offems:duty",
                icon = "far fa-clipboard",
                label = "Sign Off-EMS",
            },
            {
                event = "offpolice:duty2",
                icon = "far fa-clipboard",
                label = "Sign Off-Duty",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    AddBoxZone("VRDuty", vector3(-817.88, -1238.88, 7.75), 0.4, 0.9, {
        name = "VRDuty",
        heading = 319.6,
        debugPoly = false,
        minZ = 7.0,
        maxZ = 8.0
    }, {
        options = {
            {
                event = "ems:duty",
                icon = "far fa-clipboard",
                label = "Sign On",
            },
            {
                event = "offems:duty",
                icon = "far fa-clipboard",
                label = "Sign Off-EMS",
            },
            {
                event = "offpolice:duty2",
                icon = "far fa-clipboard",
                label = "Sign Off-Duty",
            },
        },
        job = {"all"},
        distance = 2.0
    })

        local dojped = {
            `a_f_m_bevhills_02`,
        }
        AddTargetModel(dojped, {
            options = {
                {
                    event = "state:duty",
                    icon = "far fa-clipboard",
                    label = "Sign On",
                },
                {
                    event = "offdoj:duty",
                    icon = "far fa-clipboard",
                    label = "Sign Off",
                },
            },
            job = {"all"},
            distance = 2.0
    })

    AddBoxZone("DOTDuty", vector3(-192.42, -1162.24, 23.49), 0.4, 1.5, {
		name="DOTDuty",
		heading=91,
		debugPoly=false,
		minZ=23.40,
		maxZ=23.60
    }, {
        options = {
            {
                event = "dot:duty",
                icon = "far fa-clipboard",
                label = "Sign On",
            },
            {
                event = "offdot:duty",
                icon = "far fa-clipboard",
                label = "Sign Off",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    AddBoxZone("WNDuty", vector3(-598.0, -929.86, 23.87), 0.4, 6, {
        name = "WNDuty",
        heading = 90.71,
        debugPoly = false,
        minZ = 22.87,
        maxZ = 25.87
    }, {
        options = {
            {
                event = "news:duty",
                icon = "far fa-clipboard",
                label = "Sign On",
            },
            {
                event = "offnews:duty",
                icon = "far fa-clipboard",
                label = "Sign Off",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    AddBoxZone("PDMDuty", vector3(-29.5, -1106.24, 26.22), 0.4, 0.5, {
        name = "PDMDuty",
        heading = 121.04,
        debugPoly = false,
        minZ = 26.2,
        maxZ = 26.9
    }, {
        options = {
            {
                event = "pdm:duty",
                icon = "far fa-clipboard",
                label = "Sign On",
            },
            {
                event = "pdmboss:duty",
                icon = "far fa-clipboard",
                label = "Boss Sign On",
            },
            {
                event = "offpdm:duty",
                icon = "far fa-clipboard",
                label = "Sign Off",
            },
            {
                event = "vulcan_business_rob:start",
                icon = "fas fa-mask",
                label = "Start Robbery",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    AddBoxZone("TaxiDuty", vector3(907.26, -160.2, 74.13), 0.8, 9.5, {
        name = "TaxiDuty",
        heading = 58.86,
        debugPoly = false,
        minZ = 70.13,
        maxZ = 76.33
    }, {
        options = {
            {
                event = "taxi:duty",
                icon = "far fa-clipboard",
                label = "Sign On",
            },
            {
                event = "offtaxi:duty",
                icon = "far fa-clipboard",
                label = "Sign Off",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    AddBoxZone("RealtorDuty", vector3(-126.86, -641.79, 168.68), 1.0, 1.0, {
        name = "RealtorDuty",
        heading = 97.98,
        debugPoly = false,
        minZ = 168.5,
        maxZ = 169.5
    }, {
        options = {
            {
                event = "realtor:duty",
                icon = "far fa-clipboard",
                label = "Sign On",
            },
            {
                event = "offrealtor:duty",
                icon = "far fa-clipboard",
                label = "Sign Off",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    local casinoped = {
        `s_f_y_casino_01`,
    }
    AddTargetModel(casinoped, {
        options = {
            {
                event = "casino:duty",
                icon = "far fa-clipboard",
                label = "Casino Sign On",
            },
            {
                event = "offcasino:duty",
                icon = "far fa-clipboard",
                label = "Casino Sign Off",
            },
            {
                event = "casino:buyChips:Client",
                icon = "fas fa-dollar-sign",
                label = "Purchase Chips",
            },
            {
                event = "casino:Chips:CashOut:Client",
                icon = "fas fa-dollar-sign",
                label = "Cash Out",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    local pdmPed = {
        `a_m_m_prolhost_01`,
    }
    AddTargetModel(pdmPed, {
        options = {
            {
                event = "pdm:buyPlate:Client",
                icon = "far fa-clipboard",
                label = "Purchase Plates",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    AddBoxZone("Gavel", vector3(-519.21, -175.64, 38.45), 0.4, 0.5, {
        name = "Gavel",
        heading = 121.04,
        debugPoly = false,
        minZ = 38.00,
        maxZ = 39.00
    }, {
        options = {
            {
                event = "gavel:target",
                icon = "fas fa-gavel",
                label = "Gavel",
            },
        },
        job = {"all"},
        distance = 2.0
    })
    
    AddBoxZone("Gavel2", vector3(-521.50, -194.75, 38.07), 0.4, 0.5, {
        name = "Gavel2",
        heading = 121.04,
        debugPoly = false,
        minZ = 38.00,
        maxZ = 38.50
    }, {
        options = {
            {
                event = "gavel:target",
                icon = "fas fa-gavel",
                label = "Gavel",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    AddBoxZone("Poledance", vector3(108.79771423, -1289.2926025, 29.14), 0.4, 0.5, {
        name = "Poledance",
        heading = 121.04,
        debugPoly = false,
        minZ = 28.00,
        maxZ = 32.50
    }, {
        options = {
            {
                event = "pole:dance",
                icon = "fas fa-box-tissue",
                label = "Poledance",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    AddBoxZone("Poledance2", vector3(104.77420806, -1294.4742431, 29.14), 0.4, 0.5, {
        name = "Poledance",
        heading = 121.04,
        debugPoly = false,
        minZ = 28.00,
        maxZ = 32.50
    }, {
        options = {
            {
                event = "pole:dance2",
                icon = "fas fa-box-tissue",
                label = "Poledance",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    AddBoxZone("Poledance3", vector3(102.21952819, -1290.1522216, 29.14), 0.4, 0.5, {
        name = "Poledance",
        heading = 121.04,
        debugPoly = false,
        minZ = 28.00,
        maxZ = 32.50
    }, {
        options = {
            {
                event = "pole:dance3",
                icon = "fas fa-box-tissue",
                label = "Poledance",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    local bike = {
        `bmx`,
        `bmx2`,
        `bmxp2`,
        `unicycle`,
        `bimx`,
    }
    AddTargetModel(bike, {
        options = {
            {
                event = "pickup:bike",
                icon = "fas fa-bicycle",
                label = "Pickup Bike",
            },
        },
        job = {"all"},
        distance = 2.5
    })

    AddBoxZone("TownhallHack", vector3(-518.62, -177.28, 38.71), 0.4, 1.0, {
        name = "TownhallHack",
        heading = 152.31,
        debugPoly = false,
        minZ = 38.50,
        maxZ = 39.50
    }, {
        options = {
            {
                event = "vulcan_townhall_rob:start",
                icon = "fas fa-mask",
                label = "Hack The Computer",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    local atm = {
        `prop_atm_01`,
        `prop_atm_02`,
        `prop_atm_03`,
        `prop_fleeca_atm`,

    }
    AddTargetModel(atm, {
        options = {
            {
                event = "use:atm",
                icon = "fas fa-cash-register",
                label = "Use ATM",
            },
            {
                event = "use:atm2",
                icon = "fas fa-tasks",
                label = "Open Bank Management",
            },
            {
                event = "vulcan_atm_rob:start",
                icon = "fas fa-mask",
                label = "Hack The ATM",
            },
        },
        job = {"all"},
        distance = 2.5
    })

    local parkMeter = {
        `prop_parknmeter_01`,
        `prop_parknmeter_02`,

    }
    AddTargetModel(parkMeter, {
        options = {
            {
                event = "vulcan_park_rob:start",
                icon = "fas fa-parking",
                label = "Tamper With Meter",
            },
        },
        job = {"all"},
        distance = 2.5
    })

    local safe = {
        `v_ilev_gangsafedoor`,

    }
    AddTargetModel(safe, {
        options = {
            {
                event = "vulcan_store_rob:start:safe",
                icon = "fas fa-piggy-bank",
                label = "Rob The Safe",
            },
        },
        job = {"all"},
        distance = 2.5
    })

    local cashRegister = {
        `prop_till_01`,

    }
    AddTargetModel(cashRegister, {
        options = {
            {
                event = "vulcan_store_rob:start:cashRegister",
                icon = "fas fa-cash-register",
                label = "Rob The Register",
            },
        },
        job = {"all"},
        distance = 2.5
    })

    AddBoxZone("SopranosRob", vector3(282.19, -974.85, 29.86), 0.8, 1.0, {
        name = "SopranosRob",
        heading = 1.37,
        debugPoly = false,
        minZ = 29.50,
        maxZ = 30.50
    }, {
        options = {
            {
                event = "vulcan_business_rob:start:sopranos",
                icon = "fas fa-mask",
                label = "Hack The Computer",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    local truck = {
        `stockade`,

    }
    AddTargetModel(truck, {
        options = {
            {
                event = "vulcan_truck_rob:start",
                icon = "fas fa-piggy-bank",
                label = "Rob The Truck",
            },
        },
        job = {"all"},
        distance = 2.5
    })

    local news = {
        1211559620,
        -1186769817,
        -756152956,
        720581693,
        -838860344,

    }
    AddTargetModel(news, {
        options = {
            {
                event = "newspaper:openClient",
                icon = "fas fa-newspaper",
                label = "Check News Stand",
            },
        },
        job = {"all"},
        distance = 1.0
    })

    AddBoxZone("MayorVote1", vector3(-560.3, -206.34, 38.22), 5.7, 1.5, {
        name = "MayorVote1",
        heading = 300.00,
        debugPoly = false,
        minZ = 37.40,
        maxZ = 39.00
    }, {
        options = {
            {
                event = "vote:david:cooper:client",
                icon = "fas fa-vote-yea",
                label = "Vote For David Cooper",
            },
            {
                event = "vote:bob:robertson:client",
                icon = "fas fa-vote-yea",
                label = "Vote For Bob Robertson",
            },
            {
                event = "vote:jonathan:krug:client",
                icon = "fas fa-vote-yea",
                label = "Vote For Jonathan Krug",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    AddBoxZone("BlackDuty", vector3(28.14, -2669.0, 12.05), 0.4, 1.4, {
        name = "BlackDuty",
        heading = 1,
        debugPoly = false,
        minZ = 11.0,
        maxZ = 13.0
    }, {
        options = {
            {
                event = "black:duty",
                icon = "far fa-clipboard",
                label = "Sign On",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    local casinowheel = {
        -1901044377,
        -430989390,
        -1519644200,
        654385216,
        161343630,
        207578973,
        1096374064,
        -1932041857,
        -487222358,
    }
    AddTargetModel(casinowheel, {
        options = {
            {
                event = "casino:Slot:Client",
                icon = "fas fa-dollar-sign",
                label = "Try Your Luck",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    local animals = {
        `a_c_chop`,
        `a_c_boar`,
        `a_c_cat_01`,
        `a_c_chickenhawk`,
        `a_c_chimp`,
        `a_c_cormorant`,
        `a_c_cow`,
        `a_c_coyote`,
        `a_c_crow`,
        `a_c_deer`,
        `a_c_dolphin`,
        `a_c_hen`,
        `a_c_humpback`,
        `a_c_husky`,
        `a_c_killerwhale`,
        `a_c_pig`,
        `a_c_pigeon`,
        `a_c_poodle`,
        `a_c_pug`,
        `a_c_rabbit_01`,
        `a_c_retriever`,
        `a_c_rottweiler`,
        `a_c_seagull`,
        `a_c_sharkhammer`,
        `a_c_sharktiger`,
        `a_c_shepherd`,
        `a_c_westy`,
    }
    AddTargetModel(animals, {
        options = {
            {
                event = "esx_hunting:targetButcher",
                icon = "fas fa-utensils",
                label = "Skin Carcass",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    local illegalAnimals = {
        `a_c_mtlion`,
    }
    AddTargetModel(illegalAnimals, {
        options = {
            {
                event = "esx_hunting:illegalTargetButcher",
                icon = "fas fa-utensils",
                label = "Skin Carcass",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    local gasStation = {
        `prop_gas_pump_1a`,
        `prop_gas_pump_1b`,
        `prop_gas_pump_1c`,
        `prop_gas_pump_1d`,
    }
    AddTargetModel(gasStation, {
        options = {
            {
                event = "esx_legacy_fuel:fuelVehicle",
                icon = "fas fa-gas-pump",
                label = "Fuel Vehicle",
            },
        },
        job = {"all"},
        distance = 2.0
    })

    AddBoxZone("PrisonTelephone", vector3(1828.77, 2579.73, 46.56), 0.4, 1.4, {
        name = "PrisonTelephone",
        heading = 180.0,
        debugPoly = false,
        minZ = 46.0,
        maxZ = 47.0
    }, {
        options = {
            {
                event = "vulcan_prison:checkTime",
                icon = "far fa-clock",
                label = "Check Remaining Time",
            },
            {
                event = "vulcan_prison:checkLaw",
                icon = "fas fa-gavel",
                label = "Check Legal Repersentives",
            },
            {
                event = "vulcan_prison:requestLaw",
                icon = "fas fa-phone",
                label = "Request Legal Repersentives",
            },
        },
        job = {"all"},
        distance = 2.0
    })

end)

---Police---

RegisterNetEvent('police:duty')
AddEventHandler('police:duty', function()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vulcan_sign_on', {
        title    = 'Choose A Department',
        align    = 'right',
        elements = {
            {label = 'Los Santos Police Department', value = 'lspd'},
            {label = 'Blaine County Sheriff\'s Office', value = 'bcso'},
            {label = 'San Andreas State Police',  value = 'sasp'},
            {label = 'San Andreas State Park Rangers',  value = 'saspr'},
            {label = 'Criminal Investigative Department',  value = 'cid'},
            {label = 'Special Weapons And Tactics',  value = 'swat'},
            -- {label = 'Department Of Corrections',  value = 'doc'},
            {label = 'San Andreas State Central Dispatch',  value = 'dispatch'},
        }
    }, function(data2, menu2)
        if data2.current.value == 'lspd' then 
            TriggerEvent('lspd:police:duty')
        elseif data2.current.value == 'bcso' then 
            TriggerEvent('bcso:police:duty')
        elseif data2.current.value == 'sasp' then 
            TriggerEvent('sasp:police:duty')
        elseif data2.current.value == 'saspr' then 
            TriggerEvent('rangerpolice:duty')
        elseif data2.current.value == 'cid' then 
            TriggerEvent('cidpolice:duty')
        elseif data2.current.value == 'swat' then 
            TriggerEvent('swatpolice:duty')
        -- elseif data2.current.value == 'doc' then 
        --     TriggerEvent('doc:police:duty')
        elseif data2.current.value == 'dispatch' then
            TriggerEvent('dispatchpolice:duty')
        end

    end, function(data2, menu2)
        menu2.close()
    end)
end)

RegisterNetEvent('lspd:police:duty')
AddEventHandler('lspd:police:duty', function()
    exports["rp-radio"]:GivePlayerAccessToFrequency(1)
    exports["rp-radio"]:GivePlayerAccessToFrequency(2)
	exports["rp-radio"]:GivePlayerAccessToFrequency(3)
    exports["rp-radio"]:GivePlayerAccessToFrequency(4)
    exports["rp-radio"]:GivePlayerAccessToFrequency(6)

    TriggerServerEvent("vulcan_duty:serverSignOn")
end)

RegisterNetEvent('bcso:police:duty')
AddEventHandler('bcso:police:duty', function()
    exports["rp-radio"]:GivePlayerAccessToFrequency(1)
    exports["rp-radio"]:GivePlayerAccessToFrequency(2)
	exports["rp-radio"]:GivePlayerAccessToFrequency(3)
    exports["rp-radio"]:GivePlayerAccessToFrequency(4)
    exports["rp-radio"]:GivePlayerAccessToFrequency(6)

    TriggerServerEvent("vulcan_duty:bcsoSignOn")
end)

RegisterNetEvent('sasp:police:duty')
AddEventHandler('sasp:police:duty', function()
    exports["rp-radio"]:GivePlayerAccessToFrequency(1)
    exports["rp-radio"]:GivePlayerAccessToFrequency(2)
	exports["rp-radio"]:GivePlayerAccessToFrequency(3)
    exports["rp-radio"]:GivePlayerAccessToFrequency(4)
    exports["rp-radio"]:GivePlayerAccessToFrequency(6)

    TriggerServerEvent("vulcan_duty:saspSignOn")
end)

RegisterNetEvent('doc:police:duty')
AddEventHandler('doc:police:duty', function()
    exports["rp-radio"]:GivePlayerAccessToFrequency(1)
    exports["rp-radio"]:GivePlayerAccessToFrequency(2)
	exports["rp-radio"]:GivePlayerAccessToFrequency(3)
    exports["rp-radio"]:GivePlayerAccessToFrequency(4)
    exports["rp-radio"]:GivePlayerAccessToFrequency(6)

    TriggerServerEvent("vulcan_duty:docSignOn")
end)

RegisterNetEvent('cidpolice:duty')
AddEventHandler('cidpolice:duty', function()
    exports["rp-radio"]:GivePlayerAccessToFrequency(1)
    exports["rp-radio"]:GivePlayerAccessToFrequency(2)
	exports["rp-radio"]:GivePlayerAccessToFrequency(3)
    exports["rp-radio"]:GivePlayerAccessToFrequency(4)
    exports["rp-radio"]:GivePlayerAccessToFrequency(6)

    TriggerServerEvent("vulcan_duty:cidSignOn")
end)

RegisterNetEvent('swatpolice:duty')
AddEventHandler('swatpolice:duty', function()
    exports["rp-radio"]:GivePlayerAccessToFrequency(1)
    exports["rp-radio"]:GivePlayerAccessToFrequency(2)
	exports["rp-radio"]:GivePlayerAccessToFrequency(3)
    exports["rp-radio"]:GivePlayerAccessToFrequency(4)
    exports["rp-radio"]:GivePlayerAccessToFrequency(6)

    TriggerServerEvent("vulcan_duty:swatSignOn")
end)

RegisterNetEvent('dispatchpolice:duty')
AddEventHandler('dispatchpolice:duty', function()
    exports["rp-radio"]:GivePlayerAccessToFrequency(1)
    exports["rp-radio"]:GivePlayerAccessToFrequency(2)
	exports["rp-radio"]:GivePlayerAccessToFrequency(3)
    exports["rp-radio"]:GivePlayerAccessToFrequency(4)
    exports["rp-radio"]:GivePlayerAccessToFrequency(6)

    TriggerServerEvent("vulcan_duty:dispatchSignOn")
end)

RegisterNetEvent('rangerpolice:duty')
AddEventHandler('rangerpolice:duty', function()
    exports["rp-radio"]:GivePlayerAccessToFrequency(1)
    exports["rp-radio"]:GivePlayerAccessToFrequency(2)
	exports["rp-radio"]:GivePlayerAccessToFrequency(3)
    exports["rp-radio"]:GivePlayerAccessToFrequency(4)
    exports["rp-radio"]:GivePlayerAccessToFrequency(6)

    TriggerServerEvent("vulcan_duty:rangerSignOn")
end)

---EMS---

RegisterNetEvent('ems:duty')
AddEventHandler('ems:duty', function()
    exports["rp-radio"]:GivePlayerAccessToFrequency(1)
    exports["rp-radio"]:GivePlayerAccessToFrequency(4)
    exports["rp-radio"]:GivePlayerAccessToFrequency(6)

    TriggerServerEvent("vulcan_duty:emsSignOn")
end)

---Black Market---

RegisterNetEvent('black:duty')
AddEventHandler('black:duty', function()
    TriggerServerEvent("vulcan_duty:blackSignOn")
end)

---DOJ---

RegisterNetEvent('state:duty')
AddEventHandler('state:duty', function()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vulcan_sign_on_state', {
        title    = 'Choose A Department',
        align    = 'right',
        elements = {
            {label = 'Department Of Justice - Lawyer', value = 'lawyer'},
            {label = 'Department Of Justice - Judge', value = 'judge'},
            {label = 'Department Of Justice - District Attorney',  value = 'da'},
            {label = 'State Of San Andreas - Mayor',  value = 'mayor'},
        }
    }, function(data2, menu2)
        if data2.current.value == 'lawyer' then 
            TriggerEvent('doj:duty')
        elseif data2.current.value == 'judge' then 
            TriggerEvent('dojjudge:duty')
        elseif data2.current.value == 'da' then 
            TriggerEvent('dojda:duty')
        elseif data2.current.value == 'mayor' then 
            TriggerEvent('dojmay:duty')
        end

    end, function(data2, menu2)
        menu2.close()
    end)
end)

RegisterNetEvent('doj:duty')
AddEventHandler('doj:duty', function()
    exports["rp-radio"]:GivePlayerAccessToFrequency(5)

    TriggerServerEvent("vulcan_duty:dojSignOn")
end)

RegisterNetEvent('dojjudge:duty')
AddEventHandler('dojjudge:duty', function()
    exports["rp-radio"]:GivePlayerAccessToFrequency(5)

    TriggerServerEvent("vulcan_duty:dojjudgeSignOn")
end)

RegisterNetEvent('dojda:duty')
AddEventHandler('dojda:duty', function()
    exports["rp-radio"]:GivePlayerAccessToFrequency(1)
    exports["rp-radio"]:GivePlayerAccessToFrequency(5)

    TriggerServerEvent("vulcan_duty:dojdaSignOn")
end)

RegisterNetEvent('dojmay:duty')
AddEventHandler('dojmay:duty', function()
    exports["rp-radio"]:GivePlayerAccessToFrequency(1)
    exports["rp-radio"]:GivePlayerAccessToFrequency(2)
	exports["rp-radio"]:GivePlayerAccessToFrequency(3)
    exports["rp-radio"]:GivePlayerAccessToFrequency(4)
    exports["rp-radio"]:GivePlayerAccessToFrequency(5)
    exports["rp-radio"]:GivePlayerAccessToFrequency(6)

    TriggerServerEvent("vulcan_duty:dojmaySignOn")
end)

---DOT---

RegisterNetEvent('dot:duty')
AddEventHandler('dot:duty', function()
    exports["rp-radio"]:GivePlayerAccessToFrequency(6)

    TriggerServerEvent("vulcan_duty:dotSignOn")
end)

---WN---

RegisterNetEvent('news:duty')
AddEventHandler('news:duty', function()
    TriggerServerEvent("vulcan_duty:newsSignOn")
end)

---PDM---

RegisterNetEvent('pdm:duty')
AddEventHandler('pdm:duty', function()
    TriggerServerEvent("vulcan_duty:pdmSignOn")
end)

RegisterNetEvent('pdmboss:duty')
AddEventHandler('pdmboss:duty', function()
    TriggerServerEvent("vulcan_duty:pdmBossSignOn")
end)

PDMPed = function()
    LoadModels({ GetHashKey('a_m_m_prolhost_01') })

    local pedHandle = CreatePed(5, 'a_m_m_prolhost_01', -27.6, -1103.97, 26.42 - 0.985, 68.42, true)

    SetPedComponentVariation(pedHandle, 3, 1, 0, 0)
    SetPedComponentVariation(pedHandle, 11, 0, 1, 0)
    SetPedComponentVariation(pedHandle, 4, 1, 0, 0)
    SetPedComponentVariation(pedHandle, 7, 1, 0, 0)
    SetPedComponentVariation(pedHandle, 8, 1, 0, 0)

    SetPedCombatAttributes(pedHandle, 46, true)
    SetPedFleeAttributes(pedHandle, 0, 0)                      
    SetBlockingOfNonTemporaryEvents(pedHandle, true)
    
    SetEntityAsMissionEntity(pedHandle, true, true)
    SetEntityInvincible(pedHandle, true)

    FreezeEntityPosition(pedHandle, true)
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)

            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)

            for _, v in ipairs(Config.LocationsPDMPlate) do
                local dst = #(coords - v.coords)
                if dst < 2 then
                    DrawText3D(v.coords[1], v.coords[2], v.coords[3] - 0.8, Config.Text["call_seller"])
                end
                if dst < 2 then
                    if IsControlJustReleased(0, 38) then
                        PDMPed()
                        exports['mythic_notify']:SendAlert('inform', 'Seller has been called.', 2500, { ['background-color'] = '#2F5C73', ['color'] = '#ffffff' })
                    end
                end
            end
        end
    end
)

RegisterNetEvent('pdm:buyPlate:Client')
AddEventHandler('pdm:buyPlate:Client', function()

    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wp_target_plates', {
        title = "Enter Amount Of Plates You Wish To Purchase"
    },
    function(data2, menu2)
    local amount = tonumber(data2.value)
    if amount == nil or amount == "" then
        exports['mythic_notify']:SendAlert('inform', 'No amount specified.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        menu2.close()
    else
    menu2.close()

                if amount >= 1 then
                    TriggerServerEvent("pdm:buyPlate", amount)
                end
            end

        end, function(data2, menu2)
		menu2.close()
	end)

end)

---Taxi---

RegisterNetEvent('taxi:duty')
AddEventHandler('taxi:duty', function()
    TriggerServerEvent("vulcan_duty:taxiSignOn")
end)

---Realtor---

RegisterNetEvent('realtor:duty')
AddEventHandler('realtor:duty', function()
    TriggerServerEvent("vulcan_duty:realtorSignOn")
end)

---Casino---

RegisterNetEvent('casino:duty')
AddEventHandler('casino:duty', function()
    TriggerServerEvent("vulcan_duty:casinoSignOn")
end)

local CachedModels = {}

LoadModels = function(models)
	for modelIndex = 1, #models do
		local model = models[modelIndex]

		table.insert(CachedModels, model)

		if IsModelValid(model) then
			while not HasModelLoaded(model) do
				RequestModel(model)
	
				Citizen.Wait(10)
			end
		else
			while not HasAnimDictLoaded(model) do
				RequestAnimDict(model)
	
				Citizen.Wait(10)
			end    
		end
	end
end

CasinoPed = function()
    LoadModels({ GetHashKey('s_f_y_casino_01') })

    local pedHandle = CreatePed(5, 's_f_y_casino_01', 1116.06, 220.01, -49.44 - 0.985, 91.7, true)

    SetPedComponentVariation(pedHandle, 3, 1, 0, 0)
    SetPedComponentVariation(pedHandle, 11, 0, 1, 0)
    SetPedComponentVariation(pedHandle, 4, 1, 0, 0)
    SetPedComponentVariation(pedHandle, 7, 1, 0, 0)
    SetPedComponentVariation(pedHandle, 8, 1, 0, 0)

    SetPedCombatAttributes(pedHandle, 46, true)
    SetPedFleeAttributes(pedHandle, 0, 0)                      
    SetBlockingOfNonTemporaryEvents(pedHandle, true)
    
    SetEntityAsMissionEntity(pedHandle, true, true)
    SetEntityInvincible(pedHandle, true)

    FreezeEntityPosition(pedHandle, true)
end

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
                if dst < 2 then
                    DrawText3D(v.coords[1], v.coords[2], v.coords[3] - 0.8, Config.Text["call_clerk"])
                end
                if dst < 2 then
                    if IsControlJustReleased(0, 38) then
                        CasinoPed()
                        exports['mythic_notify']:SendAlert('inform', 'Clerk has been called.', 2500, { ['background-color'] = '#2F5C73', ['color'] = '#ffffff' })
                    end
                end
            end
        end
    end
)

RegisterNetEvent('casino:buyChips:Client')
AddEventHandler('casino:buyChips:Client', function()

    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wp_target_chips', {
        title = "Enter Amount Of Chips You Wish To Purchase"
    },
    function(data2, menu2)
    local amount = tonumber(data2.value)
    if amount == nil or amount == "" then
        exports['mythic_notify']:SendAlert('inform', 'No amount specified.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        menu2.close()
    else
    menu2.close()

                if amount >= 1 then
                    TriggerServerEvent("casino:buyChips", amount)
                end
            end

        end, function(data2, menu2)
		menu2.close()
	end)

end)

RegisterNetEvent('casino:Chips:CashOut:Client')
AddEventHandler('casino:Chips:CashOut:Client', function()
    
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wp_target_cash_out', {
        title = "Enter Amount You Wish To Cash Out"
    },
    function(data2, menu2)
    local amount = tonumber(data2.value)
    if amount == nil or amount == "" then
        exports['mythic_notify']:SendAlert('inform', 'No amount specified.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        menu2.close()
    else
    menu2.close()

                if amount >= 1 then
                    TriggerServerEvent("casino:Chips:CashOut", amount)
                end
            end

        end, function(data2, menu2)
		menu2.close()
	end)

end)

RegisterNetEvent('casino:Slot:Client')
AddEventHandler('casino:Slot:Client', function()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wp_target_slot', {
        title = "Enter Your Bet"
    },
    function(data2, menu2)
    local amount = tonumber(data2.value)
    if amount == nil or amount == "" then
        exports['mythic_notify']:SendAlert('inform', 'No amount specified.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        menu2.close()
    else
    menu2.close()

                if amount >= 1 then
                    TriggerServerEvent("casino:SpinSlot", amount)
                end
            end

        end, function(data2, menu2)
		menu2.close()
	end)
    
end)

---Off-Duty---

RegisterNetEvent('offpolice:duty')
AddEventHandler('offpolice:duty', function()
    exports["rp-radio"]:RemovePlayerAccessToFrequency(1)
    exports["rp-radio"]:RemovePlayerAccessToFrequency(2)
    exports["rp-radio"]:RemovePlayerAccessToFrequency(3)
    exports["rp-radio"]:RemovePlayerAccessToFrequency(4)
    exports["rp-radio"]:RemovePlayerAccessToFrequency(6)

    TriggerServerEvent("vulcan_duty:serverSignOff")
end)

RegisterNetEvent('offpolice:duty2')
AddEventHandler('offpolice:duty2', function()
    exports["rp-radio"]:RemovePlayerAccessToFrequency(1)
    exports["rp-radio"]:RemovePlayerAccessToFrequency(2)
    exports["rp-radio"]:RemovePlayerAccessToFrequency(3)
    exports["rp-radio"]:RemovePlayerAccessToFrequency(4)
    exports["rp-radio"]:RemovePlayerAccessToFrequency(6)

    TriggerServerEvent("vulcan_duty:serverSignOff2")
end)

RegisterNetEvent('offems:duty')
AddEventHandler('offems:duty', function()
    exports["rp-radio"]:RemovePlayerAccessToFrequency(1)
    exports["rp-radio"]:RemovePlayerAccessToFrequency(4)
    exports["rp-radio"]:RemovePlayerAccessToFrequency(6)

    TriggerServerEvent("vulcan_duty:emsSignOff")
end)

RegisterNetEvent('offdoj:duty')
AddEventHandler('offdoj:duty', function()
    exports["rp-radio"]:RemovePlayerAccessToFrequency(5)

    TriggerServerEvent("vulcan_duty:dojSignOff")
end)

RegisterNetEvent('offdot:duty')
AddEventHandler('offdot:duty', function()
    exports["rp-radio"]:RemovePlayerAccessToFrequency(6)

    TriggerServerEvent("vulcan_duty:dotSignOff")
end)

RegisterNetEvent('offnews:duty')
AddEventHandler('offnews:duty', function()
    TriggerServerEvent("vulcan_duty:newsSignOff")
end)

RegisterNetEvent('offpdm:duty')
AddEventHandler('offpdm:duty', function()
    TriggerServerEvent("vulcan_duty:pdmSignOff")
end)

RegisterNetEvent('offtaxi:duty')
AddEventHandler('offtaxi:duty', function()
    TriggerServerEvent("vulcan_duty:taxiSignOff")
end)

RegisterNetEvent('offrealtor:duty')
AddEventHandler('offrealtor:duty', function()
    TriggerServerEvent("vulcan_duty:realtorSignOff")
end)

RegisterNetEvent('offcasino:duty')
AddEventHandler('offcasino:duty', function()
    TriggerServerEvent("vulcan_duty:casinoSignOff")
end)

---Gavel---

RegisterNetEvent('gavel:target')
AddEventHandler('gavel:target', function()
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 15.0, 'gavel', 1.0)
end)

---Pickup Bike---

RegisterNetEvent('pickup:bike')
AddEventHandler('pickup:bike', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
    local bone = GetPedBoneIndex(playerPed, 0xE5F3)
    local bike = false

    if GetEntityModel(vehicle) == GetHashKey("bmx") or GetEntityModel(vehicle) == GetHashKey("bmx2") or GetEntityModel(vehicle) == GetHashKey("unicycle") or GetEntityModel(vehicle) == GetHashKey("bmxp2")or GetEntityModel(vehicle) == GetHashKey("bimx") then

    AttachEntityToEntity(vehicle, playerPed, bone, 0.0, 0.24, 0.10, 340.0, 330.0, 330.0, true, true, false, true, 1, true)
    exports['mythic_notify']:SendAlert('inform', 'Press [G] to drop the bike.', 5000)

    RequestAnimDict("anim@heists@box_carry@")
    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do Citizen.Wait(0) end
    TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 2.0, 2.0, -1, 51, 0, false, false, false)
    bike = true

    RegisterCommand('dropbike', function()
        if IsEntityAttached(vehicle) then
        DetachEntity(vehicle, nil, nil)
        SetVehicleOnGroundProperly(vehicle)
        ClearPedTasksImmediately(playerPed)
        bike = false
        end
    end, false)

        RegisterKeyMapping('dropbike', 'Drop Bike', 'keyboard', 'g')

        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)
                if bike and IsEntityPlayingAnim(playerPed, "anim@heists@box_carry@", "idle", 3) ~= 1 then
                    RequestAnimDict("anim@heists@box_carry@")
                    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do Citizen.Wait(0) end
                    TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 2.0, 2.0, 50000000, 51, 0, false, false, false)
                    if not IsEntityAttachedToEntity(playerPed, vehicle) then
                        bike = false
                        ClearPedTasksImmediately(playerPed)
                    end
                end
            end
        end)
    end
end)

---ATM---

RegisterNetEvent('use:atm')
AddEventHandler('use:atm', function()
    TriggerServerEvent('openui:atm:server')
end)

RegisterNetEvent('use:atm2')
AddEventHandler('use:atm2', function()
    TriggerEvent('yow_banking:showATM')
end)

LoadDict = function(Dict)
    while not HasAnimDictLoaded(Dict) do 
        Wait(0)
        RequestAnimDict(Dict)
    end
end

---Vanilla Unicorn---

RegisterNetEvent('pole:dance')
AddEventHandler('pole:dance', function()
    LoadDict('mini@strip_club@pole_dance@pole_dance' .. 1)
    local scene = NetworkCreateSynchronisedScene(vector3(108.8, -1289.0, 29.25), vector3(0.0, 0.0, 0.0), 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, 'mini@strip_club@pole_dance@pole_dance' .. 1, 'pd_dance_0' .. 1, 1.5, -4.0, 1, 1, 1148846080, 0)
    NetworkStartSynchronisedScene(scene)
end)

RegisterNetEvent('pole:dance2')
AddEventHandler('pole:dance2', function()
    LoadDict('mini@strip_club@pole_dance@pole_dance' .. 2)
    local scene = NetworkCreateSynchronisedScene(vector3(104.8, -1294.13, 29.26), vector3(0.0, 0.0, 0.0), 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, 'mini@strip_club@pole_dance@pole_dance' .. 2, 'pd_dance_0' .. 2, 1.5, -4.0, 1, 1, 1148846080, 0)
    NetworkStartSynchronisedScene(scene)
end)

RegisterNetEvent('pole:dance3')
AddEventHandler('pole:dance3', function()
    LoadDict('mini@strip_club@pole_dance@pole_dance' .. 3)
    local scene = NetworkCreateSynchronisedScene(vector3(102.22, -1289.90, 29.26), vector3(0.0, 0.0, 0.0), 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, 'mini@strip_club@pole_dance@pole_dance' .. 3, 'pd_dance_0' .. 3, 1.5, -4.0, 1, 1, 1148846080, 0)
    NetworkStartSynchronisedScene(scene)
end)

---Election---

RegisterNetEvent('vote:david:cooper:client')
AddEventHandler('vote:david:cooper:client', function()
    TriggerServerEvent('vote:david:cooper')
end)

RegisterNetEvent('vote:bob:robertson:client')
AddEventHandler('vote:bob:robertson:client', function()
    TriggerServerEvent('vote:bob:robertson')
end)

RegisterNetEvent('vote:jonathan:krug:client')
AddEventHandler('vote:jonathan:krug:client', function()
    TriggerServerEvent('vote:jonathan:krug')
end)