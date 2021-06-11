ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local ped = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        ped = PlayerPedId()
    end
end)

-------------------Fall When Jumping-------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if IsPedJumping(ped) and IsPedSprinting(ped) and not IsPedClimbing(ped) then
            if math.random(1,20) >= 18 then 
                Citizen.Wait(600)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
                SetPedToRagdoll(ped, 2000, 2000, 3, 0, 0, 0)
            else
                Citizen.Wait(100)
            end
        end
    end
end)

-------------------Longer Stun-------------------

local tiempo = 5000 -- in miliseconds >> 1000 ms = 1s

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedBeingStunned(ped) then
		SetPedMinGroundTimeForStungun(ped, tiempo)
		end
	end
end)

-------------------IDK-------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		DisableControlAction(0, 37, true);
		HideHudComponentThisFrame( 19 )
        HideHudComponentThisFrame( 20 )
        HideHudComponentThisFrame( 22 )
		HideHudComponentThisFrame( 9 )
		HideHudComponentThisFrame( 7 )
	end
end)

-------------------Remove Cops-------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) 
        SetParkedVehicleDensityMultiplierThisFrame(0.1) -- Parked Density
        SetCreateRandomCops(false) -- Enable/Disable Random Cops
        SetCreateRandomCopsNotOnScenarios(false) --- Enable/Disable Spawn Cops Off Scenarios
        SetCreateRandomCopsOnScenarios(false) -- Enable/Disable Spawn Cops On Scenarios
        StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
        DistantCopCarSirens(false)
        local x,y,z = table.unpack(GetEntityCoords(ped))
        RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
     end
end)

-------------------Stop Weapons Being Dropped By Peds-------------------

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    -- List of pickup hashes (https://pastebin.com/8EuSv2r1)
    RemoveAllPickupsOfType(0xDF711959) -- Carbine Rifle
    RemoveAllPickupsOfType(0xF9AFB48F) -- Pistol
    RemoveAllPickupsOfType(0xA9355DCD) -- Pump Shotgun
    RemoveAllPickupsOfType(0x2BE6766B) -- SMG
  end
end)

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/brief', 'A heavy metal briefcase.')
    TriggerEvent('chat:addSuggestion', '/brief2', 'A leather briefcase.')
    TriggerEvent('chat:addSuggestion', '/neon', 'Toggle your vehicle neon underglow on/off.')
    TriggerEvent('chat:addSuggestion', '/checktune', 'View your vehicle model and all upgrades on said vehicle.')
    TriggerEvent('chat:addSuggestion', '/id', 'Get your current temp id.')
end)

-------------------Check Vehicle Upgrades-------------------

RegisterCommand('checktune', function()
    TriggerEvent('check:tune')
end)

RegisterNetEvent('check:tune')
AddEventHandler('check:tune', function()
    if IsPedInAnyVehicle(ped) then

        local vehicle = GetVehiclePedIsIn(ped)
        local vehProps = ESX.Game.GetVehicleProperties(vehicle)
        local model       = GetEntityModel(vehicle)
        local modelName 	= GetDisplayNameFromVehicleModel(model)
        local modCount = GetNumVehicleMods(vehicle, modType)

        vehProps.modEngine = vehProps.modEngine + 1
        vehProps.modBrakes = vehProps.modBrakes + 1
        vehProps.modArmor = vehProps.modArmor + 1
        vehProps.modSuspension = vehProps.modSuspension + 1
        vehProps.modTransmission = vehProps.modTransmission + 1
        
        TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 30000, text = 'Car Model: ' ..modelName })
        TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 30000, text = 'Brakes Level: ' .. tostring(vehProps.modBrakes).. '/' .. GetNumVehicleMods(vehicle, 12) })
        TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 30000, text = 'Engine Level: ' .. tostring(vehProps.modEngine).. '/' .. GetNumVehicleMods(vehicle,11) })
        TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 30000, text = 'Armor Level: ' .. tostring(vehProps.modArmor).. '/' .. GetNumVehicleMods(vehicle, 16) })
        TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 30000, text = 'Suspension Level: ' .. tostring(vehProps.modSuspension).. '/' .. GetNumVehicleMods(vehicle,15)})
        TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 30000, text = 'Transmission Level: ' .. tostring(vehProps.modTransmission).. '/' .. GetNumVehicleMods(vehicle,13)})
        TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 30000, text = 'Turbo: ' .. tostring(vehProps.modTurbo)})
    else
        TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 5000, text = 'You are not in a vehicle.'})
    end
end)

-------------------Toggle Neon-------------------

local isOn = false

RegisterCommand("neon", function()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= nil and veh ~= 0 and veh ~= 1 then
		--left
        if isOn then
            SetVehicleNeonLightEnabled(veh, 0, false)
            SetVehicleNeonLightEnabled(veh, 1, false)
            SetVehicleNeonLightEnabled(veh, 2, false)
            SetVehicleNeonLightEnabled(veh, 3, false)
			
			isOn = false
        else
            SetVehicleNeonLightEnabled(veh, 0, true)
            SetVehicleNeonLightEnabled(veh, 1, true)
            SetVehicleNeonLightEnabled(veh, 2, true)
            SetVehicleNeonLightEnabled(veh, 3, true)
			
			isOn = true
        end
    end
end, false)

-------------------Enable PVP-------------------

AddEventHandler("playerSpawned", function()
    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(ped, true, true)
end)

-------------------Clear Location-------------------

Citizen.CreateThread(function()
    while true do
        local dockloc = {
            { x = 18.93, y = -2474.90, z = 5.99 }
        }
        Wait(50)
        for i=1, #dockloc do
            ClearAreaOfPeds(dockloc[i].x, dockloc[i].y, dockloc[i].z, 100.0, 0)
            ClearAreaOfVehicles(dockloc[i].x, dockloc[i].y, dockloc[i].z, 0.0, false, false, false, false, false)
        end
        ClearAreaOfPeds(382.0, 797.10, 187.66, 10.0, 0)
    end
end)

-------------------Disable Seatshuffle-------------------

local disableShuffle = true
function disableSeatShuffle(flag)
	disableShuffle = flag
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedInAnyVehicle(ped, false) and disableShuffle then
			if GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), 0) == ped then
				if GetIsTaskActive(ped, 165) then
					SetPedIntoVehicle(ped, GetVehiclePedIsIn(ped, false), 0)
				end
			end
		end
	end
end)

-------------------Pointing-------------------

local mp_pointing = false
local keyPressed = false

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(0)
	  if IsAnimated then
		DisableControlAction(0,24,true) -- disable attack
		DisableControlAction(0,25,true) -- disable aim
		DisableControlAction(0,58,true) -- disable weapon
		DisableControlAction(0,263,true) -- disable melee
		DisableControlAction(0,264,true) -- disable melee
		DisableControlAction(0,257,true) -- disable melee
		DisableControlAction(0,140,true) -- disable melee
		DisableControlAction(0,141,true) -- disable melee
		DisableControlAction(0,142,true) -- disable melee
		DisableControlAction(0,143,true) -- disable melee
		DisableControlAction(1,323,true) -- disable X 
		DisableControlAction(0,73,true) -- disable X 
		DisableControlAction(1,74,true) -- disable H 
		DisableControlAction(2,82,true) -- disable , for ragdoll
		DisableControlAction(0,170,true) -- disable F3	
	  end
	end
end)

local function startPointing()
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(ped)
end

local once = true
local oldval = false
local oldvalped = false

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if once then
            once = false
        end

        if not keyPressed then
            if IsControlPressed(0, 29) and not mp_pointing and IsPedOnFoot(ped) and not IsAnimated then
                Wait(200)
                if not IsControlPressed(0, 29) then
                    keyPressed = true
                    startPointing()
                    mp_pointing = true
                else
                    keyPressed = true
                    while IsControlPressed(0, 29) do
                        Wait(50)
                    end
                end
            elseif (IsControlPressed(0, 29) and mp_pointing) or (not IsPedOnFoot(ped) and mp_pointing and not IsAnimated) then
                keyPressed = true
                mp_pointing = false
                stopPointing()
            end
        end

        if keyPressed then
            if not IsControlPressed(0, 29) then
                keyPressed = false
            end
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, ped) and not mp_pointing then
            stopPointing()
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, ped) then
            if not IsPedOnFoot(ped) then
                stopPointing()
            else
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0

                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                nn,blocked,coords,coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)

            end
        end
    end
end)

-------------------Raggdoll Script-------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlPressed(2, 82) then
			ragdol = 1 
        end
		if ragdol == 1 then
			DisableControlAction(0,37,true) -- disable TAB (weapon wheel)
			DisableControlAction(0,24,true) -- disable attack
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0,47,true) -- disable weapon
			DisableControlAction(0,58,true) -- disable weapon
			DisableControlAction(0,263,true) -- disable melee
			DisableControlAction(0,264,true) -- disable melee
			DisableControlAction(0,257,true) -- disable melee
			DisableControlAction(0,140,true) -- disable melee
			DisableControlAction(0,141,true) -- disable melee
			DisableControlAction(0,142,true) -- disable melee
			DisableControlAction(0,143,true) -- disable melee
			DisableControlAction(0,29,true) -- disable B for pointing	
			DisableControlAction(0,170,true) -- disable F3	
		    SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlPressed(2, 81) then
			ragdol = 0 end
			if ragdol == 1 then
		    SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
        end
    end
end)


Citizen.CreateThread(function(prop_name, secondaryprop_name)
	while true do
		Citizen.Wait(10)
		if IsPedRagdoll(ped) and IsAnimated then 
			local prop_name = prop_name
			local secondaryprop_name = secondaryprop_name
			IsAnimated = false
			ClearPedSecondaryTask(ped)
			DeleteObject(prop)
			DeleteObject(secondaryprop)
		end
	end
end)	

-------------------Briefcases-------------------

RegisterCommand('brief', function()
	if ped then
		GiveWeaponToPed(ped, 0x88C78EB7, 1, false, true);
	end
end)

RegisterCommand('brief2', function()
	if ped then
		GiveWeaponToPed(ped, 0x01B79F17, 1, false, true);
	end
end)

-------------------Stop Animation With X-------------------

local allowX = true

RegisterNetEvent('wp_utility:enableX')
AddEventHandler('wp_utility:enableX', function()
    allowX = true
end)

RegisterNetEvent('wp_utility:disableX')
AddEventHandler('wp_utility:disableX', function()
    allowX = false
end)

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(0)
		if IsControlJustReleased(0, 73) and allowX then
			ClearPedTasks(ped)
		end
	end
end)

-------------------Stop Despawning Local Cars-------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(15000)

        if IsPedInAnyVehicle(ped) then
            local vehicle = GetVehiclePedIsIn(ped)
            SetEntityAsMissionEntity(vehicle, true, true)
        end

    end
end)

-------------------No More Pistol Whipping-------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedArmed(ped, 6) then
	    	DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end
    end
end)

-------------------Tyre Blowout-------------------

Citizen.CreateThread( function()
    while true do 
        Citizen.Wait(10)
		local left = false
		local right = false

		if DoesEntityExist(ped) and not IsEntityDead(ped) then 
            if IsPedSittingInAnyVehicle(ped) then 
                local vehicle = GetVehiclePedIsIn(ped, false)

                    if GetPedInVehicleSeat(vehicle, -1) == ped then 
                        SetVehicleSteerBias(vehicle, steer)
						if IsVehicleTyreBurst(vehicle, 0, true) then
							left = true 
                        end
							
						if IsVehicleTyreBurst(vehicle, 1, true) then
							right = true 
                        end
							
						if IsVehicleTyreBurst(vehicle, 2, true) then
							left = true 
                        end
							
						if IsVehicleTyreBurst(vehicle, 3, true) then
							right = true 
                        end
							
						if	IsVehicleTyreBurst(vehicle, 4, true) then	
							left = true 
                        end
							
						if IsVehicleTyreBurst(vehicle, 5, true) then
							right = true 
                        end
							
						if IsVehicleTyreBurst(vehicle, 0, false) then
							steer = 0.0 
                        end
							
						if IsVehicleTyreBurst(vehicle, 1, false) then
							steer = 0.0 
                        end
							
						if IsVehicleTyreBurst(vehicle, 2, false) then
							steer = 0.0 
                        end
							
						if IsVehicleTyreBurst(vehicle, 3, false) then
							steer = 0.0 
                        end
							
						if IsVehicleTyreBurst(vehicle, 4, false) then	
							steer = 0.0 
                        end
							
						if IsVehicleTyreBurst(vehicle, 5, false) then
							steer = 0.0 
                        end	
							
						if left == true and right == true then
							SetVehicleReduceGrip(vehicle, true)
                        else
							SetVehicleReduceGrip(vehicle, false)
						end
							
						if left == false and right == false then
							steer = 0.0 
                        end	
                    end 
                end 
            end 
        end 
    end) 

-------------------Disabled Dispatch In Police Cars-------------------

Citizen.CreateThread(function()
    for i = 1, 12 do
        Citizen.InvokeNative(0xDC0F817884CDD856, i, false)
    end
end)