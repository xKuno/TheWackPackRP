ESX = nil
local IsFishing = false

cachedData = {
	
}

Citizen.CreateThread(function()
	while not ESX do
		--Fetching esx library, due to new to esx using this.

		TriggerEvent("esx:getSharedObject", function(library) 
			ESX = library 
		end)

		Citizen.Wait(0)
	end

	if Config.Debug then
		ESX.UI.Menu.CloseAll()

		RemoveLoadingPrompt()

		SetOverrideWeather("EXTRASUNNY")

		Citizen.Wait(2000)

		TriggerServerEvent("esx:useItem", Config.FishingItems["rod"]["name"])
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(playerData)
	ESX.PlayerData = playerData
end)

RegisterCommand('fixfish', function()
	IsFishing = false
end)
RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(newJob)
	ESX.PlayerData["job"] = newJob
end)
RegisterNetEvent("IsFishing")
AddEventHandler("IsFishing", function()
	IsFishing = true
end)

RegisterNetEvent("IsNotFishing")
AddEventHandler("IsNotFishing", function()
	IsFishing = false
end)

RegisterNetEvent("james_fishing:tryToFish")
AddEventHandler("james_fishing:tryToFish", function()
	if not IsFishing then
		TryToFish()
	else
		exports['mythic_notify']:SendAlert('inform', 'You are already fishing!', 2500)
	end

end)

RegisterNetEvent("james_fishing:tryToFish2")
AddEventHandler("james_fishing:tryToFish2", function()
	if not IsFishing then
		TryToFish2()
	else
		exports['mythic_notify']:SendAlert('inform', 'You are already fishing!', 2500)
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(500) -- Init time.

	HandleCommand()

	HandleStore()

	while true do
		local sleepThread = 500

		local ped = cachedData["ped"]
		
		if DoesEntityExist(cachedData["storeOwner"]) then
			local pedCoords = GetEntityCoords(ped)

			local dstCheck = #(pedCoords - GetEntityCoords(cachedData["storeOwner"]))

			if dstCheck < 3.0 then
				sleepThread = 5

				local displayText = not IsEntityDead(cachedData["storeOwner"]) and "Press ~INPUT_CONTEXT~ to sell your fish to the owner." or "The owner is dead, can therefore not speak."
	
				if IsControlJustPressed(0, 38) then
					SellFish()
				end

				ESX.ShowHelpNotification(displayText)
			end
		end
		
		Citizen.Wait(sleepThread)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)

		local ped = PlayerPedId()

		if cachedData["ped"] ~= ped then
			cachedData["ped"] = ped
		end
	end
end)

RegisterNetEvent('vulcan_fish:releaseFish')
AddEventHandler('vulcan_fish:releaseFish', function()
	local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

	local dlib = "anim@heists@ornate_bank@hack"
    local alib = "hack_enter"

	local dlibThrow = 'anim@heists@narcotics@trash'
	local alibThrow = 'throw_b'

	local fishProp = nil
	local fishName = "a_c_fish"

	RequestModel(fishName)
	RequestAnimDict(dlib)
	RequestAnimDict(dlibThrow)

	while not HasAnimDictLoaded(dlib) or not HasAnimDictLoaded(dlibThrow) or not HasModelLoaded(fishName) do
		Citizen.Wait(0)
	end

	TaskPlayAnim(playerPed, dlib, alib, 1.0, 1.0, 2575, 0, 0, 0, 0, 0)

	Citizen.Wait(800)

	fishProp = CreatePed(nil, GetHashKey(fishName), coords.x, coords.y, coords.z, 0, true, true)
	AttachEntityToEntity(fishProp, playerPed, GetPedBoneIndex(playerPed,  28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -10.0, 1, 1, 0, 1, 0, 1)

	Citizen.Wait(250)
    TaskPlayAnim(playerPed, dlibThrow, alibThrow, 2.0, 2.0, -1, 51, 0, false, false, false)

	Citizen.Wait(750)

	SetEntityHealth(fishProp, 0)

	Citizen.Wait(750)

	DetachEntity(fishProp, nil, nil)

	StopAnimTask(playerPed, dlibThrow, alibThrow, 1.0)

	Citizen.Wait(1000)

	DeletePed(fishProp)
  
	SetModelAsNoLongerNeeded(fishName)
end)