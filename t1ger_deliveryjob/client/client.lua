-------------------------------------
------- Created by T1GER#9080 -------
------------------------------------- 

plyCompanyID 	= 0
emptyCompanies 	= {}
RegisterNetEvent('t1ger_deliveryjob:fetchCompanyCL')
AddEventHandler('t1ger_deliveryjob:fetchCompanyCL', function(companyID)
	plyCompanyID = companyID
	for k,v in pairs(companyBlips) do RemoveBlip(v) end
	ESX.TriggerServerCallback('t1ger_deliveryjob:getTakenCompanies', function(ownedCompanies)
		for k,v in pairs(ownedCompanies) do if v.id ~= plyCompanyID then emptyCompanies[v.id] = v.id end end
		for k,v in ipairs(Config.Companies) do
			if plyCompanyID == k then
				for _,y in pairs(ownedCompanies) do if y.id == plyCompanyID then CreateCompanyBlips(k,v,y.name) break end end
			else
				if emptyCompanies[k] == k then
					for _,y in pairs(ownedCompanies) do if y.id == k then CreateCompanyBlips(k,v,y.name) end end
				else
					if Config.BuyableCompanyBlip then CreateCompanyBlips(k,v,Lang["vacant_companies"]) end
				end
			end
		end
	end)
end)

deliveryMenu = nil
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local player = GetPlayerPed(-1)
		local coords =  GetEntityCoords(player)
		for k,v in pairs(Config.Companies) do
			local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.menuPos[1], v.menuPos[2], v.menuPos[3], false)
			if deliveryMenu ~= nil then
				distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, deliveryMenu.menuPos[1], deliveryMenu.menuPos[2], deliveryMenu.menuPos[3], false)
				while deliveryMenu ~= nil and distance > 2.0 do
					deliveryMenu = nil
					Citizen.Wait(1)
				end
				if deliveryMenu == nil then
					ESX.UI.Menu.CloseAll()
				end
			else
				local mk = Config.MarkerSettings
				if distance <= 10.0 and distance >= 2.0 then
					if mk.enable then
						DrawMarker(mk.type, v.menuPos[1], v.menuPos[2], v.menuPos[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, mk.scale.x, mk.scale.y, mk.scale.z, mk.color.r, mk.color.g, mk.color.b, mk.color.a, false, true, 2, false, false, false, false)
					end
                elseif distance <= 2.0 then
                    if plyCompanyID == k then
                        DrawText3Ds(v.menuPos[1], v.menuPos[2], v.menuPos[3], Lang['manage_company'])
                        if IsControlJustPressed(0, Config.KeyToManageCompany) then
							deliveryMenu = v
                            ManageCompanyMenu(k,v)
                        end
                    else
                        if emptyCompanies[k] == k then
							DrawText3Ds(v.menuPos[1], v.menuPos[2], v.menuPos[3], Lang['no_access_company'])
                        else
                            if plyCompanyID == 0 then
                                DrawText3Ds(v.menuPos[1], v.menuPos[2], v.menuPos[3], (Lang['press_to_buy_firm']:format(math.floor(v.price))))
                                if IsControlJustPressed(0, Config.KeyToBuyCompany) then
                                    deliveryMenu = v
                                    BuyCompanyMenu(k,v)
                                end
                            else
                                DrawText3Ds(v.menuPos[1], v.menuPos[2], v.menuPos[3], Lang['only_one_company'])
                            end
                        end
                    end
				end
			end
		end
	end
end)

-- Buy Company Menu:
function BuyCompanyMenu(id,val)
	local playerPed  = GetPlayerPed(-1)
	local elements = {
		{ label = Lang['button_yes'], value = "confirm_purchase" },
		{ label = Lang['button_no'], value = "decline_purchase" },
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "company_purchase_menu",
		{
			title    = "Confirm | Price: $"..math.floor(val.price),
			align    = "right",
			elements = elements
		},
	function(data, menu)
		if(data.current.value == 'confirm_purchase') then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'company_choose_name_dialog', {
				title = "Enter Name For Company"
			}, function(data2, menu2)
				menu2.close()
				local firmName = tostring(data2.value)
				ESX.TriggerServerCallback('t1ger_deliveryjob:buyCompany', function(purchased)
					if purchased then
						ShowNotifyESX((Lang['company_bought']):format(math.floor(val.price)))
						TriggerServerEvent('t1ger_deliveryjob:fetchCompanySV')
						menu.close()
						deliveryMenu = nil
					else
						ShowNotifyESX(Lang['not_enough_money'])
						menu.close()
						deliveryMenu = nil
					end
				end, id, val, firmName)
			end,
			function(data2, menu2)
				menu2.close()	
			end)
		end
		if(data.current.value == 'decline_purchase') then
			menu.close()
			deliveryMenu = nil
		end
		menu.close()
	end, function(data, menu)
		menu.close()
		deliveryMenu = nil
	end)
end

-- Manage Company Menu:
function ManageCompanyMenu(id,val)
	local playerPed  = GetPlayerPed(-1)
	local elements = {
		{ label = Lang['rename_company'], value = "rename_company" },
		{ label = Lang['sell_company'], value = "sell_company" },
		{ label = Lang['company_level'], value = "company_level" },
		{ label = Lang['request_job'], value = "request_job" },
	}
	if Config.T1GER_Shops then
		table.insert(elements, {label = "Shop Orders", value = "shop_orders"})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "company_manage_menu",
		{
			title    = "Company ["..tostring(id).."]",
			align    = "right",
			elements = elements
		},
	function(data, menu)
		if(data.current.value == 'rename_company') then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'company_rename_dialog', {
				title = "Rename Company"
			}, function(data2, menu2)
				menu2.close()
				local firmName = tostring(data2.value)
				ESX.TriggerServerCallback('t1ger_deliveryjob:renameCompany', function(renamed)
					if renamed then
						ShowNotifyESX((Lang['company_renamed']):format(firmName))
						TriggerServerEvent('t1ger_deliveryjob:fetchCompanySV')
						menu.close()
						deliveryMenu = nil
					else
						ShowNotifyESX(Lang['not_your_company'])
						menu.close()
						deliveryMenu = nil
					end
				end, id, val, firmName)
			end,
			function(data2, menu2)
				menu2.close()	
			end)
		end
        if(data.current.value == 'sell_company') then
			SellCompanyMenu(id,val)
			menu.close()
			deliveryMenu = nil
		end
		if(data.current.value == 'company_level') then
			CompanyLevelMenu(id,val)
			menu.close()
			deliveryMenu = nil
		end
		if(data.current.value == 'request_job') then
			RequestJobMenu(id,val)
			menu.close()
			deliveryMenu = nil
		end
		if(data.current.value == 'shop_orders') then
			ShopOrderMenu(id,val)
			menu.close()
			deliveryMenu = nil
		end
		menu.close()
	end, function(data, menu)
		menu.close()
		deliveryMenu = nil
	end)
end

-- Sell Company
function SellCompanyMenu(id,val)
	local playerPed  = GetPlayerPed(-1)
	local sellPrice = (val.price * Config.SellPercent)
	local elements = {
		{ label = Lang['button_yes'], value = "confirm_sale" },
		{ label = Lang['button_no'], value = "decline_sale" },
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "company_sell_menu",
		{
			title    = "Confirm Sale | Price: $"..math.floor(sellPrice),
			align    = "right",
			elements = elements
		},
	function(data, menu)
		if(data.current.value == 'confirm_sale') then
			ESX.TriggerServerCallback('t1ger_deliveryjob:sellCompany', function(sold)
				if sold then
					TriggerServerEvent('t1ger_deliveryjob:fetchCompanySV')
					ShowNotifyESX((Lang['company_sold']):format(math.floor(sellPrice)))
				else
					ShowNotifyESX(Lang['not_your_company'])
				end
			end, id, val, math.floor(sellPrice))
			menu.close()
			deliveryMenu = nil
		end
		if(data.current.value == 'decline_sale') then
			menu.close()
			deliveryMenu = nil
		end
		menu.close()
	end, function(data, menu)
		menu.close()
		deliveryMenu = nil
	end)
end

function CompanyLevelMenu(id,val)
	local playerPed  = GetPlayerPed(-1)
	
	ESX.TriggerServerCallback('t1ger_deliveryjob:getCompanyData', function(level, certifcate)
		if level ~= nil then
			local certifcateLabel = 'No'
			if certifcate == 1 then 
				certifcateLabel = 'Yes'
			end
			local elements = {
				{ label = (Lang['certificate_state']:format(certifcateLabel)), value = "view_certifcate_state" },
				{ label = Lang['buy_certificate'], value = "buy_certifcate" },
			}
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), "company_skill_level",
				{
					title    = (Lang['company_level_value']:format(math.floor(level))),
					align    = "right",
					elements = elements
				},
			function(data, menu)

				if(data.current.value == 'buy_certifcate') then
					ESX.TriggerServerCallback('t1ger_deliveryjob:buyCertifcate', function(certificateStatus)
						if certificateStatus == nil then 
							ShowNotifyESX(Lang['not_your_company'])
						elseif certificateStatus == 1 then 
							ShowNotifyESX(Lang['alrdy_has_certificate'])
						elseif certificateStatus == true then 
							ShowNotifyESX(Lang['certificate_acquired'])
						elseif certificateStatus == false then 
							ShowNotifyESX(Lang['not_enough_money'])
						end
					end, id)
					menu.close()
					ManageCompanyMenu(id,val)
				end

			end, function(data, menu)
				menu.close()
				ManageCompanyMenu(id,val)
			end)
		end
	end, id)
end

function RequestJobMenu(id,val)
	local playerPed  = GetPlayerPed(-1)
	
	ESX.TriggerServerCallback('t1ger_deliveryjob:getCompanyData', function(level, certifcate)
		if level ~= nil then
			local elements = {}
			for k,v in ipairs(Config.JobValues) do
				if k ~= 4 then 
					table.insert(elements,{jobValue = k, label = v.label, level = v.level, certificate = v.certificate, vehicles = v.vehicles})
				end
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), "request_job_menu",
				{
					title    = Lang['select_job_value'],
					align    = "right",
					elements = elements
				},
			function(data, menu)
				if level >= data.current.level then 
					if data.current.certificate == false then 
						menu.close()
						SelectJobVehicle(data.current.jobValue, data.current.label, data.current.level, data.current.certificate, data.current.vehicles, nil, id, val)
					elseif data.current.certificate == true and certifcate == 1 then 
						menu.close()
						SelectJobVehicle(data.current.jobValue, data.current.label, data.current.level, data.current.certificate, data.current.vehicles, nil, id, val)
					else
						ShowNotifyESX(Lang['job_needs_certificate'])
					end
				else
					ShowNotifyESX(Lang['job_level_mismatch'])
				end
			end, function(data, menu)
				menu.close()
				ManageCompanyMenu(id,val)
			end)
		end
	end, id)
end

function ShopOrderMenu(id, val)
	ESX.TriggerServerCallback('t1ger_deliveryjob:fetchShopOrders', function(orders)
		ESX.TriggerServerCallback('t1ger_deliveryjob:getCompanyData', function(level, certifcate)
			local elements = {}
			local selected = {}
			if #orders > 0 then
				for num,job in ipairs(Config.JobValues) do
					if job.label == "Shops" then
						for k,v in pairs(orders) do
							if v.taken == 0 then 
								table.insert(elements, {
									label = (v.data.orderQty.."x "..v.data.itemLabel.." to shop ["..v.data.shopID.."]"), orderData = v, jobValue = num, jobName = job.label, level = job.level, certificate = job.certificate, vehicles = job.vehicles 
								})
							end
						end
					end
				end
				table.insert(elements, {label = "Done"})
				ESX.UI.Menu.CloseAll()
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), "shop_order_list",
					{
						title    = "Available Orders",
						align    = "right",
						elements = elements
					},
				function(data, menu)
					if level ~= nil then 
						if data.current.label ~= "Done" then
							if level >= data.current.level then 
								if data.current.certificate == false then 
									if #selected < Config.ShopsDeliveryLimit  then 
										local dup = false
										for i = 1, #selected do if selected[i].orderData.id == data.current.orderData.id or selected[i].orderData.data.shopID ~= data.current.orderData.data.shopID then dup = true break end end
										if not dup then ShowNotifyESX(Lang['order_selected']) table.insert(selected, {jobValue = data.current.jobValue, label = data.current.label, level = data.current.level, certificate = data.current.certificate, vehicles = data.current.vehicles, orderData = data.current.orderData, id = id, val = val}) end
									elseif #selected >= Config.ShopsDeliveryLimit then
										ShowNotifyESX(Lang['max_orders_selected'])
										menu.close()
										SelectJobVehicleShops(selected)
									else
										ShowNotifyESX(Lang['one_shop_allowed'])
									end
								elseif data.current.certificate == true and certifcate ~= nil and certifcate == 1 then 
									if #selected < Config.ShopsDeliveryLimit  then 
										local dup = false
										for i = 1, #selected do if selected[i].orderData.id == data.current.orderData.id or selected[i].orderData.data.shopID ~= data.current.orderData.data.shopID then dup = true break end end
										if not dup then ShowNotifyESX(Lang['order_selected']) table.insert(selected, {jobValue = data.current.jobValue, label = data.current.label, level = data.current.level, certificate = data.current.certificate, vehicles = data.current.vehicles, orderData = data.current.orderData, id = id, val = val}) end
									elseif #selected >= Config.ShopsDeliveryLimit then
										ShowNotifyESX(Lang['max_orders_selected'])
										menu.close()
										SelectJobVehicleShops(selected)
									else
										ShowNotifyESX(Lang['one_shop_allowed'])
									end
								else
									ShowNotifyESX(Lang['job_needs_certificate'])
								end
							else
								ShowNotifyESX(Lang['job_level_mismatch'])
							end
						else
							if selected ~= {} then
								menu.close()
								SelectJobVehicleShops(selected)
							else
								menu.close()
								ManageCompanyMenu(id,val)
							end
						end
					end
				end, function(data, menu)
					menu.close()
					ManageCompanyMenu(id,val)
				end)
			else
				ShowNotifyESX(Lang['no_available_orders'])
			end
		end, id)
	end)
end

jobVehicle 			= nil
deliveryComplete 	= false
vehDeposit 			= 0
paycheck 			= 0
function SelectJobVehicle(jobValue, label, level, certificate, vehicles, orderData, id, val)
	local elements = {}
	for k,v in ipairs(vehicles) do
		table.insert(elements,{label = v.name.." [deposit: $"..v.deposit.."]", name = v.name, model = v.model, deposit = v.deposit})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "job_select_vehicle",
		{
			title    = Lang['select_job_vehicle'],
			align    = "right",
			elements = elements
		},
	function(data, menu)
		ESX.TriggerServerCallback('t1ger_deliveryjob:vehDepositFee', function(deposited)
			if deposited then
				vehDeposit = data.current.deposit
				ShowNotifyESX((Lang['deposit_veh_paid']:format(data.current.deposit)))
				menu.close()
				local vehicleModel = data.current.model
				SpawnJobVehicle(data.current.model, val.vehSpawn, val.vehSpawn[4])
				Wait(500)
				if jobValue == 1 or jobValue == 2 then 
					TriggerEvent('t1ger_deliveryjob:parcelDelivery', jobValue, label, level, certificate, vehicleModel, nil, id, val)
				elseif jobValue == 3 then
					TriggerEvent('t1ger_deliveryjob:highValueDelivery', jobValue, label, level, certificate, vehicleModel, id, val)
				elseif jobValue == 4 then
					orderData.taken = true
					TriggerServerEvent('t1ger_deliveryJob:updateOrderState', orderData, true)
					TriggerEvent('t1ger_deliveryjob:parcelDelivery', jobValue, label, level, certificate, vehicleModel, orderData, id, val)
				end
			else
				ShowNotifyESX(Lang['not_enough_to_deposit'])
			end
		end, data.current.deposit)
	end, function(data, menu)
		menu.close()
		RequestJobMenu(id,val)
	end)
end

function SelectJobVehicleShops(jobs)
	local elements = {}
	for k,v in ipairs(jobs[1].vehicles) do
		table.insert(elements,{label = v.name.." [deposit: $"..v.deposit.."]", name = v.name, model = v.model, deposit = v.deposit})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "job_select_vehicle",
		{
			title    = Lang['select_job_vehicle'],
			align    = "right",
			elements = elements
		},
	function(data, menu)
		ESX.TriggerServerCallback('t1ger_deliveryjob:vehDepositFee', function(deposited)
			if deposited then
				local orders = {}
				vehDeposit = data.current.deposit
				ShowNotifyESX((Lang['deposit_veh_paid']:format(data.current.deposit)))
				menu.close()
				local vehicleModel = data.current.model
				SpawnJobVehicle(data.current.model, jobs[1].val.vehSpawn, jobs[1].val.vehSpawn[4])
				Wait(500)
				for i = 1, #jobs do 
					jobs[i].orderData.taken = true
					orders[i] = jobs[i].orderData 
				end
				TriggerServerEvent('t1ger_deliveryJob:updateOrderState', jobs[1].orderData.data.shopID, orders)
				TriggerEvent('t1ger_deliveryjob:parcelDelivery', jobs[1].jobValue, jobs[1].label, jobs[1].level, jobs[1].certificate, vehicleModel, orders, jobs[1].id, jobs[1].val)
			else
				ShowNotifyESX(Lang['not_enough_to_deposit'])
			end
		end, data.current.deposit)
	end, function(data, menu)
		menu.close()
		RequestJobMenu(id,val)
	end)
end


-- HIGH VALUE JOBS --
jobNum 				= 0
jobTrailer 			= nil
jobForklift 		= nil
maxPallets			= 0
palletObj			= {}
palletObjPos		= {}
traillerFilledUp	= false
palletEntity		= {}
truckingStarted		= false
truckingBlip		= nil
palletObjEntity 	= nil
deliveredPallets	= 0

RegisterNetEvent('t1ger_deliveryjob:highValueDelivery')
AddEventHandler('t1ger_deliveryjob:highValueDelivery', function(jobValue, label, level, certificate, vehModel, id, val)

	jobNum = math.random(1,#Config.HighValueJobs)
	local trailerModel = Config.HighValueJobs[jobNum].trailer
	local forkliftTaken = false
	local palletDelivered = false
	local curPallet_state 	= false
	local onGoingDelivery = false

	while true do
		Citizen.Wait(5)
		local player = GetPlayerPed(-1)
		local coords = GetEntityCoords(player)

		-- Spawn job trailer:
		if DoesEntityExist(jobVehicle) and not trailerSpawned then
			SpawnTruckTrailer(trailerModel, val.trailerSpawn, val.trailerSpawn[4])
			trailerSpawned = true
		end

		-- Spawn Forklift
		if not forkliftSpawned then
			local jk = val.forklift
			ESX.Game.SpawnVehicle(val.forklift.model, {x = jk.pos[1], y = jk.pos[2], z = jk.pos[3]}, jk.pos[4], function(veh)
				SetEntityCoordsNoOffset(veh, jk.pos[1], jk.pos[2], jk.pos[3])
				SetEntityHeading(veh, jk.pos[4])
				SetVehicleOnGroundProperly(veh)
				SetEntityAsMissionEntity(jobForklift, true, true)
				jobForklift = veh
			end)
			forkliftSpawned = true
		end

		-- Fill up truck:
		local mk = val.refill.marker
		local spot = val.refill.pos
		if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, spot[1], spot[2], spot[3], true) < mk.drawDist) and not traillerFilledUp then 
			if DoesEntityExist(jobForklift) then
				DrawMarker(mk.type, spot[1], spot[2], spot[3]-0.965, 0, 0, 0, 180.0, 0, 0, mk.scale.x, mk.scale.y, mk.scale.z,mk.color.r,mk.color.g,mk.color.b,mk.color.a, false, true, 2, false, false, false, false)
				if (GetDistanceBetweenCoords(coords, spot[1], spot[2], spot[3], true) < 3.5)  then
					DrawText3Ds(spot[1], spot[2], spot[3]+0.8, Lang['fill_up_trailer'])
					if IsControlJustPressed(0, Config.KeyToLoadJobVehicle) then
						local curVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
						if curVeh > 0 then 
							if GetEntityModel(curVeh) == GetEntityModel(jobForklift) then
								forkliftIntoTruck(val.cargo, val.cargoMarker, Config.HighValueJobs[jobNum].prop, jobValue)
							else
								ShowNotifyESX(Lang['forklift_mismatch'])
							end
						else
							ShowNotifyESX(Lang['not_inside_forklift'])
						end
					end
				end
			end
		end

		-- Park Forklift:
		if traillerFilledUp and not truckingStarted then 
			local d1 = GetModelDimensions(GetEntityModel(jobTrailer))
			local trunk = GetOffsetFromEntityInWorldCoords(jobTrailer, 0.0, d1["y"]-2.0, 0.0-0.9)
			if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, trunk.x, trunk.y, trunk.z, true) > 5.0) then 
				DrawMissionText(Lang['forklift_into_trailer'])
			end
			if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, trunk.x, trunk.y, trunk.z, true) < 5.0) then 
				DrawText3Ds(trunk.x, trunk.y, trunk.z, Lang['park_the_forklift'])
				if IsControlJustPressed(0, 47) then
					DoScreenFadeOut(1000)
					while not IsScreenFadedOut() do
						Wait(0)
					end
					Citizen.Wait(150)
					DeleteVehicle(jobForklift)
					jobForklift = nil
					SetVehicleDoorShut(jobTrailer, 5, true)
					SetVehicleDoorShut(jobTrailer, 6, true)
					SetVehicleDoorShut(jobTrailer, 7, true)
					truckingStarted = true
					DoScreenFadeIn(1000)
					Citizen.Wait(100)
					ShowNotifyESX(Lang['trailer_filled_up'])
					SetTruckingRoute()
				end
			end
		end
		
		if truckingStarted then 
			-- Taking out forklift from trailer:
			if deliveredPallets < maxPallets then 
				if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, dropOffPos[1], dropOffPos[2], dropOffPos[3], true) < 25.0) and not forkliftTaken and not onGoingDelivery then 
					if IsPedInAnyVehicle(player) then
						DrawMissionText(Lang['park_instrunctions'])
						local mk4 = val.refill.marker
						DrawMarker(30, dropOffPos[1], dropOffPos[2], dropOffPos[3], 0, 0, 0, dropOffPos[4], 0, 0, mk4.scale.x+1.0, mk4.scale.y+1.0, mk4.scale.z+1.0,mk4.color.r,mk4.color.g,mk4.color.b,mk4.color.a, false, false, 2, false, false, false, false)
					end
					if not IsPedInAnyVehicle(player) then 
						local d1 = GetModelDimensions(GetEntityModel(jobTrailer))
						local trunk = GetOffsetFromEntityInWorldCoords(jobTrailer, 0.0, d1["y"]-3.80, 0.0-0.9)
						if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, trunk.x, trunk.y, trunk.z, true) < 5.0) and jobForklift == nil then 
							DrawText3Ds(trunk.x, trunk.y, trunk.z, Lang['take_the_forklift'])
							if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, trunk.x, trunk.y, trunk.z, true) < 3.5) then 
								if IsControlJustPressed(0, 47) then
									local plyPos = GetEntityCoords(GetPlayerPed(-1))
									SetVehicleDoorOpen(jobTrailer, 5, false, false)
									SetVehicleDoorOpen(jobTrailer, 6, false, false)
									SetVehicleDoorOpen(jobTrailer, 7, false, false)
									Wait(300)
									DoScreenFadeOut(1000)
									while not IsScreenFadedOut() do
										Wait(0)
									end
									ESX.Game.SpawnVehicle(val.forklift.model, {x = trunk.x, y = trunk.y, z = trunk.z}, GetEntityHeading(GetPlayerPed(-1)), function(veh)
										SetEntityCoordsNoOffset(veh, trunk.x, trunk.y, trunk.z)
										SetEntityHeading(veh, GetPlayerPed(-1))
										SetVehicleOnGroundProperly(veh)
										SetEntityAsMissionEntity(jobForklift, true, true)
										jobForklift = veh
										Wait(100)
										TaskWarpPedIntoVehicle(player, jobForklift, -1)
									end)
									local pSpot = dropOffPallet.pickup
									ESX.Game.SpawnObject(Config.HighValueJobs[jobNum].prop, {x = pSpot[1], y = pSpot[2], z = pSpot[3]}, function(pallet)
										SetEntityHeading(pallet, 150.0)
										SetEntityAsMissionEntity(pallet, true, true)
										PlaceObjectOnGroundProperly(pallet)
										Wait(500)
										palletObjEntity = pallet
									end)
									DoScreenFadeIn(1000)
									Citizen.Wait(100)
									onGoingDelivery = true
									forkliftTaken = true
								end
							end
						end 
					end
				end
			end

			if forkliftTaken and onGoingDelivery then 

				local pcoords = GetEntityCoords(palletObjEntity)
				local mk = val.cargoMarker
				if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, pcoords.x, pcoords.y, pcoords.z, true) < 10.0) and not palletDelivered then
					DrawMarker(mk.type, pcoords.x, pcoords.y, pcoords.z+1.6, 0, 0, 0, 180.0, 0, 0, mk.scale.x+0.2, mk.scale.y+0.2, mk.scale.z+0.2, mk.color.r, mk.color.g, mk.color.b, mk.color.a, false, true, 2, false, false, false, false)
					if IsEntityInAir(palletObjEntity) then
						curPallet_state = true
					end
					if not curPallet_state then 
						DrawMissionText(Lang['pick_up_the_pallet'])
					end
				end

				if curPallet_state then
					local coords = GetEntityCoords(GetPlayerPed(-1))
					local dSpot = dropOffPallet.drop_off
					if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, dSpot[1], dSpot[2], dSpot[3], true) > 4.0) then 
						DrawMissionText(Lang['drop_off_the_pallet'])
					end
					if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, dSpot[1], dSpot[2], dSpot[3], true) < 25.0) then
						DrawMarker(27, dSpot[1], dSpot[2], dSpot[3]-0.95, 0, 0, 0, 0.0, 0, 0, 1.0, 1.0, 1.0, 220, 60, 60, 100, false, true, 2, false, false, false, false)
						if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, dSpot[1], dSpot[2], dSpot[3], true) < 4.0) then
							DrawText3Ds(dSpot[1], dSpot[2], dSpot[3], Lang['deliver_pallet'])
							if IsControlJustPressed(0, 38) then
								if not IsEntityInAir(palletObjEntity) then
									DeleteObject(palletObjEntity)
									curPallet_state = false
									palletObjEntity = nil
									palletDelivered = true
									ShowNotifyESX(Lang['park_fork_in_trailer'])
								else
									ShowNotifyESX(Lang['place_pallet_on_ground'])
								end
							end
						end
					end
				end

				if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, dropOffPos[1], dropOffPos[2], dropOffPos[3], true) < 25.0) and palletDelivered then 
					if IsPedInAnyVehicle(player) then 
						local d1 = GetModelDimensions(GetEntityModel(jobTrailer))
						local trunk = GetOffsetFromEntityInWorldCoords(jobTrailer, 0.0, d1["y"]-3.0, 0.0-0.9)
						if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, trunk.x, trunk.y, trunk.z, true) < 5.0) and DoesEntityExist(jobForklift) then 
							DrawText3Ds(trunk.x, trunk.y, trunk.z, Lang['park_the_forklift'])
							if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, trunk.x, trunk.y, trunk.z, true) < 3.5) then 
								if IsControlJustPressed(0, 47) then
									DoScreenFadeOut(1000)
									while not IsScreenFadedOut() do
										Wait(0)
									end
									Citizen.Wait(150)
									DeleteVehicle(jobForklift)
									jobForklift = nil
									forkliftTaken = false
									palletDelivered = false
									onGoingDelivery = false
									SetVehicleDoorShut(jobTrailer, 5, true)
									SetVehicleDoorShut(jobTrailer, 6, true)
									SetVehicleDoorShut(jobTrailer, 7, true)
									DoScreenFadeIn(1000)
									Citizen.Wait(250)
									deliveredPallets = deliveredPallets + 1
									Config.HighValueJobs[jobNum].route[currentRoute].done = true
									PalletDeliveryPay()
									if deliveredPallets < maxPallets then 
										SetTruckingRoute()
										ShowNotifyESX(Lang['set_delivery_route'])
									elseif deliveredPallets >= maxPallets then 
										if DoesBlipExist(truckingBlip) then RemoveBlip(truckingBlip) end
										ShowNotifyESX(Lang['delivery_pallets_done'])
										SetReturnBlip(val.vehSpawn[1],val.vehSpawn[2],val.vehSpawn[3])
									end
								end
							end
						end 
					end
				end
			end
		end

		local mk7 = val.refill.marker
		-- Return Veh & Paycheck Thread:
		if deliveredPallets >= maxPallets then 
			if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, val.vehSpawn[1],val.vehSpawn[2],val.vehSpawn[3], true) < mk7.drawDist) and truckingStarted then 
				if DoesEntityExist(jobVehicle) then
					DrawMarker(mk7.type, val.vehSpawn[1],val.vehSpawn[2],val.vehSpawn[3]-0.965, 0, 0, 0, 180.0, 0, 0, mk7.scale.x, mk7.scale.y, mk7.scale.z,mk7.color.r,mk7.color.g,mk7.color.b,mk7.color.a, false, true, 2, false, false, false, false)
					if (GetDistanceBetweenCoords(coords, val.vehSpawn[1],val.vehSpawn[2],val.vehSpawn[3], true) < 4.0)  then
						DrawText3Ds(val.vehSpawn[1],val.vehSpawn[2],val.vehSpawn[3]+0.8, Lang['return_vehicle'])
						if IsControlJustPressed(0, Config.KeyToReturnJobVehicle) then
							local curVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
							if curVeh > 0 then
								if GetEntityModel(curVeh) == GetEntityModel(jobVehicle) then
									ReturnVehAndGetPaycheck()
								else
									ShowNotifyESX(Lang['job_veh_mismatch'])
								end
							else
								ShowNotifyESX(Lang['sit_in_job_veh'])
							end
						end
					end
				end
			end
		end

		-- Reset the locales:
		if deliveryComplete then 
			jobVehicle 			= nil
			vehDeposit 			= 0
			paycheck 			= 0
			jobNum 				= 0
			jobTrailer 			= nil
			jobForklift 		= nil
			trailerSpawned		= false
			forkliftSpawned		= false
			maxPallets			= 0
			palletObj			= {}
			palletObjPos		= {}
			traillerFilledUp	= false
			palletEntity		= {}
			truckingStarted		= false
			truckingBlip		= nil
			dropOffPos			= {}
			dropOffPallet		= {}
			truckHealth			= 0
			palletPrice			= 0
			palletObjEntity 	= nil
			currentRoute		= 0
			deliveredPallets	= 0
			deliveryComplete 	= false
			break
		end

	end

end)

function PalletDeliveryPay()
	local newVehBody = GetVehicleBodyHealth(jobVehicle)
	local dmgPercent = (1-(Config.DamagePercent/100))
	if newVehBody < (truckHealth*dmgPercent) then 
		ShowNotifyESX(Lang['pallet_damaged_transit'])
		paycheck = paycheck
	else
		paycheck = paycheck + palletPrice
		ShowNotifyESX((Lang['paycheck_add_amount']:format(palletPrice)))
	end
end

function SetTruckingBlip(x,y,z)
	if DoesBlipExist(truckingBlip) then RemoveBlip(truckingBlip) end
	truckingBlip = AddBlipForCoord(x,y,z)
	SetBlipSprite(truckingBlip, 501)
	SetBlipColour(truckingBlip, 5)
	SetBlipRoute(truckingBlip, true)
	SetBlipScale(truckingBlip, 0.7)
	SetBlipAsShortRange(truckingBlip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Lang['trucking_blip'])
	EndTextCommandSetBlipName(truckingBlip)
end

function forkliftIntoTruck(palletSpots, objMarker, prop, jobValue)
	SetVehicleDoorOpen(jobTrailer, 5, false, false)
	SetVehicleDoorOpen(jobTrailer, 6, false, false)
	SetVehicleDoorOpen(jobTrailer, 7, false, false)
	local player = GetPlayerPed(-1)

	-- Prepare Objects:
	maxPallets = #palletSpots
	local curPallet = {state = false, num = nil}
	local drawPalletText = true
	local totalPallets = #palletSpots
	for num,v in pairs(palletSpots) do
		ESX.Game.SpawnObject(prop, {x = v[1], y = v[2], z = v[3]}, function(pallet)
            SetEntityHeading(pallet, 150.0)
            SetEntityAsMissionEntity(pallet, true, true)
            PlaceObjectOnGroundProperly(pallet)
            Wait(1000)
            palletEntity[num] = pallet
        end)
	end
	local fillingTrailer = true 

	-- Thread to fill up trailer:
	while fillingTrailer do 
		Citizen.Wait(3) 
		local player = GetPlayerPed(-1)
		local coords = GetEntityCoords(player)

		for num,v in pairs(palletEntity) do
			local pcoords = GetEntityCoords(palletEntity[num])
			local mk = objMarker
			if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, pcoords.x, pcoords.y, pcoords.z, true) < mk.drawDist) then
				DrawMarker(mk.type, pcoords.x, pcoords.y, pcoords.z+1.6, 0, 0, 0, 180.0, 0, 0, mk.scale.x+0.2, mk.scale.y+0.2, mk.scale.z+0.2, mk.color.r, mk.color.g, mk.color.b, mk.color.a, false, true, 2, false, false, false, false)
				if not curPallet.state then
					if IsEntityInAir(palletEntity[num]) then
						curPallet.state = true
						curPallet.num = num
					end
				end
			end
			if not curPallet.state then
				DrawMissionText(Lang['pick_up_pallet'])
			end
		end

		if curPallet.state then
			local d1 = GetModelDimensions(GetEntityModel(jobTrailer))
			local trunk = GetOffsetFromEntityInWorldCoords(jobTrailer, 0.0, d1["y"]-1.0, 0.0-0.3)
			if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, trunk.x, trunk.y, trunk.z, true) > 5.0) then 
				DrawMissionText(Lang['load_into_trailer'])
			end
			if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, trunk.x, trunk.y, trunk.z, true) < 5.0) then 
				DrawText3Ds(trunk.x, trunk.y, trunk.z, Lang['put_pallet_in_trailer'])
				if IsControlJustPressed(0, Config.KeyToPutParcelInVeh) then
					DeleteObject(palletEntity[curPallet.num])
					curPallet.state = false
					palletEntity[curPallet.num] = nil
					totalPallets = totalPallets - 1
					if totalPallets == 0 then 
						fillingTrailer = false
						traillerFilledUp = true
					end
				end
			end
		end

		if drawPalletText then 
			drawRct(0.91, 0.95, 0.07, 0.035, 0, 0, 0, 80)
			SetTextScale(0.40, 0.40)
			SetTextFont(4)
			SetTextProportional(1)
			SetTextColour(255, 255, 255, 255)
			SetTextEdge(2, 0, 0, 0, 150)
			SetTextEntry("STRING")
			SetTextCentre(1)
			AddTextComponentString("Pallets ["..(math.floor(maxPallets - totalPallets)).."/"..tonumber(maxPallets).."]")
			DrawText(0.945,0.9523)
		end
	end
end

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(1)
		if truckingStarted then 
			drawRct(0.865, 0.95, 0.1430, 0.035, 0, 0, 0, 80)
			SetTextScale(0.40, 0.40)
			SetTextFont(4)
			SetTextProportional(1)
			SetTextColour(255, 255, 255, 255)
			SetTextEdge(2, 0, 0, 0, 150)
			SetTextEntry("STRING")
			SetTextCentre(1)
			AddTextComponentString("Pallets ["..comma_value(maxPallets-deliveredPallets).."/"..tonumber(maxPallets).."] | Paycheck [$"..comma_value(paycheck).."]")
			DrawText(0.933,0.9523)
		end
	end
end)

-- LOW & MEDIUM VALUE JOBS --

deliveryStarted 	= false
commerical 			= nil
objProp 			= nil
maxDeliveries 		= 0
deliveryObj 		= {}
deliveryObjPos 		= {}
deliveryBlip 		= nil
deliveryParcel		= nil
deliveredParcels	= 0
returnBlip 			= nil

local jobValue, label, level, certificate, vehModel, orderData, id, val= nil, '', nil, nil, nil, nil, nil, nil
RegisterNetEvent('t1ger_deliveryjob:parcelDelivery')
AddEventHandler('t1ger_deliveryjob:parcelDelivery', function(jobValueX, labelX, levelX, certificateX, vehModelX, orderDataX, idX, valX)
	jobValue = jobValueX
	label = labelX
	level = levelX
	certificate = certificateX
	vehModel = vehModelX
	orderData = orderDataX
	id = idX
	val = valX

end)

-- Refilling Thread:
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local sleep1 = true
		if not deliveryStarted and not deliveryComplete then
			sleep1 = false
			if id ~= nil and val ~= nil then
				local player = PlayerPedId()
				local coords = GetEntityCoords(player)
				local mk = val.refill.marker
				local spot = val.refill.pos

				if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, spot[1], spot[2], spot[3], true) < mk.drawDist) then
					if DoesEntityExist(jobVehicle) then
						DrawMarker(mk.type, spot[1], spot[2], spot[3]-0.965, 0, 0, 0, 180.0, 0, 0, mk.scale.x, mk.scale.y, mk.scale.z,mk.color.r,mk.color.g,mk.color.b,mk.color.a, false, true, 2, false, false, false, false)
						if (GetDistanceBetweenCoords(coords, spot[1], spot[2], spot[3], true) < 3.5)  then
							DrawText3Ds(spot[1], spot[2], spot[3]+0.8, Lang['load_the_job_veh'])
							if IsControlJustPressed(0, Config.KeyToLoadJobVehicle) then
								local curVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
								if curVeh > 0 then 
									if GetEntityModel(curVeh) == GetEntityModel(jobVehicle) then
										if jobValue == 1 or jobValue == 4 then
											objProp = Config.ParcelProp
										elseif jobValue == 2 then
											commerical = math.random(1,#Config.MedValueJobs)
											objProp = Config.MedValueJobs[commerical].prop
										end
										RefillJobVehicle(val.cargo, val.cargoMarker, objProp, jobValue, orderData)
									else
										ShowNotifyESX(Lang['job_veh_mismatch'])
									end
								else
									ShowNotifyESX(Lang['sit_in_job_veh'])
								end
							end
						end
					end
				end
			end
		end
		if sleep1 then Citizen.Wait(500) end
	end
end)

-- Taking out parcel from veh thread:
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local sleep2 = true
		if deliveryStarted and not deliveryComplete then
			sleep2 = false
			if id ~= nil and val ~= nil then
				if deliveryParcel == nil then 
					local player = PlayerPedId()
					local coords = GetEntityCoords(player)
					local mk = val.refill.marker
					local spot = val.refill.pos
					if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, deliveryPos[1], deliveryPos[2], deliveryPos[3], true) < 25.0) then 
						if not IsPedInAnyVehicle(player) then 
							if deliveredParcels < maxDeliveries then
								local d1 = GetModelDimensions(GetEntityModel(jobVehicle))
								local trunk = GetOffsetFromEntityInWorldCoords(jobVehicle, 0.0, d1["y"]+0.60, 0.0)
								if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, trunk.x, trunk.y, trunk.z, true) < 2.0) then 
									if deliveryParcel == nil then 
										DrawText3Ds(trunk.x, trunk.y, trunk.z, Lang['take_parcel_from_veh'])
										if IsControlJustPressed(0, Config.KeyToTakeParcelFromVeh) then
											SetVehicleDoorOpen(jobVehicle, 2 , false, false)
											SetVehicleDoorOpen(jobVehicle, 3 , false, false)
											Wait(250)
											LoadModel(objProp)
											local coords = GetEntityCoords(GetPlayerPed(-1), false)
											deliveryParcel = CreateObject(GetHashKey(objProp), coords.x, coords.y, coords.z, true, true, true)
											AttachEntityToEntity(deliveryParcel, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), 0.0, -0.03, 0.0, 5.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
											LoadAnim("anim@heists@box_carry@")
											TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
											Wait(300)
											SetVehicleDoorShut(jobVehicle, 2 , false, true)
											SetVehicleDoorShut(jobVehicle, 3 , false, true)
										end
									end
								end 
							end
						end
					end
				end
			end
		end
		if sleep2 then Citizen.Wait(1000) end
	end
end)

-- Delivering parcel thread:
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local sleep3 = true
		if deliveryStarted and not deliveryComplete then 
			sleep3 = false
			if id ~= nil and val ~= nil then
				if deliveryParcel ~= nil then 
					local player = PlayerPedId()
					local coords = GetEntityCoords(player)
					local mk = val.refill.marker
					local spot = val.refill.pos
					
					if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, deliveryPos[1], deliveryPos[2], deliveryPos[3], true) < 25.0) then
						local mk2 = Config.DeliveryMarkerSpots
						if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, deliveryPos[1], deliveryPos[2], deliveryPos[3], true) > 1.5) then
							DrawMarker(mk2.type, deliveryPos[1], deliveryPos[2], deliveryPos[3], 0, 0, 0, 180.0, 0, 0, mk2.scale.x, mk2.scale.y, mk2.scale.z, mk2.color.r, mk2.color.g, mk2.color.b, mk2.color.a, false, true, 2, false, false, false, false)
						end
						if(GetDistanceBetweenCoords(GetEntityCoords(player), deliveryPos[1], deliveryPos[2], deliveryPos[3], true) < 1.5) then
							DrawText3Ds(deliveryPos[1], deliveryPos[2], deliveryPos[3], Lang['deliver_parcel'])
							if IsControlJustPressed(0, Config.KeyToDeliverParcel) then
								if deliveredParcels < maxDeliveries then
									if IsEntityAttachedToAnyPed(deliveryParcel) then 
										DeleteObject(deliveryParcel)
										ClearPedTasks(player)
										deliveredParcels = deliveredParcels + 1
										if jobValue == 1 then 
											Config.LowValueJobs[deliveryNum].done = true
										elseif jobValue == 2 then 
											Config.MedValueJobs[commerical].deliveries[deliveryNum].done = true
										end
										ParcelDeliveryPay()
										if deliveredParcels < maxDeliveries then 
											SetDeliveryRoute(jobValue)
											ShowNotifyESX(Lang['set_delivery_route'])
										elseif deliveredParcels == maxDeliveries then 
											if DoesBlipExist(deliveryBlip) then RemoveBlip(deliveryBlip) end
											ShowNotifyESX(Lang['delivery_complete'])
											if jobValue == 4 then
												TriggerServerEvent('t1ger_deliveryJob:orderDeliveryDone', orderData)
											end
											SetReturnBlip(val.vehSpawn[1],val.vehSpawn[2],val.vehSpawn[3])
										end
										deliveryParcel = nil 
									else
										ShowNotifyESX(Lang['parcel_not_ind_hand'])
									end
								end
							end
						end
					end
				end
			end
		end
		if sleep3 then Citizen.Wait(1000) end
	end
end)

-- Return Veh & Paycheck Thread:
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local sleep4 = true
		if deliveryStarted and not deliveryComplete then
			sleep4 = false
			if id ~= nil and val ~= nil then
				local player = PlayerPedId()
				local coords = GetEntityCoords(player)
				local mk = val.refill.marker
				local spot = val.refill.pos

				if deliveredParcels == maxDeliveries and deliveryParcel == nil then 
					if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, val.vehSpawn[1],val.vehSpawn[2],val.vehSpawn[3], true) < mk.drawDist) then 
						if DoesEntityExist(jobVehicle) then
							DrawMarker(mk.type, val.vehSpawn[1],val.vehSpawn[2],val.vehSpawn[3]-0.965, 0, 0, 0, 180.0, 0, 0, mk.scale.x, mk.scale.y, mk.scale.z,mk.color.r,mk.color.g,mk.color.b,mk.color.a, false, true, 2, false, false, false, false)
							if (GetDistanceBetweenCoords(coords, val.vehSpawn[1],val.vehSpawn[2],val.vehSpawn[3], true) < 4.0)  then
								DrawText3Ds(val.vehSpawn[1],val.vehSpawn[2],val.vehSpawn[3]+0.8, Lang['return_vehicle'])
								if IsControlJustPressed(0, Config.KeyToReturnJobVehicle) then
									local curVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
									if curVeh > 0 then
										if GetEntityModel(curVeh) == GetEntityModel(jobVehicle) then
											ReturnVehAndGetPaycheck()
										else
											ShowNotifyESX(Lang['job_veh_mismatch'])
										end
									else
										ShowNotifyESX(Lang['sit_in_job_veh'])
									end
								end
							end
						end
					end
				end
			end
		end
		if sleep4 then Citizen.Wait(1000) end
	end
end)

-- Reset the locals:
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local sleep5 = true
		if deliveryComplete then 
			sleep5 = false
			vehDeposit			= 0
			jobVehicle 			= nil
			deliveryStarted 	= false
			commerical 			= nil
			objProp 			= nil
			maxDeliveries 		= 0
			deliveryObj 		= {}
			deliveryObjPos 		= {}
			deliveryBlip 		= nil
			deliveryNum 		= 0
			deliveryPos 		= {}
			deliveryParcel		= nil
			deliveredParcels	= 0
			vehBodyHealth 		= 0
			parcelPrice 		= 0
			paycheck 			= 0
			orderData			= nil
			returnBlip 			= nil
			if jobValue == 1 then
				for i = 1, #Config.LowValueJobs do
					Config.LowValueJobs[i].done = false
				end
			elseif jobValue == 2 then
				for i = 1, #Config.MedValueJobs do
					for k,v in pairs(Config.MedValueJobs[i].deliveries) do
						v.done = false
					end
				end 
			end
			deliveryComplete = false
		end
		if sleep5 then Citizen.Wait(1000) end
	end
end)

function ReturnVehAndGetPaycheck()
	if DoesBlipExist(returnBlip) then RemoveBlip(returnBlip) end
	SetVehicleEngineOn(jobVehicle, false, false, false)
	if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
		TaskLeaveVehicle(GetPlayerPed(-1), jobVehicle, 4160)
		SetVehicleDoorsLockedForAllPlayers(jobVehicle, true)
	end
	local newVehBody = GetVehicleBodyHealth(jobVehicle)
	Citizen.Wait(500)
	FreezeEntityPosition(jobVehicle, true)
	local giveDeposit = false
	local dmgDeposit = (1-(Config.DepositDamage/100))
	if newVehBody < (1000*dmgDeposit) then 
		giveDeposit = false
		ShowNotifyESX(Lang['deposit_not_returned'])
	else
		giveDeposit = true
	end
	DeleteVehicle(jobVehicle)
	if DoesEntityExist(jobTrailer) then DeleteVehicle(jobTrailer) end
	TriggerServerEvent('t1ger_deliveryjob:retrievePaycheck', paycheck, vehDeposit, giveDeposit)
	deliveryComplete = true
end

function ParcelDeliveryPay()
	local newVehBody = GetVehicleBodyHealth(jobVehicle)
	local dmgPercent = (1-(Config.DamagePercent/100))
	if newVehBody < (vehBodyHealth*dmgPercent) then 
		ShowNotifyESX(Lang['parcel_damaged_transit'])
		paycheck = paycheck
	else
		paycheck = paycheck + parcelPrice
		ShowNotifyESX((Lang['paycheck_add_amount']:format(parcelPrice)))
	end
end

function RefillJobVehicle(objSpots, objMarker, prop, jobValue, orderData)
	local player = GetPlayerPed(-1)
	-- Prepare Vehicle:
	SetVehicleEngineOn(jobVehicle, false, false, false)
	SetVehicleDoorOpen(jobVehicle, 2 , false, false)
	SetVehicleDoorOpen(jobVehicle, 3 , false, false)
	if IsPedInAnyVehicle(player, true) then
		TaskLeaveVehicle(player, jobVehicle, 4160)
		SetVehicleDoorsLockedForAllPlayers(jobVehicle, true)
	end
	Citizen.Wait(500)
	FreezeEntityPosition(jobVehicle, true)
	-- Prepare Objects:
	if jobValue == 4 then maxDeliveries = 1 else maxDeliveries = #objSpots end
	local currentObj = {state = false, num = nil}
	local drawObjText = true
	local totalObjects = #objSpots
	if jobValue == 4 then totalObjects = 1 end
	for num,v in pairs(objSpots) do
		deliveryObj[num] = CreateObject(GetHashKey(prop), v[1], v[2], v[3]-0.965, true, true, true)
		deliveryObjPos[num] = v
		PlaceObjectOnGroundProperly(deliveryObj[num])
		if jobValue == 4 then break end
	end
	local fillingVeh = true 
	-- Thread to fill up job vehicle:
	while fillingVeh do 
		Citizen.Wait(1) 
		local player = GetPlayerPed(-1)
		local coords = GetEntityCoords(player)

		for num,v in pairs(deliveryObjPos) do
			local mk = objMarker
			if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v[1], v[2], v[3], true) < mk.drawDist) and not currentObj.state then 
				DrawMarker(mk.type, v[1], v[2], v[3], 0, 0, 0, 180.0, 0, 0, mk.scale.x, mk.scale.y, mk.scale.z, mk.color.r, mk.color.g, mk.color.b, mk.color.a, false, true, 2, false, false, false, false)
				if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v[1], v[2], v[3], true) < 1.0) then 
					DrawMissionText(Lang['pick_up_parcel'])
					if IsControlJustPressed(0, Config.KeyToPickUpParcel) then
						AttachEntityToEntity(deliveryObj[num], PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, -0.03, 0.0, 5.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
						LoadAnim("anim@heists@box_carry@")
						TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
						currentObj.state = true
						currentObj.num = num
					end 
				end
			end
		end

		if currentObj.state then
			local d1 = GetModelDimensions(GetEntityModel(jobVehicle))
			local trunk = GetOffsetFromEntityInWorldCoords(jobVehicle, 0.0,d1["y"]+0.60,0.0)
			if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, trunk.x, trunk.y, trunk.z, true) < 2.0) then 
				DrawText3Ds(trunk.x, trunk.y, trunk.z, Lang['put_parcel_in_veh'])
				if IsControlJustPressed(0, Config.KeyToPutParcelInVeh) then
					DeleteObject(deliveryObj[currentObj.num])
					ClearPedTasks(player)
					currentObj.state = false
					deliveryObjPos[currentObj.num] = {}
					deliveryObj[currentObj.num] = nil
					totalObjects = totalObjects - 1
					if totalObjects == 0 then 
						if jobValue == 4 then
							SetShopRoute(jobValue, orderData)
						else
							SetDeliveryRoute(jobValue)
						end
						SetVehicleDoorsLockedForAllPlayers(jobVehicle, false)
						FreezeEntityPosition(jobVehicle, false)
						SetVehicleEngineOn(jobVehicle, true, false, false)
						SetVehicleDoorShut(jobVehicle, 2 , false, true)
						SetVehicleDoorShut(jobVehicle, 3 , false, true)
						deliveryStarted = true
						ShowNotifyESX(Lang['vehicle_filled_up'])
						fillingVeh = false
					end
				end
			end
		end

		if drawObjText then 
			drawRct(0.91, 0.95, 0.07, 0.035, 0, 0, 0, 80)
			SetTextScale(0.40, 0.40)
			SetTextFont(4)
			SetTextProportional(1)
			SetTextColour(255, 255, 255, 255)
			SetTextEdge(2, 0, 0, 0, 150)
			SetTextEntry("STRING")
			SetTextCentre(1)
			AddTextComponentString("Parcels ["..(math.floor(maxDeliveries - totalObjects)).."/"..tonumber(maxDeliveries).."]")
			DrawText(0.945,0.9523)
		end
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if deliveryStarted then
			drawRct(0.865, 0.95, 0.1430, 0.035, 0, 0, 0, 80)
			SetTextScale(0.40, 0.40)
			SetTextFont(4)
			SetTextProportional(1)
			SetTextColour(255, 255, 255, 255)
			SetTextEdge(2, 0, 0, 0, 150)
			SetTextEntry("STRING")
			SetTextCentre(1)
			AddTextComponentString("Parcels ["..comma_value(maxDeliveries-deliveredParcels).."/"..tonumber(maxDeliveries).."] | Paycheck [$"..comma_value(paycheck).."]")
			DrawText(0.933,0.9523)
		end
	end
end)

function SetDeliveryBlip(x,y,z)
	if DoesBlipExist(deliveryBlip) then RemoveBlip(deliveryBlip) end
	deliveryBlip = AddBlipForCoord(x,y,z)
	SetBlipSprite(deliveryBlip, 501)
	SetBlipColour(deliveryBlip, 5)
	SetBlipRoute(deliveryBlip, true)
	SetBlipScale(deliveryBlip, 0.7)
	SetBlipAsShortRange(deliveryBlip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Lang['delivery_blip'])
	EndTextCommandSetBlipName(deliveryBlip)
end

function SetReturnBlip(x,y,z)
	if DoesBlipExist(returnBlip) then RemoveBlip(returnBlip) end
	returnBlip = AddBlipForCoord(x,y,z)
	SetBlipSprite(returnBlip, 164)
	SetBlipColour(returnBlip, 2)
	SetBlipRoute(returnBlip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Lang['return_blip'])
	EndTextCommandSetBlipName(returnBlip)
end

function SpawnJobVehicle(vehModel, vehCoords, vehHeading)
	ESX.Game.SpawnVehicle(vehModel, {x = vehCoords[1], y = vehCoords[2], z = vehCoords[3]}, vehHeading, function(veh)
		SetEntityCoordsNoOffset(veh, vehCoords[1], vehCoords[2], vehCoords[3])
		SetEntityHeading(veh, vehHeading)
		FreezeEntityPosition(veh, true)
		SetVehicleOnGroundProperly(veh)
		FreezeEntityPosition(veh, false)
		SetEntityAsMissionEntity(jobVehicle, true, true)
		jobVehicle = veh
		SetVehicleDoorsLockedForAllPlayers(jobVehicle, false)
		local numPlate = GetVehicleNumberPlateText(jobVehicle)
		Wait(150)
		if Config.t1gerKeys then
			TriggerServerEvent('t1ger_keys:addTempKeysToVeh', numPlate)
		end
	end)
	ShowNotifyESX(Lang['job_veh_spawned'])
end

function SpawnTruckTrailer(trailerModel, vehCoords, vehHeading)
	ESX.Game.SpawnVehicle(trailerModel, {x = vehCoords[1], y = vehCoords[2], z = vehCoords[3]}, vehHeading, function(trailer)
		SetEntityCoordsNoOffset(trailer, vehCoords[1], vehCoords[2], vehCoords[3])
		SetEntityHeading(trailer, vehHeading)
		FreezeEntityPosition(trailer, true)
		SetVehicleOnGroundProperly(trailer)
		FreezeEntityPosition(trailer, false)
		SetEntityAsMissionEntity(jobTrailer, true, true)
		jobTrailer = trailer
		SetVehicleDoorsLockedForAllPlayers(jobTrailer, false)
	end)
	ShowNotifyESX(Lang['job_veh_spawned'])
end

-- Adjust pricing here:
function calculatePrice(level)
	local packagePrice = 0
	local reward = Config.Reward
	math.randomseed(GetGameTimer())
	local random = math.random(reward.min,reward.max)
	packagePrice = (random * (((reward.valueAddition[level])/100) + 1)) 
	return math.floor(packagePrice)
end

RegisterCommand('canceldelivery', function(source, args)
	deliveryComplete = true
	if DoesEntityExist(jobTrailer) then DeleteVehicle(jobTrailer) end 
	if DoesEntityExist(jobVehicle) then DeleteVehicle(jobVehicle) end
	if DoesBlipExist(truckingBlip) then RemoveBlip(truckingBlip) end
	if DoesBlipExist(deliveryBlip) then RemoveBlip(deliveryBlip) end
	if DoesBlipExist(returnBlip) then RemoveBlip(returnBlip) end
end, false)

