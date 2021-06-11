local AvailableExtras = {['VehicleExtras'] = {}, ['TrailerExtras'] = {}}
local Items = {['Vehicle'] = {}, ['Trailer'] = {}}
local Menupool = MenuPool.New()
local MainMenu = UIMenu.New('Vehicle Extras', '~b~Enable/Disable vehicle extras')
local TrailerMenu, MenuExists, Vehicle, TrailerHandle, GotTrailer, DeletingMenu
Menupool:Add(MainMenu)

-- Actual Menu [

local IsAdmin

RegisterNetEvent('VEM:AdminStatusChecked')
AddEventHandler('VEM:AdminStatusChecked', function(State) --Just Don't Edit!
	IsAdmin = State
end)

-- Init ESX
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		Menupool:MouseControlsEnabled (false);
		Menupool:MouseEdgeEnabled (false);
		Menupool:ControlDisablingEnabled(false)
	end
end)


Citizen.CreateThread(function() --Controls
	while true do
		Citizen.Wait(0)

		if not DeletingMenu then
			Menupool:ProcessMenus()
		end
		
		local IsInVehicle = IsPedInAnyVehicle(PlayerPedId(), false)

		if ((GetIsControlJustPressed(VEM.KBKey) and GetLastInputMethod(2))) and MenuExists then
			veheng = GetVehicleEngineHealth(Vehicle)
			if veheng > 900 and (GetEntitySpeed(Vehicle) * 2.236936) < 5 then
				SetVehicleAutoRepairDisabled(Vehicle, false)
				MainMenu:Visible(not MainMenu:Visible())
			elseif (GetEntitySpeed(Vehicle) * 2.236936) > 5 then
				SetVehicleAutoRepairDisabled(Vehicle, true)
				TriggerEvent('esx:showNotification', 'Your car needs to be stationary.')
			elseif veheng < 899 then
				SetVehicleAutoRepairDisabled(Vehicle, true)
				TriggerEvent('esx:showNotification', 'Your car needs to be repaired first.')
			end
		end
		
		local CurrentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		local Got, Handle = GetVehicleTrailerVehicle(CurrentVehicle)

		if not MenuExists and IsInVehicle then
			Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			VEM.CreateMenu(Got, Handle)
		elseif MenuExists and (not IsInVehicle or (TrailerMenu and not Got) or Handle ~= TrailerHandle or Vehicle ~= CurrentVehicle) then
			VEM.DeleteMenu()
		end

	end
end)

-- ] Actual Menu

-- Functions [

function VEM.CreateMenu(Got, Handle)
	GotVehicleExtras = false
	GotTrailerExtras = false
	GotTrailer = Got
	TrailerHandle = Handle

	for ExtraID = 0, 20 do
		if DoesExtraExist(Vehicle, ExtraID) then
			AvailableExtras.VehicleExtras[ExtraID] = (IsVehicleExtraTurnedOn(Vehicle, ExtraID) == 1)
			GotVehicleExtras = true
		end
		
		if GotTrailer and DoesExtraExist(TrailerHandle, ExtraID) then
			if not TrailerMenu then
				TrailerMenu = Menupool:AddSubMenu(MainMenu, 'Trailer Extras', '~b~Enable/Disable trailer extras')
			end
			
			AvailableExtras.TrailerExtras[ExtraID] = (IsVehicleExtraTurnedOn(TrailerHandle, ExtraID) == 1)
			GotTrailerExtras = true
		end
	end

	-- Vehicle Extras
			if GotVehicleExtras then
				
				for Key, Value in pairs(AvailableExtras.VehicleExtras) do
					local ExtraItem = UIMenuCheckboxItem.New('Extra ' .. Key, AvailableExtras.VehicleExtras[Key])
					MainMenu:AddItem(ExtraItem)
					Items.Vehicle[Key] = ExtraItem
				end

				MainMenu.OnCheckboxChange = function(Sender, Item, Checked)
					for Key, Value in pairs(Items.Vehicle) do
						if Item == Value then
							AvailableExtras.VehicleExtras[Key] = Checked
							veheng = GetVehicleEngineHealth(Vehicle)
							if veheng > 900 then
								if AvailableExtras.VehicleExtras[Key] then
									local vehicleProps  = ESX.Game.GetVehicleProperties(Vehicle)
									--TriggerServerEvent("esx_discordbot:vehicle_repaired_alert", GetPlayerName(PlayerId()), GetPlayerServerId(PlayerId()), GetDisplayNameFromVehicleModel(vehicleProps.model), vehicleProps.plate)
									SetVehicleExtra(Vehicle, Key, 0)
								else
									SetVehicleExtra(Vehicle, Key, 1)
								end
							else
								SetVehicleEngineHealth(Vehicle, 100.0)
								--TriggerServerEvent("esx_discordbot:vehicle_repaired_alert", GetPlayerName(PlayerId()), GetPlayerServerId(PlayerId()), GetDisplayNameFromVehicleModel(vehicleProps.model), vehicleProps.plate)
							end
						end
					end
				end
			end

	-- Trailer Extras
			if GotTrailerExtras then
				SetVehicleAutoRepairDisabled(TrailerHandle, VEM.DisableAutoRepair)
				
				for Key, Value in pairs(AvailableExtras.TrailerExtras) do
					local ExtraItem = UIMenuCheckboxItem.New('Extra ' .. Key, AvailableExtras.TrailerExtras[Key])
					TrailerMenu:AddItem(ExtraItem)
					Items.Trailer[Key] = ExtraItem
				end

				TrailerMenu.OnCheckboxChange = function(Sender, Item, Checked)
					for Key, Value in pairs(Items.Trailer) do
						if Item == Value then
							AvailableExtras.TrailerExtras[Key] = Checked
							local GotTrailer, TrailerHandle = GetVehicleTrailerVehicle(Vehicle)
							if AvailableExtras.TrailerExtras[Key] then
								SetVehicleExtra(TrailerHandle, Key, 0)
							else
								SetVehicleExtra(TrailerHandle, Key, 1)
							end
						end
					end
				end
			end

	if GotVehicleExtras or GotTrailerExtras then
		Menupool:RefreshIndex()
		MenuExists = true
	end
end

function VEM.DeleteMenu()
	DeletingMenu = true
	Vehicle = nil
	AvailableExtras = {['VehicleExtras'] = {}, ['TrailerExtras'] = {}}
	Items = {['Vehicle'] = {}, ['Trailer'] = {}}

	Menupool = MenuPool.New()
	MainMenu = UIMenu.New('Vehicle Extras', '~b~Enable/Disable vehicle extras')
	Menupool:Add(MainMenu)
	MenuExists = false
	DeletingMenu = false
end

function GetIsControlPressed(Control)
	if IsControlPressed(1, Control) or IsDisabledControlPressed(1, Control) then
		return true
	end
	return false
end

function GetIsControlJustPressed(Control)
	if IsControlJustPressed(1, Control) or IsDisabledControlJustPressed(1, Control) then
		return true
	end
	return false
end

