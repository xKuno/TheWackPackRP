local ESX = nil
local hacking = false
local cops = 0
local PcHack = { ['x'] = -631.31,['y'] = -230.04,['z'] = 38.06,['h'] = 219, ['info'] = 'HackerMan3000' }
local Cases = {
    [1] = {x = -626.85, y = -235.39, z = 38.06, isSearched = false},
    [2] = {x = -625.65, y = -234.59, z = 38.06, isSearched = false},
    [3] = {x = -626.85, y = -233.08, z = 38.06, isSearched = false},
    [4] = {x = -628.02, y = -233.95, z = 38.06, isSearched = false},
    [5] = {x = -626.66, y = -238.52, z = 38.06, isSearched = false},
    [6] = {x = -625.6, y = -237.8, z = 38.06, isSearched = false},
    [7] = {x = -623.07, y = -232.93, z = 38.06, isSearched = false},
    [8] = {x = -620.18, y = -234.44, z = 38.06, isSearched = false},
    [9] = {x = -619.15, y = -233.63, z = 38.06, isSearched = false},
    [10] = {x = -620.21, y = -233.38, z = 38.06, isSearched = false},
    [11] = {x = -617.52, y = -230.55, z = 38.06, isSearched = false},
    [12] = {x = -618.33, y = -229.44, z = 38.06, isSearched = false},
    [13] = {x = -619.63, y = -230.43, z = 38.06, isSearched = false},
    [14] = {x = -621.11, y = -228.51, z = 38.06, isSearched = false},
    [15] = {x = -619.63, y = -227.65, z = 38.06, isSearched = false},
    [16] = {x = -620.49, y = -226.53, z = 38.06, isSearched = false},
    [17] = {x = -623.84, y = -227.09, z = 38.06, isSearched = false},
    [18] = {x = -625.06, y = -227.9, z = 38.06, isSearched = false},
    [19] = {x = -624.01, y = -228.19, z = 38.06, isSearched = false},
    [20] = {x = -624.42, y = -231.14, z = 38.06, isSearched = false},
}
local ped = PlayerPedId(-1)


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



--- 3D text


Citizen.CreateThread(function()

    while true do

	    Citizen.Wait(1)
	    local HackSpot = #(GetEntityCoords(PlayerPedId()) - vector3(PcHack["x"],PcHack["y"],PcHack["z"]))
        if HackSpot < 1.6 and not hacking and not Hacked and not BeingRobbed then

            DrawText3Ds(PcHack["x"],PcHack["y"],PcHack["z"], "~w~Press ~g~E~s~ To ~r~Start Hacking~s~") 
            if IsControlJustReleased(0,38) then
                local cops = exports.esx_scoreboard:GetPlayerCounts().police
                if cops >= Config.CopsRequired then
                    hacking = true
                    TriggerEvent("mythic_progbar:client:progress", {
                        name = "H4CKER",
                        duration = 10000,
                        label = "Hacking Into PC",
                        useWhileDead = false,
                        canCancel = false,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        },
                        animation = {
                            animDict = "mp_fbi_heist",
                            anim = "loop",
                            flags = 9,
                        },
                    }, function(status)
                        if not status then
                            hacking = false
                            StopAnimTask(ped, "mp_fbi_heist", "loop", 1.0)
                            TriggerServerEvent("Jstore:RemoveCard")
                            exports['wp_dispatch']:addCall("10-90", "Jewelry Is Being Robbed", {
                                {icon="fas fa-road", info = "Partola Drive, Rockford Hills"}
                            }, {-624.5538, -233.2352, 38.04175}, "police", 3000, 118, 1 )
                            exports['wp_dispatch']:addCall("10-90", "Jewelry Is Being Robbed", {
                                {icon="fas fa-road", info = "Partola Drive, Rockford Hills"}
                            }, {-624.5538, -233.2352, 38.04175}, "dispatch", 3000, 118, 1 )

                        end
                    end)
                    Citizen.Wait(10000)
                else
                    exports['mythic_notify']:SendAlert('inform', 'Need more cops.', 2500)
                end
            end
        end
    end

end)

RegisterNetEvent("Jstore:ResetTimer")
AddEventHandler("Jstore:ResetTimer", function()
    Hacked = true
    BeingRobbed = true
    if BeingRobbed and Hacked then
        TriggerServerEvent("Jstore:StartServerTimer")
    end
end)

RegisterNetEvent("Jstore:TotalReset")
AddEventHandler("Jstore:TotalReset", function(caseid, status)
    Hacked = false
    BeingRobbed = false
    Cases[caseid].isSearched = status
end)


RegisterNetEvent("Jstore:CaseHit")
AddEventHandler("Jstore:CaseHit", function(caseid, status)
    Cases[caseid].isSearched = status
end)

RegisterNetEvent("Jstore:BeingRobbed")
AddEventHandler("Jstore:BeingRobbed", function()
    CanCases = Cases 
    Citizen.CreateThread(function()


        while true do
    
            Citizen.Wait(1)
            local ped = PlayerPedId()
            if BeingRobbed then
                for i=1,#CanCases do
                    if (GetDistanceBetweenCoords(CanCases[i]["x"],CanCases[i]["y"],CanCases[i]["z"], GetEntityCoords(PlayerPedId())) < 1.4) and not CanCases[i]['isSearched'] then
                        if IsPedArmed(ped, 4) then 
                            DrawText3Ds(CanCases[i]["x"],CanCases[i]["y"],CanCases[i]["z"], "~w~Press ~g~E~s~ To ~r~Smash Glass~s~")                         
                            if IsControlJustReleased(0,38) then
                                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3, 'robberyglassbreak', 0.5)
                                TriggerEvent("mythic_progbar:client:progress", {
                                    name = "SM4SHER",
                                    duration = 3000,
                                    label = "Smashing Glass....",
                                    useWhileDead = false,
                                    canCancel = false,
                                    controlDisables = {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    },
                                    animation = {
                                        animDict = "missheist_jewel",
                                        anim = "fp_smash_case_d",
                                        flags = 48,
                                    },
                                }, function(status)
                                    if not status then
                                        if math.random(1,10) >= 5 then
                                            StopAnimTask(ped, "missheist_jewel", "fp_smash_case_d", 1.0)
                                            TriggerServerEvent("Jstore:CaseUpdate", i)
                                            TriggerServerEvent("Jstore:Reward")
                                        else
                                            exports['mythic_notify']:SendAlert('inform', 'You failed to break the glass!', 2500, { ['background-color'] = '#9c001f', ['color'] = '#000000' })
                                        end
                                    end
                                end)
                                Citizen.Wait(2000)
                            end
                        end
                    end
                end
            end
    
        end
    
    end)
end)

local doorUnlocked = false
local drill_status = nil
local drillObject = nil
local hasDrill = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2500)
        if not isOpen() and not doorUnlocked then
            local leftdoor = GetClosestObjectOfType(-631.9554, -236.3333, 38.20653, 11.0, GetHashKey("p_jewel_door_l"), false, false, false)
            local rightdoor = GetClosestObjectOfType(-631.9554, -236.3333, 38.20653, 11.0, GetHashKey("p_jewel_door_r1"), false, false, false)
            FreezeEntityPosition(leftdoor, true)
            FreezeEntityPosition(rightdoor, true)
        elseif isOpen() or doorUnlocked then
            local leftdoor = GetClosestObjectOfType(-631.9554, -236.3333, 38.20653, 11.0, GetHashKey("p_jewel_door_l"), false, false, false)
            local rightdoor = GetClosestObjectOfType(-631.9554, -236.3333, 38.20653, 11.0, GetHashKey("p_jewel_door_r1"), false, false, false)
            FreezeEntityPosition(leftdoor, false)
            FreezeEntityPosition(rightdoor, false)
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not isOpen() and not doorUnlocked then
            if (GetDistanceBetweenCoords(-631.25, -237.4333, 38.20653, GetEntityCoords(PlayerPedId())) < 1.4) then
                DrawText3Ds(-631.25, -237.4333, 38.20653, "~w~Press ~g~E~s~ To ~r~Start Drilling~s~")                      
                if IsControlJustReleased(0,38) and exports.esx_scoreboard:GetPlayerCounts().police >= Config.CopsRequired then
                    local playerPed = PlayerPedId()

                    ESX.TriggerServerCallback('anthony_jewl_store:getDrill', function(hasDrill)
                        if hasDrill then

                            local dict = "anim@heists@fleeca_bank@drilling"
                            RequestAnimDict(dict)
                            drillObject = CreateObject(GetHashKey('hei_prop_heist_drill'), GetEntityCoords(playerPed), 1, 1, 1)
                            AttachEntityToEntity(drillObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
                            while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
                            if not IsEntityPlayingAnim(playerPed, dict, 'drill_straight_idle', 3) then
                                TaskPlayAnim(playerPed, dict, "drill_straight_idle", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
                            
                                SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"),true)
                                RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", 0)
                                RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", 0)
                                RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", 0)
                                PlaySoundFromEntity(GetSoundId(), "Drill", drillObject, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
                                Citizen.Wait(100)
                                local particle_dict = "scr_fbi5a"
                                local particle_lib = "scr_bio_grille_cutting"
                                RequestNamedPtfxAsset(particle_dict)
                                while not HasNamedPtfxAssetLoaded(particle_dict) do
                                    Citizen.Wait(0)
                                end
                                SetPtfxAssetNextCall(particle_dict)
                                local effect = StartParticleFxLoopedOnEntity(particle_lib, drill_obj, 0.0, -0.6, 0.0, 0.0, 0.0, 0.0, 2.0, 0, 0, 0)
                                ShakeGameplayCam("ROAD_VIBRATION_SHAKE", 1.0)
                                TaskTurnPedToFaceCoord(playerPed, -631.25, -237.4333, 38.20653, 1000)
                            end

                            exports['wp_dispatch']:addCall("10-90", "Jewelry Is Being Robbed", {
                                {icon="fas fa-road", info = "Partola Drive, Rockford Hills"}
                            }, {-624.5538, -233.2352, 38.04175}, "police", 3000, 118, 1 )
                            exports['wp_dispatch']:addCall("10-90", "Jewelry Is Being Robbed", {
                                {icon="fas fa-road", info = "Partola Drive, Rockford Hills"}
                            }, {-624.5538, -233.2352, 38.04175}, "dispatch", 3000, 118, 1 )

                            TriggerEvent("Drilling:Start",function(drill_status)
                                if drill_status == 1 then
                                    DeleteEntity(drillObject)
                                    ClearPedTasks(playerPed)
                                    drillObject = nil
                                    StopSound(drill_sound)
                                    ReleaseSoundId(drill_sound)
                                    StopParticleFxLooped(effect, 0)
                                    StopGameplayCamShaking(true)
                                    exports['mythic_notify']:SendAlert('inform', 'You successfully drilled the lock!', 2500)

                                    doorUnlocked = true
                                    TriggerServerEvent('anthony_jewl_store:toggleDoorAll', 'true')
                                    drill_status = nil
                                    hasDrill = nil
                                elseif (drill_status == 3) then
                                    DeleteEntity(drillObject)
                                    ClearPedTasks(playerPed)
                                    drillObject = nil
                                    StopSound(drill_sound)
                                    ReleaseSoundId(drill_sound)
                                    StopParticleFxLooped(effect, 0)
                                    StopGameplayCamShaking(true)
                                    exports['mythic_notify']:SendAlert('inform', 'You stopped drilling!', 2500)
                    
                                    drill_status = nil
                                    hasDrill = nil
                                elseif (drill_status == 2) then
                                    DeleteEntity(drillObject)
                                    ClearPedTasks(playerPed)
                                    drillObject = nil
                                    StopSound(drill_sound)
                                    ReleaseSoundId(drill_sound)
                                    StopParticleFxLooped(effect, 0)
                                    StopGameplayCamShaking(true)
                                    exports['mythic_notify']:SendAlert('inform', 'You failed to drill the lock!', 2500)
                    
                                    drill_status = nil
                                    hasDrill = nil
                                end
                            end)
                        else
                            exports['mythic_notify']:SendAlert('inform', 'You need a drill.', 2500)
                        end
                    end)
                elseif IsControlJustReleased(0,38) and exports.esx_scoreboard:GetPlayerCounts().police < Config.CopsRequired then
                    exports['mythic_notify']:SendAlert('inform', 'Not enough police.', 2500)
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

function isOpen()
    local hour = GetClockHours()
    if hour > 8 and hour < 17 then
     return true
    end
end

RegisterNetEvent('anthony_jewl_store:toggleDoorAll:Client')
AddEventHandler('anthony_jewl_store:toggleDoorAll:Client', function(state)
    if state == 'false' then
        doorUnlocked = false
    elseif state == 'true' then
        doorUnlocked = true
    end
end)