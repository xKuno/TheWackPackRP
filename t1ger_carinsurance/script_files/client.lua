-------------------------------------
------- Created by T1GER#9080 -------
------------------------------------- 

ESX = nil
PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.GETSHAREDOBJECT, function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

menuOpen = false
-- Job NPC Thread Function:
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1)
		local player = PlayerPedId()
		local coords = GetEntityCoords(player)
		for k,v in pairs(Config.InsCompany) do
			local dist = GetDistanceBetweenCoords(v.Pos[1], v.Pos[2], v.Pos[3], coords.x, coords.y, coords.z, false)
			local mk = v.Marker
			if mk.Enable and dist <= mk.DrawDist and not menuOpen then
				DrawMarker(mk.Type, v.Pos[1], v.Pos[2], v.Pos[3]-0.97, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, mk.Scale.x, mk.Scale.y, mk.Scale.z, mk.Color.r, mk.Color.g, mk.Color.b, mk.Color.a, false, true, 2, false, false, false, false)
			end
			if dist <= 1.5 and not menuOpen then
				DrawText3Ds(v.Pos[1], v.Pos[2], v.Pos[3]+0.2, Lang['open_menu'])
				if IsControlJustPressed(0, v.Key) then
					OpenInsuranceMenu()
					Citizen.Wait(250)
				end
			end
		end
	end
end)

function OpenBuyMenu(plate,insurance,carName)	
	local elements = {}
	local insLabel
	
	if insurance == 0 then
		insLabel = Lang['status_not_insured']
		table.insert(elements,{label = Lang['buy_ins'], value = 'buy_insurance'})
	elseif 	insurance == 1 then
		insLabel = Lang['status_insured']
		table.insert(elements,{label = Lang['del_ins'], value = 'del_insurnace'})
	end
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "insurance_second_menu",
		{
			title    = carName..": "..insLabel,
			align    = Config.ShopMenuAlign,
			elements = elements
		},
	function(data, menu)
		menu.close()
		
		if(data.current.value == 'buy_insurance') then
			menu.close()
			if insurance == 0 then
				local vehIns = 1
				TriggerEvent("mythic_progbar:client:progress", {
					name = "BUYING_INSURANCE",
					duration = 2000,
					label = "Buying Insurance",
					useWhileDead = false,
					canCancel = false,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
				}, function(status)
					if not status then
						TriggerServerEvent('t1ger_carinsurance:updateInsurance', plate,vehIns)
					end
				end)
				exports['mythic_notify']:SendAlert('inform', 'Purchased Insurance', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
				OpenInsuranceMenu()
			else
				exports['mythic_notify']:SendAlert('inform', 'Vehicle is already insured', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
			end
		end
		if(data.current.value == 'del_insurnace') then
			menu.close()
			if insurance == 1 then
				local vehIns = 0
				
				TriggerEvent("mythic_progbar:client:progress", {
					name = "cancelling",
					duration = 1000,
					label = "Cancelling Insurance",
					useWhileDead = false,
					canCancel = false,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
				}, function(status)
					if not status then
						TriggerServerEvent('t1ger_carinsurance:updateInsurance', plate,vehIns)
					end
				end)
				exports['mythic_notify']:SendAlert('inform', 'Cancelled Insurance!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })--RED
				menu.close()
			else
				menu.close()
				exports['mythic_notify']:SendAlert('inform', 'Vehicle is not insured!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })--RED
			end
			OpenInsuranceMenu()
		end
	end, function(data, menu)
		menu.close()
		OpenInsuranceMenu()
	end)
end

RegisterNetEvent('t1ger_carinsurance:openMenu')
AddEventHandler('t1ger_carinsurance:openMenu', function()
	OpenInsuranceMenu()
end)

function OpenInsuranceMenu()
	menuOpen = true
	local playerPed  = PlayerPedId()
	FreezeEntityPosition(playerPed, true)
	local elements = {}
	
	ESX.TriggerServerCallback("t1ger_carinsurance:fetchData", function(vehicles)
	
		for k,v in pairs(vehicles) do
			local vehHash = v.vehicle.model
			local vehName = GetDisplayNameFromVehicleModel(vehHash)
			local vehLabel = GetLabelText(vehName)
			
			table.insert(elements,{ label = vehLabel.." ("..v.plate..")" , name = vehLabel, plate = v.plate, insurance = v.insurance})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), "insurance_main_menu",
			{
				title    = Lang['insurance_menu_title'],
				align    = Config.ShopMenuAlign,
				elements = elements
			},
		function(data, menu)
			menu.close()
			OpenBuyMenu(data.current.plate, data.current.insurance, data.current.name)
		end, function(data, menu)
			menu.close()
			ESX.UI.Menu.CloseAll()
			FreezeEntityPosition(playerPed, false)
			menuOpen = false
		end)
	end)
end

-- Client Event to check veh for insurance state
RegisterNetEvent('t1ger_carinsurance:checkVehInsurance')
AddEventHandler('t1ger_carinsurance:checkVehInsurance', function(vehPlate)
	ESX.TriggerServerCallback("t1ger_carinsurance:checkInsurance", function(hasInsurance)
		if hasInsurance == true then
			if Config.VehCheckChatMSG then
				exports['mythic_notify']:SendAlert('inform', 'The vehicle has insurance', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' }) -- GREEN
			else
				exports['mythic_notify']:SendAlert('inform', 'Vehicle is not insured!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })--RED
			end
		elseif hasInsurance == false then
			if Config.VehCheckChatMSG then
			-- 	TriggerEvent('chat:addMessage', { args = { (Lang['veh_check_ins_0']):format(vehPlate) } })
			-- else
			exports['mythic_notify']:SendAlert('inform', 'The vehicle does not have insurance', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) --RED
			end	
		end	
	end,vehPlate)
end)

-- Client Event to pay veh insurances
RegisterNetEvent('t1ger_carinsurance:payVehInsurance')
AddEventHandler('t1ger_carinsurance:payVehInsurance', function()
	local OwnedVeh = {}
	ESX.TriggerServerCallback("t1ger_carinsurance:fetchInsuredCars", function(insurance)
		for k,v in pairs(insurance) do
			local vehMatch = false
			local carModel = string.lower(GetDisplayNameFromVehicleModel(v.vehicle.model))
			table.insert(OwnedVeh, {name = carModel, plate = v.plate, insurance = v.insurance})
		end
		TriggerServerEvent("t1ger_carinsurance:getPayment", OwnedVeh)
	end)
end)

RegisterNetEvent('t1ger_carinsurance:insuranceF1')
AddEventHandler('t1ger_carinsurance:insuranceF1', function(source)

	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'plate_insurance', {
		title = "Enter Plate"
	},
	function(data, menu)
		local plate = string.upper(data.value)
		if plate == nil or plate == "" then
			exports['mythic_notify']:SendAlert('inform', 'No plate specified.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
		else
		menu.close()
		
			local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= Config.DistToShow then
					TriggerServerEvent('t1ger_carinsurance:openSV', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), plate)
				else
					exports['mythic_notify']:SendAlert('inform', 'No one nearby.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
				end
	
			end

		end, function(data, menu)
		menu.close()
	end)

end)

RegisterNetEvent('t1ger_carinsurance:insuranceViewF1')
AddEventHandler('t1ger_carinsurance:insuranceViewF1', function(source)

	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'plate_insurance', {
		title = "Enter Plate"
	},
	function(data, menu)
		local plate = string.upper(data.value)
		if plate == nil or plate == "" then
			exports['mythic_notify']:SendAlert('inform', 'No plate specified.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
		else
		menu.close()
		
		TriggerServerEvent('t1ger_carinsurance:openSV', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), plate)
	
			end

		end, function(data, menu)
		menu.close()
	end)

end)

-- Insurance Commands:
RegisterCommand('insurance', function(source, args)
	local option = args[1]
	local typedCommand = args[2]
	local plate = typedCommand:gsub("^%s*(.-)%s*$", "%1")
		
	if option == "check" then
		if PlayerData.job ~= nil and PlayerData.job.name == Config.PoliceJobLabel then
			if plate ~= nil or plate == '' then
				TriggerEvent("t1ger_carinsurance:checkVehInsurance",plate)
			else
				exports['mythic_notify']:SendAlert('inform', 'Please enter plate number!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
			end
		else
			exports['mythic_notify']:SendAlert('inform', 'You are not a cop!', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
		end
	elseif option == "view" then
		TriggerServerEvent('t1ger_carinsurance:openSV', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), plate)
	
	elseif option == "show" then
		local player, distance = ESX.Game.GetClosestPlayer()
		if distance ~= -1 and distance <= Config.DistToShow then
			TriggerServerEvent('t1ger_carinsurance:openSV', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), plate)
		else
			exports['mythic_notify']:SendAlert('inform', 'No one nearby', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
		end
	
	end
	
end, false)

-- Chat suggestions:
TriggerEvent('chat:addSuggestion', '/insurance', 'check insurance on a plate or view/show insurance paper for a plate', {
	{ name="option", help="choose between: check, show or view" },
	{ name="plate", help="type in the plate nr" }
})
