ESX 			    			= nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

--Wheelchair
local wheelChair = nil
RegisterNetEvent('spawn:whchair')
AddEventHandler('spawn:whchair', function()
    if not DoesEntityExist(wheelChair) then
        local wheelChairModel = `npwheelchair`
        RequestModel(wheelChairModel)
        while not HasModelLoaded(wheelChairModel) do
            Citizen.Wait(0)
        end
        wheelChair = CreateVehicle(wheelChairModel, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), true, false)
        SetVehicleOnGroundProperly(wheelChair)
        SetVehicleNumberPlateText(wheelChair, "PILLBOX".. math.random(9))
        SetPedIntoVehicle(PlayerPedId(), wheelChair, -1)
        SetModelAsNoLongerNeeded(wheelChairModel)
    elseif DoesEntityExist(wheelChair) and #(GetEntityCoords(wheelChair) - GetEntityCoords(PlayerPedId())) < 3.0 and GetPedInVehicleSeat(wheelChair,-1) == 0 then
        DeleteVehicle(wheelChair)
        wheelChair = nil
    else
        exports['mythic_notify']:SendAlert('inform', 'Too far away from the wheelchair or someon is sitting in it!', 2500)
    end
end)

--NVG
local NVG = false

RegisterNetEvent("wp_items:NVG")
AddEventHandler("wp_items:NVG", function()
    local playerPed = PlayerPedId()

    if NVG then
        SetNightvision(false)
        NVG = false
        SetPedComponentVariation(PlayerPedId(), 1, 101, 0, 0)
    elseif not NVG then
        SetNightvision(true)
        NVG = true
        SetPedComponentVariation(PlayerPedId(), 1, 181, 0, 0)
    end
    
end)

--  Civ/Crim  Related Stuff/Items
RegisterNetEvent('wp_items:gunlocker')
AddEventHandler('wp_items:gunlocker', function(source)
    local playerPed = PlayerPedId()
    
    TriggerEvent("mythic_progbar:client:progress", {
        name = "gun_locker",
        duration = 4000,
        label = "Opening Gun Locker",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "amb@world_human_clipboard@male@idle_a",
            anim = "idle_c",
        },
        prop = {
            model = "prop_security_case_02",
        }
    }, function(status)
        if not status then
            ClearPedTasksImmediately(playerPed)
            TriggerServerEvent('wp_items:gunLockerReward:Server')
        end
    end)

end)

RegisterNetEvent('wp_items:parachute')
AddEventHandler('wp_items:parachute', function(source)
    local playerPed = PlayerPedId()
    TriggerEvent('menu:hasParachute', true)
    GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), 150, true, true)
    TriggerServerEvent('wp_items:removeParachute')
    SetPedComponentVariation(PlayerPedId(), 5, 5, 0, 0)
end)

RegisterNetEvent('wp_items:addParachute')
AddEventHandler('wp_items:addParachute', function(source)
    local playerPed = PlayerPedId()
    TriggerEvent('menu:notHasParachute', true)
    RemoveWeaponFromPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"))
    SetPedComponentVariation(PlayerPedId(), 5, 0, 0, 0)
    TriggerServerEvent('wp_items:addParachuteServer')
    exports['mythic_notify']:SendAlert('inform', 'You took off your parachute!', 2500)
end)

RegisterNetEvent('wp_items:radioscanner')
AddEventHandler('wp_items:radioscanner', function(source)
    local playerPed = PlayerPedId()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'wp_items_radioscanner', {
        title    = 'Choose A Radio',
        align    = 'right',
        elements = {
            {label = 'Radio 1', value = 'police_radio'},
            {label = 'Radio 2', value = 'swat_radio'},
            {label = 'Radio 3',  value = 'cid_radio'},
            {label = 'Radio 4',  value = 'ems_radio'},
            {label = 'Radio 5',  value = 'doj_radio'},
            {label = 'Radio 6',  value = 'dot_radio'},
        }
    }, function(data2, menu2)
        if data2.current.value == 'police_radio' then 
            exports["rp-radio"]:GivePlayerAccessToFrequency(1)
            menu2.close()
            TriggerServerEvent('wp_items:removeScanner')
        elseif data2.current.value == 'swat_radio' then 
            exports["rp-radio"]:GivePlayerAccessToFrequency(2)
            menu2.close()
            TriggerServerEvent('wp_items:removeScanner')
        elseif data2.current.value == 'cid_radio' then 
            exports["rp-radio"]:GivePlayerAccessToFrequency(3)
            menu2.close()
            TriggerServerEvent('wp_items:removeScanner')
        elseif data2.current.value == 'ems_radio' then 
            exports["rp-radio"]:GivePlayerAccessToFrequency(4)
            menu2.close()
            TriggerServerEvent('wp_items:removeScanner')
        elseif data2.current.value == 'doj_radio' then 
            exports["rp-radio"]:GivePlayerAccessToFrequency(5)
            menu2.close()
            TriggerServerEvent('wp_items:removeScanner')
        elseif data2.current.value == 'dot_radio' then 
            exports["rp-radio"]:GivePlayerAccessToFrequency(6)
            menu2.close()
            TriggerServerEvent('wp_items:removeScanner')
        end

        Citizen.Wait(300000)

        exports["rp-radio"]:RemovePlayerAccessToFrequency(1)
        exports["rp-radio"]:RemovePlayerAccessToFrequency(2)
        exports["rp-radio"]:RemovePlayerAccessToFrequency(3)
        exports["rp-radio"]:RemovePlayerAccessToFrequency(4)
        exports["rp-radio"]:RemovePlayerAccessToFrequency(5)
        exports["rp-radio"]:RemovePlayerAccessToFrequency(6)

    end, function(data2, menu2)
        menu2.close()
    end)
end)

RegisterNetEvent('wp_items:carwashkit')
AddEventHandler('wp_items:carwashkit', function(source)
    local playerPed = PlayerPedId()
 
    local coords    = GetEntityCoords(playerPed)
    local _source = source

    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

        local vehicle = nil

        if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
        else
            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
        end

        if DoesEntityExist(vehicle) and not IsPedInAnyVehicle(playerPed) then
            TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
            TriggerEvent("mythic_progbar:client:progress", {
                name = "wash_car_kit",
                duration = 10000,
                label = "Washing...",
                useWhileDead = false,
                canCancel = true,
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
            }, function(status)
                if not status then
                    TriggerServerEvent('wp_items:removeCarwashKit')
                    exports['mythic_notify']:SendAlert('inform', 'You used a car wash kit.', 2500)
                    SetVehicleDirtLevel(vehicle, 0)
                    ClearPedTasksImmediately(playerPed)
                    exports['mythic_notify']:SendAlert('inform', 'Vehicle cleaned.', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
                end
            end)
        elseif IsPedInAnyVehicle(playerPed) then
            ESX.ShowNotification('You need to be outside of the vehicle.')
        end
    else
        exports['mythic_notify']:SendAlert('inform', 'No car near-by!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
    end
    
end)

RegisterNetEvent('wp_items:Armor')
AddEventHandler('wp_items:Armor', function(source)
	local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(PlayerPedId(-1), true) then
        TriggerEvent("mythic_progbar:client:progress", {
            name = "Armor",
            duration = 10000,
            label = "Putting on light vest...",
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false,
            },
        }, function(status)
            if not status then
                AddArmourToPed(playerPed, 50)
                TriggerServerEvent('RemoveArmor')
            end
        end)

    else
        TriggerEvent("mythic_progbar:client:progress", {
            name = "Armor",
            duration = 10000,
            label = "Putting on light vest...",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "clothingtie",
                anim = "try_tie_neutral_a",
                flags = 48,
            },
        }, function(status)
            if not status then
                AddArmourToPed(playerPed, 50)
                TriggerServerEvent('RemoveArmor')
                StopAnimTask(playerPed, "clothingtie", "try_tie_neutral_a", 1.0)
            end
        end)
    end
end)


RegisterNetEvent('wp_items:Bandage')
AddEventHandler('wp_items:Bandage', function(source)
	local playerPed = PlayerPedId()
	local health = GetEntityHealth(playerPed)
	local maxHealth = GetEntityMaxHealth(playerPed)
	local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))

    if IsPedInAnyVehicle(PlayerPedId(-1), true) then
        TriggerEvent("mythic_progbar:client:progress", {
            name = "Bandage",
            duration = 4000,
            label = "Using A Bandage...",
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false,
            },
        }, function(status)
            if not status then
                SetEntityHealth(playerPed, newHealth)
                TriggerServerEvent('RemoveBandage')
            end
        end)

    else
        TriggerEvent("mythic_progbar:client:progress", {
            name = "Bandage",
            duration = 4000,
            label = "Using A Bandage...",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "amb@world_human_clipboard@male@idle_a",
                anim = "idle_c",
                flags = 48,
            },
            prop = {
                model = "prop_ld_health_pack",
            }
        }, function(status)
            if not status then
                SetEntityHealth(playerPed, newHealth)
                TriggerServerEvent('RemoveBandage')
                StopAnimTask(playerPed, "amb@world_human_clipboard@male@idle_a", "idle_c", 1.0)
            end
        end)
    end

end)

RegisterNetEvent('wp_items:LaceCoke')
AddEventHandler('wp_items:LaceCoke', function(source)
	local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(PlayerPedId(-1), true) then
        TriggerEvent("mythic_progbar:client:progress", {
            name = "LaceCoke",
            duration = 4000,
            label = "Snorting Coke...",
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false,
            },
        }, function(status)
            if not status then
                TriggerEvent('Reload_Death:EyesDilated')
                TriggerServerEvent('RemoveVice')
                SetTimecycleModifier("BlackOut")
                Citizen.Wait(10000)
                SetTimecycleModifier("Glasses_BlackOut")
                Citizen.Wait(30000)
                SetTimecycleModifier("BlackOut")
                Citizen.Wait(5000)
                SetTimecycleModifier("Glasses_BlackOut")
                Citizen.Wait(30000)
                SetTimecycleModifier("BlackOut")
                Citizen.Wait(2000)
                SetEntityHealth(playerPed, 0)
                Citizen.Wait(360000)
                SetTimecycleModifier("default")
            end
        end)

    else
        TriggerEvent("mythic_progbar:client:progress", {
            name = "LaceCoke",
            duration = 4000,
            label = "Snorting Coke...",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "mp_suicide",
                anim = "pill",
                flags = 48,
            },
        }, function(status)
            if not status then
                TriggerEvent('Reload_Death:EyesDilated')
                TriggerServerEvent('RemoveVice')
                StopAnimTask(playerPed, "mp_suicide", "pill", 1.0)
                SetTimecycleModifier("BlackOut")
                Citizen.Wait(10000)
                SetTimecycleModifier("Glasses_BlackOut")
                Citizen.Wait(30000)
                SetTimecycleModifier("BlackOut")
                Citizen.Wait(5000)
                SetTimecycleModifier("Glasses_BlackOut")
                Citizen.Wait(30000)
                SetTimecycleModifier("BlackOut")
                Citizen.Wait(2000)
                SetEntityHealth(playerPed, 0)
                Citizen.Wait(360000)
                SetTimecycleModifier("default")
            end
        end)
    end

end)

RegisterNetEvent('wp_items:Oxy')
AddEventHandler('wp_items:Oxy', function(source)
	local playerPed = PlayerPedId()
	local health = GetEntityHealth(playerPed)
	local maxHealth = GetEntityMaxHealth(playerPed)
	local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 6))
    if IsPedInAnyVehicle(PlayerPedId(-1), true) then
        TriggerEvent("mythic_progbar:client:progress", {
            name = "Oxy",
            duration = 4000,
            label = "Poppin Oxy...",
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false,
            },
        }, function(status)
            if not status then
                SetEntityHealth(playerPed, newHealth)
                TriggerServerEvent('RemoveOxy')
            end
        end)
    else
        TriggerEvent("mythic_progbar:client:progress", {
            name = "Oxy",
            duration = 3000,
            label = "Poppin Oxy...",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "mp_suicide",
                anim = "pill",
                flags = 48,
            },
        }, function(status)
            if not status then
                SetEntityHealth(playerPed, newHealth)
                TriggerServerEvent('RemoveOxy')
                StopAnimTask(playerPed, "mp_suicide", "pill", 1.0)
            end
        end)
    end

end)


RegisterNetEvent('wp_items:Joint')
AddEventHandler('wp_items:Joint', function(source)
	local playerPed = PlayerPedId()
	local health = GetEntityHealth(playerPed)
	local maxHealth = GetEntityMaxHealth(playerPed)
	local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 16))
    if IsPedInAnyVehicle(PlayerPedId(-1), true) then
        TriggerEvent("mythic_progbar:client:progress", {
            name = "Joint",
            duration = 4000,
            label = "Smoking A Joint...",
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            },
        }, function(status)
            if not status then
                TriggerEvent('Reload_Death:SmellMarijuana')
                SetEntityHealth(playerPed, newHealth)
                TriggerServerEvent('RemoveJoint')
                StartScreenEffect("DrugsMichaelAliensFight", 3.0, 0)
	            Citizen.Wait(12000)
	            StopScreenEffect("DrugsMichaelAliensFight")
            end
        end)
    else
        TriggerEvent("mythic_progbar:client:progress", {
            name = "Joint",
            duration = 4000,
            label = "Smoking A Joint...",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "amb@world_human_smoking_pot@male@base",
                anim = "base",
            },
            prop = {
                model = "prop_sh_joint_01",
            }
        }, function(status)
            if not status then
                TriggerEvent('Reload_Death:SmellMarijuana')
                SetEntityHealth(playerPed, newHealth)
                TriggerServerEvent('RemoveJoint')
                DeleteObject(prop)
                StopAnimTask(playerPed, "amb@world_human_smoking_pot@male@base", "base", 1.0)
                StartScreenEffect("DrugsMichaelAliensFight", 3.0, 0)
	            Citizen.Wait(12000)
	            StopScreenEffect("DrugsMichaelAliensFight")
            end
        end)
    end

end)


--Police Related Stuff/Items

RegisterNetEvent('wp_items:Ifak')
AddEventHandler('wp_items:Ifak', function(source)
	local playerPed = PlayerPedId()
	local health = GetEntityHealth(playerPed)
	local maxHealth = GetEntityMaxHealth(playerPed)
	local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 6))

    if IsPedInAnyVehicle(PlayerPedId(-1), true) then
        TriggerEvent("mythic_progbar:client:progress", {
            name = "Ifak",
            duration = 4000,
            label = "Using First Aid Kit",
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false,
            },
        }, function(status)
            if not status then
                SetEntityHealth(playerPed, newHealth)
                TriggerServerEvent('RemoveIfak')
            end
        end)
    else
        TriggerEvent("mythic_progbar:client:progress", {
            name = "Ifak",
            duration = 4000,
            label = "Using First Aid Kit",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "amb@world_human_clipboard@male@idle_a",
                anim = "idle_c",
                flags = 48,
            },
            prop = {
                model = "prop_ld_health_pack",
            }
        }, function(status)
            if not status then
                SetEntityHealth(playerPed, newHealth)
                TriggerServerEvent('RemoveIfak')
                StopAnimTask(playerPed, "amb@world_human_clipboard@male@idle_a", "idle_c", 1.0)
            end
        end)
    end

end)

RegisterNetEvent('wp_items:PdVest')
AddEventHandler('wp_items:PdVest', function(source)
	local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(PlayerPedId(-1), true) then
        TriggerEvent("mythic_progbar:client:progress", {
            name = "ArmorPolice",
            duration = 10000,
            label = "Putting on vest...",
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false,
            },
        }, function(status)
            if not status then
                AddArmourToPed(playerPed, 75)
                TriggerServerEvent('RemovePdVest')
            end
        end)
    else
        TriggerEvent("mythic_progbar:client:progress", {
            name = "ArmorPolice",
            duration = 10000,
            label = "Putting on vest...",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "clothingtie",
                anim = "try_tie_neutral_a",
                flags = 48,
            },
        }, function(status)
            if not status then
                AddArmourToPed(playerPed, 75)
                TriggerServerEvent('RemovePdVest')
                StopAnimTask(playerPed, "clothingtie", "try_tie_neutral_a", 1.0)
            end
        end)
    end
end)

RegisterNetEvent('wp_items:SwatVest')
AddEventHandler('wp_items:SwatVest', function(source)
	local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(PlayerPedId(-1), true) then
        TriggerEvent("mythic_progbar:client:progress", {
            name = "ArmorSwat",
            duration = 10000,
            label = "Putting on heavy vest...",
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false,
            },
        }, function(status)
            if not status then
                AddArmourToPed(playerPed, 100)
                TriggerServerEvent('RemoveSwatVest')
            end
        end)
    else
        TriggerEvent("mythic_progbar:client:progress", {
            name = "ArmorSwat",
            duration = 10000,
            label = "Putting on heavy vest...",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "clothingtie",
                anim = "try_tie_neutral_a",
                flags = 48,
            },
        }, function(status)
            if not status then
                AddArmourToPed(playerPed, 100)
                TriggerServerEvent('RemoveSwatVest')
                StopAnimTask(playerPed, "clothingtie", "try_tie_neutral_a", 1.0)
            end
        end)
    end
end)