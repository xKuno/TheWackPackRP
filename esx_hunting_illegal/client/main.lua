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

ESX                             = nil
local PlayerData              = {}
local isAnimated = false
local tooFarIgnore = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	ScriptLoaded()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

local entitySkin
local entityType
local entityQuantity = 1
local missionX = 783.84
local missionY = 1275.58
local missionZ = 360.3
local entityBlip = {}
local avantspawn
--local entityAlive = {}
local entityAlive = false
local entityHealth = {}
local entity = {}
local entitySpawned = true
local remover = false
local blockOtherWeapons = true


local MarkerType   = 1
local DrawDistance = 100.0
local MaxDistance = 2.0 -- added

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function DrawText3d(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    if onScreen then
        SetTextScale(0.2, 0.2)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function ScriptLoaded()
	Citizen.Wait(1000)
	LoadMarkers()
end

local AnimalPositions = {
	{ x = 830.28, y = 1294.79, z = 364.35 },
	{ x = 800.61, y = 1312.82, z = 362.04 },
	{ x = 746.02, y = 1323.66, z = 358.73 },
	{ x = 869.82, y = 1256.7, z = 354.09 },
	{ x = 878.3, y = 1297.47, z = 356.98 },
    { x = 679.563, y = 1328.779, z = 350.453 },
    { x = 691.766, y = 1280.429, z = 150.0 },
    { x = 681.057, y = 1302.798, z = 357.215 },
    { x = 577.59, y = 1291.036, z = 324.996 },
    { x = 736.192, y = 1383.248, z = 332.004 },
    { x = 762.246, y = 1408.734, z = 330.654 },
    { x = 743.774, y = 1479.364, z = 308.132 },
    { x = 702.235, y = 1518.675, z = 290.636 },
    { x = 649.491, y = 1520.586, z = 269.108 },
    { x = 384.921, y = 1217.451, z = 266.86 },
    { x = 389.794, y = 1459.06, z = 322.518 },
    { x = 618.692, y = 1502.994, z = 274.6 },
    { x = 809.937, y = 1458.676, z = 273.986 },
}

local AnimalsInSession = {}

local Positions = {
	['StartHunting'] = { ['hint'] = '[E] Start Hunting', ['x'] = 781.41, ['y'] = 1274.98, ['z'] = 361.28 }
}

local OnGoingHuntSession = false
local HuntCar = nil

function LoadMarkers()

	Citizen.CreateThread(function()
		for index, v in ipairs(Positions) do
			if index ~= 'StartHunting' then
				local StartBlip = AddBlipForCoord(v.x, v.y, v.z)
				SetBlipSprite(StartBlip, 442)
				SetBlipColour(StartBlip, 75)
				SetBlipScale(StartBlip, 0.7)
				SetBlipAsShortRange(StartBlip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString('Hunting Spot')
				EndTextCommandSetBlipName(StartBlip)
			end
		end
	end)

	LoadModel('blazer')
	LoadModel('a_c_mtlion')
	LoadAnimDict('amb@medic@standing@kneel@base')
	LoadAnimDict('anim@gangops@facility@servers@bodysearch@')

	Citizen.CreateThread(function()
		while true do
			local sleep = 500
			
			local plyCoords = GetEntityCoords(PlayerPedId())

			for index, value in pairs(Positions) do
				if value.hint ~= nil then

					if OnGoingHuntSession and index == 'StartHunting' then
						value.hint = '[E] Stop Hunting'
					elseif not OnGoingHuntSession and index == 'StartHunting' then
						value.hint = '[E] Start Hunting'
					end

					local distance = GetDistanceBetweenCoords(plyCoords, value.x, value.y, value.z, true)

					if distance < 5.0 then
						sleep = 5
						DrawM(value.hint, 27, value.x, value.y, value.z - 0.945, 255, 255, 255, 1.5, 15)
						if distance < 1.0 then
							if IsControlJustReleased(0, Keys['E']) then
								if index == 'StartHunting' then
									StartHuntingSession()
								else
									SellItems()
								end
							end
						end
					end

				end
				
			end
			Citizen.Wait(sleep)
		end
	end)
end

function StartHuntingSession()

	if OnGoingHuntSession then

		OnGoingHuntSession = false

		TriggerServerEvent('esx_hunting:removeWeapon')

		DeleteEntity(HuntCar)

		for index, value in pairs(AnimalsInSession) do
			if DoesEntityExist(value.id) then
				DeleteEntity(value.id)
			end
		end

	else
		OnGoingHuntSession = true

		--Car

		TriggerServerEvent('esx_hunting:giveWeapon2')

		--Animals

		Citizen.CreateThread(function()

				
			for index, value in pairs(AnimalPositions) do
				local Animal = CreatePed(5, GetHashKey('a_c_mtlion'), value.x, value.y, value.z, 0.0, true, false)
				TaskWanderStandard(Animal, true, true)
				SetEntityAsMissionEntity(Animal, true, true)
				--Blips

				local AnimalBlip = AddBlipForEntity(Animal)
				SetBlipSprite(AnimalBlip, 153)
				SetBlipColour(AnimalBlip, 1)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString('Mountain Lion - Animal')
				EndTextCommandSetBlipName(AnimalBlip)


				table.insert(AnimalsInSession, {id = Animal, x = value.x, y = value.y, z = value.z, Blipid = AnimalBlip})
			end
				
		end)
	end
end

local animal = {
	`a_c_mtlion`,
}

RegisterNetEvent('esx_hunting:illegalTargetButcher')
AddEventHandler('esx_hunting:illegalTargetButcher', function()
	local dead = false
	local closestAnimal, closestDistance = ESX.Game.GetClosestPed(plyCoords)
	local animal = `a_c_cow`,`a_c_deer`,`a_c_boar`,`a_c_coyote`,`a_c_mtlion`,`a_c_pig`,`a_c_rabbit_01`,`a_c_rat`,`a_c_cat`,`a_c_chickenhawk`,`a_c_chimp`,`a_c_chop`,`a_c_cormorant`,`a_c_crow`,`a_c_dolphin`,`a_c_fish`,`a_c_hen`,`a_c_humpback`,`a_c_husky`,`a_c_killerwhale`,`a_c_pigeon`,`a_c_poodle`,`a_c_pug`,`a_c_retriever`,`a_c_rhesus`,`a_c_rottweiler`,`a_c_seagull`,`a_c_sharkhammer`,`a_c_sharktiger`,`a_c_shepherd`,`a_c_stingray`,`a_c_westy` --dunno why but this seems to make it all work?
	local plyCoords = GetEntityCoords(PlayerPedId())
	if closestAnimal ~= -1 and closestDistance <= 3.0 then
		if GetPedType(closestAnimal) == 28 and GetEntityHealth(closestAnimal) == 0 then
			dead = true
			while not NetworkHasControlOfEntity(closestAnimal) and attempt < 10 and DoesEntityExist(closestAnimal) do -- Network handling contributed via thelindat
				Citizen.Wait(100)
				NetworkRequestControlOfEntity(closestAnimal)
				attempt = attempt + 1
			end
			 if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_KNIFE') then
				if DoesEntityExist(closestAnimal) and NetworkHasControlOfEntity(closestAnimal) then
					local netid = NetworkGetNetworkIdFromEntity(closestAnimal)
					SetNetworkIdCanMigrate(netid, false)
					TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
					TriggerEvent("mythic_progbar:client:progress", {
						name = "skinning",
						duration = 7500,
						label = "Skinning Animal",
						useWhileDead = false,
						canCancel = true,
						controlDisables = {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = false,
						},
						animation = {
							animDict = "anim@gangops@facility@servers@bodysearch@",
							anim = "player_search"
						},
					}, function(status)
						if not status then
							ClearPedTasksImmediately(PlayerPedId())
							local AnimalWeight = math.random(200) / 10
							exports['mythic_notify']:SendAlert('inform', 'You have slaughtered an animal yielding a total of ' ..AnimalWeight.. 'kg of meat and leather.', 6500)
							isButchering = false
							TriggerServerEvent('esx-qalle-hunting:reward-illegal', AnimalWeight)
							Citizen.Wait(150)
							SetEntityAsMissionEntity(closestAnimal, true, true)
							SetEntityAsNoLongerNeeded(closestAnimal)
							DeleteEntity(closestAnimal)

							if math.random(1, 3) == 3 then
								local cord = GetEntityCoords(PlayerPedId())
								local streetName,_ = GetStreetNameAtCoord(cord[1], cord[2], cord[3])
								local streetName = GetStreetNameFromHashKey(streetName)
								local gender = "unknown"
								local model = GetEntityModel(PlayerPedId())
								if (model == GetHashKey("mp_f_freemode_01")) then
									gender = "female"
								end
								if (model == GetHashKey("mp_m_freemode_01")) then
									gender = "male"
								end

								exports['wp_dispatch']:addCall("10-54", "Animal Carcass At", {
									{icon="fas fa-road", info = streetName},
									{icon="fa-venus-mars", info=gender}
								}, {cord[1], cord[2], cord[3]}, "police", 3000, 442, 5 )
								exports['wp_dispatch']:addCall("10-54", "Animal Carcass At", {
									{icon="fas fa-road", info = streetName},
									{icon="fa-venus-mars", info=gender}
								}, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 442, 5 )
							end
						end
					end)
				end
			 else
			 	exports['mythic_notify']:SendAlert('inform', 'This is the wrong tool for this activity, use a knife.', 3000)
			 end
		elseif dead == false or GetPedCauseOfDeath(closestAnimal) ~= PlayerPedId() or netid == nil then
			exports['mythic_notify']:SendAlert('inform', 'This animal is not dead or this is not your kill.', 3000)
			dead = false
		end
	end
end)

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end    
end

function LoadModel(model)
    while not HasModelLoaded(model) do
          RequestModel(model)
          Citizen.Wait(10)
    end
end

function DrawM(hint, type, x, y, z)
	ESX.Game.Utils.DrawText3D({x = x, y = y, z = z + 1.0}, hint, 0.4)
	DrawMarker(type, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 100, false, true, 2, false, false, false, false)
end