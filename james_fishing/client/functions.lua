HandleCommand = function()
    if Config.Command ~= "none" and #Config.Command > 0 then
        RegisterCommand(Config.Command, function()
            TryToFish()
        end)
    end
end

TryToFish = function()
    if IsPedSwimming(cachedData["ped"]) then return exports['mythic_notify']:SendAlert('inform', 'You can\'t be swimming and fishing at the same time.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) end
    if IsPedInAnyVehicle(cachedData["ped"]) then return exports['mythic_notify']:SendAlert('inform', 'You need to exit your vehicle to start fishing.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) end

    if not HasItems({
        Config.FishingItems["rod"]["name"],
        Config.FishingItems["bait"]["name"]
    }) then return exports['mythic_notify']:SendAlert('inform', 'You need both a fishing rod and a bait to fish.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) end

    local waterValidated, castLocation = IsInWater()

    if waterValidated then
        local fishingRod = GenerateFishingRod(cachedData["ped"])

        CastBait(fishingRod, castLocation)
        TriggerEvent("IsFishing", 1)
    else
        exports['mythic_notify']:SendAlert('inform', 'You need to aim towards the water to fish.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        TriggerEvent("IsNotFishing", 1)

    end
end

TryToFish2 = function()
    if IsPedSwimming(cachedData["ped"]) then return exports['mythic_notify']:SendAlert('inform', 'You can\'t be swimming and fishing at the same time.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) end
    if IsPedInAnyVehicle(cachedData["ped"]) then return exports['mythic_notify']:SendAlert('inform', 'You need to exit your vehicle to start fishing.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) end

    if not HasItems({
        Config.FishingItems["rod"]["name"],
        Config.FishingItems["baitLuxary"]["name"]
    }) then return exports['mythic_notify']:SendAlert('inform', 'You need both a fishing rod and a bait to fish.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) end

    local waterValidated, castLocation = IsInWater()

    if waterValidated then
        local fishingRod = GenerateFishingRod(cachedData["ped"])

        CastBait2(fishingRod, castLocation)
        TriggerEvent("IsFishing", 1)
    else
        exports['mythic_notify']:SendAlert('inform', 'You need to aim towards the water to fish.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        TriggerEvent("IsNotFishing", 1)
    end
end

CastBait2 = function(rodHandle, castLocation)
    local startedCasting = GetGameTimer()

    while not IsControlJustPressed(0, 47) do
        Citizen.Wait(5)

        ESX.ShowHelpNotification("Cast your line by pressing ~INPUT_DETONATE~")

        if GetGameTimer() - startedCasting > 5000 then
            exports['mythic_notify']:SendAlert('inform', 'You need to cast the bait.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })

            return DeleteEntity(rodHandle)
        end
    end

    PlayAnimation(cachedData["ped"], "mini@tennis", "forehand_ts_md_far", {
        ["flag"] = 48
    })

    while IsEntityPlayingAnim(cachedData["ped"], "mini@tennis", "forehand_ts_md_far", 3) do
        Citizen.Wait(0)
    end

    PlayAnimation(cachedData["ped"], "amb@world_human_stand_fishing@idle_a", "idle_c", {
        ["flag"] = 11
    })

    local startedBaiting = GetGameTimer()
    local randomBait = math.random(10000, 30000)

    DrawBusySpinner("Waiting for a fish to bite...")
    

    local interupted = false

    Citizen.Wait(1000)

    while GetGameTimer() - startedBaiting < randomBait do
        Citizen.Wait(5)

        DrawScriptMarker({
            ["type"] = 1,
            ["size"] = Config.MarkerData["size"],
            ["color"] = Config.MarkerData["color"],
            ["pos"] = castLocation - vector3(0.0, 0.0, 0.985),
        })

        if not IsEntityPlayingAnim(cachedData["ped"], "amb@world_human_stand_fishing@idle_a", "idle_c", 3) then
            interupted = true

            break
        end
    end

    RemoveLoadingPrompt()

    if interupted then
        ClearPedTasks(cachedData["ped"])
        TriggerEvent("IsNotFishing", 1)

        CastBait2(rodHandle, castLocation)

        return
    end
    
    local caughtFish = TryToCatchFish()

    ClearPedTasks(cachedData["ped"])

    if caughtFish then
        ESX.TriggerServerCallback("james_fishing:receiveFish2", function(received)
            if received then
                exports['mythic_notify']:SendAlert('inform', 'You caught a fish!', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' })
                local playerPed = PlayerPedId()
                local cord = GetEntityCoords(PlayerPedId())
                local streetName,_ = GetStreetNameAtCoord(cord[1], cord[2], cord[3])
                local streetName = GetStreetNameFromHashKey(streetName)
                local gender = "unknown"
                local model = GetEntityModel(playerPed)
                if (model == GetHashKey("mp_f_freemode_01")) then
                    gender = "female"
                end
                if (model == GetHashKey("mp_m_freemode_01")) then
                    gender = "male"
                end

                if math.random(1, 2) == 1 then
                    exports['wp_dispatch']:addCall("10-31", "Illegal Fishing", {
                        {icon="fas fa-road", info = streetName},
                        {icon="fa-venus-mars", info=gender}
                    }, {cord[1], cord[2], cord[3]}, "police", 3000, 442, 5 )
                    exports['wp_dispatch']:addCall("10-31", "Illegal Fishing", {
                        {icon="fas fa-road", info = streetName},
                        {icon="fa-venus-mars", info=gender}
                    }, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 442, 5 )
                end
            end
        end)
    else
        exports['mythic_notify']:SendAlert('inform', 'The fish got loose.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
        TriggerEvent("IsNotFishing", 1)

    end

    CastBait2(rodHandle, castLocation)
end

CastBait = function(rodHandle, castLocation)
    local startedCasting = GetGameTimer()

    while not IsControlJustPressed(0, 47) do
        Citizen.Wait(5)

        ESX.ShowHelpNotification("Cast your line by pressing ~INPUT_DETONATE~")

        if GetGameTimer() - startedCasting > 5000 then
            exports['mythic_notify']:SendAlert('inform', 'You need to cast the bait.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
            

            return DeleteEntity(rodHandle)
        end
    end

    PlayAnimation(cachedData["ped"], "mini@tennis", "forehand_ts_md_far", {
        ["flag"] = 48
    })

    while IsEntityPlayingAnim(cachedData["ped"], "mini@tennis", "forehand_ts_md_far", 3) do
        Citizen.Wait(0)
    end

    PlayAnimation(cachedData["ped"], "amb@world_human_stand_fishing@idle_a", "idle_c", {
        ["flag"] = 11
    })

    local startedBaiting = GetGameTimer()
    local randomBait = math.random(10000, 30000)

    DrawBusySpinner("Waiting for a fish to bite...")

    local interupted = false

    Citizen.Wait(1000)

    while GetGameTimer() - startedBaiting < randomBait do
        Citizen.Wait(5)

        DrawScriptMarker({
            ["type"] = 1,
            ["size"] = Config.MarkerData["size"],
            ["color"] = Config.MarkerData["color"],
            ["pos"] = castLocation - vector3(0.0, 0.0, 0.985),
        })

        if not IsEntityPlayingAnim(cachedData["ped"], "amb@world_human_stand_fishing@idle_a", "idle_c", 3) then
            interupted = true

            break
        end
    end

    RemoveLoadingPrompt()

    if interupted then
        ClearPedTasks(cachedData["ped"])
        TriggerEvent("IsNotFishing", 1)

        CastBait(rodHandle, castLocation)

        return
    end
    
    local caughtFish = TryToCatchFish()

    ClearPedTasks(cachedData["ped"])

    if caughtFish then
        ESX.TriggerServerCallback("james_fishing:receiveFish", function(received)
            if received then
                exports['mythic_notify']:SendAlert('inform', 'You caught a fish!', 2500, { ['background-color'] = '#00b51e', ['color'] = '#ffffff' }) 

            end
        end)
    else
        TriggerEvent("IsNotFishing", 1)
        exports['mythic_notify']:SendAlert('inform', 'The fish got loose.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
    end

    CastBait(rodHandle, castLocation)
end

TryToCatchFish = function()
    local minigameSprites = {
        ["powerDict"] = "custom",
        ["powerName"] = "bar",
    
        ["tennisDict"] = "tennis",
        ["tennisName"] = "swingmetergrad"
    }

    while not HasStreamedTextureDictLoaded(minigameSprites["powerDict"]) and not HasStreamedTextureDictLoaded(minigameSprites["tennisDict"]) do
        RequestStreamedTextureDict(minigameSprites["powerDict"], false)
        RequestStreamedTextureDict(minigameSprites["tennisDict"], false)

        Citizen.Wait(5)
    end

    local swingOffset = 0.1
    local swingReversed = false

    local DrawObject = function(x, y, width, height, red, green, blue)
        DrawRect(x + (width / 2.0), y + (height / 2.0), width, height, red, green, blue, 150)
    end

    while true do
        Citizen.Wait(5)

        ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ in the green area.")

        DrawSprite(minigameSprites["powerDict"], minigameSprites["powerName"], 0.5, 0.4, 0.01, 0.2, 0.0, 255, 0, 0, 255)

        DrawObject(0.49453227, 0.3, 0.010449, 0.03, 0, 255, 0)

        DrawSprite(minigameSprites["tennisDict"], minigameSprites["tennisName"], 0.5, 0.4 + swingOffset, 0.018, 0.002, 0.0, 0, 0, 0, 255)

        if swingReversed then
            swingOffset = swingOffset - 0.005
        else
            swingOffset = swingOffset + 0.005
        end

        if swingOffset > 0.1 then
            swingReversed = true
        elseif swingOffset < -0.1 then
            swingReversed = false
        end

        if IsControlJustPressed(0, 38) then
            swingOffset = 0 - swingOffset

            extraPower = (swingOffset + 0.1) * 250 + 1.0

            if extraPower >= 45 then
                return true
            else
                return false
            end
        end
    end

    SetStreamedTextureDictAsNoLongerNeeded(minigameSprites["powerDict"])
    SetStreamedTextureDictAsNoLongerNeeded(minigameSprites["tennisDict"])
end

IsInWater = function()
    local startedCheck = GetGameTimer()

    local ped = cachedData["ped"]
    local pedPos = GetEntityCoords(ped)

    local forwardVector = GetEntityForwardVector(ped)
    local forwardPos = vector3(pedPos["x"] + forwardVector["x"] * 10, pedPos["y"] + forwardVector["y"] * 10, pedPos["z"])

    local fishHash = `a_c_fish`

    WaitForModel(fishHash)

    local waterHeight = GetWaterHeight(forwardPos["x"], forwardPos["y"], forwardPos["z"])

    local fishHandle = CreatePed(1, fishHash, forwardPos, 0.0, false)
    
    SetEntityAlpha(fishHandle, 0, true) -- makes the fish invisible.

    DrawBusySpinner("Checking fishing location...")

    while GetGameTimer() - startedCheck < 3000 do
        Citizen.Wait(0)
    end

    RemoveLoadingPrompt()

    local fishInWater = IsEntityInWater(fishHandle)

    DeleteEntity(fishHandle)

    SetModelAsNoLongerNeeded(fishHash)

    return fishInWater, fishInWater and vector3(forwardPos["x"], forwardPos["y"], waterHeight) or false
end

GenerateFishingRod = function(ped)
    local pedPos = GetEntityCoords(ped)
    
    local fishingRodHash = `prop_fishing_rod_01`

    WaitForModel(fishingRodHash)

    local rodHandle = CreateObject(fishingRodHash, pedPos, true)

    AttachEntityToEntity(rodHandle, ped, GetPedBoneIndex(ped, 18905), 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)

    SetModelAsNoLongerNeeded(fishingRodHash)

    return rodHandle
end

HandleStore = function()
    local storeData = Config.FishingRestaurant

    WaitForModel(storeData["ped"]["model"])

    local pedHandle = CreatePed(5, storeData["ped"]["model"], storeData["ped"]["position"], storeData["ped"]["heading"], false)

    SetEntityAsMissionEntity(pedHandle, true, true)
    SetBlockingOfNonTemporaryEvents(pedHandle, true)

    cachedData["storeOwner"] = pedHandle

    SetModelAsNoLongerNeeded(storeData["ped"]["model"])

    local storeBlip = AddBlipForCoord(storeData["ped"]["position"])

    SetBlipSprite(storeBlip, storeData["blip"]["sprite"])
    SetBlipDisplay(628, 5)
    SetBlipScale(storeBlip, 1.0)
    SetBlipColour(storeBlip, storeData["blip"]["color"])
    SetBlipAsShortRange(storeBlip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(storeData["name"])
    EndTextCommandSetBlipName(storeBlip)
end

SellFish = function()
    TaskTurnPedToFaceEntity(cachedData["storeOwner"], cachedData["ped"], 1000)
    TaskTurnPedToFaceEntity(cachedData["ped"], cachedData["storeOwner"], 1000)

    TriggerServerEvent("james_fishing:sellFish")
end

HasItems = function(itemsToCheck)
    local playerInventory = ESX.GetPlayerData()["inventory"]

    local itemsValidated = 0

    for itemIndex, itemData in ipairs(playerInventory) do
        for itemCheckIndex, itemCheckName in ipairs(itemsToCheck) do
            if itemData["name"] == itemCheckName then
                if itemData["count"] > 0 then
                    itemsValidated = itemsValidated + 1

                    break
                end
            end
        end
    end

    return itemsValidated >= #itemsToCheck
end

DrawScriptMarker = function(markerData)
    DrawMarker(markerData["type"] or 1, markerData["pos"] or vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, (markerData["type"] == 6 and -90.0 or markerData["rotate"] and -180.0) or 0.0, 0.0, 0.0, markerData["size"] or vector3(1.0, 1.0, 1.0), markerData["color"] or vector3(150, 150, 150), 100, false, true, 2, false, false, false, false)
end

PlayAnimation = function(ped, dict, anim, settings)
	if dict then
        Citizen.CreateThread(function()
            RequestAnimDict(dict)

            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end

            if settings == nil then
                TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
            else 
                local speed = 1.0
                local speedMultiplier = -1.0
                local duration = 1.0
                local flag = 0
                local playbackRate = 0

                if settings["speed"] then
                    speed = settings["speed"]
                end

                if settings["speedMultiplier"] then
                    speedMultiplier = settings["speedMultiplier"]
                end

                if settings["duration"] then
                    duration = settings["duration"]
                end

                if settings["flag"] then
                    flag = settings["flag"]
                end

                if settings["playbackRate"] then
                    playbackRate = settings["playbackRate"]
                end

                TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
            end
      
            RemoveAnimDict(dict)
		end)
	else
		TaskStartScenarioInPlace(ped, anim, 0, true)
	end
end

FadeOut = function(duration)
    DoScreenFadeOut(duration)
    
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end
end

FadeIn = function(duration)
    DoScreenFadeIn(500)

    while not IsScreenFadedIn() do
        Citizen.Wait(0)
    end
end

WaitForModel = function(model)
    if not IsModelValid(model) then
        return
    end

	if not HasModelLoaded(model) then
		RequestModel(model)
	end
	
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end
end

DrawBusySpinner = function(text)
    SetLoadingPromptTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    ShowLoadingPrompt(3)
    TriggerEvent("IsFishing", 1)
end

GetWeaponLabel = function(weaponModel)
    local playerInventory = ESX.PlayerData["inventory"]

    if not playerInventory then playerInventory = ESX.GetPlayerData()["inventory"] end

    for itemIndex, itemData in ipairs(playerInventory) do
        if string.lower(itemData["name"]) == string.lower(weaponModel) then
            return itemData["label"]
        end
    end

    return weaponModel
end