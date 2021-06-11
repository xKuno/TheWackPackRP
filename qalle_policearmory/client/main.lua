ESX = nil


Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(5)

		TriggerEvent("esx:getSharedObject", function(library)
			ESX = library
		end)
    end

    if ESX.IsPlayerLoaded() then
		ESX.PlayerData = ESX.GetPlayerData()

		RefreshPed()
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	ESX.PlayerData = response

	RefreshPed()
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
	ESX.PlayerData["job"] = response
end)

Citizen.CreateThread(function()
    Wait(100)
    while true do
        if ESX.PlayerData["job"] and (ESX.PlayerData["job"]["name"] == "police") then
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            if #(pedCoords-Config.Armory) <= 5.0 then
                local text = "Armory"
                if #(pedCoords-Config.Armory) <= 0.5 then
                    text = "[~g~E~s~] Armory"
                    if IsControlJustPressed(0, 38) then
                        OpenPoliceArmory()
                    end
                end
                ESX.Game.Utils.DrawText3D(Config.Armory, text, 0.6)
            end
        end
        Wait(0)
    end
end)

Citizen.CreateThread(function()
    Wait(100)
    while true do
        if ESX.PlayerData["job"] and (ESX.PlayerData["job"]["name"] == "police" and ESX.PlayerData["job"]["grade"] == 3) then
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            if #(pedCoords-Config.RangerArmory) <= 5.0 then
                local text = "Armory"
                if #(pedCoords-Config.RangerArmory) <= 0.5 then
                    text = "[~g~E~s~] Armory"
                    if IsControlJustPressed(0, 38) then
                        OpenRangerArmory()
                    end
                end
                ESX.Game.Utils.DrawText3D(Config.RangerArmory, text, 0.6)
            end
        end
        Wait(0)
    end
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)
	while true do
		if ESX.PlayerData["job"] and (ESX.PlayerData["job"]["name"] == "ambulance") then
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            if #(pedCoords-Config.EMSArmory) <= 5.0 then
                local text = "Armory"
                if #(pedCoords-Config.EMSArmory) <= 0.5 then
                    text = "[~g~E~s~] Armory"
                    if IsControlJustPressed(0, 38) then
                        OpenEMSArmory()
                    end
                end
                ESX.Game.Utils.DrawText3D(Config.EMSArmory, text, 0.6)
            end
        end
        Wait(0)
    end
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)
	while true do
		if ESX.PlayerData["job"] and (ESX.PlayerData["job"]["name"] == "blackmarket") then
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            if #(pedCoords-Config.BlackArmory) <= 5.0 then
                local text = "Armory"
                if #(pedCoords-Config.BlackArmory) <= 0.5 then
                    text = "[~g~E~s~] Armory"
                    if IsControlJustPressed(0, 38) then
                        OpenBlackArmory()
                    end
                end
                ESX.Game.Utils.DrawText3D(Config.BlackArmory, text, 0.6)
            end
        end
        Wait(0)
    end
end)

OpenPoliceArmory = function()
	PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

	local elements = {
        { ["label"] = "Police Items", ["action"] = "Item_Storage" },
        { ["label"] = "SWAT/CID Items", ["action"] = "Swat_Storage" },
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "police_armory_menu",
		{
			title    = "Police Armory",
			align    = "right",
			elements = elements
		},
	function(data, menu)
		local action = data.current["action"]

        if action == "Item_Storage" then
            OpenItemStorage()
        end 
        if action == "Swat_Storage" then
            OpenSwatItem()
        end
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

		menu.close()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end


OpenItemStorage = function()
    PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
    local elements = {}
    local Location = Config.Armory
    local PedLocation = Config.ArmoryPed

    for i = 1, #Config.Items, 1 do
        local item =  Config.Items[i]
        table.insert(elements, { ["label"] = item.name, ["item"] = item })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), "police_armory_item_menu",
        {
            title   = "Police Items",
            align   = "right",
            elements = elements
            
        },
    function(data, menu)
        local Item = data.current["item"]

        ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'police_armory_item_quantity', {
			title = "Enter Amount"
		},
		function(data2, menu2)
			local amount = tonumber(data2.value)
			if amount == nil or amount == "" then
				exports['mythic_notify']:SendAlert('inform', 'No amount specified.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
				menu2.close()
			else
				menu2.close()

				local closestPed, closestPedDst = ESX.Game.GetClosestPed(PedLocation)
				
				if (DoesEntityExist(closestPed) and closestPedDst >= 5.0) or IsPedAPlayer(closestPed) then
					RefreshPed(true) -- failsafe if the ped somehow dissapear.

					ESX.ShowNotification("Please try again.")

					return
				end

				if IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "pistol_on_counter_cop", 3) or IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "rifle_on_counter_cop", 3) then
					ESX.ShowNotification("Please wait on your turn.")
					return
				end

				if not NetworkHasControlOfEntity(closestPed) then
					NetworkRequestControlOfEntity(closestPed)

					Citizen.Wait(1000)
				end

				if not NetworkHasControlOfEntity(closestPed) then
					NetworkRequestControlOfEntity(closestPed)

					Citizen.Wait(1000)
				end

				SetEntityCoords(closestPed, PedLocation["x"], PedLocation["y"], PedLocation["z"] - 0.985)
				SetEntityHeading(closestPed, PedLocation["h"])

				SetEntityCoords(PlayerPedId(), Location["x"], Location["y"], Location["z"] - 0.985)
				SetEntityHeading(PlayerPedId(), Config.ArmoryHead)
				SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)

				local animLib = "mp_cop_armoury"

				LoadModels({ animLib })

				if DoesEntityExist(closestPed) and closestPedDst <= 5.0 then
					if Config.EnableBudget then
					TriggerServerEvent("qalle_policearmory:giveItemBudget", Item, amount)
					elseif not Config.EnableBudget then
					TriggerServerEvent("qalle_policearmory:giveItem", Item, amount)
					end
					TaskPlayAnim(closestPed, animLib, "package_from_counter", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)

					Citizen.Wait(1100)

					TaskPlayAnim(PlayerPedId(), animLib, "package_from_counter_cop", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)

					Citizen.Wait(3100)

					Citizen.Wait(15)
					
					ClearPedTasks(closestPed)
				end
			end

			UnloadModels()

		end, function(data2, menu2)
			menu2.close()
		end)

	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

		menu.close()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

OpenSwatItem = function()
    PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
    local elements = {}
    local Location = Config.Armory
    local PedLocation = Config.ArmoryPed

    for i = 1, #Config.SwatItem, 1 do
        local item =  Config.SwatItem[i]
        table.insert(elements, { ["label"] = item.name, ["item"] = item })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), "police_swat_item_menu",
        {
            title   = "Swat Items",
            align   = "right",
            elements = elements
            
        },
    function(data, menu)
        local Item = data.current["item"]

        ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'police_armory_item_quantity', {
			title = "Enter Amount"
		},
		function(data2, menu2)
			local amount = tonumber(data2.value)
			if amount == nil or amount == "" then
				exports['mythic_notify']:SendAlert('inform', 'No amount specified.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
				menu2.close()
			else
				menu2.close()

				local closestPed, closestPedDst = ESX.Game.GetClosestPed(PedLocation)
				
				if (DoesEntityExist(closestPed) and closestPedDst >= 5.0) or IsPedAPlayer(closestPed) then
					RefreshPed(true) -- failsafe if the ped somehow dissapear.

					ESX.ShowNotification("Please try again.")

					return
				end

				if IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "pistol_on_counter_cop", 3) or IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "rifle_on_counter_cop", 3) then
					ESX.ShowNotification("Please wait on your turn.")
					return
				end

				if not NetworkHasControlOfEntity(closestPed) then
					NetworkRequestControlOfEntity(closestPed)

					Citizen.Wait(1000)
				end

				if not NetworkHasControlOfEntity(closestPed) then
					NetworkRequestControlOfEntity(closestPed)

					Citizen.Wait(1000)
				end

				SetEntityCoords(closestPed, PedLocation["x"], PedLocation["y"], PedLocation["z"] - 0.985)
				SetEntityHeading(closestPed, PedLocation["h"])

				SetEntityCoords(PlayerPedId(), Location["x"], Location["y"], Location["z"] - 0.985)
				SetEntityHeading(PlayerPedId(), Config.ArmoryHead)
				SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)

				local animLib = "mp_cop_armoury"

				LoadModels({ animLib })

				if DoesEntityExist(closestPed) and closestPedDst <= 5.0 then
					if Config.EnableBudget then
					TriggerServerEvent("qalle_policearmory:giveItem2Budget", Item, amount)
					elseif not Config.EnableBudget then
					TriggerServerEvent("qalle_policearmory:giveItem2", Item, amount)
					end
					TaskPlayAnim(closestPed, animLib, "package_from_counter", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)

					Citizen.Wait(1100)

					TaskPlayAnim(PlayerPedId(), animLib, "package_from_counter_cop", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)

					Citizen.Wait(3100)

					Citizen.Wait(15)
					
					ClearPedTasks(closestPed)
				end

			end

			UnloadModels()

		end, function(data2, menu2)
			menu2.close()
		end)

	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

		menu.close()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

OpenRangerArmory = function()
	PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

	local elements = {
        { ["label"] = "Ranger Armory", ["action"] = "Ranger_Item_Storage" },
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "Ranger_Armory_Menu",
		{
			title    = "Ranger Armory",
			align    = "right",
			elements = elements
		},
	function(data, menu)
		local action = data.current["action"]

        if action == "Ranger_Item_Storage" then
            OpenRangerItemStorage()
        end 
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

		menu.close()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

OpenRangerItemStorage = function()
    PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
    local elements = {}
	local Location = Config.RangerArmory
    local PedLocation = Config.RangerPed
    
    for i = 1, #Config.RangerItems, 1 do
        local item =  Config.RangerItems[i]
        table.insert(elements, { ["label"] = item.name, ["item"] = item })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), "Ranger_Item_Storage_Menu",
        {
            title   = "Ranger Armory",
            align   = "right",
            elements = elements
            
        },
    function(data, menu)
        local Item = data.current["item"]

        ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'police_armory_item_quantity', {
			title = "Enter Amount"
		},
		function(data2, menu2)
			local amount = tonumber(data2.value)
			if amount == nil or amount == "" then
				exports['mythic_notify']:SendAlert('inform', 'No amount specified.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
				menu2.close()
			else
				menu2.close()

				local closestPed, closestPedDst = ESX.Game.GetClosestPed(PedLocation)
				
				if (DoesEntityExist(closestPed) and closestPedDst >= 5.0) or IsPedAPlayer(closestPed) then
					RefreshPed(true) -- failsafe if the ped somehow dissapear.

					ESX.ShowNotification("Please try again.")

					return
				end

				if IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "pistol_on_counter_cop", 3) or IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "rifle_on_counter_cop", 3) then
					ESX.ShowNotification("Please wait on your turn.")
					return
				end

				if not NetworkHasControlOfEntity(closestPed) then
					NetworkRequestControlOfEntity(closestPed)

					Citizen.Wait(1000)
				end

				if not NetworkHasControlOfEntity(closestPed) then
					NetworkRequestControlOfEntity(closestPed)

					Citizen.Wait(1000)
				end

				SetEntityCoords(closestPed, PedLocation["x"], PedLocation["y"], PedLocation["z"] - 0.985)
				SetEntityHeading(closestPed, PedLocation["h"])

				SetEntityCoords(PlayerPedId(), Location["x"], Location["y"], Location["z"] - 0.985)
				SetEntityHeading(PlayerPedId(), Config.RangerHead)
				SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)

				local animLib = "mp_cop_armoury"

				LoadModels({ animLib })

				if DoesEntityExist(closestPed) and closestPedDst <= 5.0 then
					if Config.EnableBudget then
					TriggerServerEvent("qalle_policearmory:giveItem4Budget", Item, amount)
					elseif not Config.EnableBudget then
					TriggerServerEvent("qalle_policearmory:giveItem4", Item, amount)
					end
					TaskPlayAnim(closestPed, animLib, "package_from_counter", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)

					Citizen.Wait(1100)

					TaskPlayAnim(PlayerPedId(), animLib, "package_from_counter_cop", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)

					Citizen.Wait(3100)

					Citizen.Wait(15)
					
					ClearPedTasks(closestPed)
				end

			end

			UnloadModels()

		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

		menu.close()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

--- Gun dealers--
OpenBlackArmory = function()
	PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

	local elements = {
        { ["label"] = "Black market", ["action"] = "Black_Market_Item_Storage" },
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "Black_Market_menu",
		{
			title    = "Black Market",
			align    = "right",
			elements = elements
		},
	function(data, menu)
		local action = data.current["action"]

        if action == "Black_Market_Item_Storage" then
            OpenBlackMarketItemStorage()
        end 
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

		menu.close()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

OpenBlackMarketItemStorage = function()
    PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
    local elements = {}
	local Location = Config.BlackArmory
    local PedLocation = Config.BlackPed
    
    for i = 1, #Config.BlackWeapons, 1 do
        local item =  Config.BlackWeapons[i]
        table.insert(elements, { ["label"] = item.name, ["item"] = item })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), "Black_Market_Item_Menu",
        {
            title   = "Black Market",
            align   = "right",
            elements = elements
            
        },
    function(data, menu)
        local Item = data.current["item"]

        ESX.UI.Menu.CloseAll()

        local closestPed, closestPedDst = ESX.Game.GetClosestPed(PedLocation)
        
        if (DoesEntityExist(closestPed) and closestPedDst >= 5.0) or IsPedAPlayer(closestPed) then
			RefreshPed(true) -- failsafe if the ped somehow dissapear.

			ESX.ShowNotification("Please try again.")

			return
		end

		if IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "pistol_on_counter_cop", 3) or IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "rifle_on_counter_cop", 3) then
			ESX.ShowNotification("Please wait on your turn.")
			return
		end

		if not NetworkHasControlOfEntity(closestPed) then
			NetworkRequestControlOfEntity(closestPed)

			Citizen.Wait(1000)
        end

        if not NetworkHasControlOfEntity(closestPed) then
			NetworkRequestControlOfEntity(closestPed)

			Citizen.Wait(1000)
		end

		SetEntityCoords(closestPed, PedLocation["x"], PedLocation["y"], PedLocation["z"] - 0.985)
		SetEntityHeading(closestPed, PedLocation["h"])

		SetEntityCoords(PlayerPedId(), Location["x"], Location["y"], Location["z"] - 0.985)
        SetEntityHeading(PlayerPedId(), Config.BlackHead)
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)

		local animLib = "mp_cop_armoury"

		LoadModels({ animLib })

        if DoesEntityExist(closestPed) and closestPedDst <= 5.0 then
            TriggerServerEvent("qalle_policearmory:GiveBlackItem", Item)
            -- print("item")
			TaskPlayAnim(closestPed, animLib, "package_from_counter", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)

			Citizen.Wait(1100)

			TaskPlayAnim(PlayerPedId(), animLib, "package_from_counter_cop", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)

			Citizen.Wait(3100)

            Citizen.Wait(15)
            
			ClearPedTasks(closestPed)
		end

		UnloadModels()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

		menu.close()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end
-- EMS STUFF ---

OpenEMSArmory = function()
	PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

	local elements = {
        { ["label"] = "EMS Item Storage", ["action"] = "Ems_Item_Storage" },
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ems_armory_menu",
		{
			title    = "EMS Armory",
			align    = "right",
			elements = elements
		},
	function(data, menu)
		local action = data.current["action"]

        if action == "Ems_Item_Storage" then
            OpenEmsItemStorage()
        end 
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

		menu.close()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end


OpenEmsItemStorage = function()
    PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
    local elements = {}
	local Location = Config.EMSArmory
    local PedLocation = Config.EMSArmoryPed
    
    for i = 1, #Config.EmsItems, 1 do
        local item =  Config.EmsItems[i]
        table.insert(elements, { ["label"] = item.name, ["item"] = item })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ems_armory_item_menu",
        {
            title   = "Ems Items",
            align   = "right",
            elements = elements
            
        },
    function(data, menu)
        local Item = data.current["item"]

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'police_armory_item_quantity', {
			title = "Enter Amount"
		},
		function(data2, menu2)
			local amount = tonumber(data2.value)
			if amount == nil or amount == "" then
				exports['mythic_notify']:SendAlert('inform', 'No amount specified.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
				menu2.close()
			else
				menu2.close()

				ESX.UI.Menu.CloseAll()

				local closestPed, closestPedDst = ESX.Game.GetClosestPed(PedLocation)
				
				if (DoesEntityExist(closestPed) and closestPedDst >= 5.0) or IsPedAPlayer(closestPed) then
					RefreshPed(true) -- failsafe if the ped somehow dissapear.

					ESX.ShowNotification("Please try again.")

					return
				end

				if IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "pistol_on_counter_cop", 3) or IsEntityPlayingAnim(closestPed, "mp_cop_armoury", "rifle_on_counter_cop", 3) then
					ESX.ShowNotification("Please wait on your turn.")
					return
				end

				if not NetworkHasControlOfEntity(closestPed) then
					NetworkRequestControlOfEntity(closestPed)

					Citizen.Wait(1000)
				end

				if not NetworkHasControlOfEntity(closestPed) then
					NetworkRequestControlOfEntity(closestPed)

					Citizen.Wait(1000)
				end

				SetEntityCoords(closestPed, PedLocation["x"], PedLocation["y"], PedLocation["z"] - 0.985)
				SetEntityHeading(closestPed, PedLocation["h"])

				SetEntityCoords(PlayerPedId(), Location["x"], Location["y"], Location["z"] - 0.985)
				SetEntityHeading(PlayerPedId(), Config.EmsHead)
				SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)

				local animLib = "mp_cop_armoury"

				LoadModels({ animLib })

				if DoesEntityExist(closestPed) and closestPedDst <= 5.0 then
					if Config.EnableBudget then
					TriggerServerEvent("qalle_policearmory:EmsGiveItemBudget", Item, amount)
					elseif not Config.EnableBudget then
					TriggerServerEvent("qalle_policearmory:EmsGiveItem", Item, amount)
					end
					-- print("item")
					TaskPlayAnim(closestPed, animLib, "package_from_counter", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)

					Citizen.Wait(1100)

					TaskPlayAnim(PlayerPedId(), animLib, "package_from_counter_cop", 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)

					Citizen.Wait(3100)

					Citizen.Wait(15)
					
					ClearPedTasks(closestPed)
				end
			end

			UnloadModels()

		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

		menu.close()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

-- END OF EMS STUFF --


RegisterNetEvent("qalle_policearmory:tooFull")
AddEventHandler("qalle_policearmory:tooFull", function()
    exports['mythic_notify']:SendAlert("error", "You have too many", 10000, {["background-color"] = "#f50a0a", ["color"] = "#ffffff"})
end)

RegisterNetEvent("qalle_policearmory:NoMoney")
AddEventHandler("qalle_policearmory:NoMoney", function()
    local ped = PlayerPedId()
    exports['mythic_notify']:SendAlert("error", "You don't have enough money!", 10000, {["background-color"] = "#f50a0a", ["color"] = "#ffffff"})
    Wait(2000)
    ClearPedTasksImmediately(ped)
end)

RegisterNetEvent("qalle_policearmory:notSwat")
AddEventHandler("qalle_policearmory:notSwat", function()
    exports['mythic_notify']:SendAlert("error", "You're not SWAT!", 10000, {["background-color"] = "#f50a0a", ["color"] = "#ffffff"})
end)




RefreshPed = function(spawn)
    local Location = Config.ArmoryPed
    local Location2 = Config.EMSArmoryPed
    local Location3 = Config.BlackPed
    local Location4 = Config.RangerPed

	ESX.TriggerServerCallback("qalle_policearmory:pedExists", function(Exists)
		if Exists and not spawn then
			return
		else
            LoadModels({ GetHashKey(Location["hash"]) })
            LoadModels({ GetHashKey(Location2["hash"]) })
            LoadModels({ GetHashKey(Location3["hash"]) })
            LoadModels({ GetHashKey(Location4["hash"]) })

            local pedId = CreatePed(5, Location["hash"], Location["x"], Location["y"], Location["z"] - 0.985, Location["h"], true)
            local pedId2 = CreatePed(5, Location2["hash"], Location2["x"], Location2["y"], Location2["z"] - 0.985, Location2["h"], true)
            local pedId3 = CreatePed(5, Location3["hash"], Location3["x"], Location3["y"], Location3["z"] - 0.985, Location3["h"], true)
            local pedId4 = CreatePed(5, Location4["hash"], Location4["x"], Location4["y"], Location4["z"] - 0.985, Location4["h"], true)

			SetPedCombatAttributes(pedId, 46, true)                     
			SetPedFleeAttributes(pedId, 0, 0)                      
			SetBlockingOfNonTemporaryEvents(pedId, true)
			
			SetEntityAsMissionEntity(pedId, true, true)
			SetEntityInvincible(pedId, true)

			FreezeEntityPosition(pedId, true)


            SetPedCombatAttributes(pedId2, 46, true)                     
			SetPedFleeAttributes(pedId2, 0, 0)                      
			SetBlockingOfNonTemporaryEvents(pedId2, true)
			
			SetEntityAsMissionEntity(pedId2, true, true)
			SetEntityInvincible(pedId2, true)

			FreezeEntityPosition(pedId2, true)

			SetPedCombatAttributes(pedId3, 46, true)                     
			SetPedFleeAttributes(pedId3, 0, 0)                      
			SetBlockingOfNonTemporaryEvents(pedId3, true)
			
			SetEntityAsMissionEntity(pedId3, true, true)
			SetEntityInvincible(pedId3, true)

			FreezeEntityPosition(pedId3, true)

            SetPedCombatAttributes(pedId4, 46, true)                     
			SetPedFleeAttributes(pedId4, 0, 0)                      
			SetBlockingOfNonTemporaryEvents(pedId4, true)
			
			SetEntityAsMissionEntity(pedId4, true, true)
			SetEntityInvincible(pedId4, true)

			FreezeEntityPosition(pedId4, true)

		end
	end)
end


local CachedModels = {}

LoadModels = function(models)
	for modelIndex = 1, #models do
		local model = models[modelIndex]

		table.insert(CachedModels, model)

		if IsModelValid(model) then
			while not HasModelLoaded(model) do
				RequestModel(model)
	
				Citizen.Wait(10)
			end
		else
			while not HasAnimDictLoaded(model) do
				RequestAnimDict(model)
	
				Citizen.Wait(10)
			end    
		end
	end
end

UnloadModels = function()
	for modelIndex = 1, #CachedModels do
		local model = CachedModels[modelIndex]

		if IsModelValid(model) then
			SetModelAsNoLongerNeeded(model)
		else
			RemoveAnimDict(model)   
		end

		table.remove(CachedModels, modelIndex)
	end
end