local ESX = nil
local hacking = false
local Houses = {
    [1] = {x = 196.7473, y = -1494.277, z = 29.12817},
}
local pin = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local processedClient = false

RegisterNetEvent('VulTony_Traphouse:UpdateProcessed')
AddEventHandler('VulTony_Traphouse:UpdateProcessed', function(state)
    if state == 'true' then
        processedClient = true
    elseif state == 'false' then
        processedClient = false
    end
end)

Citizen.CreateThread(function()

    while true do
        local pickup = {x = 179.20, y = -200.61, z = -28.39}
        Citizen.Wait(1)
        local distancePickup = #(GetEntityCoords(PlayerPedId()) - vector3(pickup["x"],pickup["y"],pickup["z"]))

        if distancePickup < 1.6 and processedClient == true then

            DrawText3Ds(pickup["x"],pickup["y"],pickup["z"], "~w~Press ~g~E~s~ To ~r~Pickup Processed Goods~s~") 
            if IsControlJustReleased(0,38) then
                TriggerServerEvent('VulTony_Traphouse:PickupProcessed')
            end
        end
    end
end)

Citizen.CreateThread(function()

    while true do
        local Exit = {x = 178.1143, y = -207.1912, z = -28.39709}
	    Citizen.Wait(1)
	    local dropOff6 = #(GetEntityCoords(PlayerPedId()) - vector3(Exit["x"],Exit["y"],Exit["z"]))

		if dropOff6 < 1.6 then

			DrawText3Ds(Exit["x"],Exit["y"],Exit["z"], "~w~Press ~g~E~s~ To ~r~Exit Traphouse~s~") 
			if IsControlJustReleased(0,38) then
                DoScreenFadeOut(1)
	            SetEntityCoords(PlayerPedId(), 196.7473, -1494.277, 29.12817)
                Citizen.Wait(2000)
                DoScreenFadeIn(1)
			end
		end
    end
end)

Citizen.CreateThread(function()

    while true do
        local TrapStorage = {x = 178.1802, y = -199.2264, z = -28.39709}
	    Citizen.Wait(1)
	    local BoxHolder = #(GetEntityCoords(PlayerPedId()) - vector3(TrapStorage["x"],TrapStorage["y"],TrapStorage["z"]))

		if BoxHolder < 1.6 then

			DrawText3Ds(TrapStorage["x"],TrapStorage["y"],TrapStorage["z"], "~w~Press ~g~E~s~ To Put In ~r~Contraband~s~") 
			if IsControlJustReleased(0,38) then

                local elements = {
                    { ["label"] = "10g Coke Bag", ["action"] = "10_coke_bag" },
                    { ["label"] = "Coke Bag", ["action"] = "coke_bag" },
                    { ["label"] = "1g Crack Bag", ["action"] = "1_crack_bag" },
                    { ["label"] = "10g Meth Bag", ["action"] = "10_meth_bag" },
                    { ["label"] = "1g Meth Bag", ["action"] = "1_meth_bag" },
                    { ["label"] = "Cash Roll", ["action"] = "cash_roll" },
                    { ["label"] = "Cash Stack", ["action"] = "cash_stack" },
                }
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), "traphouse_input_item_menu",
                {
                    title    = "Traphouse",
                    align    = "right",
                    elements = elements
                },
                function(data, menu)
                    local action = data.current["action"]
                    if action == "10_coke_bag" then

                        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'traphouse_input_quantity', {
                            title = "Enter Amount"
                        },
                        function(data2, menu2)
                            local amount = tonumber(data2.value)
                            if amount == nil or amount == "" then
                                menu2.close()
                                exports['mythic_notify']:SendAlert('inform', 'No amount specified.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
                            else
                                menu2.close()
                                TriggerServerEvent('VulTony_Traphouse:BeginProcess', 1, amount)
                            end
                        end, function(data2, menu2)
                            menu2.close()
                        end)

                    elseif action == "coke_bag" then

                        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'traphouse_input_quantity', {
                            title = "Enter Amount"
                        },
                        function(data2, menu2)
                            local amount = tonumber(data2.value)
                            if amount == nil or amount == "" then
                                menu2.close()
                                exports['mythic_notify']:SendAlert('inform', 'No amount specified.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
                            else
                                menu2.close()
                                TriggerServerEvent('VulTony_Traphouse:BeginProcess', 2, amount)
                            end
                        end, function(data2, menu2)
                            menu2.close()
                        end)

                    elseif action == "1_crack_bag" then

                        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'traphouse_input_quantity', {
                            title = "Enter Amount"
                        },
                        function(data2, menu2)
                            local amount = tonumber(data2.value)
                            if amount == nil or amount == "" then
                                menu2.close()
                                exports['mythic_notify']:SendAlert('inform', 'No amount specified.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
                            else
                                menu2.close()
                                TriggerServerEvent('VulTony_Traphouse:BeginProcess', 3, amount)
                            end
                        end, function(data2, menu2)
                            menu2.close()
                        end)

                    elseif action == "10_meth_bag" then

                        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'traphouse_input_quantity', {
                            title = "Enter Amount"
                        },
                        function(data2, menu2)
                            local amount = tonumber(data2.value)
                            if amount == nil or amount == "" then
                                menu2.close()
                                exports['mythic_notify']:SendAlert('inform', 'No amount specified.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
                            else
                                menu2.close()
                                TriggerServerEvent('VulTony_Traphouse:BeginProcess', 4, amount)
                            end
                        end, function(data2, menu2)
                            menu2.close()
                        end)

                    elseif action == "1_meth_bag" then

                        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'traphouse_input_quantity', {
                            title = "Enter Amount"
                        },
                        function(data2, menu2)
                            local amount = tonumber(data2.value)
                            if amount == nil or amount == "" then
                                menu2.close()
                                exports['mythic_notify']:SendAlert('inform', 'No amount specified.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
                            else
                                menu2.close()
                                TriggerServerEvent('VulTony_Traphouse:BeginProcess', 5, amount)
                            end
                        end, function(data2, menu2)
                            menu2.close()
                        end)

                    elseif action == "cash_roll" then

                        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'traphouse_input_quantity', {
                            title = "Enter Amount"
                        },
                        function(data2, menu2)
                            local amount = tonumber(data2.value)
                            if amount == nil or amount == "" then
                                menu2.close()
                                exports['mythic_notify']:SendAlert('inform', 'No amount specified.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
                            else
                                menu2.close()
                                TriggerServerEvent('VulTony_Traphouse:BeginProcess', 6, amount)
                            end
                        end, function(data2, menu2)
                            menu2.close()
                        end)

                    elseif action == "cash_stack" then

                        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'traphouse_input_quantity', {
                            title = "Enter Amount"
                        },
                        function(data2, menu2)
                            local amount = tonumber(data2.value)
                            if amount == nil or amount == "" then
                                menu2.close()
                                exports['mythic_notify']:SendAlert('inform', 'No amount specified.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
                            else
                                menu2.close()
                                TriggerServerEvent('VulTony_Traphouse:BeginProcess', 7, amount)
                            end
                        end, function(data2, menu2)
                            menu2.close()
                        end)
                    end
                end, function(data, menu)
                    menu.close()
                end)
			end
		end
    end
end)

Citizen.CreateThread(function()
    TrapHouse = Houses 
    while true do
        for i=1,#TrapHouse do
            local frontdoor = #(GetEntityCoords(PlayerPedId()) - vector3(TrapHouse[i]["x"],TrapHouse[i]["y"],TrapHouse[i]["z"]))
            Citizen.Wait(1)
            if frontdoor < 1.6 then
                DrawText3Ds(TrapHouse[i]["x"],TrapHouse[i]["y"],TrapHouse[i]["z"], "~w~Press ~g~E~s~ To ~r~Enter Traphouse~s~") 
                if IsControlJustReleased(0,38) then
                    ESX.TriggerServerCallback('VulTony_Traphouse:getPin', function(cb)
                        pin = cb
                    end, i)
                    while pin == nil do
                        Wait(0)
                    end

                        exports['wp_keypad']:openNumpad(pin,4,function(correct)
                        if correct then
                            buildDrugShop()
                        end
                    end)
                end
            end
        end
    end
end)

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

local TrapBuilding =  { ['x'] = 178.6681,['y'] = -202.9187,['z'] = -2.195557,['h'] = 5.53 }

function buildDrugShop()
	DoScreenFadeOut(1)
	SetEntityCoords(PlayerPedId(),177.82, -207.25, -28.39) -- Default
	FreezeEntityPosition(PlayerPedId(),true)
	Citizen.Wait(1000)

	local generator = { x = TrapBuilding["x"] , y = TrapBuilding["y"], z = TrapBuilding["z"] - 35.0}
  	SetEntityCoords(PlayerPedId(),generator.x,generator.y,generator.z+2)
  	
	local building = CreateObject(`traphouse_shell`,generator.x-0.31811000,generator.y+1.79183500,generator.z+2.56171400,false,false,false)
	FreezeEntityPosition(building, true)
	local coordsofbuilding = GetEntityCoords(building, true)
	SetEntityCoords(PlayerPedId(), 177.82, -207.25, -28.39)
	Citizen.Wait(500)
	SetEntityHeading(PlayerPedId(), 0.0)
	FreezeEntityPosition(PlayerPedId(), false)
	DoScreenFadeIn(1)
end