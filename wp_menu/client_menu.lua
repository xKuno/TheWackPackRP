ESX          = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

-- Menu state
local showMenu = false

-- Keybind Lookup table
local keybindControls = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18, ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182, ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81, ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178, ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118, ["G"] = 113,
}

local MAX_MENU_ITEMS = 7

-- Main thread
Citizen.CreateThread(function()
    local keyBind = "F1"
    while true do
        Citizen.Wait(0)
        if IsControlPressed(1, keybindControls[keyBind]) and GetLastInputMethod(2) and showMenu then
            showMenu = false
            SetNuiFocus(false, false)
            --print('hideMenu')
        end
        if IsControlPressed(1, keybindControls[keyBind]) and GetLastInputMethod(2) and not IsControlPressed(1, keybindControls['F2']) then
            --print('showMenu')
            showMenu = true
            local enabledMenus = {}
            for _, menuConfig in ipairs(rootMenuConfig) do
                if menuConfig:enableMenu() then
                    local dataElements = {}
                    local hasSubMenus = false
                    if menuConfig.subMenus ~= nil and #menuConfig.subMenus > 0 then
                        hasSubMenus = true
                        local previousMenu = dataElements
                        local currentElement = {}
                        for i = 1, #menuConfig.subMenus do
                            -- if newSubMenus[menuConfig.subMenus[i]] ~= nil and newSubMenus[menuConfig.subMenus[i]].enableMenu ~= nil and not newSubMenus[menuConfig.subMenus[i]]:enableMenu() then
                            --     goto continue
                            -- end
                            currentElement[#currentElement+1] = newSubMenus[menuConfig.subMenus[i]]
                            currentElement[#currentElement].id = menuConfig.subMenus[i]
                            currentElement[#currentElement].enableMenu = nil

                            if i % MAX_MENU_ITEMS == 0 and i < (#menuConfig.subMenus - 1) then
                                previousMenu[MAX_MENU_ITEMS + 1] = {
                                    id = "_more",
                                    title = "More",
                                    icon = "#more",
                                    items = currentElement
                                }
                                previousMenu = currentElement
                                currentElement = {}
                            end
                            --::continue::
                        end
                        if #currentElement > 0 then
                            previousMenu[MAX_MENU_ITEMS + 1] = {
                                id = "_more",
                                title = "More",
                                icon = "#more",
                                items = currentElement
                            }
                        end
                        dataElements = dataElements[MAX_MENU_ITEMS + 1].items

                    end
                    enabledMenus[#enabledMenus+1] = {
                        id = menuConfig.id,
                        title = menuConfig.displayName,
                        functionName = menuConfig.functionName,
                        icon = menuConfig.icon,
                    }
                    if hasSubMenus then
                        enabledMenus[#enabledMenus].items = dataElements
                    end
                end
            end
            SendNUIMessage({
                state = "show",
                resourceName = GetCurrentResourceName(),
                data = enabledMenus,
                menuKeyBind = keyBind
            })
            SetCursorLocation(0.5, 0.5)
            SetNuiFocus(true, true)

            -- Play sound
            PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)


            while showMenu == true do Citizen.Wait(100) end
            Citizen.Wait(100)
            while IsControlPressed(1, keybindControls[keyBind]) and GetLastInputMethod(2) do Citizen.Wait(100) end
        end
    end
end)
-- Callback function for closing menu
RegisterNUICallback('closemenu', function(data, cb)
    -- Clear focus and destroy UI
    showMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        state = 'destroy'
    })

    -- Play sound
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)

    -- Send ACK to callback function
    cb('ok')
end)

-- Callback function for when a slice is clicked, execute command
RegisterNUICallback('triggerAction', function(data, cb)
    -- Clear focus and destroy UI
    showMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        state = 'destroy'
    })

    -- Play sound
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)

    -- Run command
    --ExecuteCommand(data.action)
    --print(json.encode(data))
    TriggerEvent(data.action, data.parameters)

    -- Send ACK to callback function
    cb('ok')
end)

RegisterCommand('closef1', function(source, args)
    showMenu = false
    SetNuiFocus(false, false)
end)

RegisterNetEvent("menu:menuexit")
AddEventHandler("menu:menuexit", function()
    showMenu = false
    SetNuiFocus(false, false)
end)

RegisterNetEvent('rmenu:Cam:ToggleCam')
AddEventHandler('rmenu:Cam:ToggleCam', function()
    TriggerServerEvent('Cam:ToggleCamServer')
end)

RegisterNetEvent('rmenu:Mic:ToggleBMic')
AddEventHandler('rmenu:Mic:ToggleBMic', function()
    TriggerServerEvent('Mic:ToggleBMicServer')
end)

RegisterNetEvent('rmenu:Mic:ToggleMic')
AddEventHandler('rmenu:Mic:ToggleMic', function()
    TriggerServerEvent('Mic:ToggleMicServer')
end)

RegisterNetEvent('healf1')
AddEventHandler('healf1', function()
	TriggerServerEvent('esx_ambulancejob:healserver')
end)

RegisterNetEvent('dot:repair')
AddEventHandler('dot:repair', function()
	TriggerServerEvent('esx_mecanojob:repairserver')
end)

RegisterNetEvent('loaf:keys')
AddEventHandler('loaf:keys', function()
	TriggerServerEvent('loaf_keysystem:menuserver')
end)

RegisterNetEvent('dot:clean')
AddEventHandler('dot:clean', function()
	TriggerServerEvent('esx_mecanojob:cleanserver')
end)

RegisterNetEvent('police:removeMask')
AddEventHandler('police:removeMask', function()
    local target, distance = ESX.Game.GetClosestPlayer()
    local target_id = GetPlayerServerId(target)
	if target ~= -1 and distance <= 3.0 then

        TriggerServerEvent('police:removeMaskServer', target_id)
    else
        exports['mythic_notify']:SendAlert('inform', 'No players nearby.', 2500)
    end
end)

RegisterNetEvent('police:removeMaskTarget')
AddEventHandler('police:removeMaskTarget', function(targetid)
    SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)
    SetPedPropIndex(PlayerPedId(), 0, 8, 0, 0)
    SetPedPropIndex(PlayerPedId(), 1, 0, 0, 0)
end)

RegisterNetEvent('ems:removeClothes')
AddEventHandler('ems:removeClothes', function()
    local target, distance = ESX.Game.GetClosestPlayer()
    local target_id = GetPlayerServerId(target)
	if target ~= -1 and distance <= 3.0 then

        TriggerServerEvent('ems:removeClothesServer', target_id)
    else
        exports['mythic_notify']:SendAlert('inform', 'No players nearby.', 2500)
    end
end)

RegisterNetEvent('ems:removeClothesTarget')
AddEventHandler('ems:removeClothesTarget', function(targetid)
    SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)
    SetPedComponentVariation(PlayerPedId(), 3, 20, 0, 0)
    SetPedComponentVariation(PlayerPedId(), 4, 92, 0, 0)
    SetPedComponentVariation(PlayerPedId(), 5, 0, 0, 0)
    SetPedComponentVariation(PlayerPedId(), 6, 45, 0, 0)
    SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 0)
    SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 0)
    SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 0)
    SetPedComponentVariation(PlayerPedId(), 11, 15, 0, 0)

    
    SetPedPropIndex(PlayerPedId(), 0, 8, 0, 0)
    SetPedPropIndex(PlayerPedId(), 1, 0, 0, 0)
end)

RegisterNetEvent('police:gsrtestf1')
AddEventHandler('police:gsrtestf1', function()
    local player, distance = ESX.Game.GetClosestPlayer()

    if distance ~= -1 and distance <= 3.0 then
        TriggerServerEvent('esx_gsr:Check', GetPlayerServerId(player))
    else
        exports['mythic_notify']:SendAlert('inform', 'No players nearby.', 2500)
    end
end)

RegisterNetEvent('rmenu:mdt:hotKeyOpen')
AddEventHandler('rmenu:mdt:hotKeyOpen', function(job)
    TriggerServerEvent('mdt:hotKeyOpen')
end)

RegisterNetEvent("rmenu:fingerprintsearch")
AddEventHandler("rmenu:fingerprintsearch", function()
    local player, distance = ESX.Game.GetClosestPlayer()
    if distance ~= -1 and distance <= 3 then
        TriggerServerEvent('mdt:getFingerprintInfo', GetPlayerServerId(player))
        Citizen.Wait(200)
        TriggerServerEvent('mdt:hotKeyOpen')
    else
        TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No player nearby.'})
    end
end)

RegisterNetEvent('rmenu:nearbyPlateCheck')
AddEventHandler('rmenu:nearbyPlateCheck', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = nil
    if IsPedInAnyVehicle(playerPed, false) then 
        vehicle = GetVehiclePedIsIn(playerPed, false) 
    elseif not IsPedInAnyVehicle(playerPed, false) then
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end
    if vehicle ~= 0 then
        local plate = GetVehicleNumberPlateText(vehicle)
        TriggerServerEvent('mdt:performVehicleSearchInFront', plate)
    else
        TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'No vehicle nearby.'})
    end
end)

RegisterNetEvent('rmenu:doj:hotKeyOpen')
AddEventHandler('rmenu:doj:hotKeyOpen', function(job)
    TriggerServerEvent('doj:hotKeyOpen')
end)

RegisterNetEvent('rmenu:ems:hotKeyOpen')
AddEventHandler('rmenu:ems:hotKeyOpen', function(job)
    TriggerServerEvent('ems:hotKeyOpen')
end)

RegisterNetEvent('rmenu:dispatch:hotKeyOpen')
AddEventHandler('rmenu:dispatch:hotKeyOpen', function(job)
    TriggerServerEvent('dispatch:hotKeyOpen')
end)

RegisterNetEvent('rmenu:jsfour-idcard:open')
AddEventHandler('rmenu:jsfour-idcard:open', function(job)
    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
end)

RegisterNetEvent('rmenu:jsfour-idcard:give')
AddEventHandler('rmenu:jsfour-idcard:give', function(job)
    local player, distance = ESX.Game.GetClosestPlayer()

    if distance ~= -1 and distance <= 3.0 then
        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
    else
        exports['mythic_notify']:SendAlert('inform', 'No players nearby.', 2500)
    end
end)

RegisterNetEvent('rmenu:jsfour-idcard:take')
AddEventHandler('rmenu:jsfour-idcard:take', function(job)
    local player, distance = ESX.Game.GetClosestPlayer()

    if distance ~= -1 and distance <= 3.0 then
        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(player), GetPlayerServerId(PlayerId()))
    else
        exports['mythic_notify']:SendAlert('inform', 'No players nearby.', 2500)
    end
end)

RegisterNetEvent('rmenu:fakeid:open')
AddEventHandler('rmenu:fakeid:open', function(job)
    TriggerServerEvent('fakeid:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
end)

RegisterNetEvent('fakeid:give')
AddEventHandler('fakeid:give', function(job)
    local player, distance = ESX.Game.GetClosestPlayer()

    if distance ~= -1 and distance <= 3.0 then
        TriggerServerEvent('fakeid:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
    else
        exports['mythic_notify']:SendAlert('inform', 'No players nearby.', 2500)
    end
end)

local handsup = false

RegisterNetEvent('handsup:f1')
AddEventHandler('handsup:f1', function()
    local playerPed = PlayerPedId()
    RequestAnimDict("missminuteman_1ig_2")
    while not HasAnimDictLoaded("missminuteman_1ig_2") do
        Citizen.Wait(100)
    end
    if not handsup then
        handsup = true
        TaskPlayAnim(playerPed, "missminuteman_1ig_2", "handsup_base", 4.0, -8, -1, 49, 0, 0, 0, 0)
        SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"))
        
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)
                if handsup and IsEntityPlayingAnim(playerPed, "missminuteman_1ig_2", "handsup_base", 3) ~= 1 then
                    while (not HasAnimDictLoaded("missminuteman_1ig_2")) do Citizen.Wait(0) end
                    TaskPlayAnim(playerPed, "missminuteman_1ig_2", "handsup_base", 2.0, 2.0, 50000000, 51, 0, false, false, false)
                end
            end
        end)

    elseif handsup then
        handsup = false
        ClearPedSecondaryTask(playerPed)
    end
end)

RegisterNetEvent('radio:F1')
AddEventHandler('radio:F1', function(state)
    if state == 1 then -- Police
        exports["rp-radio"]:GivePlayerAccessToFrequency(1)
        TriggerEvent('Radio:F1:Main', 1)
        exports['mythic_notify']:SendAlert('inform', 'Radio 1 joined.', 2500)
    elseif state == 2 then -- SWAT
        TriggerEvent('Radio:F1:Main', 2)
        exports['mythic_notify']:SendAlert('inform', 'Radio 2 joined.', 2500)
    elseif state == 3 then -- CID
        TriggerEvent('Radio:F1:Main', 3)
        exports['mythic_notify']:SendAlert('inform', 'Radio 3 joined.', 2500)
    elseif state == 4 then -- EMS
        exports["rp-radio"]:GivePlayerAccessToFrequency(4)
        TriggerEvent('Radio:F1:Main', 4)
        exports['mythic_notify']:SendAlert('inform', 'Radio 4 joined.', 2500)
    elseif state == 5 then -- DOJ
        exports["rp-radio"]:GivePlayerAccessToFrequency(5)
        TriggerEvent('Radio:F1:Main', 5)
        exports['mythic_notify']:SendAlert('inform', 'Radio 5 joined.', 2500)
    elseif state == 6 then -- DOT
        exports["rp-radio"]:GivePlayerAccessToFrequency(6)
        TriggerEvent('Radio:F1:Main', 6)
        exports['mythic_notify']:SendAlert('inform', 'Radio 6 joined.', 2500)
    end
end)

RegisterNetEvent('medic:rollInjury')
AddEventHandler('medic:rollInjury', function(state)
    if state == 'gsw' then
        local GSWMath = math.random(1, 6)
        local GSWText = {
            [1] = {text = 'The bullet has grazed the skin.'},
            [2] = {text = 'The bullet has gone skin deep.'},
            [3] = {text = 'Bullet has pierced the skin and is lodged between two bones.'},
            [4] = {text = 'Bullet hit a bone and the bone has fragmented.'},
            [5] = {text = 'Bullet hit a minor artery.'},
            [6] = {text = 'Bullet hit a major artery.'},
        }
        exports['mythic_notify']:SendAlert('inform', GSWText[GSWMath].text, 10000)

    elseif state == 'stab' then
        local stabMath = math.random(1, 3)
        local stabText = {
            [1] = {text = 'Knife has pierced a organ.'},
            [2] = {text = 'Knife pierced the skin leading to excessive bleeding.'},
            [3] = {text = 'Horizontal slash across the skin.'},
        }
        exports['mythic_notify']:SendAlert('inform', stabText[stabMath].text, 10000)

    elseif state == 'fall' then
        local fallMath = math.random(1, 4)
        local fallText = {
            [1] = {text = 'The patient has excessive bleeding from the head.'},
            [2] = {text = 'The patient has a dislocated leg and minor bleeding from the head.'},
            [3] = {text = 'The patient has a dislocated leg.'},
            [4] = {text = 'The patient has a twisted ankle.'},
        }
        exports['mythic_notify']:SendAlert('inform', fallText[fallMath].text, 10000)

    elseif state == 'taser' then
        local taserMath = math.random(1, 2)
        local taserText = {
            [1] = {text = 'Prongs have pierced the skin and the patient has a irregular heartbeat.'},
            [2] = {text = 'Prongs have pierced the skin.'},
        }
        exports['mythic_notify']:SendAlert('inform', taserText[taserMath].text, 10000)

    elseif state == 'carCrash' then
        local carCrashMath = math.random(1, 4)
        local carCrashText = {
            [1] = {text = 'Bleeding from the head possible concussion along with road rash and lacerations across the persons back.'},
            [2] = {text = 'Road rash and lacerations across the persons back along with whiplash to the neck.'},
            [3] = {text = 'Lacerations across the persons back.'},
            [4] = {text = 'Road rash across the persons back.'},
        }
        exports['mythic_notify']:SendAlert('inform', carCrashText[carCrashMath].text, 10000)
    end
end)

RegisterNetEvent("shoes:steal")
AddEventHandler("shoes:steal", function()
    local player, distance = ESX.Game.GetClosestPlayer()
    local searchPlayerPed = PlayerPedId(player)

    if distance ~= -1 and distance <= 3.0 then
        if IsEntityPlayingAnim(searchPlayerPed, 'missminuteman_1ig_2', 'handsup_base', 3) or IsEntityPlayingAnim(searchPlayerPed, 'dead', 'dead_a', 3) or IsEntityPlayingAnim(searchPlayerPed, 'mp_arresting', 'idle', 3) or IsEntityDead(searchPlayerPed) or GetEntityHealth(searchPlayerPed) <= 0 then
            loadAnimDict('random@domestic')
            TaskTurnPedToFaceEntity(PlayerPedId(), searchPlayerPed, -1)
            TaskPlayAnim(PlayerPedId(),'random@domestic', 'pickup_low',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
            Citizen.Wait(1600)
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent('shoes:steal:removeShoesServer', player)
        end
    else
        exports['mythic_notify']:SendAlert('inform', 'No players nearby.', 2500)
    end
end)

RegisterNetEvent('shoes:steal:removeShoesTarget')
AddEventHandler('shoes:steal:removeShoesTarget', function(targetid)
    SetPedComponentVariation(PlayerPedId(), 6, 45, 0, 0)
end)