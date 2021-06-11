ESX = nil
PlayerData = nil
IsDead = nil
IsBusy = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do Citizen.Wait(10) end

    PlayerData = ESX.GetPlayerData()

end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job) PlayerData.job = job end)
AddEventHandler('playerSpawned', function(spawn) IsDead = nil end)
AddEventHandler('esx:onPlayerDeath', function(data) IsDead = true end)

Bracelets = {}

RegisterNetEvent('Cyber:JobNotAuthorized')
AddEventHandler('Cyber:JobNotAuthorized', function()
    ESX.ShowNotification('~r~ You Cannot Use This Item. You are not Authorized')
end)

RegisterNetEvent('Cyber:BraceletAdded')
AddEventHandler('Cyber:BraceletAdded', function()

    TriggerEvent('skinchanger:getSkin', function(skin)
        local targetuni

        if skin.sex == 0 then
            targetuni = {chain_1 = 11, chain_2 = 0}
        else
            targetuni = {chain_1 = 8, chain_2 = 0}
        end

        if targetuni then
            TriggerEvent('skinchanger:loadClothes', skin, targetuni)
        else
            ESX.ShowNotification(
                'You Need to be MP_Freemode in order to get ankle bracelet installed on you')
        end
    end)
    ESX.ShowNotification('~r~ Someone Installed A ~y~Tracking Bracelet~r~ On You!!')

end)
RegisterNetEvent('Cyber:BraceletRemoved')
AddEventHandler('Cyber:BraceletRemoved', function()

    TriggerEvent('skinchanger:getSkin', function(skin)
        local targetuni

        if skin.sex == 0 then
            targetuni = {chain_1 = 0, chain_2 = 0}
        else
            targetuni = {chain_1 = 0, chain_2 = 0}
        end

        if targetuni then
            TriggerEvent('skinchanger:loadClothes', skin, targetuni)
        else
            ESX.ShowNotification('You Need to be MP_Freemode in order to get ankle bracelet removed from you')
        end
    end)
    ESX.ShowNotification('~g~ Someone Removed ~y~Tracking Bracelet of you!!')

end)

RegisterNetEvent('Cyber:AddBraceletTrackerForPlayer')
AddEventHandler('Cyber:AddBraceletTrackerForPlayer', function(target, boundary, labell, isjobshare)
    local blip = AddBlipForEntity(GetPlayerPed(GetPlayerFromServerId(target)))
    SetBlipSprite(blip, Config.TargetBlipInformations.Sprite)
    SetBlipDisplay(blip, Config.TargetBlipInformations.Display)
    SetBlipColour(blip, Config.TargetBlipInformations.Color)
    SetBlipScale(blip, Config.TargetBlipInformations.Scale)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(labell)
    EndTextCommandSetBlipName(blip)
    Bracelets[target] = {
        blip = blip,
        boundary = boundary,
        startpoint = GetEntityCoords(PlayerPedId()),
        label = labell,
        breakboundary = false
    }
    PlaySoundFrontend(-1, "DELETE", "HUD_DEATHMATCH_SOUNDSET", 1)
    if isjobshare then
        ESX.ShowNotification('~g~One of Your Colleges Added A Tracker For You. Check Your Map, Label : ~y~' ..labell)
    else
        ESX.ShowNotification('Tracker Activated Succesfuly Check Your Map, Label :  ~y~' .. labell)
    end
end)

RegisterNetEvent('Cyber:OnTrackerUsage')
AddEventHandler('Cyber:OnTrackerUsage', function()
    if not IsBusy and not IsDead then
        local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer == -1 or closestPlayerDistance > 3.0 then
            ESX.ShowNotification('There\'s No Player Near You')
            return
        end
        ESX.TriggerServerCallback('CyberCheckForBraceletStatus', function(status)
            if not status then
                local jobshare = false
                if Config.AuthorizedJobShare[PlayerData.job.name] then
                    local goforrjobshare =
                        GetUserInput(
                            'Do You Want to Share This Tracker with Your Job? yes-no',
                            30)
                    if goforrjobshare == 'yes' or goforrjobshare == 'no' then
                        if goforrjobshare == 'yes' then
                            jobshare = PlayerData.job.name
                        else
                            jobshare = false
                        end
                    else
                        return ESX.ShowNotification(
                                   'Please Enter a Valid Response. yes / no')
                    end
                end
                local label = GetUserInput('Enter a Label', 15)
                if label and label ~= '' then
                    local boundary = GetUserInput('Enter boundary 0-' ..tostring(Config.Maximumboundary), 15)
                    if not boundary or not tonumber(boundary) then
                        return ESX.ShowNotification('Please Enter a valid boundary')
                    end
                    if tonumber(boundary) >= Config.Maximumboundary then
                        return ESX.ShowNotification('Please Enter a Lower Number as boundary. Maximum : ' ..tostring(Config.Maximumboundary))
                    end

                    -- Progress Bar
                    IsBusy = true
                    TriggerEvent("mythic_progbar:client:progress", {
                        name = "Installing",
                        duration = Config.InstallTimes.Tracker * 1000,
                        label = "Installing The Tracker",
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true
                        },
                        animation = {
                            animDict = Config.Animations.TrackerSetupAnimation.animDict,
                            anim = Config.Animations.TrackerSetupAnimation.anim
                        },
                        prop = {model = nil}
                    }, function(status)
                        IsBusy = nil
                        if not status then

                            local closestPlayertwo, closestPlayerDistancetwo =
                            ESX.Game.GetClosestPlayer()
                        if closestPlayertwo ~= closestPlayer or
                            closestPlayerDistancetwo > 3.0 then
                            ESX.ShowNotification('Player Got Far Away From You')
                            return
                        end
                        TriggerServerEvent('Cyber:TrackedUsedOnPlayer', GetPlayerServerId(closestPlayer), boundary, label, jobshare)
                                       
                        end
                    end)
   

                else
                    return ESX.ShowNotification('Please Enter a Valid Label')
                end

            else
                return ESX.ShowNotification('Target Has a Tracking Bracelet Already.')
            end
        end, GetPlayerServerId(closestPlayer))
    end
end)

RegisterNetEvent('Cyber:OnBoltCutterUsage')
AddEventHandler('Cyber:OnBoltCutterUsage', function()
    if not IsBusy and not IsDead then
        local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer == -1 or closestPlayerDistance > 3.0 then
            ESX.ShowNotification('There\'s No Player Near You')
            return
        end
        ESX.TriggerServerCallback('CyberCheckForBraceletStatus', function(status)
            if status then

                -- Progress Bar
                IsBusy = true
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "Removing",
                    duration = Config.InstallTimes.BoltCutter * 1000,
                    label = "Removing The Tracker",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true
                    },
                    animation = {
                        animDict = Config.Animations.BoltCuttingAnimation.animDict,
                        anim = Config.Animations.BoltCuttingAnimation.anim
                    },
                    prop = {model = nil}
                }, function(status)
                    IsBusy = nil
                    if not status then
                        local closestPlayertwo, closestPlayerDistancetwo =
                            ESX.Game.GetClosestPlayer()
                        if closestPlayertwo ~= closestPlayer or
                            closestPlayerDistancetwo > 3.0 then
                            ESX.ShowNotification('Player Got Far Away From You')
                            return
                        end
                        TriggerServerEvent('Cyber:BoltCutterUsedOnPlayer', GetPlayerServerId(closestPlayer))
                        ESX.ShowNotification('~g~ Succesfully Removed The Tracker.')
                    end
                end)

            else
                return ESX.ShowNotification('Target Does Not Have Tracking Bracelet.')
            end
        end, GetPlayerServerId(closestPlayer))
    end
end)

RegisterNetEvent('Cyber:BoltCutterUsedForPlayer')
AddEventHandler('Cyber:BoltCutterUsedForPlayer', function(trgt)
   local target = trgt
    if Bracelets[target] then
        RemoveBlip(Bracelets[target].blip)
        Bracelets[target] = nil
        PlaySoundFrontend(-1, "DELETE", "HUD_DEATHMATCH_SOUNDSET", 1)

        local playerPed = PlayerPedId(target)
        local cord = GetEntityCoords(playerPed)
        local streetName,_ = GetStreetNameAtCoord(cord[1], cord[2], cord[3])
        local streetName = GetStreetNameFromHashKey(streetName)

        exports['wp_dispatch']:addCall("10-98", "Ankle Tracker Has Been Disabled", {
            {icon="fas fa-road", info = streetName}
        }, {cord[1], cord[2], cord[3]}, "police", 3000, 106, 1 )
        exports['wp_dispatch']:addCall("10-98", "Ankle Tracker Has Been Disabled", {
            {icon="fas fa-road", info = streetName}
        }, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 106, 1 )
    end
end)

RegisterNetEvent('Cyber:PlayerLeftTheServer')
AddEventHandler('Cyber:PlayerLeftTheServer', function(target)
    if Bracelets[target] then
        if Config.InformIfTargetLeavedServer then
            ESX.ShowNotification('Player with Ankle Tracking Bracelet Left The Server. Target Label : ' ..Bracelets[target].label)
        end
        RemoveBlip(Bracelets[target].blip)
        Bracelets[target] = nil
        PlaySoundFrontend(-1, "DELETE", "HUD_DEATHMATCH_SOUNDSET", 1)
    end
end)

GetUserInput = function(forwhat, maxchar)
    local textresult = nil

    AddTextEntry('FMMC_KEY_TIP1', forwhat)
    DisplayOnscreenKeyboard(1, 'FMMC_KEY_TIP1', "", '', "", "", "", maxchar)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        textresult = GetOnscreenKeyboardResult()
    end
    return textresult
end

Citizen.CreateThread(function()
    while true do
        if GetTableCount(Bracelets) > 0 then

            Wait(500)
            for i, v in pairs(Bracelets) do
                if not v.breakboundary then
                    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(i)))
                    local distance = GetDistanceBetweenCoords(coords, v.startpoint)
                    if distance > tonumber(v.boundary) then
                        PlaySoundFrontend(-1, "DELETE", "HUD_DEATHMATCH_SOUNDSET", 1)
                        Bracelets[i].breakboundary = true

                        local playerPed = GetPlayerPed(GetPlayerFromServerId(i))
                        local cord = GetEntityCoords(playerPed)
                        local streetName,_ = GetStreetNameAtCoord(coords[1], coords[2], coords[3])
                        local streetName = GetStreetNameFromHashKey(streetName)
                
                        exports['wp_dispatch']:addCall("10-98", "Breach Of House Arrest", {
                            {icon="fas fa-road", info = streetName}
                        }, {coords[1], coords[2], coords[3]}, "police", 3000, 106, 1 )
                        exports['wp_dispatch']:addCall("10-98", "Breach Of House Arrest", {
                            {icon="fas fa-road", info = streetName}
                        }, {coords[1], coords[2], coords[3]}, "dispatch", 3000, 106, 1 )
                    end
                end
            end
        else
            Wait(3000)
        end
    end
end)

GetTableCount = function(tbl)
    local count = 0
    for i, v in pairs(tbl) do if v ~= nil then count = count + 1 end end
    return count
end

RegisterNetEvent('Cyber:LabelIsAlreadyBeingUsed')
AddEventHandler('Cyber:LabelIsAlreadyBeingUsed', function(isjobshare, name)
    local msg
    if isjobshare then
        msg = '~y~' .. name ..'~r~ With Same Job With You Tried to add Tracking Ankle Bracelet for you but you Already had same label'
    else
        msg ='~r~You have same label for another person. Please use another label'
    end
    ESX.ShowNotification(msg)
end)
