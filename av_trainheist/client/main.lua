local hackeando, robando = false, false
local isWhitelisted = false
local cuenta = 0

ESX = nil

Citizen.CreateThread(function()
    SwitchTrainTrack(0, true)
    SwitchTrainTrack(3, true)
    SetTrainTrackSpawnFrequency(0, 120000)
    SetRandomTrains(true)
	SetGarbageTrucks(true)
	SetRandomBoats(true)
  end)


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	isWhitelisted = Whitelisted()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	isWhitelisted = Whitelisted()
end)

Citizen.CreateThread(function()
   while true do 
        Citizen.Wait(5) 
            local pos = GetEntityCoords(PlayerPedId())
			local inicio = #(GetEntityCoords(PlayerPedId()) - vector3(Config.PC.x, Config.PC.y, Config.PC.z))			
			if inicio < 2 and not hackeando then
				DrawText3Ds(Config.PC.x, Config.PC.y, Config.PC.z,Config.Lang['hack_pc'])                       
				if IsControlJustReleased(0, 38) then
					ESX.TriggerServerCallback('av_train:cooldown',function(disponible)
						if disponible then
							if Config.PCitem then
								ESX.TriggerServerCallback('av_train:pcitem',function(hasItem)
									if hasItem then
										TriggerEvent('av_train:hackeo')
									else
										ESX.ShowNotification(Config.Lang['pc_item'])
									end
								end)
							else
								TriggerEvent('av_train:hackeo')
							end
						else
							ESX.ShowNotification(Config.Lang['cooldown'])
						end
					end)
				end	
			else
			Citizen.Wait(1000)
		end
	end
end)

RegisterNetEvent('av_train:hackeo')
AddEventHandler('av_train:hackeo', function()		
	local ped = PlayerPedId()
	local animDict = "anim@heists@prison_heiststation@cop_reactions"
	local animLib = "cop_b_idle"			
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(50)
	end
	hackeando = true			
	SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"),true)
	Citizen.Wait(500)
	FreezeEntityPosition(ped, true)
	TaskPlayAnim(ped, animDict, animLib, 2.0, -2.0, -1, 1, 0, 0, 0, 0 )
	Citizen.Wait(5500)
	TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_STAND_MOBILE', -1, true)
	Citizen.Wait(3000)
	TriggerEvent("mhacking:show")
	TriggerEvent("mhacking:start",Config.HackBlocks,Config.HackTime,hackeoEvent)	
end)

function hackeoEvent(success)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	TriggerEvent('mhacking:hide')
	
	if success then	
		robando = true
		hackeando = true
		ESX.ShowNotification(Config.Lang['robbery_started'])		
	else
		hackeando = false
	end		
	ClearPedTasksImmediately(ped)
	FreezeEntityPosition(ped, false)
end

RegisterNetEvent('av_train:tren')
AddEventHandler('av_train:tren', function()
	if not robando then return end
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)           
	local cabina = ESX.Game.GetClosestVehicle(pos)
	local tren1 = GetEntityCoords(cabina)
	local hash = GetEntityModel(cabina)
	local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, tren1.x, tren1.y, tren1.z, true)

	if dist < 10 and hash == GetHashKey('FreightCont1') or dist < 10 and hash == GetHashKey('FreightCont2') then				
		SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"),true)
		Citizen.Wait(600)				
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true)
		Citizen.Wait(2000)
		TriggerEvent('av_train:taladrar')			
	end 
end)

RegisterNetEvent('av_train:taladrar')
AddEventHandler('av_train:taladrar', function()		
	if not robando then return end
	local ped = PlayerPedId()
	local animDict = "anim@heists@fleeca_bank@drilling"
	local animLib = "drill_straight_idle"
			
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(50)
	end	
	SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"),true)
	Citizen.Wait(500)				
	local drillProp = GetHashKey('hei_prop_heist_drill')
	local boneIndex = GetPedBoneIndex(ped, 28422)			
	RequestModel(drillProp)
	while not HasModelLoaded(drillProp) do
		Citizen.Wait(100)
	end			
	TaskPlayAnim(ped,animDict,animLib,1.0, -1.0, -1, 2, 0, 0, 0, 0)			
	attachedDrill = CreateObject(drillProp, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedDrill, ped, boneIndex, 0.0, 0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)			
	SetEntityAsMissionEntity(attachedDrill, true, true)					
	PlaySoundFromEntity(drillSound, "Drill", attachedDrill, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
	TriggerEvent("av_train:Drilling:Start",function(success)
		if (success) then
			DeleteObject(attachedDrill)
			DeleteEntity(attachedDrill)
			ClearPedTasksImmediately(ped)
			local cord = GetEntityCoords(ped)
			local streetName,_ = GetStreetNameAtCoord(cord[1], cord[2], cord[3])
			local streetName = GetStreetNameFromHashKey(streetName)
			local zone = tostring(GetNameOfZone(cord[1], cord[2], cord[3]))
			local area = GetLabelText(zone)
		
			exports['wp_dispatch']:addCall("10-90", "Train Robbery In Progress", {
				{icon="fas fa-road", info = streetName ..", ".. area}
			}, {cord[1], cord[2], cord[3]}, "police", 3000, 118, 1 )
			exports['wp_dispatch']:addCall("10-90", "Train Robbery In Progress", {
				{icon="fas fa-road", info = streetName ..", ".. area}
			}, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 118, 1 )
			contador()
		else
			DeleteObject(attachedDrill)
			DeleteEntity(attachedDrill)
			ClearPedTasksImmediately(ped)
		end
	end)				
end)

RegisterNetEvent('av_train:updateCoords')
AddEventHandler('av_train:updateCoords', function()	
	Citizen.CreateThread(function()
		while robando do
			Citizen.Wait(2300)					
			local coords = GetEntityCoords(PlayerPedId())			
			TriggerServerEvent('av_train:gps', coords)			
		end
	end)
end)

function contador()
    cuenta = Config.Timer
    TriggerEvent("Timer:tren")
    TriggerEvent("av_train:updateCoords")
    local wait = 100
	local teclas = 0
	while robando do        
        Citizen.Wait(wait)
        cuenta = cuenta - 0.1
		if cuenta < 0 then wait = 5 end
		if IsControlJustReleased(0,38) and cuenta < 0 then
			teclas = teclas + 1
			TriggerEvent('av_train:comprobar')
			if teclas > 2 then 
				robando = false 
				ESX.ShowNotification(Config.Lang['failed'])
			end
		end
    end
end

RegisterNetEvent('av_train:comprobar')
AddEventHandler('av_train:comprobar', function()
    local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
           
	local cabina = ESX.Game.GetClosestVehicle(pos)
	local tren1 = GetEntityCoords(cabina)
	local hash = GetEntityModel(cabina)
	local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, tren1.x, tren1.y, tren1.z, true)
	
	if dist < 20 and hash == GetHashKey('FreightCont1') or dist < 20 and hash == GetHashKey('FreightCont2') then		
		RequestAnimDict("missexile3")
		while not HasAnimDictLoaded("missexile3") do
			Citizen.Wait(50)
		end
		hackeando = false
		robando = false
		TaskPlayAnim(ped, "missexile3", "ex03_dingy_search_case_a_michael", 1.0, 1.0, -1, 1, 0, 0, 0, 0 )
		Citizen.Wait(5500)
		ClearPedTasksImmediately(ped)
		TriggerServerEvent('av_train:recompensas')
	else
		ESX.ShowNotification(Config.Lang['train_cab'])
	end 
end)

RegisterNetEvent('Timer:tren')
AddEventHandler('Timer:tren', function()
    while robando do
        Citizen.Wait(0)
        if cuenta > 0 then
            drawTxt(0.94, 1.44, 1.0,1.0,0.6, Config.Lang['drill_countdown1']..''..math.ceil(cuenta) .. Config.Lang['drill_countdown2'], 255, 255, 255, 255)
        else
			drawTxt(0.94, 1.44, 1.0,1.0,0.6, Config.Lang['rob_train'], 255, 255, 255, 255)
		end
    end
end)

RegisterNetEvent('av_train:trainblip')
AddEventHandler('av_train:trainblip', function(targetCoords)
	if isWhitelisted then		
		local alpha = 250
		local trenBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, 50.0)

		SetBlipHighDetail(trenBlip, true)
		SetBlipColour(trenBlip, 1)
		SetBlipAlpha(trenBlip, alpha)
		SetBlipAsShortRange(trenBlip, true)

		while alpha ~= 0 do
			Citizen.Wait(8 * 4)
			alpha = alpha - 1
			SetBlipAlpha(trenBlip, alpha)

			if alpha == 0 then
				RemoveBlip(trenBlip)
				return
			end
		end		
	end
end)

function Whitelisted()
	if not ESX.PlayerData then
		return false
	end

	if not ESX.PlayerData.job then
		return false
	end

	for k,v in ipairs(Config.PoliceJobName) do
		if v == ESX.PlayerData.job.name then
			return true
		end
	end

	return false
end

AddEventHandler('esx:onPlayerDeath', function()
	if robando then
		robando = false 
		ESX.ShowNotification(Config.Lang['failed'])
	end
end)

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

DrawText3Ds = function(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.30, 0.30)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end