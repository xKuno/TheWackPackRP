-------------------------------------
------- Created by T1GER#9080 -------
------------------------------------- 
player = nil
coords = {}
Citizen.CreateThread(function()
    while true do
		player = PlayerPedId()
		coords = GetEntityCoords(player)
        Citizen.Wait(500)
    end
end)

plyShopID 	= 0
emptyShops = {}
RegisterNetEvent('t1ger_shops:applyPlyShops')
AddEventHandler('t1ger_shops:applyPlyShops', function(shopID, employeeID, ownedShops)
	plyShopID = shopID
	plyEmployeeID = employeeID
	for k,v in pairs(shopBlips) do RemoveBlip(v) end
	for k,v in pairs(ownedShops) do if v.id ~= plyShopID then emptyShops[v.id] = v.id end end
	for k,v in ipairs(Config.Shops) do
		if plyShopID == k then
			for _,y in pairs(ownedShops) do
				if y.id == plyShopID then
					v.owned = true
					CreateShopBlips(k,v,'Your ')
					break
				end
			end
		else
			if emptyShops[k] == k then
				for _,y in pairs(ownedShops) do
					if y.id == k then
						v.owned = true
						CreateShopBlips(k,v,'')
					end
				end
			else
				v.owned = false
				CreateShopBlips(k,v,'')
			end
		end
	end
end)
    
plyEmployeeID = 0
RegisterNetEvent('t1ger_shops:updateEmployeeID')
AddEventHandler('t1ger_shops:updateEmployeeID', function(employeeID)
	plyEmployeeID = employeeID
end)

-- ## CASHIER SECTION ## --

-- Thread for CASHIER menu:
cashier_menu = nil
basket = {bill = 0, items = {}, shopID = 0}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local sleep = true
		for k,v in pairs(Config.Shops) do
			local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.cashier[1], v.cashier[2], v.cashier[3], false)
			if cashier_menu ~= nil then
				distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, cashier_menu.cashier[1], cashier_menu.cashier[2], cashier_menu.cashier[3], false)
				while cashier_menu ~= nil and distance > 1.5 do cashier_menu = nil Citizen.Wait(1) end
				if cashier_menu == nil then ESX.UI.Menu.CloseAll() end
			else
				local mk = Config.MarkerSettings['cashier']
				if distance < 20.0 then
					sleep = false
					if distance > 13.0 and basket.bill > 0 then 
						EmptyShopBasket(Lang['basket_emptied'])
					elseif distance < 13.0 then 
						if distance > 1.5 and distance < 5.0 then
							if mk.enable then
								DrawMarker(mk.type, v.cashier[1], v.cashier[2], v.cashier[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, mk.scale.x, mk.scale.y, mk.scale.z, mk.color.r, mk.color.g, mk.color.b, mk.color.a, false, true, 2, false, false, false, false)
							end
						elseif distance < 1.5 then
							DrawText3Ds(v.cashier[1], v.cashier[2], v.cashier[3], "~r~[E]~s~ "..Lang['cashier_draw'])
							if IsControlJustPressed(0, 38) then
								cashier_menu = v
								OpenCashierMenu(k,v)
							end 
						end
					end
				end
			end
		end
		if sleep then Citizen.Wait(1000) end
	end
end)

-- Cashier Menu:
function OpenCashierMenu(id,val)
	local elements = {}
	if val.owned then 
		if basket.bill > 0 and #basket.items then
			elements = {{label = ('<span style="color:MediumSeaGreen;">%s</span>'):format(Lang['confirm_basket']), value = "confirm_basket"}}
			for k,v in pairs(basket.items) do
				local listLabel = ('<span style="color:GoldenRod;">%sx</span> %s <span style="color:MediumSeaGreen;">[ $%s ]</span>'):format(v.count,v.label,v.price)
				table.insert(elements, {label = listLabel, v.count, v.price, value = "item_data", num = k, str_match = v.str_match})
			end
			ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_basket_confirm_items',
				{
					title    = ('%s <span style="color:MediumSeaGreen;"> [ $%s ]</span>'):format("Basket Bill",basket.bill),
					align    = "right",
					elements = elements
				},
			function(data, menu)
				if data.current.value == "confirm_basket" then
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_basket_select_payment_type', {
						title    = Lang['shop_payment_type'],
						align    = 'right',
						elements = {
							{label = Lang['button_cash'], value = 'button_cash'},
							{label = Lang['button_card'], value = 'button_card'},
							{label = Lang['button_no'],  value = 'button_no'},
						}
					}, function(data2, menu2)
						if data2.current.value ~= "button_no" then 
							menu.close()
							cashier_menu = nil
							ESX.TriggerServerCallback('t1ger_shops:getPlayerMoney', function(hasMoney)
								if hasMoney then
									ESX.TriggerServerCallback('t1ger_shops:getPlayerInvLimit', function(limitExceeded)
										if not limitExceeded then
											TriggerServerEvent('t1ger_shops:checkoutBasket', basket, data2.current.value, id)
											EmptyShopBasket(nil)
										end
									end, basket.items)
								end
							end, basket.bill, data2.current.value)
						end
						menu2.close()
					end, function(data2, menu2)
						menu2.close()
					end)
				end 
			end, function(data, menu)
				menu.close()
				cashier_menu = nil
			end)
		else
			ShowNotifyESX(Lang['basket_is_empty'])
			cashier_menu = nil
		end
	else
		for k,v in pairs(Config.Items) do
			for i = 1, #v.type do
				if val.type == v.type[i] then
					local max_count = 100
					if v.str_match ~= nil and Config.WeaponLoadout and v.str_match == "weapon" then max_count = 1 end
					if v.str_match ~= nil and Config.WeaponLoadout and v.str_match == "ammo" then max_count = 250 end
					table.insert(elements, {label = (('%s <span style="color:MediumSeaGreen;">[ $%s ]</span>'):format(v.label,v.price)), name = v.label, item = v.item, ammo_type = v.ammo_type, str_match = v.str_match, price = v.price, type = 'slider', value = 1, min = 1, max = max_count})
				end
			end
		end
		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_item_list_menu',
			{
				title    = 'Shop',
				align    = 'right',
				elements = elements
			},
		function(data, menu)
			local item = data.current
			local price = (item.value * item.price)
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_item_confirm_purchase', {
				title    = (Lang['shop_confirm_item']):format(item.value, item.name, price),
				align    = 'right',
				elements = {
					{label = Lang['button_cash'], value = 'button_cash'},
					{label = Lang['button_card'], value = 'button_card'},
					{label = Lang['button_no'],  value = 'button_no'},
				}
			}, function(data2, menu2)
				if data2.current.value ~= 'button_no' then 
					ESX.TriggerServerCallback('t1ger_shops:getPlayerMoney', function(hasMoney)
						if hasMoney then
							if Config.WeaponLoadout then
								if item.str_match ~= nil then
									if (string.match(item.str_match, "ammo")) then
										menu2.close()
										AddAmmoToLoadout(item, price, data2.current.value)
									elseif (string.match(item.str_match, "weapon")) then
										AddWeaponToLoadout(item, price, data2.current.value)
									end
								else
									ESX.TriggerServerCallback('t1ger_shops:getPlayerInvLimit', function(limitExceeded)
										if not limitExceeded then
											TriggerServerEvent('t1ger_shops:purchaseItem', item, price, data2.current.value)
										end
									end, item)
								end
							else
								ESX.TriggerServerCallback('t1ger_shops:getPlayerInvLimit', function(limitExceeded)
									if not limitExceeded then
										TriggerServerEvent('t1ger_shops:purchaseItem', item, price, data2.current.value)
									end
								end, item)
							end
						else
							ShowNotifyESX(Lang['not_enough_money'])
						end
					end, price, data2.current.value)
				end
				menu2.close()
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
			cashier_menu = nil
		end)
	end
end

-- ## BASKET SECTION ## --

-- Comand to open basket:
RegisterCommand(Config.BasketCommand, function(source, args)
	OpenShopBasket()
end, false)

-- Function to view basket content:
function OpenShopBasket()
	if basket.bill > 0 and #basket.items then
		local elements = {}
		for k,v in pairs(basket.items) do
			local listLabel = ('<span style="color:GoldenRod;">%sx</span> %s <span style="color:MediumSeaGreen;">[ $%s ]</span>'):format(v.count,v.label,v.price)
			table.insert(elements, {label = listLabel, name = v.label, v.count, v.price, value = "item_data", num = k})
		end
		table.insert(elements, {label = ('<span style="color:IndianRed;">%s</span>'):format(Lang['empty_basket']), value = "empty_basket"})
		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_basket_overview', {
			title    = ('Basket Bill <span style="color:MediumSeaGreen;">[ $%s</span>'):format(basket.bill),
			align    = 'right',
			elements = elements
		}, function(data, menu)
			if data.current.value == 'empty_basket' then
				menu.close()
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_basket_confirm_empty', {
					title    = Lang['confirm_empty_basket'],
					align    = 'right',
					elements = {
						{label = Lang['button_no'],  value = 'button_no'},
						{label = Lang['button_yes'], value = 'button_yes'},
					}
				}, function(data2, menu2)
					menu2.close()
					if data2.current.value == 'button_yes' then
						EmptyShopBasket(Lang['you_emptied_basket'])
					else
						OpenShopBasket()
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
			if data.current.value == 'item_data' then
				menu.close()
				local i = data.current.num
				local item = basket.items[i]
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_basket_item_data', {
					title    = item.label,
					align    = 'right',
					elements = {
						{label = ('Price <span style="color:MediumSeaGreen;">[ $%s ]</span>'):format(item.price)},
						{label = ('Count <span style="color:GoldenRod;">[ %sx ]</span>'):format(item.count)},
						{label = ('<span style="color:IndianRed;">%s</span>'):format(Lang['basket_remove_item']), value = 'remove_item'},
					}
				}, function(data2, menu2)
					if data2.current.value == 'remove_item' then
						basket.bill = basket.bill - item.price
						TriggerServerEvent('t1ger_shops:removeBasketItem', basket.shopID, item)
						table.remove(basket.items, i)
						ShowNotifyESX((Lang['basket_item_removed']):format(item.count,item.label))
						OpenShopBasket()
					end
				end, function(data2, menu2)
					menu2.close()
					OpenShopBasket()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	else
		ShowNotifyESX(Lang['basket_is_empty'])
		ESX.UI.Menu.CloseAll()
	end
end

-- ## SHELVES SECTION ## --

shop_shelves = {}
RegisterNetEvent('t1ger_shops:applyShopShelves')
AddEventHandler('t1ger_shops:applyShopShelves', function(shelvesData)
	if #shelvesData > 0 then 
		for k,v in pairs(shelvesData) do
			shop_shelves[v.id] = {id = v.id, shelves = v.shelves}
		end
	else
		shop_shelves = {}
	end
end)

shelf_menu = nil
-- Thread for SHELVES menu:
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2)
		local sleep = true
		for k,v in pairs(Config.Shops) do
			if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.cashier[1], v.cashier[2], v.cashier[3], false) < 12.0 then
				sleep = false
				if shop_shelves[k] ~= nil then
					for num,shelf in pairs(shop_shelves[k].shelves) do
						local shelfDist = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, shelf.pos[1], shelf.pos[2], shelf.pos[3], false)
						if shelf_menu ~= nil then 
							shelfDist = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, shelf_menu.pos[1], shelf_menu.pos[2], shelf_menu.pos[3], false)
							while shelf_menu ~= nil and shelfDist > 1.5 do shelf_menu = nil Citizen.Wait(1) end
							if shelf_menu == nil then ESX.UI.Menu.CloseAll() end
						else
							if shelfDist > 1.5 and shelfDist < 4.0 then
								local mk = Config.MarkerSettings['shelves']
								if mk.enable then
									DrawMarker(mk.type, shelf.pos[1], shelf.pos[2], shelf.pos[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, mk.scale.x, mk.scale.y, mk.scale.z, mk.color.r, mk.color.g, mk.color.b, mk.color.a, false, true, 2, false, false, false, false)
								end
							end
							if shelfDist <= 1.5 then
								if (plyEmployeeID > 0 and plyEmployeeID == k) or (plyShopID > 0 and plyShopID == k) then 
									DrawText3Ds(shelf.pos[1], shelf.pos[2], shelf.pos[3], "~r~[E]~s~ "..shelf.drawText.." | ~y~[G]~s~ "..Lang['manage_stock'])
									if IsControlJustPressed(0, 47) then 
										shelf_menu = shelf
										OpenShelfStockManageMenu(k,v,num,shelf)
									end
								else
									DrawText3Ds(shelf.pos[1], shelf.pos[2], shelf.pos[3], "~r~[E]~s~ "..shelf.drawText)
								end
								if IsControlJustPressed(0, 38) then
									shelf_menu = shelf
									OpenShelvesMenu(k,v,num,shelf)
								end
							end
						end
					end
				end
			end
		end
		if sleep then Citizen.Wait(1000) end
	end
end)

-- Function view & interact with shelves:
function OpenShelvesMenu(id,val,num,shelf)
	local elements = {}
	ESX.TriggerServerCallback('t1ger_shops:fetchShelfStock', function(stock_data)
		if #stock_data > 0 then 
			for k,v in pairs(stock_data) do
				if v.type == shelf.type then 
					local list_label = ('%s <span style="color:MediumSeaGreen;"> [ $%s ]</span>'):format(v.label,v.price)
					table.insert(elements, {label = list_label, name = v.label, item = v.item, price = v.price, str_match = v.str_match, type = 'slider', value = 1, min = 1, max = v.qty})
				end
			end
			ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), "shelf_item_menu",
				{
					title    = "Shelf [ "..shelf.drawText.." ]",
					align    = "right",
					elements = elements
				},
			function(data, menu)
				local loopDone, selected_weapon = false, nil
				local item_price = math.floor(data.current.price * data.current.value)
				local itemInBasket, int = IsItemInBasket(data.current.item)
				if data.current.str_match == "weapon" and data.current.value > 1 then
					return ShowNotifyESX("Only add one of each weapon type in the basket.")
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shelf_add_to_basket', {
					title    = Lang['shop_add_to_basket']:format(data.current.value, data.current.name, item_price),
					align    = 'right',
					elements = {
						{label = Lang['button_no'],  value = 'button_no'},
						{label = Lang['button_yes'], value = 'button_yes'},
					}
				}, function(data2, menu2)
					if data2.current.value == 'button_yes' then
						menu.close()
						if data.current.str_match == "weapon" then
							if itemInBasket then
								ShowNotifyESX("Already added similar pistol in the basket.")
								menu2.close()
								return OpenShelvesMenu(id,val,num,shelf)
							else
								ESX.TriggerServerCallback('t1ger_shops:getLoadout', function(loadout)
									if #loadout > 0 then 
										for k,v in pairs(loadout) do
											if data.current.item == v.name then
												ShowNotifyESX(Lang['wep_already_in_loadout'])
												menu2.close()
												return OpenShelvesMenu(id,val,num,shelf)
											else
												if k == #loadout then loopDone = true end
											end
										end
									else
										loopDone = true
									end
								end)
								while not loopDone do Citizen.Wait(5) end
							end
						end
						if data.current.str_match == "ammo" then
							selected_weapon = GetSelectedPedWeapon(player)
							if selected_weapon == -1569615261 then
								ShowNotifyESX("You must hold weapon in hand to select correct ammo type.")
								menu2.close()
								return OpenShelvesMenu(id,val,num,shelf)
							else
								if GetPedAmmoTypeFromWeapon(player, selected_weapon) ~= data.current.item then
									ShowNotifyESX("Selected ammo does not fit into your selected weapon.")
									menu2.close()
									return OpenShelvesMenu(id,val,num,shelf)
								end
								if itemInBasket then
									if (GetAmmoInPedWeapon(player, selected_weapon) + basket.items[int].count + data.current.value) > 250 then 
										ShowNotifyESX("You cannot carry that much ammo of the same type.")
										menu2.close()
										return OpenShelvesMenu(id,val,num,shelf)
									end								
								end
							end
						end
						ESX.TriggerServerCallback('t1ger_shops:updateItemStock', function(hasItemStock)
							if hasItemStock ~= nil and hasItemStock then
								if itemInBasket then
									basket.items[int].count = basket.items[int].count + data.current.value
									basket.items[int].price = basket.items[int].price + item_price
								else
									table.insert(basket.items, {label = data.current.name, item = data.current.item, count = data.current.value, price = item_price, str_match = data.current.str_match, weapon = selected_weapon})
								end
								basket.bill = basket.bill + item_price
								basket.shopID = id
								ShowNotifyESX((Lang['basket_item_added']):format(data.current.value,data.current.name,item_price))
								menu2.close()
								OpenShelvesMenu(id,val,num,shelf)
							else
								ShowNotifyESX(Lang['item_not_available'])
							end
						end, id, data.current.item, data.current.value)
					end
					menu2.close()
				end, function(data2, menu2)
					menu2.close()
					OpenShelvesMenu(id,val,num,shelf)
				end)
			end, function(data, menu)
				menu.close()
				shelf_menu = nil
			end)
		else
			ShowNotifyESX(Lang['no_stock_in_shelf'])
			shelf_menu = nil
		end
	end, id, shelf)
end

-- Shelf Stock Manage Menu:
function OpenShelfStockManageMenu(id,val,num,shelf)
	local elements = {
		{label = "View Stock", value = "view_stock"},
		{label = "Add Stock", value = "add_stock"},
		{label = "Remove Stock", value = "remove_stock"}
	}
	if plyShopID > 0 then
		table.insert(elements, {label = "Order Stock", value = "order_stock"})
	end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "shelf_restock_main_menu",
		{
			title    = "Shelf [ "..shelf.drawText.." ]",
			align    = "right",
			elements = elements
		},
	function(data, menu)
		if data.current.value == "add_stock" then
			menu.close()
			AddStockFunction(id,val,num,shelf)
		elseif data.current.value == "remove_stock" then 
			menu.close()
			RemoveStockFunction(id,val,num,shelf)
		elseif data.current.value == "view_stock" then 
			menu.close()
			ViewShelfStock(id,val,num,shelf)
		elseif data.current.value == "order_stock" then 
			menu.close()
			OrderStockFunction(id,val,num,shelf)
		end
	end, function(data, menu)
		menu.close()
		shelf_menu = nil
	end)
	
end

-- function to add stock:
function AddStockFunction(id,val,num,shelf)
	ESX.TriggerServerCallback('t1ger_shops:getUserInventory', function(inventory)
		local list_items = {}
		if #inventory > 0 then 
			for k,v in pairs(inventory) do 
				if v.count > 0 then
					if Config.ItemCompatibility then
						for _,y in pairs(Config.Items) do
							if v.name == y.item then
								for arr,shop_type in pairs(y.type) do
									if val.type == shop_type then 
										local inv_label = ('<span style="color:GoldenRod;">%sx</span> %s'):format(v.count,v.label)
										table.insert(list_items, {label = inv_label, value = v.name, shopID = id, shelf = shelf })
										break
									end
								end
								break
							end
						end
					else
						local inv_label = ('<span style="color:GoldenRod;">%sx</span> %s'):format(v.count,v.label)
						table.insert(list_items, {label = inv_label, value = v.name, shopID = id, shelf = shelf })
					end
				end
			end
			LoadoutFetched = false
			AmmoFetched = false
			if Config.WeaponLoadout then
				ESX.TriggerServerCallback('t1ger_shops:getLoadout', function(loadout)
					if #loadout > 0 then
						local userLoadout = {}
						for k,v in pairs(loadout) do
							local inv_label = ('<span style="color:GoldenRod;">%sx</span> %s [loadout]'):format(1, v.label)
							table.insert(list_items, {label = inv_label, value = v.name, name = v.label, loadout = true, type = "weapon", ammo = v.ammo, shopID = id, shelf = shelf })
							table.insert(userLoadout, {label = inv_label, value = v.name, name = v.label, ammo = v.ammo, shopID = id, shelf = shelf })
							if k == #loadout then LoadoutFetched = true end
						end
						for k,v in pairs(Config.AmmoTypes) do
							for _,y in pairs(userLoadout) do 
								local ped_ammoType = GetPedAmmoTypeFromWeapon(player, GetHashKey(y.value))
								if ped_ammoType == v.hash and y.ammo > 0 then
									local inv_label = ('<span style="color:GoldenRod;">%sx</span> %s [loadout]'):format(y.ammo, v.label)
									table.insert(list_items, {label = inv_label, value = v.hash, name = v.label, loadout = true, type = "ammo", ammo = y.ammo, ammoType = ped_ammoType, weapon = y.value, shopID = id, shelf = shelf })
									break
								end
							end
							if k == #Config.AmmoTypes then AmmoFetched = true end
						end
					else
						LoadoutFetched = true; AmmoFetched = true
					end
				end)
			else
				LoadoutFetched = true; AmmoFetched = true
			end
			while not LoadoutFetched and not AmmoFetched do Citizen.Wait(10) end
			if #list_items > 0 then
				local menu_title = "User Inventory"; if Config.WeaponLoadout then menu_title = "Inventory & Loadout" end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), "shelf_restock_list_items",
					{
						title    = menu_title,
						align    = "right",
						elements = list_items
					},
				function(data, menu)
					menu.close()
					-- menu 2
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'shelf_restock_item_amount', {title = "Enter Restock Amount"}, function(data2, menu2)
						local restock_amount = tonumber(data2.value)
						if restock_amount == nil or restock_amount == '' or restock_amount == 0 then
							ShowNotifyESX(Lang['invalid_amount'])
						else
							-- menu 3
							menu2.close()
							ESX.TriggerServerCallback('t1ger_shops:doesItemExists', function(itemExists)
								if itemExists == nil or not itemExists then
									ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'shelf_restock_item_price', {title = "Enter Item Price"}, function(data3, menu3)
										local restock_price = tonumber(data3.value)
										if restock_price == nil or restock_price == '' or restock_price == 0 then
											ShowNotifyESX(Lang['invalid_amount'])
										else
											menu3.close()
											if Config.WeaponLoadout then
												if data.current.loadout then
													AddLoadoutStock(data.current,restock_amount,restock_price,id)
												else
													TriggerServerEvent('t1ger_shops:itemDeposit', data.current.value, restock_amount, restock_price, id, data.current.shelf)
												end
											else
												TriggerServerEvent('t1ger_shops:itemDeposit', data.current.value, restock_amount, restock_price, id, data.current.shelf)
											end
											OpenShelfStockManageMenu(id,val,num,shelf)
										end
									end, function(data3, menu3)
										menu3.close()
										AddStockFunction(id,val,num,shelf)
									end)
								else
									if Config.WeaponLoadout then
										if data.current.loadout then
											AddLoadoutStock(data.current,restock_amount,0,id)
										else
											TriggerServerEvent('t1ger_shops:itemDeposit', data.current.value, restock_amount, 0, id, data.current.shelf)
										end
									else
										TriggerServerEvent('t1ger_shops:itemDeposit', data.current.value, restock_amount, 0, id, data.current.shelf)
									end
									OpenShelfStockManageMenu(id,val,num,shelf)
								end
							end, id, data.current.value, shelf.type)
							-- menu 3 end
						end
					end, function(data2, menu2)
						menu2.close()
						AddStockFunction(id,val,num,shelf)
					end)
					-- menu 2 end

				end, function(data, menu)
					menu.close()
					OpenShelfStockManageMenu(id,val,num,shelf)
				end)
			else
				ShowNotifyESX("No items to display..")
				OpenShelfStockManageMenu(id,val,num,shelf)
			end
		else
			OpenShelfStockManageMenu(id,val,num,shelf)
		end
	end, id)
end

-- function to remove stock:
function RemoveStockFunction(id,val,num,shelf)
	ESX.TriggerServerCallback('t1ger_shops:getItemStock', function(item_stock)
		local elements = {}
		if #item_stock > 0 then 
			for k,v in pairs(item_stock) do
				if shelf.type == v.type then
					local list_label = ('<span style="color:GoldenRod;">%sx</span> %s'):format(v.qty,v.label)
					table.insert(elements, {label = list_label, item = v.item, name = v.label, qty = v.qty, type = v.type, str_match = v.str_match})
				end
			end
			if #elements > 0 then 
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), "shelf_stock_remove",
					{
						title    = "Shelf Stock",
						align    = "right",
						elements = elements
					},
				function(data, menu)
					menu.close()
					-- menu 2
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'shelf_remove_item_amount', {title = "Enter Amount to Remove"}, function(data2, menu2)
						local remove_amount = tonumber(data2.value)
						if remove_amount == nil or remove_amount == '' or remove_amount == 0 or remove_amount > data.current.qty or (data.current.str_match == "weapon" and remove_amount > 1) then
							ShowNotifyESX(Lang['invalid_amount'])
						else
							menu2.close()
							if data.current.str_match ~= nil then
								if data.current.str_match == "ammo" then
									local ammo_arr = {ammo_type = data.current.item, value = remove_amount, label = data.current.name, id = id, type = data.current.type, str_match = data.current.str_match}
									AddAmmoToLoadout(ammo_arr, nil, nil)
								elseif data.current.str_match == "weapon" then
									local weapon_arr = {item = data.current.item, value = remove_amount, label = data.current.name, id = id, type = data.current.type, str_match = data.current.str_match}
									AddWeaponToLoadout(weapon_arr, nil, nil)
								end
							else
								TriggerServerEvent('t1ger_shops:itemWithdraw', data.current.item, data.current.name, remove_amount, id, data.current.type)
							end
							OpenShelfStockManageMenu(id,val,num,shelf)
						end
					end, function(data2, menu2)
						menu2.close()
						RemoveStockFunction(id,val,num,shelf)
					end)
				end, function(data, menu)
					menu.close()
					OpenShelfStockManageMenu(id,val,num,shelf)
				end)
			else
				ShowNotifyESX(Lang['stock_inv_empty'])
				OpenShelfStockManageMenu(id,val,num,shelf)
			end
		else
			ShowNotifyESX(Lang['stock_inv_empty'])
			OpenShelfStockManageMenu(id,val,num,shelf)
		end
	end, id)
end

-- change item price in shelf stock:
function ViewShelfStock(id,val,num,shelf)
	ESX.TriggerServerCallback('t1ger_shops:getItemStock', function(item_stock)
		local elements = {}
		if #item_stock > 0 then 
			for k,v in pairs(item_stock) do
				if shelf.type == v.type then
					local list_label = ('<span style="color:GoldenRod;">%sx</span> %s <span style="color:MediumSeaGreen;"> [ $%s ]</span>'):format(v.qty,v.label,v.price)
					table.insert(elements, {label = list_label, item = v.item, name = v.label, qty = v.qty, price = v.price, shelf = v.type})
				end
			end
			if #elements > 0 then 
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), "view_shelf_item_stock",
					{
						title    = "Shelf Overview",
						align    = "right",
						elements = elements
					},
				function(data, menu)
					local selected = data.current
					if plyShopID > 0 and plyShopID == id then 
						--HERE
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'shop_amount_order_stock', {
							title = "Enter Order Amount"
						},
						function(data2, menu2)
							local amount = tonumber(data2.value)
							if amount >= 1 then
								menu2.close()
								TriggerServerEvent('t1ger_shops:updateItemPrice', id, shelf.type, selected.item, amount)
								ShowNotifyESX((Lang['shelf_item_price_change']):format(selected.name, selected.price, amount))
								menu.close()
								OpenShelfStockManageMenu(id,val,num,shelf)
							end
						end, function(data2, menu2)
							menu2.close()
						end)
					end
				end, function(data, menu)
					menu.close()
					OpenShelfStockManageMenu(id,val,num,shelf)
				end)
			else
				ShowNotifyESX(Lang['stock_inv_empty'])
				OpenShelfStockManageMenu(id,val,num,shelf)
			end
		else
			ShowNotifyESX(Lang['stock_inv_empty'])
			OpenShelfStockManageMenu(id,val,num,shelf)
		end
	end, id)
end

-- function to order stock:
function OrderStockFunction(id,val,num,shelf)
	ESX.TriggerServerCallback('t1ger_shops:getItemStock', function(stockSV)
		local elements = {}
		for k,v in pairs(Config.Items) do
			local typeChecked = false
			for num,typeC in pairs(v.type) do
				if typeC == val.type then typeChecked = true break end
			end
			if typeChecked then 
				local currentCount = 0
				local order_item = v.item; if v.str_match ~= nil and v.str_match == "ammo" and Config.WeaponLoadout then order_item = v.ammo_type end  
				if #stockSV > 0 then
					for _,y in pairs(stockSV) do if v.item == y.item then currentCount = y.qty end end
					table.insert(elements, {
						label = v.label..'<span style="color:MediumSeaGreen;"> [ '..'<span style="color:GoldenRod;">'..currentCount.."x pcs </span> ]",
						name = v.label, item = order_item, price = v.price, count = currentCount
					})
				else
					table.insert(elements, {
						label = v.label..'<span style="color:MediumSeaGreen;"> [ '..'<span style="color:GoldenRod;">'..currentCount.."x pcs </span> ]",
						name = v.label, item = order_item, price = v.price, count = currentCount
					})
				end
			end
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_order_item_stock', {
			title    = "Shelf ["..shelf.drawText.."] Order",
			align    = 'right',
			elements = elements
		}, function(data, menu)
			local selected = data.current
			-- menu 2 start:
			menu.close()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_amount_order_stock', {
				title    = data.current.name..'<span style="color:MediumSeaGreen;">',
				align    = 'right',
				elements = {
					{label = '<span style="color:GoldenRod;">'.."Order".." "..data.current.name, value = 1, action = "order"},
				}
			}, function(data2, menu2)
				menu2.close()
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'shop_amount_order_stock', {
				title = "Enter Order Amount"
			},
			function(data3, menu3)
				local amount = tonumber(data3.value)
				if amount >= 1 then
					menu3.close()
					local item_price = (selected.price*(1-(Config.OrderItemPercent/100))) * amount
					local order_price = math.floor(item_price * data2.current.value)
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'order_stock_confirmation', {
						title    = "Confirm Order Price: [$"..order_price.."]",
						align    = 'right',
						elements = {
							{label = Lang['button_no'],  value = 'button_no'},
							{label = Lang['button_yes'], value = 'button_yes'},
						}
					}, function(data3, menu3)
						if data3.current.value == 'button_yes' then
							menu3.close()
							ESX.TriggerServerCallback('t1ger_shops:payStockOrder', function(paidOrder)
								if paidOrder then
									TriggerServerEvent('t1ger_shops:sendStockOrder', id, selected.name, selected.item, selected.count, selected.str_match, amount, selected.price, order_price, shelf.type)
								else
									ShowNotifyESX("Insufficient funds in shops account..")
								end
							end, id, order_price)
							OpenShelfStockManageMenu(id,val,num,shelf)
						end
						menu3.close()
					end, function(data3, menu3)
						menu3.close()
					end)
					-- menu 3 end
				end
			end, function(data3, menu3)
				menu3.close()
				OpenShelfStockManageMenu(id,val,num,shelf)
			end)
			end, function(data2, menu2)
				menu2.close()
				OpenShelfStockManageMenu(id,val,num,shelf)
			end)
			-- menu 2 end:
		end, function(data, menu)
			menu.close()
			OpenShelfStockManageMenu(id,val,num,shelf)
		end)
	end, id)
end

-- ## BOSS MENU SECTION ## --

-- Thread for BOSS menu:
boss_menu = nil
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local sleep = true
		for k,v in pairs(Config.Shops) do
			local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.b_menu[1], v.b_menu[2], v.b_menu[3], false)
			if boss_menu ~= nil then
				distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, boss_menu.b_menu[1], boss_menu.b_menu[2], boss_menu.b_menu[3], false)
				while boss_menu ~= nil and distance > 1.5 do boss_menu = nil Citizen.Wait(1) end
				if boss_menu == nil then ESX.UI.Menu.CloseAll() end
			else
				local mk = Config.MarkerSettings['boss']
				if distance < 10.0 then 
					sleep = false
					if distance >= 2.0 and distance < 5.0 then
						if mk.enable then
							DrawMarker(mk.type, v.b_menu[1], v.b_menu[2], v.b_menu[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, mk.scale.x, mk.scale.y, mk.scale.z, mk.color.r, mk.color.g, mk.color.b, mk.color.a, false, true, 2, false, false, false, false)
						end
					elseif distance < 2.0 then
						if plyShopID == k then
							DrawText3Ds(v.b_menu[1], v.b_menu[2], v.b_menu[3], Lang['boss_menu_access'])
							if IsControlJustPressed(0, 38) then
								boss_menu = v
								BossMenuManage(k,v)
							end
						else
							if v.buyable then 
								if emptyShops[k] ~= k then
									if plyShopID == 0 then
										DrawText3Ds(v.b_menu[1], v.b_menu[2], v.b_menu[3], (Lang['press_to_buy_shop']:format(math.floor(v.price))))
										if IsControlJustPressed(0, 38) then
											boss_menu = v
											BuyClosestShop(k,v)
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if sleep then Citizen.Wait(1000) end
	end
end)

-- Function for boss menu:
function BossMenuManage(id,val)
	local elements = {
		{ label = Lang['sell_shop'], value = "sell_shop" },
		{ label = Lang['employees_action'], value = "employees_menu" },
		{ label = Lang['accounts_action'], value = "accounts_menu" }
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "shop_boss_manage_menu",
		{
			title    = "Shop ["..tostring(id).."]",
			align    = "right",
			elements = elements
		},
	function(data, menu)
        if data.current.value == 'sell_shop' then
			SellClosestShop(id,val)
			menu.close()
			bossMenu = nil
		end
        if data.current.value == 'employees_menu' then
			EmployeesMainMenu(id,val)
			menu.close()
		end
        if data.current.value == 'accounts_menu' then
			AccountsMainMenu(id,val)
			menu.close()
		end
	end, function(data, menu)
		menu.close()
		boss_menu = nil
	end)
end

-- Function to purchase shop:
function BuyClosestShop(id,val)
	local elements = {
		{ label = Lang['button_yes'], value = "confirm_purchase" },
		{ label = Lang['button_no'], value = "decline_purchase" },
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "shop_purchase_menu",
		{
			title    = "Confirm | Price: $"..math.floor(val.price),
			align    = "right",
			elements = elements
		},
	function(data, menu)
		if data.current.value ~= 'decline_purchase' then
			ESX.TriggerServerCallback('t1ger_shops:buyShop', function(purchased)
				if purchased then
					ShowNotifyESX((Lang['shop_purchased']):format(math.floor(val.price)))
					TriggerServerEvent('t1ger_shops:fetchPlyShops')
				else
					ShowNotifyESX(Lang['not_enough_money'])
				end
			end, id, val)
		end
		menu.close()
		boss_menu = nil
	end, function(data, menu)
		menu.close()
		boss_menu = nil
	end)
end

-- Function to sell shop:
function SellClosestShop(id,val)
	local sellPrice = (val.price * Config.SellPercent)
	local elements = {
		{ label = Lang['button_yes'], value = "confirm_sale" },
		{ label = Lang['button_no'], value = "decline_sale" },
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "shop_sell_menu",
		{
			title    = "Confirm Sale | Price: $"..math.floor(sellPrice),
			align    = "right",
			elements = elements
		},
	function(data, menu)
		if data.current.value == 'confirm_sale' then
			ESX.TriggerServerCallback('t1ger_shops:sellShop', function(sold)
				if sold then
					TriggerServerEvent('t1ger_shops:fetchPlyShops')
					ShowNotifyESX((Lang['shop_sold']):format(math.floor(sellPrice)))
				end
			end, id, val, math.floor(sellPrice))
			menu.close()
			boss_menu = nil
			ESX.UI.Menu.CloseAll()
		else
			menu.close()
			BossMenuManage(id,val)
		end
	end, function(data, menu)
		menu.close()
		BossMenuManage(id,val)
	end)
end

-- Employees Main Menu:
function EmployeesMainMenu(id,val)
	local elements = {
		{ label = Lang['hire_employee'], value = "recruit_employee" },
		{ label = Lang['employee_list'], value = "employee_list" },
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "shop_employees_menu",
		{
			title    = "Shop [Employees]",
			align    = "right",
			elements = elements
		},
	function(data, menu)
		menu.close()
		if data.current.value == 'recruit_employee' then
			ESX.TriggerServerCallback('t1ger_shops:getOnlinePlayers', function(players)
				local elements = {}
				for i=1, #players, 1 do
					table.insert(elements, {
						label = players[i].name,
						value = players[i].source,
						name = players[i].name,
						identifier = players[i].identifier
					})
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_recruit_player', {
					title    = "Recruit Employee",
					align    = 'right',
					elements = elements
				}, function(data2, menu2)
					-- YES / NO OPTION:
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_recruit_confirm', {
						title    = "Recruit: "..data2.current.name,
						align    = 'right',
						elements = {
							{label = Lang['button_no'],  value = 'no'},
							{label = Lang['button_yes'], value = 'yes'}
						}
					}, function(data3, menu3)
						menu2.close()
						if data3.current.value == 'yes' then
							menu3.close()
							local jobGrade = 0
							TriggerServerEvent('t1ger_shops:recruitEmployee',id,data2.current.identifier,jobGrade,data2.current.name)
							EmployeesMainMenu(id,val)
						end
					end, function(data3, menu3)
						menu3.close()
						EmployeesMainMenu(id,val)
					end)
				end, function(data2, menu2)
					menu2.close()
					EmployeesMainMenu(id,val)
				end)
			end)
		end
        if data.current.value == 'employee_list' then
			OpenEmployeeListMenu(id,val)
		end
	end, function(data, menu)
		menu.close()
		BossMenuManage(id,val)
	end)
end

-- Employe List Menu
function OpenEmployeeListMenu(id,val)
	local elements = {}
	ESX.TriggerServerCallback('t1ger_shops:getEmployees', function(employees)
		if employees ~= nil then 
			for k,v in pairs(employees) do
				table.insert(elements,{label = v.firstname.." "..v.lastname, identifier = v.identifier, jobGrade = v.jobGrade, data = v})
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), "shop_employees_list",
				{
					title    = "Employee List",
					align    = "right",
					elements = elements
				},
			function(data, menu)
				menu.close()
				OpenEmployeeData(data.current,data.current.data,id,val)
			end, function(data, menu)
				menu.close()
				EmployeesMainMenu(id,val)
			end)
		else
			ShowNotifyESX(Lang['no_employees_hired'])
		end
	end, id)
end

-- Get Employee Menu Data
function OpenEmployeeData(info,user,id,val)
	local elements = {
		{ label = Lang['fire_employee'], value = "fire_employee" },
		{ label = Lang['employee_job_grade'], value = "job_grade_manage" },
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "shop_employee_data_menu",
		{
			title    = "Employee: "..user.firstname,
			align    = "right",
			elements = elements
		},
	function(data, menu)
		menu.close()
		if data.current.value == 'fire_employee' then
			TriggerServerEvent('t1ger_shops:fireEmployee',id,user.identifier)
			EmployeesMainMenu(id,val)
		end
		if data.current.value == 'job_grade_manage' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'shop_update_employee_job_grade', {
				title = "Current Job Grade: "..user.jobGrade
			}, function(data2, menu2)
				menu2.close()
				local newJobGrade = tonumber(data2.value)
				TriggerServerEvent('t1ger_shops:updateEmployeJobGrade',id,user.identifier,newJobGrade)
				EmployeesMainMenu(id,val)
			end,
			function(data2, menu2)
				menu2.close()	
				EmployeesMainMenu(id,val)
			end)
		end
	end, function(data, menu)
		menu.close()
		OpenEmployeeListMenu(id,val)
	end)
end

-- Acounts Main Menu:
function AccountsMainMenu(id,val)
	local elements = {
		{ label = Lang['account_withdraw'], value = "withdraw" },
		{ label = Lang['account_deposit'], value = "deposit" },
	}
	ESX.TriggerServerCallback('t1ger_shops:getShopAccount', function(account)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), "shop_account_menu",
			{
				title    = "Account "..'<span style="color:MediumSeaGreen;">[ $'..account.." ]",
				align    = "right",
				elements = elements
			},
		function(data, menu)
			menu.close()
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'shop_update_account_menu', {
				title = "Account Money: $"..account
			}, function(data2, menu2)
				menu2.close()
				local amount = tonumber(data2.value)
				ESX.TriggerServerCallback('t1ger_shops:checkUpdateAcount', function(hasMoney)
					if hasMoney then
						TriggerServerEvent('t1ger_shops:updateAccount', id, data.current.value, amount)
						BossMenuManage(id,val)
					end
				end, id, data.current.value, amount)
			end,
			function(data2, menu2)
				menu2.close()	
				AccountsMainMenu(id,val)
			end)
		end, function(data, menu)
			menu.close()
			BossMenuManage(id,val)
		end)
	end, id)
end


-- ## INTERACTION MENU ## --

-- Mechanic Action Thread:
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if IsControlJustPressed(0, Config.InteractionMenuKey) and plyShopID > 0 then
			local current_shop = Config.Shops[plyShopID]
			local cashier_pos = current_shop.cashier
			if GetDistanceBetweenCoords(coords, cashier_pos[1], cashier_pos[2], cashier_pos[3], true) < Config.ShelfCreateDist then 
				OpenShopInteractionMenu()
			else
				ShowNotifyESX("Not inside your shop.")
			end
		end
	end
end)

-- function to open menu:
function OpenShopInteractionMenu()
	local elements = {}
	if plyShopID > 0 then
		table.insert(elements, { label = "Add Shelf", value = "add_shelf" })
		table.insert(elements, { label = "Remove Shelf", value = "remove_shelf" })
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "shop_interaction_menu",
		{
			title    = "Shop Owner Menu",
			align    = "right",
			elements = elements
		},
	function(data, menu)
		menu.close()
		if data.current.value == 'add_shelf' then
			AddShelfMenu()
		end
		if data.current.value == 'remove_shelf' then
			RemoveShelfMenu()
		end
	end, function(data, menu)
		menu.close()
	end)
end

-- function to add new shelf in shop:
function AddShelfMenu()
	local pos = {round(coords.x,2),round(coords.y,2),round(coords.z,2),round(GetEntityHeading(player),2)}
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'shelf_enter_type', {
		title = "Enter Shelf Type: "
	}, function(data, menu)
		--menu.close()
		if data.value == nil or data.value == '' then
			ShowNotifyESX(Lang['invalid_string'])
		else
			menu.close()
			local type = string.lower(data.value)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'shelf_enter_drawText', {
				title = "Enter Shelf 3D Text: "
			}, function(data2, menu2)
				if data2.value == nil or data2.value == '' then
					ShowNotifyESX(Lang['invalid_string'])
				else
					menu2.close()
					local fixChars = string.lower(data2.value)
					local text = (fixChars):gsub("^%l", string.upper)
					local elements = {
						{label = "Confirm New Shelf", value = "confirm_new_shelf"},
						{label = "Pos: { "..pos[1]..", "..pos[2]..", "..pos[3]..", "..pos[4].." }"},
						{label = "Type: "..type},
						{label = "3D Text: "..text}
					}
					ESX.UI.Menu.CloseAll()
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), "new_shelf_overview",
						{
							title    = "New Shelf View",
							align    = "right",
							elements = elements
						},
					function(data3, menu3)
						if data3.current.value == "confirm_new_shelf" then 
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'new_shelf_final_confirmation', {
								title    = "Final Confirmation",
								align    = 'right',
								elements = {
									{label = Lang['button_no'],  value = 'button_no'},
									{label = Lang['button_yes'], value = 'button_yes'},
								}
							}, function(data4, menu4)
								if data4.current.value == 'button_yes' then
									local table = {pos = pos, type = type, drawText = text}
									TriggerServerEvent('t1ger_shops:updateShelves', plyShopID, table, true)
									menu3.close()
								end
								menu4.close()
							end, function(data4, menu4)
								menu4.close()
							end)
						end
					end, function(data3, menu3)
						menu3.close()
					end)
				end
			end,
			function(data2, menu2)
				menu2.close()
			end)
		end
	end,
	function(data, menu)
		menu.close()
		OpenShopInteractionMenu()
	end)
end

-- function to remove a shelf from shop:
function RemoveShelfMenu()
	local elements = {}
	ESX.TriggerServerCallback('t1ger_shops:fetchShelves', function(shelves)
		if #shelves > 0 then
			for k,v in pairs(shelves) do 
				table.insert(elements, {label = v.drawText, pos = v.pos, type = v.type, drawText = v.drawText})
			end
			ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), "shelves_list_menu",
				{
					title    = "Shop Shelves",
					align    = "right",
					elements = elements
				},
			function(data, menu)
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shelf_confirm_removal', {
					title    = "Confirm Removal",
					align    = 'right',
					elements = {
						{label = Lang['button_no'],  value = 'button_no'},
						{label = Lang['button_yes'], value = 'button_yes'},
					}
				}, function(data2, menu2)
					if data2.current.value == 'button_yes' then
						local chk = data.current
						local table = {pos = chk.pos, type = chk.type, drawText = chk.drawText}
						TriggerServerEvent('t1ger_shops:updateShelves', plyShopID, table, false)
						menu.close()
					end
					menu2.close()
				end, function(data2, menu2)
					menu2.close()
				end)
			end, function(data, menu)
				menu.close()
			end)
		else
			ShowNotifyESX(Lang['no_shelves'])
		end
	end, plyShopID)
end


-- ## WEAPON LOADOUT SYSTEMS ## --

RegisterNetEvent('t1ger_shops:addAmmoClient')
AddEventHandler('t1ger_shops:addAmmoClient', function(weapon, amount)
	local add_amount = (GetAmmoInPedWeapon(player, weapon) + amount)
	SetPedAmmo(player, weapon, add_amount)
end)

-- function to purchase ammo
function AddAmmoToLoadout(item, price, paymentType)
	ESX.TriggerServerCallback('t1ger_shops:getLoadout', function(loadout)
		local selected_weapon = GetSelectedPedWeapon(player)
		if selected_weapon ~= -1569615261 then
			local ped_ammoType = GetPedAmmoTypeFromWeapon(player, selected_weapon)
			if item.ammo_type == ped_ammoType then
				for k,v in pairs(loadout) do
					if selected_weapon == GetHashKey(v.name) then
						local cur_ammo = GetAmmoInPedWeapon(player, v.name)
						local new_ammo = (cur_ammo + item.value)
						if new_ammo <= 250 then 
							SetPedAmmo(player, v.name, new_ammo)
							if price ~= nil or paymentType ~= nil then 
								TriggerServerEvent('t1ger_shops:purchaseAmmo', item, price, paymentType)
							else
								TriggerServerEvent('t1ger_shops:loadoutWithdraw', item.ammo_type, item.label, item.value, item.id, item.type, item.str_match)
							end
						else
							ShowNotifyESX(Lang['ammo_limit_exceed'])
						end
						break
					else
						if k == #loadout then
							ShowNotifyESX(Lang['ammo_unavailable'])
						end
					end
				end
			else
				ShowNotifyESX(Lang['ammo_incompatible'])
			end
		else
			ShowNotifyESX(Lang['hold_wep_in_hands']) 
		end
	end)
end

-- function to purchase weapon:
function AddWeaponToLoadout(item, price, paymentType)
	ESX.TriggerServerCallback('t1ger_shops:getLoadout', function(loadout)
		if #loadout > 0 then 
			for k,v in pairs(loadout) do
				if item.item == v.name then
					ShowNotifyESX(Lang['wep_already_in_loadout'])
					break
				else
					if k == #loadout then
						if price ~= nil or paymentType ~= nil then 
							TriggerServerEvent('t1ger_shops:purchaseWeapon', item, price, paymentType)
						else
							TriggerServerEvent('t1ger_shops:loadoutWithdraw', item.item, item.label, item.value, item.id, item.type, item.str_match)
						end
					end
				end
			end
		else
			if price ~= nil or paymentType ~= nil then 
				TriggerServerEvent('t1ger_shops:purchaseWeapon', item, price, paymentType)
			else
				TriggerServerEvent('t1ger_shops:loadoutWithdraw', item.item, item.label, item.value, item.id, item.type, item.str_match)
			end
		end
	end)
end

-- function to add loadout stock:
function AddLoadoutStock(selected_item,amount,price,id)
	local selected = selected_item 
	local ammoType = "N/A"; if selected.ammoType ~= nil then ammoType = selected.ammoType end
	if selected.type == "ammo" then
		if amount > selected.ammo then 
			ShowNotifyESX(Lang['ammo_restock_amount'])
		else
			local new_ammo = (selected.ammo - amount)
			SetPedAmmo(player, selected.weapon, new_ammo)
			TriggerServerEvent('t1ger_shops:loadoutDeposit', selected, amount, price, id, selected.shelf)
		end
	elseif selected.type == "weapon" then
		if amount > 1 then
			ShowNotifyESX(Lang['wep_restock_amount'])
		else
			TriggerServerEvent('t1ger_shops:loadoutDeposit', selected, amount, price, id, selected.shelf)
		end
	end
end

-- Function to empty basket:
function EmptyShopBasket(reason)
    if reason ~= nil then
        TriggerServerEvent('t1ger_shops:emptyShopBasket', basket.shopID, basket.items)
        Citizen.Wait(200)
        ShowNotifyESX(reason)
    end
    basket.bill = 0
    basket.items = {}
    basket.shopID = 0
end
-- Check if item exists in basket:
function IsItemInBasket(item)
    for i = 1, #basket.items do if item == basket.items[i].item then return true, i end end
    return false, nil
end