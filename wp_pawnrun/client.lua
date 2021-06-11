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

local tasking = false
local drugStorePed = 0

local PawnDropOffs = {
	[1] =  { ['x'] = 323.88,['y'] = -231.65,['z'] = 54.22,['h'] = 68.69, ['info'] = ' 1' },
	[2] =  { ['x'] = -18.4,['y'] = -1454.18,['z'] = 30.54,['h'] = 194.13, ['info'] = ' 2' },
	[3] =  { ['x'] = -14.92,['y'] = -1849.27,['z'] = 24.96,['h'] = 318, ['info'] = ' 3' },
	[4] =  { ['x'] = -395.62,['y'] = 146.84,['z'] = 65.72,['h'] = 88.61, ['info'] = ' 4' },
	[5] =  { ['x'] = 880.23,['y'] = 28.21, ['z'] = 78.71, ['h'] = 44.0, ['info'] = ' 5' },
	[6] =  { ['x'] = 952.48,['y'] = -137.0637,['z'] = 74.45,['h'] = 205.56, ['info'] = ' 6' },
	[7] =  { ['x'] = 409.53,['y'] = -1818.74,['z'] = 28.63,['h'] = 50.2, ['info'] = ' 7' },

}

local carspawns = {
	[1] =  { ['x'] = 79.85,['y'] = -1544.99,['z'] = 29.47,['h'] = 51.55, ['info'] = ' car 8' },
	[2] =  { ['x'] = 66.93,['y'] = -1561.73,['z'] = 29.47,['h'] = 45.73, ['info'] = ' car 1' },
	[3] =  { ['x'] = 68.57,['y'] = -1559.53,['z'] = 29.47,['h'] = 50.6, ['info'] = ' car 2' },
	[4] =  { ['x'] = 70.4,['y'] = -1557.12,['z'] = 29.47,['h'] = 51.18, ['info'] = ' car 3' },
	[5] =  { ['x'] = 72.22,['y'] = -1554.63,['z'] = 29.47,['h'] = 50.32, ['info'] = ' car 4' },
	[6] =  { ['x'] = 73.99,['y'] = -1552.22,['z'] = 29.47,['h'] = 52.47, ['info'] = ' car 5' },
	[7] =  { ['x'] = 76.06,['y'] = -1549.87,['z'] = 29.47,['h'] = 51.53, ['info'] = ' car 6' },
	[8] =  { ['x'] = 77.9,['y'] = -1547.45,['z'] = 29.47,['h'] = 53.24, ['info'] = ' car 7' },
}

local pillWorker = { ['x'] = 183.24,['y'] = -1319.89,['z'] = 29.32,['h'] = 234, ['info'] = 'boop bap' }

local rnd = 0
local blip = 0
local deliveryPed = 0

local PawnPeds = {
	'a_m_y_stwhi_02',
	'a_m_y_stwhi_01'
}





function CreatePawnPed()

    local hashKey = `a_m_y_stwhi_01`

    local pedType = 5

    RequestModel(hashKey)
    while not HasModelLoaded(hashKey) do
        RequestModel(hashKey)
        Citizen.Wait(100)
    end


	deliveryPed = CreatePed(pedType, hashKey, PawnDropOffs[rnd]["x"],PawnDropOffs[rnd]["y"],PawnDropOffs[rnd]["z"], PawnDropOffs[rnd]["h"], true)
	

    ClearPedTasks(deliveryPed)
    ClearPedSecondaryTask(deliveryPed)
    TaskSetBlockingOfNonTemporaryEvents(deliveryPed, true)
    SetPedFleeAttributes(deliveryPed, 0, 0)
    SetPedCombatAttributes(deliveryPed, 17, 1)

    SetPedSeeingRange(deliveryPed, 0.0)
    SetPedHearingRange(deliveryPed, 0.0)
    SetPedAlertness(deliveryPed, 0)
    SetPedKeepTask(deliveryPed, true)

end

function DeleteCreatedPed()
	-- print("Deleting Ped?")
	if DoesEntityExist(deliveryPed) then 
		SetPedKeepTask(deliveryPed, false)
		TaskSetBlockingOfNonTemporaryEvents(deliveryPed, false)
		ClearPedTasks(deliveryPed)
		TaskWanderStandard(deliveryPed, 10.0, 10)
		SetPedAsNoLongerNeeded(deliveryPed)

		Citizen.Wait(20000)
		DeletePed(deliveryPed)
	end
end

function DeleteBlip()
	if DoesBlipExist(blip) then
		RemoveBlip(blip)
	end
end

function CreateBlip()
	DeleteBlip()
	if PawnRun then
		blip = AddBlipForCoord(PawnDropOffs[rnd]["x"],PawnDropOffs[rnd]["y"],PawnDropOffs[rnd]["z"])
	end
    
    SetBlipSprite(blip, 514)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Drop Off")
    EndTextCommandSetBlipName(blip)
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function playerAnim()
	loadAnimDict( "mp_safehouselost@" )
    TaskPlayAnim( PlayerPedId(), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
end

function giveAnim()
    if ( DoesEntityExist( deliveryPed ) and not IsEntityDead( deliveryPed ) ) then 
        loadAnimDict( "mp_safehouselost@" )
        if ( IsEntityPlayingAnim( deliveryPed, "mp_safehouselost@", "package_dropoff", 3 ) ) then 
            TaskPlayAnim( deliveryPed, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        else
            TaskPlayAnim( deliveryPed, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        end     
    end
end

function DoDropOff()
	local success = true
	local PawnChance = math.random(1,1000)

	Citizen.Wait(1000)
	playerAnim()
	Citizen.Wait(800)

	PlayAmbientSpeech1(deliveryPed, "Chat_State", "Speech_Params_Force")

	if DoesEntityExist(deliveryPed) and not IsEntityDead(deliveryPed) then

		local counter = math.random(50,200)
		while counter > 0 do
			local crds = GetEntityCoords(deliveryPed)
			counter = counter - 1
			Citizen.Wait(1)
		end
	
		if success then
			local counter = math.random(100,300)
			while counter > 0 do
				local crds = GetEntityCoords(deliveryPed)
				counter = counter - 1
				Citizen.Wait(1)
			end
			giveAnim()
		end
	
		local crds = GetEntityCoords(deliveryPed)
		local crds2 = GetEntityCoords(PlayerPedId())
	
		if #(crds - crds2) > 3.0 or not DoesEntityExist(deliveryPed) or IsEntityDead(deliveryPed) then
			success = false
		end
		
		DeleteBlip()
		if success then

			if PawnChance <= Config.CashStackChance then
				-- TriggerServerEvent("pawndelivery:receivepawn")
				TriggerServerEvent('pawndelivery:RemovePawnItem')
			elseif PawnChance <= Config.BigRewarditemChance then
				TriggerServerEvent("pawndelivery:receiveBigRewarditem")
			end

			Citizen.Wait(2000)
			exports['mythic_notify']:SendAlert('inform', 'Drop off went well wait for a new buyer.', 2500, { ['background-color'] = '#169403', ['color'] = '#ffffff' })
		else
			exports['mythic_notify']:SendAlert('inform', 'Drop off failed!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
		end
	
		DeleteCreatedPed()
	end
end

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

RegisterNetEvent("pawndelivery:client")
AddEventHandler("pawndelivery:client", function()

	if tasking then
		return
	end
	
	rnd = math.random(1,#PawnDropOffs)

	CreateBlip()

	local pedCreated = false

	tasking = true
	local toolong = 600000
	while tasking do

		Citizen.Wait(1)
		local plycoords = GetEntityCoords(PlayerPedId())
		local dstcheck = #(plycoords - vector3(PawnDropOffs[rnd]["x"],PawnDropOffs[rnd]["y"],PawnDropOffs[rnd]["z"])) 

		if dstcheck < 40.0 and not pedCreated then
			pedCreated = true
			DeleteCreatedPed()
			CreatePawnPed()
			exports['mythic_notify']:SendAlert('inform', 'Close to drop off.', 2500, { ['background-color'] = '#169403', ['color'] = '#ffffff' })
		end
		toolong = toolong - 1
		if toolong < 0 then
			tasking = false
			PawnRun = false
			exports['mythic_notify']:SendAlert('inform', 'You took to long all the buyers left.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
		end
		if dstcheck < 2.0 and pedCreated then

			local crds = GetEntityCoords(deliveryPed)
			DrawText3Ds(crds["x"],crds["y"],crds["z"], "[E]")  

			if not IsPedInAnyVehicle(PlayerPedId()) and IsControlJustReleased(0,38) then
				TaskTurnPedToFaceEntity(deliveryPed, PlayerPedId(), 1.0)
				Citizen.Wait(1500)
				PlayAmbientSpeech1(deliveryPed, "Generic_Hi", "Speech_Params_Force")
				DoDropOff()
				tasking = false
				exports['mythic_notify']:SendAlert('inform', 'Next pick up is ready.', 2500, { ['background-color'] = '#169403', ['color'] = '#ffffff' }) -- green

			end

		end

	end
	

	DeleteCreatedPed()
	DeleteBlip()

end)

Citizen.CreateThread(function()

    while true do

	    Citizen.Wait(1)
	    local dropOff6 = #(GetEntityCoords(PlayerPedId()) - vector3(pillWorker["x"],pillWorker["y"],pillWorker["z"]))

		if dropOff6 < 1.6 and not PawnRun then

			DrawText3Ds(pillWorker["x"],pillWorker["y"],pillWorker["z"], "[E] $1,000 - Delivery Job") 
			if IsControlJustReleased(0,38) then
				TriggerServerEvent("pawndelivery:server")
				Citizen.Wait(1000)
			end
		end

    end

end)

local firstdeal = false
Citizen.CreateThread(function()


    while true do

		if PawnRun then

			if tasking then
				Citizen.Wait(30000)
			else
				TriggerEvent("pawndelivery:client")  
				salecount = salecount + 1
				if salecount == Config.RunAmount then
					Citizen.Wait(300000)
					PawnRun = false
				end
			end

		end
		Citizen.Wait(500)
    end

end)

RegisterNetEvent("pawndelivery:startDealing")
AddEventHandler("pawndelivery:startDealing", function()
    local NearNPC = GetClosestPed()

	PlayAmbientSpeech1(NearNPC, "Chat_Resp", "SPEECH_PARAMS_FORCE", 1)
	salecount = 0
	PawnRun = true
	firstdeal = true
	exports['mythic_notify']:SendAlert('inform', 'Next pick up is ready.', 2500, { ['background-color'] = '#169403', ['color'] = '#ffffff' }) -- green

end)