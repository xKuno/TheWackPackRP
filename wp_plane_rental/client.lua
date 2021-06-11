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

local haveplane = false

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
				if haveplane == false then
					AddTextEntry("FREE_plane", _U('press_e'))
					DisplayHelpTextThisFrame("FREE_plane",false )
					if IsControlJustPressed(0, Keys['E']) and IsPedOnFoot(PlayerPedId()) then
						Citizen.Wait(100)  
						OpenplanesMenu()
					end 
				elseif haveplane == true then
					AddTextEntry("FREE_plane", _U('storeplane')) 
					DisplayHelpTextThisFrame("FREE_plane",false )
					if IsControlJustPressed(0, Keys['E']) then
						if IsPedInAnyHeli(PlayerPedId()) or IsPedInAnyPlane(PlayerPedId())  then
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
								ESX.ShowNotification(_U('planemessage'))
							else
								TriggerEvent("chatMessage", _U('planes'), {255,255,0}, _U('planemessage'))
							end
							haveplane = false
						else
							if Config.EnableEffects then
								ESX.ShowNotification(_U('notaplane'))
							else
								TriggerEvent("chatMessage", _U('planes'), {255,255,0}, _U('notaplane'))
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



function OpenplanesMenu()
	
	local elements = {}

	ESX.TriggerServerCallback('wp_plane_rental:getPilotLicense', function(hasLicense)
		if hasLicense then
			if Config.EnablePrice == false then
				table.insert(elements, {label = _U('planefree'), value = 'planeValue'}) 
				table.insert(elements, {label = _U('plane2free'), value = 'planeValue2'}) 
				table.insert(elements, {label = _U('plane3free'), value = 'planeValue3'}) 
				table.insert(elements, {label = _U('plane4free'), value = 'planeValue4'}) 
				table.insert(elements, {label = _U('plane5free'), value = 'planeValue5'}) 
				table.insert(elements, {label = _U('plane6free'), value = 'planeValue6'}) 
				table.insert(elements, {label = _U('plane7free'), value = 'planeValue7'}) 
				table.insert(elements, {label = _U('plane8free'), value = 'planeValue8'}) 
			end
			
			if Config.EnablePrice == true then
				table.insert(elements, {label = _U('plane'), value = 'planeValue'}) 
				table.insert(elements, {label = _U('plane2'), value = 'planeValue2'}) 
				table.insert(elements, {label = _U('plane3'), value = 'planeValue3'}) 
				table.insert(elements, {label = _U('plane4'), value = 'planeValue4'}) 
				table.insert(elements, {label = _U('plane5'), value = 'planeValue5'}) 
				table.insert(elements, {label = _U('plane6'), value = 'planeValue6'}) 
				table.insert(elements, {label = _U('plane7'), value = 'planeValue7'}) 
				table.insert(elements, {label = _U('plane8'), value = 'planeValue8'}) 
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
				title    = _U('planetitle'),
				align    = 'right',
				elements = elements,
			},
			
			
			function(data, menu)

			if data.current.value == 'planeValue' then
				if Config.EnableSoundEffects == true then
					TriggerServerEvent('InteractSound_SV:PlayOnSource', 'buy', Config.Volume)
				end
				if Config.EnablePrice then
					TriggerServerEvent("esx:lowmoney", Config.PriceSeabreeze) 
				end
				
				if Config.EnableEffects then
					DoScreenFadeOut(1000)
					Citizen.Wait(1000)
					TriggerEvent('esx:spawnVehicle', "seabreeze")
					DoScreenFadeIn(3000) 
					ESX.ShowNotification(_U('plane_pay', Config.PriceSeabreeze))
				else
					TriggerEvent('esx:spawnVehicle', "seabreeze")
					TriggerEvent("chatMessage", _U('planes'), {255,0,255}, _U('plane_pay', Config.PriceSeabreeze))
				end
				
				ESX.UI.Menu.CloseAll()
				haveplane = true	
			end
			
			if data.current.value == 'planeValue2' then
				if Config.EnableSoundEffects == true then
					TriggerServerEvent('InteractSound_SV:PlayOnSource', 'buy', Config.Volume)
				end
				if Config.EnablePrice then
					TriggerServerEvent("esx:lowmoney", Config.PriceVestra) 
				end
				
				if Config.EnableEffects then
					DoScreenFadeOut(1000)
					Citizen.Wait(1000)
					TriggerEvent('esx:spawnVehicle', "vestra")
					DoScreenFadeIn(3000) 
					ESX.ShowNotification(_U('plane_pay', Config.PriceVestra))
				else
					TriggerEvent('esx:spawnVehicle', "vestra")
					TriggerEvent("chatMessage", _U('planes'), {255,0,255}, _U('plane_pay', Config.PriceVestra))
				end
				
				ESX.UI.Menu.CloseAll()
				haveplane = true	
			end
			
			if data.current.value == 'planeValue3' then
				if Config.EnableSoundEffects == true then
					TriggerServerEvent('InteractSound_SV:PlayOnSource', 'buy', Config.Volume)
				end
				if Config.EnablePrice then
					TriggerServerEvent("esx:lowmoney", Config.PriceCuban800) 
				end
				
				if Config.EnableEffects then
					DoScreenFadeOut(1000)
					Citizen.Wait(1000)
					TriggerEvent('esx:spawnVehicle', "cuban800")
					DoScreenFadeIn(3000) 
					ESX.ShowNotification(_U('plane_pay', Config.PriceCuban800))
				else
					TriggerEvent('esx:spawnVehicle', "cuban800")
					TriggerEvent("chatMessage", _U('planes'), {255,0,255}, _U('plane_pay', Config.PriceCuban800))
				end
				ESX.UI.Menu.CloseAll()
				haveplane = true	
			end
			
			if data.current.value == 'planeValue4' then
				if Config.EnableSoundEffects == true then
					TriggerServerEvent('InteractSound_SV:PlayOnSource', 'buy', Config.Volume)
				end
				if Config.EnablePrice then
					TriggerServerEvent("esx:lowmoney", Config.PriceDodo) 
				end
				
				if Config.EnableEffects then
					DoScreenFadeOut(1000)
					Citizen.Wait(1000)
					TriggerEvent('esx:spawnVehicle', "dodo")
					DoScreenFadeIn(3000) 
					ESX.ShowNotification(_U('plane_pay', Config.PriceDodo))
				else
					TriggerEvent('esx:spawnVehicle', "dodo")
					TriggerEvent("chatMessage", _U('planes'), {255,0,255}, _U('plane_pay', Config.PriceDodo))
				end
				ESX.UI.Menu.CloseAll()
				haveplane = true	
			end

			if data.current.value == 'planeValue5' then
				if Config.EnableSoundEffects == true then
					TriggerServerEvent('InteractSound_SV:PlayOnSource', 'buy', Config.Volume)
				end
				if Config.EnablePrice then
					TriggerServerEvent("esx:lowmoney", Config.PriceMicrolight) 
				end
				
				if Config.EnableEffects then
					DoScreenFadeOut(1000)
					Citizen.Wait(1000)
					TriggerEvent('esx:spawnVehicle', "microlight")
					DoScreenFadeIn(3000) 
					ESX.ShowNotification(_U('plane_pay', Config.PriceMicrolight))
				else
					TriggerEvent('esx:spawnVehicle', "microlight")
					TriggerEvent("chatMessage", _U('planes'), {255,0,255}, _U('plane_pay', Config.PriceMicrolight))
				end
				ESX.UI.Menu.CloseAll()
				haveplane = true	
			end

			if data.current.value == 'planeValue6' then
				if Config.EnableSoundEffects == true then
					TriggerServerEvent('InteractSound_SV:PlayOnSource', 'buy', Config.Volume)
				end
				if Config.EnablePrice then
					TriggerServerEvent("esx:lowmoney", Config.PriceMaverick) 
				end
				
				if Config.EnableEffects then
					DoScreenFadeOut(1000)
					Citizen.Wait(1000)
					TriggerEvent('esx:spawnVehicle', "maverick")
					DoScreenFadeIn(3000) 
					ESX.ShowNotification(_U('plane_pay', Config.PriceMaverick))
				else
					TriggerEvent('esx:spawnVehicle', "maverick")
					TriggerEvent("chatMessage", _U('planes'), {255,0,255}, _U('plane_pay', Config.PriceMaverick))
				end
				ESX.UI.Menu.CloseAll()
				haveplane = true	
			end

			if data.current.value == 'planeValue7' then
				if Config.EnableSoundEffects == true then
					TriggerServerEvent('InteractSound_SV:PlayOnSource', 'buy', Config.Volume)
				end
				if Config.EnablePrice then
					TriggerServerEvent("esx:lowmoney", Config.PriceSwift) 
				end
				
				if Config.EnableEffects then
					DoScreenFadeOut(1000)
					Citizen.Wait(1000)
					TriggerEvent('esx:spawnVehicle', "swift")
					DoScreenFadeIn(3000) 
					ESX.ShowNotification(_U('plane_pay', Config.PriceSwift))
				else
					TriggerEvent('esx:spawnVehicle', "swift")
					TriggerEvent("chatMessage", _U('planes'), {255,0,255}, _U('plane_pay', Config.PriceSwift))
				end
				ESX.UI.Menu.CloseAll()
				haveplane = true	
			end

			if data.current.value == 'planeValue8' then
				if Config.EnableSoundEffects == true then
					TriggerServerEvent('InteractSound_SV:PlayOnSource', 'buy', Config.Volume)
				end
				if Config.EnablePrice then
					TriggerServerEvent("esx:lowmoney", Config.PriceFrogger) 
				end
				
				if Config.EnableEffects then
					DoScreenFadeOut(1000)
					Citizen.Wait(1000)
					TriggerEvent('esx:spawnVehicle', "frogger")
					DoScreenFadeIn(3000) 
					ESX.ShowNotification(_U('plane_pay', Config.PriceFrogger))
				else
					TriggerEvent('esx:spawnVehicle', "frogger")
					TriggerEvent("chatMessage", _U('planes'), {255,0,255}, _U('plane_pay', Config.PriceFrogger))
				end
				ESX.UI.Menu.CloseAll()
				haveplane = true	
			end

			end,
			function(data, menu)
				menu.close()
			end)
		elseif not hasLicense then
			exports['mythic_notify']:SendAlert('inform', 'You do not have a pilots license.', 2500)
		end
	end)
end