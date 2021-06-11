ESX = nil

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- gas filling
DecorRegister("CurrentFuel", 3)
Fuel = 0
local gasStations = {
    -- {49.41872, 2778.793, 58.04395,600},
    -- {263.8949, 2606.463, 44.98339,600},
    -- {1039.958, 2671.134, 39.55091,900},
    -- {1207.26, 2660.175, 37.89996,900},
    -- {2539.685, 2594.192, 37.94488,1500},
    -- {2679.858, 3263.946, 55.24057,1500},
    -- {2005.055, 3773.887, 32.40393,1200},
    -- {1687.156, 4929.392, 42.07809,900},
    -- {1701.314, 6416.028, 32.76395,1200},
    -- {179.8573, 6602.839, 31.86817,600},
    -- {-94.46199, 6419.594, 31.48952,600},
    -- {-2554.996, 2334.402, 33.07803,600},
    -- {-1800.375, 802.236936619, 138.6512,600},
    -- {-1437.622, -276.7476, 46.20771,600},
    -- {-2096.243, -320.2867, 13.16857,600},
    -- {-724.6192, -935.1631, 19.21386,600},
    -- {-526.0198, -1211.003, 18.18483,600},
    -- {-70.21484, -1761.792, 29.53402,600},
    -- {265.6484,-1261.309, 29.29294,600},
    -- {819.6538,-1028.846, 26.40342,780},
    -- {1208.951,-1402.567, 35.22419,900},
    -- {1181.381,-330.8471, 69.31651,900},
    -- {620.8434, 269.1009, 103.0895,780},
    -- {2581.321, 362.0393, 108.4688,1500},
    -- {1785.363, 3330.372, 41.38188,1200},
    -- {-319.537, -1471.5116, 30.54118,600},
    -- {-66.58, -2532.56, 6.14, 400}
}

function getVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle

    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)   
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        
        offset = offset - 1

        if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 3000 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end
-- local showGasStations = false

-- RegisterNetEvent('CarPlayerHud:ToggleGas')
-- AddEventHandler('CarPlayerHud:ToggleGas', function()
--     showGasStations = not showGasStations
--    for _, item in pairs(gasStations) do
--         if not showGasStations then
--             if item.blip ~= nil then
--                 RemoveBlip(item.blip)
--             end
--         else
--             item.blip = AddBlipForCoord(item[1], item[2], item[3])
--             SetBlipSprite(item.blip, 361)
--             SetBlipScale(item.blip, 0.7)
--             SetBlipAsShortRange(item.blip, true)
--             BeginTextCommandSetBlipName("STRING")
--             AddTextComponentString("Gas")
--             EndTextCommandSetBlipName(item.blip)
--         end
--     end
-- end)

-- Citizen.CreateThread(function()
--     showGasStations = true
--     TriggerEvent('CarPlayerHud:ToggleGas')
-- end)

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function TargetVehicle()
    playerped = PlayerPedId()
    coordA = GetEntityCoords(playerped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    targetVehicle = getVehicleInDirection(coordA, coordB)
    return targetVehicle
end

-- function IsNearGasStations()
--     local location = {}
--     local hasFound = false
--     local pos = GetEntityCoords(PlayerPedId(), false)
--     for k,v in ipairs(gasStations) do
--         if(Vdist(v[1], v[2], v[3], pos.x, pos.y, pos.z) < 22.0)then
--             location = {v[1], v[2], v[3],v[4]}
--             hasFound = true
--         end
--     end

--     if hasFound then return location,true end
--     return {},false
-- end

-- RegisterNetEvent("RefuelCar")
-- AddEventHandler("RefuelCar",function()
--     local w = `WEAPON_PETROCAN` 
--     local curw = GetSelectedPedWeapon(PlayerPedId())
--     if curw == w then
--         coordA = GetEntityCoords(PlayerPedId(), 1)
--         coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 100.0, 0.0)
--         targetVehicle = getVehicleInDirection(coordA, coordB)
--         if DoesEntityExist(targetVehicle) then
--             SetPedAmmo( PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0 )

--             if DecorExistOn(targetVehicle, "CurrentFuel") then 
--                 curFuel = DecorGetInt(targetVehicle, "CurrentFuel")
                
--                 curFuel = curFuel + 30
--                 if curFuel > 100 then
--                     curFuel = 100
--                 end
--                 DecorSetInt(targetVehicle, "CurrentFuel", curFuel)
--             else
--                 DecorSetInt(targetVehicle, "CurrentFuel", 50)
--             end

--             DecorSetInt(targetVehicle, "CurrentFuel", 100)
--             TriggerEvent("notification","Refueled",1)
--         else
--             TriggerEvent("notification","No Target",2)
--         end
--     else
--         TriggerEvent("notification","Need a Gas Can",2)
--     end
-- end)

-- RegisterNetEvent("RefuelCarServerReturn")
-- AddEventHandler("RefuelCarServerReturn",function()

--     local timer = (100 - curFuel) * 400
--     refillVehicle()
--     local finished = exports['progressBars']:startUI(timer, "Refueling")
--     local veh = TargetVehicle()

--     if finished == 100 then
--         DecorSetInt(veh, "CurrentFuel", 100)
--     else

--         local curFuel = DecorGetInt(veh, "CurrentFuel")
--         local endFuel = (100 - curFuel) 
--         endFuel = math.ceil(endFuel + curFuel)
--         DecorSetInt(veh, "CurrentFuel", endFuel)

--     end
--     endanimation()
--     TriggerEvent('notification', 'You paid $' .. round(costs) .. ' for your fuel')
-- end)

-- local petrolCan = {title = "Petrol Can", name = "PetrolCan", costs = 100, description = {}, model = "WEAPON_PETROCAN"}

-- function refillVehicle()
--     ClearPedSecondaryTask(PlayerPedId())
--     loadAnimDict( "weapon@w_sp_jerrycan" ) 
--     TaskPlayAnim( PlayerPedId(), "weapon@w_sp_jerrycan", "fire", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
-- end

-- function endanimation()
--     shiftheld = false
--     ctrlheld = false
--     tabheld = false
--     ClearPedTasksImmediately(PlayerPedId())
-- end

-- function loadAnimDict( dict )
--     while not HasAnimDictLoaded( dict )  do
--         RequestAnimDict( dict )
--         Citizen.Wait( 5 )
--     end
-- end

-- function TargetVehicle()
--     playerped = PlayerPedId()
--     coordA = GetEntityCoords(playerped, 1)
--     coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
--     targetVehicle = getVehicleInDirection(coordA, coordB)
--     return targetVehicle
-- end

-- function round( n )
--     return math.floor( n + 0.5 )
-- end

-- Fuel = 45
-- DrivingSet = false
-- LastVehicle = nil
-- lastupdate = 0
-- local fuelMulti = 0

-- RegisterNetEvent("carHud:FuelMulti")
-- AddEventHandler("carHud:FuelMulti",function(multi)
--     fuelMulti = multi
-- end)

-- alarmset = false

-- RegisterNetEvent("CarFuelAlarm")
-- AddEventHandler("CarFuelAlarm",function()
--     if not alarmset then
--         alarmset = true
--         local i = 5
--         TriggerEvent("notification", "Low fuel.",1)
--         while i > 0 do
--             PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
--             i = i - 1
--             Citizen.Wait(300)
--         end
--         Citizen.Wait(60000)
--         alarmset = false
--     end
-- end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

-- CONFIG --
local showCompass = true
-- CODE --
local compass = "Loading GPS"

local lastStreet = nil
local lastStreetName = ""
local zone = "Unknown";

function playerLocation()
    return lastStreetName
end

function playerZone()
    return zone
end

-- Thanks @marxy
function getCardinalDirectionFromHeading(heading)
    if heading >= 315 or heading < 45 then
        return "North Bound"
    elseif heading >= 45 and heading < 135 then
        return "West Bound"
    elseif heading >=135 and heading < 225 then
        return "South Bound"
    elseif heading >= 225 and heading < 315 then
        return "East Bound"
    end
end

local seatbelt = false
local safetybelt = false
RegisterNetEvent("seatbelt")
AddEventHandler("seatbelt", function(belt)
    seatbelt = belt
    safetybelt = belt
end)

local nos = 0
local nosEnabled = false
RegisterNetEvent("noshud")
AddEventHandler("noshud", function(_nos, _nosEnabled)
    if _nos == nil then
        nos = 0
    else
        nos = _nos
    end
    nosEnabled = _nosEnabled
end)

local time = "12:00"
RegisterNetEvent("timeheader2")
AddEventHandler("timeheader2", function(h,m)
    if h < 10 then
        h = "0"..h
    end
    if m < 10 then
        m = "0"..m
    end
    time = h .. ":" .. m
end)

local counter = 0
local Mph = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 2.236936
local uiopen = false
local colorblind = false
local compass_on = false

RegisterNetEvent('option:colorblind')
AddEventHandler('option:colorblind',function()
    colorblind = not colorblind
end)

Citizen.CreateThread(function()
    
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
    currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
    intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
    zone = tostring(GetNameOfZone(x, y, z))
    local area = GetLabelText(zone)
    playerStreetsLocation = area

    if not zone then
        zone = "UNKNOWN"
    end

    if intersectStreetName ~= nil and intersectStreetName ~= "" then
        playerStreetsLocation = currentStreetName .. " | " .. intersectStreetName .. " | [" .. area .. "]"
    elseif currentStreetName ~= nil and currentStreetName ~= "" then
        playerStreetsLocation = currentStreetName .. " | [" .. area .. "]"
    else
        playerStreetsLocation = "[" .. area .. "]"
    end

    while true do
        Citizen.Wait(500)
        local player = PlayerPedId()
        local x, y, z = table.unpack(GetEntityCoords(player, true))
        local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
        currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
        intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
        zone = tostring(GetNameOfZone(x, y, z))
        local area = GetLabelText(zone)
        local vehicle = GetVehiclePedIsIn(player)
        playerStreetsLocation = area

        if not zone then
            zone = "UNKNOWN"
        end

        if intersectStreetName ~= nil and intersectStreetName ~= "" then
            playerStreetsLocation = currentStreetName .. " | " .. intersectStreetName .. " | [" .. area .. "]"
        elseif currentStreetName ~= nil and currentStreetName ~= "" then
            playerStreetsLocation = currentStreetName .. " | [" .. area .. "]"
        else
            playerStreetsLocation = "[".. area .. "]"
        end
        -- compass = getCardinalDirectionFromHeading(math.floor(GetEntityHeading(player) + 0.5))
        -- street = compass .. " | " .. playerStreetsLocation
        street = playerStreetsLocation
        local veh = GetVehiclePedIsIn(player, false)
        if IsVehicleEngineOn(veh) then     
            local carhudfuel = math.floor(GetVehicleFuelLevel(vehicle))     

            if not uiopen then
                uiopen = true
                SendNUIMessage({
                  open = 1,
                }) 
            end

             Mph = math.ceil(GetEntitySpeed(GetVehiclePedIsIn(player, false)) * 2.236936)
			
			 local hours = GetClockHours()
            if string.len(tostring(hours)) == 1 then
                trash = '0'..hours
            else
                trash = hours
            end
    
            local mins = GetClockMinutes()
            if string.len(tostring(mins)) == 1 then
                mins = '0'..mins
            else
                mins = mins
            end
			
            local atl = false
            if IsPedInAnyPlane(player) or IsPedInAnyHeli(player) then
                atl = string.format("%.1f", GetEntityHeightAboveGround(veh) * 3.28084)
            end
            local engine = false
            if GetVehicleEngineHealth(veh) < 400.0 then
                engine = true
            end
            local GasTank = false
            if GetVehiclePetrolTankHealth(veh) < 3002.0 then
                GasTank = false
            end
            SendNUIMessage({
              open = 2,
              mph = Mph,
              fuel = carhudfuel,
              street = street,
              belt = safetybelt,
              nos = nos,
              nosEnabled = nosEnabled,
              time = hours .. ':' .. mins,
              colorblind = colorblind,
              atl = atl,
              engine = engine,
              GasTank = GasTank,
            }) 
        else

            if uiopen and not compass_on then
                SendNUIMessage({
                  open = 3,
                }) 
                uiopen = false
            end
        end
    end
end)

local seatbelt = false
local speedBuffer = {}
local velBuffer    = {}

Fwv = function (entity)
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

-- -- Seatbelt High Speed, By Vulcan#5487

-- Citizen.CreateThread(function()
--     while true do
--     Citizen.Wait(1500)
    
--       local ped = PlayerPedId()
--       local vehicle = GetVehiclePedIsIn(ped)
  
--         speedBuffer[2] = speedBuffer[1]
--         speedBuffer[1] = GetEntitySpeed(vehicle)
--         local fallChance = math.random(1, 3)
--         local fallSpeed = 60 * 2.236936 -- 134 MPH
        
--         if not seatbelt and GetEntitySpeedVector(vehicle, true).y > 1.0 and (speedBuffer[1] * 2.236936) > fallSpeed and fallChance == 2 then
--           local co = GetEntityCoords(ped)
--           local fw = Fwv(ped)
--           SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
--           SetEntityVelocity(playerPed, velBuffer.x, velBuffer.y, velBuffer.z)
--           Citizen.Wait(1)
--           SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
--         end
          
--         velBuffer = GetEntityVelocity(vehicle)
      
--     end
-- end)

-- -- Seatbelt Impact Old, By Vulcan#5487

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
--         local playerPed = PlayerPedId()
-- 		local vehicle = GetVehiclePedIsIn(playerPed, false)
-- 		if DoesEntityExist(vehicle) then
--             local oldDamage = GetVehicleBodyHealth(vehicle)
--             Citizen.Wait(50)
--             local currentDamage = GetVehicleBodyHealth(vehicle)
--             velBuffer = GetEntityVelocity(vehicle)
--             local tyreChance = math.random(1, 100)
--             if currentDamage ~= oldDamage and (oldDamage - currentDamage) >= 35 and not seatbelt then
--                 local co = GetEntityCoords(playerPed)
--                 local fw = Fwv(playerPed)
--                 SetEntityCoords(playerPed, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
--                 SetEntityVelocity(playerPed, velBuffer.x, velBuffer.y, velBuffer.z)
--                 Citizen.Wait(1)
--                 SetPedToRagdoll(playerPed, 1000, 1000, 0, 0, 0, 0)
--             end
--             if currentDamage ~= oldDamage and (oldDamage - currentDamage) >= 35 and tyreChance <= 33 then
--                 SetVehicleTyreBurst(vehicle, 0, true, 1000.0)
--                 SetVehicleTyreBurst(vehicle, 1, true, 1000.0)
--                 SetVehicleTyreBurst(vehicle, 4, true, 1000.0)
--                 SetVehicleTyreBurst(vehicle, 5, true, 1000.0)
--             end
-- 		end
-- 	end
-- end)

-- Seatbelt Impact, By Vulcan#5487

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if DoesEntityExist(vehicle) then
            local oldDamage = GetVehicleBodyHealth(vehicle)
            Citizen.Wait(50)
            local currentDamage = GetVehicleBodyHealth(vehicle)
            local tyreChance = math.random(1, 100)
            if currentDamage ~= oldDamage and (oldDamage - currentDamage) >= 35 and not seatbelt and not harness
            or currentDamage ~= oldDamage and (oldDamage - currentDamage) >= 35 and seatbelt and math.random(1,6) == 3 and not harness then
                local veloc = GetEntityVelocity(vehicle)
                local coords = GetOffsetFromEntityInWorldCoords(vehicle, 1.0, 0.0, 1.0)
                SetEntityCoords(playerPed, coords)
                Citizen.Wait(1)
                SetPedToRagdoll(playerPed, 5511, 5511, 0, 0, 0, 0)
                SetEntityVelocity(playerPed, veloc.x*4,veloc.y*4,veloc.z*4)
                local ejectspeed = math.ceil(GetEntitySpeed(playerPed) * 8)
                SetEntityHealth(playerPed, (GetEntityHealth(playerPed) - ejectspeed) )
            end
            if currentDamage ~= oldDamage and (oldDamage - currentDamage) >= 35 and tyreChance <= 33 and GetPedInVehicleSeat(vehicle, -1) == playerPed then
                SetVehicleTyreBurst(vehicle, 0, true, 1000.0)
                SetVehicleTyreBurst(vehicle, 1, true, 1000.0)
                SetVehicleTyreBurst(vehicle, 4, true, 1000.0)
                SetVehicleTyreBurst(vehicle, 5, true, 1000.0)
            end
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        local vehicle = GetVehiclePedIsIn(PlayerPedId())
        local vehEngine = GetVehicleEngineHealth(vehicle)
        if vehEngine < 500.0 and math.random(1, 5) == 3 then
            SetVehicleEngineOn(vehicle, false, true)
            exports['mythic_notify']:SendAlert('inform', 'Your vehicle has stalled due to engine damage.', 5000, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
            SetVehicleEngineHealth(vehicle, vehEngine - 40)
            Citizen.Wait(3500)
            SetVehicleEngineOn(vehicle, true, true)
        end
    end
end)

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(5000)
		TriggerServerEvent('carhud:checkHasHarness', source)
	end
end)

local harness = false
local hasHarness = false

RegisterNetEvent('carhud:hasHarness')
AddEventHandler('carhud:hasHarness', function(state)
    if state == 'false' then
        hasHarness = false
        harness = false
    elseif state == 'true' then
        hasHarness = true
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        local playerPed = PlayerPedId()
        if seatbelt or harness then 
            DisableControlAction(0, 75)
        end
        -- if IsPedInAnyVehicle(playerPed) then
        --     local vehicle = GetVehiclePedIsIn(playerPed)
        --     local lock = GetVehicleDoorLockStatus(vehicle)
        --     if lock == 2 then
        --         DisableControlAction(0, 75)
        --     end
        -- end
        if not IsPedInAnyVehicle(playerPed) and seatbelt == true or not IsPedInAnyVehicle(playerPed) and harness == true then
            seatbelt = false
            harness = false
            TriggerEvent("seatbelt",false)
        end
		if IsControlJustReleased(0, 29) and IsPedInAnyVehicle(playerPed) then
			 if seatbelt == false and not hasHarness then
				TriggerEvent("seatbelt",true)
                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.5, 'buckle', 0.5)
                exports['mythic_notify']:SendAlert('inform', 'Seat Belt Enabled', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
             elseif seatbelt == true and not hasHarness then
				TriggerEvent("seatbelt",false)
                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.5, 'buckle', 0.5)
                exports['mythic_notify']:SendAlert('inform', 'Seat Belt Disabled', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
			end
            if harness == false and hasHarness then
                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.5, 'harness', 0.5)
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "toggle_harness_on",
                    duration = 3500,
                    label = "Strapping Harness On",
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                    },
                }, function(status)
                    if not status then
                        harness = true
                        safetybelt = true
                        exports['mythic_notify']:SendAlert('inform', 'Harness Enabled', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
                    end
                end)
			elseif harness == true and hasHarness then
                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.5, 'harness', 0.5)

                TriggerEvent("mythic_progbar:client:progress", {
                    name = "toggle_harness_off",
                    duration = 3500,
                    label = "Unstrapping Harness",
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                    },
                }, function(status)
                    if not status then
                        harness = false
                        safetybelt = false
                        exports['mythic_notify']:SendAlert('inform', 'Harness Disabled', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
                    end
                end)
			end
			seatbelt = not seatbelt
		end
	end
end)

RegisterNetEvent('carHud:compass')
AddEventHandler('carHud:compass', function(table)
    if not compass_on then
        compass_on = true
    elseif compass_on then
        compass_on = false
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        local player = PlayerPedId()
        if IsVehicleEngineOn(GetVehiclePedIsIn(player, false)) then
            -- in vehicle
            SendNUIMessage({
                open = 2,
                direction = math.floor(calcHeading(-GetEntityHeading(player) % 360)),
            })
        elseif compass_on == true then
            -- has compass toggled
            if not uiopen then
                uiopen = true
                SendNUIMessage({
                  open = 1,
                })
            end
			
		    local hours = GetClockHours()
            if string.len(tostring(hours)) == 1 then
                trash = '0'..hours
            else
                trash = hours
            end
    
            local mins = GetClockMinutes()
            if string.len(tostring(mins)) == 1 then
                mins = '0'..mins
            else
                mins = mins
            end

            SendNUIMessage({
                open = 4,
                time = hours .. ':' .. mins,
                direction = math.floor(calcHeading(-GetEntityHeading(player) % 360)),
            })
        else
            Citizen.Wait(1000)
        end
    end
end)

Controlkey = {["generalUse"] = {38,"E"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
    Controlkey["generalUse"] = table["generalUse"]
end)

---------------------------------
-- Compass shit
---------------------------------

--[[
    Heavy Math Calcs
 ]]--

 local imageWidth = 100 -- leave this variable, related to pixel size of the directions
 local containerWidth = 100 -- width of the image container
 
 -- local width =  (imageWidth / containerWidth) * 100; -- used to convert image width if changed
 local width =  0;
 local south = (-imageWidth) + width
 local west = (-imageWidth * 2) + width
 local north = (-imageWidth * 3) + width
 local east = (-imageWidth * 4) + width
 local south2 = (-imageWidth * 5) + width
 
 function calcHeading(direction)
     if (direction < 90) then
         return lerp(north, east, direction / 90)
     elseif (direction < 180) then
         return lerp(east, south2, rangePercent(90, 180, direction))
     elseif (direction < 270) then
         return lerp(south, west, rangePercent(180, 270, direction))
     elseif (direction <= 360) then
         return lerp(west, north, rangePercent(270, 360, direction))
     end
 end
 
 function rangePercent(min, max, amt)
     return (((amt - min) * 100) / (max - min)) / 100
 end
 
 function lerp(min, max, amt)
     return (1 - amt) * min + amt * max
 end