local isPlayerSafe = false

RegisterNetEvent("DP_Inventory:openPropertyInventory")
AddEventHandler("DP_Inventory:openPropertyInventory", function(data, playerSafe)
	if playerSafe then isPlayerSafe = playerSafe; else isPlayerSafe = false; end
	setPropertyInventoryData(data)
	openPropertyInventory()
end)

function refreshPropertyInventory()
    if isPlayerSafe then
        ESX.TriggerServerCallback('playersafes:GetSafeInventory', function(inventory) 
            setPropertyInventoryData(inventory); 
        end,isPlayerSafe.safeid)
    elseif isMotel then
        ESX.TriggerServerCallback('motels:getInventory', function(inventory) 
            setPropertyInventoryData(inventory); 
        end,isMotel.zone,isMotel.door)
    else
        ESX.TriggerServerCallback("esx_property:getPropertyInventory",function(inventory)
            setPropertyInventoryData(inventory)
        end,ESX.GetPlayerData().identifier)
    end
end

function setPropertyInventoryData(data)
    SendNUIMessage({
		action = "setInfoText",
		text = _("propertyinv")
	})
    items = {}

    local blackMoney = data.blackMoney
    local propertyItems = data.items
    local propertyWeapons = data.weapons

    if blackMoney > 0 then
        accountData = {
            label = _U("black_money"),
            count = blackMoney,
            type = "item_account",
            name = "black_money",
            usable = false,
            rare = false,
            limit = -1,
            canRemove = false
        }
        table.insert(items, accountData)
    end

    for i = 1, #propertyItems, 1 do
        local item = propertyItems[i]
        if item.count > 0 then            
            item.type = "item_standard"
            item.usable = false
            item.rare = false
            item.limit = -1
            item.canRemove = false

            table.insert(items, item)
        end
    end

    for i = 1, #propertyWeapons, 1 do
        local weapon = propertyWeapons[i]
        if propertyWeapons[i].name ~= "WEAPON_UNARMED" then
            table.insert(
                items,
                {
                    label = ESX.GetWeaponLabel(weapon.name),
                    count = weapon.ammo,
                    limit = -1,
                    type = "item_weapon",
                    name = weapon.name,
                    usable = false,
                    rare = false,
                    canRemove = false
                }
            )
        end
    end

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = items
        }
    )
end

function openPropertyInventory()
	loadPlayerInventory()
	isInInventory = true
	SendNUIMessage({
		action = "display",
		type = "property"
	})
	SetNuiFocus(true, true)
end

RegisterNUICallback("PutIntoProperty", function(data, cb) 
    if IsPedSittingInAnyVehicle(playerPed) then
		return
	end
	for k,v in pairs(data) do end
        if type(data.number) == "number" and math.floor(data.number) == data.number then
            local count = tonumber(data.number)
            local isWeapon = false
            if data.item.type == "item_weapon" then
                isWeapon = true
                count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
            end
            if isPlayerSafe then
                --print("DOPUTSAFE")
                TriggerServerEvent("playersafes:PutItem", ESX.GetPlayerData().identifier, data.item.type, data.item.name, count, isPlayerSafe.safeid, isWeapon)
            else
                if data.item.name == 'cash' then
                    TriggerServerEvent("esx_property:putItem", ESX.GetPlayerData().identifier, 'item_account', 'money', count)
                else
                    TriggerServerEvent("esx_property:putItem", ESX.GetPlayerData().identifier, data.item.type, data.item.name, count)
                end
            end
        end
    Wait(0)
	refreshPropertyInventory()
	Wait(0)
	loadPlayerInventory()
	cb("ok")
end)

RegisterNUICallback("TakeFromProperty", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        if isPlayerSafe then
            TriggerServerEvent("playersafes:GetItem", ESX.GetPlayerData().identifier, data.item.type, data.item.name, tonumber(data.number), isPlayerSafe.safeid)
        else
            if data.item.name == 'cash' then
                TriggerServerEvent("esx_property:getItem", ESX.GetPlayerData().identifier, 'item_account', 'money', tonumber(data.number))
            else
                TriggerServerEvent("esx_property:getItem", ESX.GetPlayerData().identifier, data.item.type, data.item.name, tonumber(data.number))
            end
        end
    end
    Wait(0)
    refreshPropertyInventory()
    Wait(0)
    loadPlayerInventory()
    cb("ok")
end)

