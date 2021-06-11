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

ESX          = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local haveboat = false

Citizen.CreateThread(function()

	if not Config.EnableBlips then return end
	
	for _, info in pairs(Config.BlipZones) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 0.6)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
	end
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(Config.MarkerZones) do
            DrawMarker(27, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.501, 0, 255, 255, 100, 0, 0, 0, 0)
			
		end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
	
        for k in pairs(Config.MarkerZones) do
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z)
            if dist <= 1.40 then
				if haveboat == false then
					AddTextEntry("FREE_boat", _U('press_e'))
					DisplayHelpTextThisFrame("FREE_boat",false )
					if IsControlJustPressed(0, Keys['E']) and IsPedOnFoot(PlayerPedId()) then
						Citizen.Wait(100)  
						OpenboatsMenu()
					end 
				elseif haveboat == true then
					AddTextEntry("FREE_boat", _U('storeboat')) 
					DisplayHelpTextThisFrame("FREE_boat",false )
					if IsControlJustPressed(0, Keys['E']) then
						if TaskGetOffBoat(PlayerPedId()) then
							Citizen.Wait(100) 
							if Config.EnableEffects then
								DoScreenFadeOut(1000)
								Citizen.Wait(500)
								TriggerEvent('esx:deleteVehicle')
								DoScreenFadeIn(3000) 
							else
								TriggerEvent('esx:deleteVehicle')
							end
							
							if Config.EnableEffects then
								wp.ShowNotification(_U('boatmessage'))
							else
							end
							haveboat = false
						else
							if Config.EnableEffects then
								wp.ShowNotification(_U('notaboat'))
							end
						end
					end 		
				end
			elseif dist < 1.45 then
				ESX.UI.Menu.CloseAll()
            end
        end
    end
end)



function OpenboatsMenu()
	
	local elements = {}
	
	if Config.EnablePrice == false then
		table.insert(elements, {label = _U('boatfree'), value = 'kolo'}) 
		table.insert(elements, {label = _U('boat2free'), value = 'kolo2'}) 
		table.insert(elements, {label = _U('boat3free'), value = 'kolo3'}) 
		table.insert(elements, {label = _U('boat4free'), value = 'kolo4'}) 
	end
	
	if Config.EnablePrice == true then
		table.insert(elements, {label = _U('boat'), value = 'kolo'}) 
		table.insert(elements, {label = _U('boat2'), value = 'kolo2'}) 
		table.insert(elements, {label = _U('boat3'), value = 'kolo3'}) 
		table.insert(elements, {label = _U('boat4'), value = 'kolo4'}) 
	end
	
	
	--- WIP 
	if Config.EnableBuyOutfits then
		table.insert(elements, {label = '--------------------------------------------------', value = 'spacer'}) 
		table.insert(elements, {label = _U('civil_outfit'), value = 'citizen_wear'}) 
		table.insert(elements, {label = _U('outfit'), value = 'outfit'}) 
		table.insert(elements, {label = _U('outfit2'), value = 'outfit2'}) 
		table.insert(elements, {label = _U('outfit3'), value = 'outfit3'}) 
	end
	
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'client',
    {
		title    = _U('boattitle'),
		align    = 'right',
		elements = elements,
    },
	
	
	function(data, menu)

	if data.current.value == 'kolo' then
		if Config.EnableSoundEffects == true then
			TriggerServerEvent('InteractSound_SV:PlayOnSource', 'buy', Config.Volume)
		end
		if Config.EnablePrice then
			TriggerServerEvent("wp:lowmoney", Config.PriceSeaShark) 
		end
		
		if Config.EnableEffects then
			DoScreenFadeOut(1000)
			Citizen.Wait(1000)
			TriggerEvent('esx:spawnVehicle', "seashark")
			DoScreenFadeIn(3000) 
			ESX.ShowNotification(_U('boat_pay', Config.PriceSeaShark))
		else
			TriggerEvent('esx:spawnVehicle', "seashark")
		end
		
		ESX.UI.Menu.CloseAll()
		haveboat = true	
	end
	
	if data.current.value == 'kolo2' then
		if Config.EnableSoundEffects == true then
			TriggerServerEvent('InteractSound_SV:PlayOnSource', 'buy', Config.Volume)
		end
		if Config.EnablePrice then
			TriggerServerEvent("wp:lowmoney", Config.PriceTropic) 
		end
		
		if Config.EnableEffects then
			DoScreenFadeOut(1000)
			Citizen.Wait(1000)
			TriggerEvent('esx:spawnVehicle', "tropic")
			DoScreenFadeIn(3000) 
			ESX.ShowNotification(_U('boat_pay', Config.PriceTropic))
		else
			TriggerEvent('esx:spawnVehicle', "tropic")
		end
		
		ESX.UI.Menu.CloseAll()
		haveboat = true	
	end
	
	if data.current.value == 'kolo3' then
		if Config.EnableSoundEffects == true then
			TriggerServerEvent('InteractSound_SV:PlayOnSource', 'buy', Config.Volume)
		end
		if Config.EnablePrice then
			TriggerServerEvent("esx:lowmoney", Config.PriceSunTrap) 
		end
		
		if Config.EnableEffects then
			DoScreenFadeOut(1000)
			Citizen.Wait(1000)
			TriggerEvent('esx:spawnVehicle', "suntrap")
			DoScreenFadeIn(3000) 
			ESX.ShowNotification(_U('boat_pay', Config.PriceSunTrap))
		else
			TriggerEvent('esx:spawnVehicle', "suntrap")
		end
		ESX.UI.Menu.CloseAll()
		haveboat = true	
	end
	
	if data.current.value == 'kolo4' then
		if Config.EnableSoundEffects == true then
			TriggerServerEvent('InteractSound_SV:PlayOnSource', 'buy', Config.Volume)
		end
		if Config.EnablePrice then
			TriggerServerEvent("wp:lowmoney", Config.PriceJetMax) 
		end
		
		if Config.EnableEffects then
			DoScreenFadeOut(1000)
			Citizen.Wait(1000)
			TriggerEvent('esx:spawnVehicle', "jetmax")
			DoScreenFadeIn(3000) 
			ESX.ShowNotification(_U('boat_pay', Config.PriceJetMax))
		else
			TriggerEvent('esx:spawnVehicle', "jetmax")
		end
		ESX.UI.Menu.CloseAll()
		haveboat = true	
	end
	
	
	-- outfits
	
	if data.current.value == 'citizen_wear' then
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
	end
	
	if data.current.value == 'outfit' then
        TriggerEvent('skinchanger:getSkin', function(skin)
        
            if skin.sex == 0 then

                local clothesSkin = {
					['tshirt_1'] = 0, ['tshirt_2'] = 0,
                    ['torso_1'] = 0, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 0,
                    ['pants_1'] = 0, ['pants_2'] = 0,
                    ['shoes_1'] = 0, ['shoes_2'] = 0,
                    ['helmet_1'] = -1, ['helmet_2'] = 0,
                    ['chain_1'] = 0, ['chain_2'] = 0,
                    ['ears_1'] = -1, ['ears_2'] = -1
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            else

                local clothesSkin = {
                    ['tshirt_1'] = 0, ['tshirt_2'] = 0,
                    ['torso_1'] = 0, ['torso_2'] = 0,
                    ['decals_1'] = 0, ['decals_2'] = 0,
                    ['arms'] = 0,
                    ['pants_1'] = 0, ['pants_2'] = 0,
                    ['shoes_1'] = 0, ['shoes_2'] = 0,
                    ['helmet_1'] = 0, ['helmet_2'] = 0,
                    ['chain_1'] = 0, ['chain_2'] = 0,
                    ['ears_1'] = -1, ['ears_2'] = -1
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

            end

            local playerPed = PlayerPedId()
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
        end)
      end
	

    end,
	function(data, menu)
		menu.close()
		end
	)
end