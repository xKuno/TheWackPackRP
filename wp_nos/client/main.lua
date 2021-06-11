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
ESX              = nil
local PlayerData = {}
local nitroActivado = false
local TimeTrial = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do

        Citizen.Wait(0)
        local ped = PlayerPedId()
		local isInVeh = IsPedInAnyVehicle(ped, false)
		if IsControlPressed(1, 58) and nitroActivado and isInVeh and not TimeTrial then
			local playerVeh = GetVehiclePedIsIn(ped, false)
			print(GetEntitySpeed(playerVeh))
			if not IsPedInAnyHeli(ped) and not IsPedInAnyPlane(ped) and not IsPedInAnyBoat(ped) and not IsThisModelABicycle(GetEntityModel(vehicle)) and IsVehicleOnAllWheels(playerVeh) and IsVehicleEngineOn(playerVeh) then
				if (GetEntitySpeed(playerVeh) * 2.236936) > 15 then
					if (GetEntitySpeed(playerVeh) * 2.236936) > 150 then
						SetVehicleEngineHealth(playerVeh, 0.0)
						SetVehicleEngineOn(playerVeh, false, true, true)
						exports['mythic_notify']:SendAlert('inform', 'Your engine blew up.', 2500)
					else
						local force = 80.0
						local vehEngine = GetVehicleEngineHealth(playerVeh)
						local RNG = math.random(1, 10)
						local RNGTyre = math.random(1, 100)
						Citizen.Wait(0)
						TriggerEvent('menu:notHasNos', true)
						SetVehicleBoostActive(playerVeh, 1, 0)
						SetVehicleForwardSpeed(playerVeh, force)
						StartScreenEffect("RaceTurbo", 0, 0)
						SetVehicleBoostActive(playerVeh, 0, 0)
						nitroActivado = false
						TriggerEvent("noshud", 0, false)
						if RNG == 10 then
							SetVehicleEngineHealth(playerVeh, vehEngine - 80)
							exports['mythic_notify']:SendAlert('inform', 'Your engine sustained extreme damage from the nos.', 2500)
							if RNGTyre >= 75 then
								SetVehicleTyreBurst(playerVeh, 0, true, 1000.0)
								SetVehicleTyreBurst(playerVeh, 1, true, 1000.0)
								SetVehicleTyreBurst(playerVeh, 4, true, 1000.0)
								SetVehicleTyreBurst(playerVeh, 5, true, 1000.0)
							end
						else
							SetVehicleEngineHealth(playerVeh, vehEngine - 40)
						end
					end
				end
			end
		elseif IsControlJustPressed(1, 58) and nitroActivado and TimeTrial then
			exports['mythic_notify']:SendAlert('inform', 'You can not use NOS during a time trial.', 2500)
        end
    end
end)

RegisterNetEvent('hypr9speed:activar')
AddEventHandler('hypr9speed:activar', function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		if not IsPedInAnyHeli(PlayerPedId()) and not IsPedInAnyPlane(PlayerPedId()) and not IsPedInAnyBoat(PlayerPedId()) and not IsThisModelABicycle(GetEntityModel(vehicle)) then
			if not IsToggleModOn(vehicle, 18) then
				exports['mythic_notify']:SendAlert('inform', 'You need a Turbo for NOS!', 2500)
			else
				TriggerServerEvent('hypr9speed:removeInventoryItem','nos', 1)
				TriggerEvent('menu:hasNos', true)
				TriggerEvent("noshud", 100, false)
				if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
					ESX.UI.Menu.Close('default', 'es_extended', 'inventory')
				end

				if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory_item') then
					ESX.UI.Menu.Close('default', 'es_extended', 'inventory_item')
				end
				activarNitro()
			end
		else
			exports['mythic_notify']:SendAlert('inform', 'You can not install nos in this vehicle.', 2500)
		end
	else
		exports['mythic_notify']:SendAlert('inform', 'You are not in a vehicle.', 2500)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if nitroActivado and not IsPedInAnyVehicle(PlayerPedId(), false) then
			nitroActivado = false
			TriggerEvent('menu:notHasNos', true)
			TriggerEvent("noshud", 0, false)
			TriggerServerEvent('wp_items:addNosServer')
			exports['mythic_notify']:SendAlert('inform', 'You exited the vehicle and uninstalled the NOS.', 2500)
		end
	end
end)

function activarNitro()
    nitroActivado = true
end

RegisterNetEvent('wp_items:addNos')
AddEventHandler('wp_items:addNos', function(source)
    local playerPed = PlayerPedId()
	nitroActivado = false
    TriggerEvent('menu:notHasNos', true)
	TriggerEvent("noshud", 0, false)
    TriggerServerEvent('wp_items:addNosServer')
    exports['mythic_notify']:SendAlert('inform', 'You unhooked your NOS.', 2500)
end)

RegisterNetEvent("wp_items:InTimeTrial")
AddEventHandler("wp_items:InTimeTrial", function()
    TimeTrial = true
end)

RegisterNetEvent("wp_items:notInTimeTrial")
AddEventHandler("wp_items:notInTimeTrial", function()
    TimeTrial = false
end)

-- Thanks to Flacetracer for the code snippet @ https://forum.fivem.net/t/help-add-speed-for-vehicle/23966
