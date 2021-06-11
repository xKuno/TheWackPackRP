local isDead = false
local hasOxygenTankOn = false
local hasParachute = false
local hasNos = false

local current_job = nil


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    current_job = job
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    current_job = xPlayer.job
end)

rootMenuConfig =  {
    {
        id = "general",
        displayName = "General",
        icon = "#globe-europe",
        enableMenu = function()
            if not isDead then
                return true
            end
        end,
        subMenus = {"general:handsup", "general:emotes", "general:flipvehicle", "loaf_keysystem:F1Menu", "carkeys:F1Menu", "general:skelly"}
    },
    {
        id = "cuffactions",
        displayName = "Cuff Actions",
        icon = "#cuffs",
        enableMenu = function()
            local ped = PlayerPedId()
            PlayerData = ESX.GetPlayerData()
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if PlayerData.job.name ~= "police" and closestPlayer ~= -1 and closestDistance <= 3 and not IsPedInAnyVehicle(PlayerPedId(), false) and not isDead then
                return true
            end
        end,
        subMenus = {"cuffs:cuff2", "cuffs:hardcuff2", "cuffs:uncuff2", "general:escort", "police:putinvehicle", "police:unseatnearest"},
    },
    {
        id = "id",
        displayName = "IDs",
        icon = "#general-giveidcard",
        enableMenu = function()
            if not isDead then
                return true
            end
        end,
        subMenus = {"general:giveid", "general:viewid", "general:giveinsurance", "general:viewinsurance", "general:fakegiveid", "general:fakeviewid" }
    },
    {
        id = "vehicle",
        displayName = "Vehicle",
        icon = "#vehicle-options-vehicle",
        functionName = "OpenUI:CarControl:F1",
        enableMenu = function()
            local ped = PlayerPedId()
            PlayerData = ESX.GetPlayerData()
            if IsPedInAnyVehicle(PlayerPedId(), false) and not isDead then
            return true
        end
    end,
    },
    {
        id = "police-action",
        displayName = "Police",
        icon = "#police-action",
        enableMenu = function()
           local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
            if PlayerData.job.name == "police" and not IsPedInAnyVehicle(PlayerPedId(), false) and not isDead then
                return true
            end
        end,
        subMenus = {"cuffs:cuff", "cuffs:hardcuff", "cuffs:uncuff", "general:escort", "police:putinvehicle", "police:unseatnearest", "cuffs:checkinventory", "police:revive", "mdt:open", "police:dispatchmenu", "police:getid", "police:fingerprint", "police:platecheck", "police:removemask", "police:lockpick", "police:gsrtestf1", "police:baccheck", "police:checkother"},
    },
    {
        id = "police-vehicle-action",
        displayName = "Police",
        icon = "#police-action",
        enableMenu = function()
           local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
            if PlayerData.job.name == "police" and IsPedInAnyVehicle(PlayerPedId(), false) and not isDead then
                return true
            end
        end,
        subMenus = {"mdt:open", "police:dispatchmenu", "police:radar", "dot:impound", "police:platecheck"},
    },
    {
        id = "cid",
        displayName = "C.I.D",
        icon = "#police-action-dna-swab",
        functionName = "wp_evidence:processVan",
        enableMenu = function()
           local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
           if PlayerData.job.name == "police" and PlayerData.job.grade == 1 and (GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(ped, false))) == 'SPEEDO') and not isDead then
            return true
        end
    end,
    },
    {
        id = "k9",
        displayName = "K9",
        icon = "#k9",
        enableMenu = function()
            local ped = PlayerPedId()
            PlayerData = ESX.GetPlayerData()
            if PlayerData.job.name == "police" and not IsPedInAnyVehicle(PlayerPedId(), false) and not isDead then
                 return true
             end
         end,
        subMenus = {"k9:spawn", "k9:huntfind", "k9:sit", "k9:sniff"}
    },
    {
        id = "ranger",
        displayName = "Ranger Licenses",
        icon = "#judge-actions",
        enableMenu = function()
           local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
           if PlayerData.job.name == "police" and PlayerData.job.grade == 3 and not IsPedInAnyVehicle(PlayerPedId(), false) and not isDead then
                return true
            end
        end,
        subMenus = {"judge:grantFish", "judge:grantHunt"}
    },
    {
        id = "offpolicemdt",
        displayName = "MDT",
        icon = "#mdt",
        functionName = "rmenu:mdt:hotKeyOpen",
        enableMenu = function()
           local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
           if PlayerData.job.name == "offpolice" and not isDead then
            return true
        end
    end,
    },
    {
        id = "dispatch-action",
        displayName = "Dispatch",
        icon = "#police-action",
        enableMenu = function()
           local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
            if PlayerData.job.name == "dispatch" and not isDead then
                return true
            end
        end,
        subMenus = {"dismdt:open", "police:dispatchmenu"},
    },
    {
        id = "medic",
        displayName = "Medical",
        icon = "#medic",
        enableMenu = function()
           local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
            if PlayerData.job.name == "ambulance" and not IsPedInAnyVehicle(PlayerPedId(), false) and not isDead then
                return true
            end
        end,
        subMenus = {"emsmdt:open", "police:dispatchmenu", "police:revive", "police:lockpick", "medic:heal", "medic:treat", "medic:viewother", "medic:removclothes"}
    },
    {
        id = "medic-injury-checks",
        displayName = "Injury Checks",
        icon = "#medic-check",
        enableMenu = function()
           local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
           local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if PlayerData.job.name == "ambulance" and closestPlayer ~= -1 and closestDistance <= 3 and not IsPedInAnyVehicle(PlayerPedId(), false) and not isDead then
                return true
            end
        end,
        subMenus = {"medic:rollGSW", "medic:rollStab", "medic:rollTaser", "medic:rollFall", "medic:rollCarCrash"}
    },
    {
        id = "medic-vehicle",
        displayName = "Medical",
        icon = "#medic",
        enableMenu = function()
           local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
            if PlayerData.job.name == "ambulance" and IsPedInAnyVehicle(PlayerPedId(), false) and not isDead then
                return true
            end
        end,
        subMenus = {"emsmdt:open", "police:dispatchmenu"}
    },
    {
        id = "panic-buttons",
        displayName = "Panic Button",
        icon = "#police-dead",
        enableMenu = function()
           local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
            if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "judge" or PlayerData.job.name == "district" or PlayerData.job.name == "mayor" then
                return true
            end
        end,
        subMenus = {"panic:a", "panic:b"},
    },
    {
        id = "radio-quick",
        displayName = "Radio",
        icon = "#police-radio",
        enableMenu = function()
           local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
            if PlayerData.job.name == "police" and not isDead or PlayerData.job.name == "ambulance" and not isDead then
                return true
            end
        end,
        subMenus = {"radio:1", "radio:2", "radio:3", "radio:4", "radio:6"},
    },
    {
        id = "judge",
        displayName = "Government",
        icon = "#judge-actions",
        enableMenu = function()
           local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
            if PlayerData.job.name == "judge" or PlayerData.job.name == "mayor" and not isDead then
                return true
            end
        end,
        subMenus = {"dojmdt:open", "police:dispatchmenu", "judge:grantWeapon", "judge:grantPilot", "judge:grantBar", "judge:grantBeer", "judge:grantPI", "judge:grantSec"}
    },
    {
        id = "districta",
        displayName = "District Attorney",
        icon = "#judge-actions",
        enableMenu = function()
           local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
            if PlayerData.job.name == "district" and not isDead then
                return true
            end
        end,
        subMenus = {"dojmdt:open", "police:dispatchmenu"}
    },
    {
        id = "news",
        displayName = "News",
        icon = "#news",
        enableMenu = function()
           local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
            if PlayerData.job.name == "reporter" and not isDead then
                return true
            end
        end,
        subMenus = {"news:setCamera", "news:setMicrophone", "news:setBoom", "radio:1", "radio:4"}
    },
    {
        id = "dot",
        displayName = "Mechanic",
        icon = "#impound-vehicle",
        enableMenu = function()
           local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
            if PlayerData.job.name == "mecano" and not isDead then
                return true
            end
        end,
        subMenus = {"police:lockpick", "dot:clean", "dot:repair", "dot:impound", "dot:tow", "radio:6"}
    },
    {
        id = "cardealer",
        displayName = "Cardealer",
        icon = "#impound-vehicle",
        enableMenu = function()
           local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
            if PlayerData.job.name == "cardealer" and not isDead then
                return true
            end
        end,
        subMenus = {"dot:clean"}
    },
    {
        id = "taxi",
        displayName = "Taxi Meter",
        icon = "#taxi",
        functionName = "taxi:toggleDisplay",
        enableMenu = function()
           local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
           if PlayerData.job.name == "taxi" and IsPedInAnyVehicle(PlayerPedId(), false) and not isDead then
                return true
            end
        end,
    },
    {
        id = "realtor",
        displayName = "Realtor",
        icon = "#judge-licenses-grant-house",
        functionName = "realtor:f1:menu",
        enableMenu = function()
           local ped = PlayerPedId()
           PlayerData = ESX.GetPlayerData()
           if PlayerData.job.name == "rea" and not isDead then
                return true
            end
        end,
    },
    {
        id = "animations",
        displayName = "Walk Styles",
        icon = "#walking",
        enableMenu = function()
            return not isDead
        end,
        subMenus = { "animations:default", "animations:injured", "animations:business", "animations:quick", "animations:brave", "animations:tipsy", "animations:tough", "animations:sassy", "animations:sad", "animations:posh", "animations:alien", "animations:hobo", "animations:money", "animations:swagger", "animations:shady", "animations:hurry", "animations:maneater", "animations:nonchalant", "animations:chichi", }
    },
    {
        id = "expressions",
        displayName = "Expressions",
        icon = "#expressions",
        enableMenu = function()
            return not isDead
        end,
        subMenus = { "expressions:normal", "expressions:drunk", "expressions:angry", "expressions:dumb", "expressions:electrocuted", "expressions:grumpy", "expressions:happy", "expressions:injured", "expressions:joyful", "expressions:mouthbreather", "expressions:oneeye", "expressions:shocked", "expressions:sleeping", "expressions:smug", "expressions:speculative", "expressions:stressed", "expressions:sulking", "expressions:weird", "expressions:weird2"}
    },
    {
        id = "shoes",
        displayName = "Steal Shoes",
        icon = "#general-shoes",
        functionName = "shoes:steal",
        enableMenu = function()
            local ped = PlayerPedId()
            PlayerData = ESX.GetPlayerData()
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer ~= -1 and closestDistance <= 3 then
                local searchPlayerPed = PlayerPedId(closestPlayer)
                if IsEntityPlayingAnim(searchPlayerPed, 'missminuteman_1ig_2', 'handsup_base', 3) or IsEntityPlayingAnim(searchPlayerPed, 'dead', 'dead_a', 3) or IsEntityPlayingAnim(searchPlayerPed, 'mp_arresting', 'idle', 3) or IsEntityDead(searchPlayerPed) or GetEntityHealth(searchPlayerPed) <= 0 then
                    return true
                end
            end
        end,
    },
    {
        id = "oxygentank",
        displayName = "Remove Scuba Gear",
        icon = "#oxygen-mask",
        functionName = "qb-diving:client:UseGear",
        enableMenu = function()
            if hasOxygenTankOn and not isDead then
            return true
        end
    end
    },
    {
        id = "parachute",
        displayName = "Remove Parachute",
        icon = "#parachute",
        functionName = "wp_items:addParachute",
        enableMenu = function()
            if hasParachute and not isDead then
            return true
        end
    end
    },
    {
        id = "nos",
        displayName = "Remove Nos",
        icon = "#nos",
        functionName = "wp_items:addNos",
        enableMenu = function()
            if hasNos and not isDead then
            return true
        end
    end
    },

}

newSubMenus = {
    ['general:handsup'] = {
        title = "Hands Up",
        icon = "#general-handsups",
        functionName = "handsup:f1"
    },
    ['general:emotes'] = {
        title = "Emotes",
        icon = "#general-emotes",
        functionName = "rmenu:open_emote_menu"
    },
    ['general:skelly'] = {
        title = "View Your Injuries",
        icon = "#medic",
        functionName = "skeletalsystem:openownmenuf1"
    },
    ['general:giveid'] = {
        title = "Give ID",
        icon = "#general-giveidcard",
        functionName = "rmenu:jsfour-idcard:give"
    },
    ['general:viewid'] = {
        title = "View ID",
        icon = "#general-viewidcard",
        functionName = "rmenu:jsfour-idcard:open"
    },
    ['general:fakegiveid'] = {
        title = "Give Fake ID",
        icon = "#general-giveidcard",
        functionName = "fakeid:give"
    },
    ['general:fakeviewid'] = {
        title = "View Fake ID",
        icon = "#general-viewidcard",
        functionName = "rmenu:fakeid:open"
    },
    ['general:giveinsurance'] = {
        title = "Give Insurance",
        icon = "#vehicle-options",
        functionName = "t1ger_carinsurance:insuranceF1"
    },
    ['general:viewinsurance'] = {
        title = "View Insurance",
        icon = "#vehicle-options",
        functionName = "t1ger_carinsurance:insuranceViewF1"
    },
    ['general:flipvehicle'] = {
        title = "Flip Vehicle",
        icon = "#general-flip-vehicle",
        functionName = "FlipVehicle"
    },
    ['panic:a'] = {
        title = "10-13",
        icon = "#police-dead",
        functionName = "wp_dispatch:panica"
    },
    ['panic:b'] = {
        title = "10-14",
        icon = "#police-dead",
        functionName = "wp_dispatch:panicb"
    },
    ['mdt:open'] = {
        title = "MDT",
        icon = "#mdt",
        functionName = "rmenu:mdt:hotKeyOpen"
    },
    ['dojmdt:open'] = {
        title = "MDT",
        icon = "#mdt",
        functionName = "rmenu:doj:hotKeyOpen"
    },
    ['emsmdt:open'] = {
        title = "EMS MDT",
        icon = "#mdt",
        functionName = "rmenu:ems:hotKeyOpen"
    },
    ['dismdt:open'] = {
        title = "Dispatch MDT",
        icon = "#mdt",
        functionName = "rmenu:dispatch:hotKeyOpen"
    },
    ['dot:impound'] = {
        title = "Impound",
        icon = "#police-vehicle",
        functionName = "loaf_garage:impound:f1"
    },
    ['dot:clean'] = {
        title = "Clean",
        icon = "#car",
        functionName = "dot:clean"
    },
    ['dot:repair'] = {
        title = "Repair",
        icon = "#general-check-vehicle",
        functionName = "dot:repair"
    },
    ['dot:tow'] = {
        title = "Tow",
        icon = "#truck",
        functionName = "esx_mecanojob:towclient"
    },
    ['general:escort'] = {
        title = "Escort",
        icon = "#general-escort",
        functionName = "esx_policejob:escortclient"
    },
    ['general:putinvehicle'] = {
        title = "Seat Vehicle",
        icon = "#general-put-in-veh",
        functionName = "esx_policejob:putInVehicle"
    },
    ['general:unseatnearest'] = {
        title = "Unseat Nearest",
        icon = "#general-unseat-nearest",
        functionName = "unseatPlayer"
    },
    ['judge:grantBar'] = {
        title = "Grant Bar Certification",
        icon = "#judge-licenses-grant-house",
        functionName = "judge:givebarlicense"
    },
    ['judge:grantBeer'] = {
        title = "Grant Liquor License",
        icon = "#judge-licenses-grant-bar",
        functionName = "judge:givebeerlicense"
    },
    ['judge:grantFish'] = {
        title = "Grant Fishing License",
        icon = "#judge-licenses-grant-business",
        functionName = "judge:givefishlicense"
    },
    ['judge:grantWeapon'] = {
        title = "Grant Weapon License",
        icon = "#judge-licenses-grant-weapon",
        functionName = "judge:givegunlicense"
    },
    ['judge:grantHunt'] = {
        title = "Grant Hunting License",
        icon = "#judge-licenses-grant-da",
        functionName = "judge:givehuntlicense"
    },
    ['judge:grantPI'] = {
        title = "Grant PI License",
        icon = "#judge-licenses-grant-drivers",
        functionName = "judge:givepilicense"
    },
    ['judge:grantSec'] = {
        title = "Grant Security License",
        icon = "#animation-tough",
        functionName = "judge:givesecuritylicense"
    },
    ['judge:grantPilot'] = {
        title = "Grant Pilot License",
        icon = "#heli",
        functionName = "judge:givepilotlicense"
    },
    ['k9:spawn'] = {
        title = "Summon/Dismiss",
        icon = "#k9-spawn",
        functionName = "K9:Create"
    },
    ['k9:sit'] = {
        title = "Sit/Stand",
        icon = "#k9-sit",
        functionName = "K9:Sit"
    },
    ['k9:sniff'] = {
        title = "Sniff Person",
        icon = "#k9-sniff",
        functionName = "K9:Sniff"
    },
    ['k9:huntfind'] = {
        title = "Attack Nearest",
        icon = "#k9-huntfind",
        functionName = "K9:Attack"
    },
    ['cuffs:cuff2'] = {
        title = "Soft Cuff",
        icon = "#cuffs-cuff",
        functionName = "esx_policejob:requestarrestclient2"
    },
    ['cuffs:hardcuff2'] = {
        title = "Hard Cuff",
        icon = "#cuffs-cuff",
        functionName = "esx_policejob:requesthardclient2"
    },
    ['cuffs:uncuff2'] = {
        title = "Uncuff",
        icon = "#cuffs-uncuff",
        functionName = "esx_policejob:uncuffclient2"
    },
    ['cuffs:cuff'] = {
        title = "Soft Cuff",
        icon = "#cuffs-cuff",
        functionName = "esx_policejob:requestarrestclient"
    },
    ['cuffs:hardcuff'] = {
        title = "Hard Cuff",
        icon = "#cuffs-cuff",
        functionName = "esx_policejob:requesthardclient"
    },
    ['cuffs:uncuff'] = {
        title = "Uncuff",
        icon = "#cuffs-uncuff",
        functionName = "esx_policejob:uncuffclient"
    },
    ['cuffs:checkinventory'] = {
        title = "Search Person",
        icon = "#police-action-frisk",
        functionName = "robo:copsearch"
    },
    ['loaf_keysystem:F1Menu'] = {
        title = "House Keys",
        icon = "#general-door-open",
        functionName = "loaf_keysystem:F1Menu"
    },
    ['carkeys:F1Menu'] = {
        title = "Car Keys",
        icon = "#vehicle-options",
        functionName = "RufiCarkey:OpenMenu"
    },
    ['police:gsrtestf1'] = {
        title = "GSR Test",
        icon = "#police-action-gsr",
        functionName = "police:gsrtestf1"
    },
    ['police:checkother'] = {
        title = "Check Injuries",
        icon = "#police-action-dna-swab",
        functionName = "Reload_Death:policeCheckOther"
    },
    ['police:dispatchmenu'] = {
        title = "Dispatch Menu",
        icon = "#expressions-speculative",
        functionName = "dispatchmenu:f1menu"
    },
    ['police:revive'] = {
        title = "Revive",
        icon = "#medic-revive",
        functionName = "esx_policejob:coprevive"
    },
    ['medic:removclothes'] = {
        title = "Remove Clothing",
        icon = "#cuffs-remove-mask",
        functionName = "ems:removeClothes"
    },
    ['medic:rollGSW'] = {
        title = "Check GSW Injury",
        icon = "#medic-aid",
        functionName = "medic:rollInjury",
        functionParameters = 'gsw'
    },
    ['medic:rollStab'] = {
        title = "Check Stab Injury",
        icon = "#medic-aid",
        functionName = "medic:rollInjury",
        functionParameters = 'stab'
    },
    ['medic:rollTaser'] = {
        title = "Check Taser Injury",
        icon = "#medic-aid",
        functionName = "medic:rollInjury",
        functionParameters = 'taser'
    },
    ['medic:rollFall'] = {
        title = "Check Falling Injury",
        icon = "#medic-aid",
        functionName = "medic:rollInjury",
        functionParameters = 'fall'
    },
    ['medic:rollCarCrash'] = {
        title = "Check Car Crash Injury",
        icon = "#medic-aid",
        functionName = "medic:rollInjury",
        functionParameters = 'carCrash'
    },
    ['medic:heal'] = {
        title = "Heal",
        icon = "#medic-heal",
        functionName = "healf1"
    },
    ['medic:treat'] = {
        title = "Treat",
        icon = "#doctor",
        functionName = "skeletalsystem:treatotherf1"
    },
    ['medic:viewother'] = {
        title = "Inspect Injuries",
        icon = "#police-action-dna-swab",
        functionName = "skeletalsystem:openothermenuf1"
    },
    ['police:getid'] = {
        title = "Get ID",
        icon = "#police-vehicle-plate",
        functionName = "rmenu:jsfour-idcard:take"
    },
    ['police:fingerprint'] = {
        title = "Fingerprint",
        icon = "#police-action-fingerprint",
        functionName = "rmenu:fingerprintsearch"
    },
    ['police:platecheck'] = {
        title = "Plate Check",
        icon = "#vehicle-options",
        functionName = "rmenu:nearbyPlateCheck"
    },
    ['police:radar'] = {
        title = "Radar",
        icon = "#police-vehicle-radar",
        functionName = "wk:openRemote"
    },
    ['police:lockpick'] = {
        title = "Lockpick",
        icon = "#general-tools",
        functionName = "esx_policejob:lockpick"
    },
    ['police:removemask'] = {
        title = "Remove Face Covering",
        icon = "#cuffs-remove-mask",
        functionName = "police:removeMask"
    },
    ['police:unseatnearest'] = {
        title = "Unseat Nearest",
        icon = "#general-unseat-nearest",
        functionName = "esx_policejob:outvehicleclient"
    },
    ['police:putinvehicle'] = {
        title = "Seat Vehicle",
        icon = "#general-put-in-veh",
        functionName = "esx_policejob:putinvehicleclient"
    },
    ['police:baccheck'] = {
        title = "Check BAC",
        icon = "#expressions-drunk",
        functionName = "esx_policejob:bac"
    },
    ['radio:1'] = {
        title = "Radio 1",
        icon = "#police-vehicle-radar",
        functionName = "radio:F1",
        functionParameters = 1,
    },
    ['radio:2'] = {
        title = "Radio 2",
        icon = "#police-vehicle-radar",
        functionName = "radio:F1",
        functionParameters = 2,
    },
    ['radio:3'] = {
        title = "Radio 3",
        icon = "#police-vehicle-radar",
        functionName = "radio:F1",
        functionParameters = 3,
    },
    ['radio:4'] = {
        title = "Radio 4",
        icon = "#police-vehicle-radar",
        functionName = "radio:F1",
        functionParameters = 4,
    },
    ['radio:5'] = {
        title = "Radio 5",
        icon = "#police-vehicle-radar",
        functionName = "radio:F1",
        functionParameters = 5,
    },
    ['radio:6'] = {
        title = "Radio 6",
        icon = "#police-vehicle-radar",
        functionName = "radio:F1",
        functionParameters = 6,
    },
    ['radio:7'] = {
        title = "Radio 7",
        icon = "#police-vehicle-radar",
        functionName = "radio:F1",
        functionParameters = 7,
    },
    ['news:setCamera'] = {
        title = "Camera",
        icon = "#news-job-news-camera",
        functionName = "rmenu:Cam:ToggleCam"
    },
    ['news:setMicrophone'] = {
        title = "Microphone",
        icon = "#news-job-news-microphone",
        functionName = "rmenu:Mic:ToggleMic"
    },
    ['news:setBoom'] = {
        title = "Microphone Boom",
        icon = "#news-job-news-boom",
        functionName = "rmenu:Mic:ToggleBMic"
    },
    ['animations:brave'] = {
        title = "Brave",
        icon = "#animation-brave",
        functionName = "dpemotes:set_walk_style",
        functionParameters =  "Brave",
    },
    ['animations:business'] = {
        title = "Business",
        icon = "#animation-business",
        functionName = "dpemotes:set_walk_style",
        functionParameters =  "Cop",
    },
    ['animations:hurry'] = {
        title = "Hurry",
        icon = "#animation-hurry",
        functionName = "dpemotes:set_walk_style",
        functionParameters =  "Hurry",
    },
    ['animations:quick'] = {
        title = "Quick",
        icon = "#animation-hurry",
        functionName = "dpemotes:set_walk_style",
        functionParameters =  "Quick",
    },
    ['animations:tipsy'] = {
        title = "Drunk",
        icon = "#animation-tipsy",
        functionName = "dpemotes:set_walk_style",
        functionParameters =  "Drunk3",
    },
    ['animations:injured'] = {
        title = "Injured",
        icon = "#animation-injured",
        functionName = "dpemotes:set_walk_style",
        functionParameters =  "Injured",
    },
    ['animations:tough'] = {
        title = "Tough",
        icon = "#animation-tough",
        functionName = "dpemotes:set_walk_style",
        functionParameters =  "Tough",
    },
    ['animations:sassy'] = {
        title = "Sassy",
        icon = "#animation-sassy",
        functionName = "dpemotes:set_walk_style",
        functionParameters =  "Sassy",
    },
    ['animations:sad'] = {
        title = "Sad",
        icon = "#animation-sad",
        functionName = "dpemotes:set_walk_style",
        functionParameters =  "Sad",
    },
    ['animations:posh'] = {
        title = "Posh",
        icon = "#animation-posh",
        functionName = "dpemotes:set_walk_style",
        functionParameters =  "Posh",
    },
    ['animations:alien'] = {
        title = "Alien",
        icon = "#animation-alien",
        functionName = "dpemotes:set_walk_style",
        functionParameters =  "Alien",
    },
    ['animations:hobo'] = {
        title = "Hobo",
        icon = "#animation-hobo",
        functionName = "dpemotes:set_walk_style",
        functionParameters =  "Hobo",
    },
    ['animations:money'] = {
        title = "Money",
        icon = "#animation-money",
        functionName = "dpemotes:set_walk_style",
        functionParameters =  "Money",
    },
    ['animations:swagger'] = {
        title = "Swagger",
        icon = "#animation-swagger",
        functionName = "dpemotes:set_walk_style",
        functionParameters =  "Swagger",
    },
    ['animations:shady'] = {
        title = "Shady",
        icon = "#animation-shady",
        functionName = "dpemotes:set_walk_style",
        functionParameters =  "Shady",
    },
    ['animations:maneater'] = {
        title = "Man Eater",
        icon = "#animation-maneater",
        functionName = "dpemotes:set_walk_style",
        functionParameters =  "Maneater",
    },
    ['animations:default'] = {
        title = "Default",
        icon = "#animation-default",
        functionName = "dpemotes:set_walk_style",
        functionParameters = "Reset",
    },
    ['animations:nonchalant'] = {
        title = "Nonchalant",
        icon = "#animation-nonchalant",
        functionName = "dpemotes:set_walk_style",
        functionParameters = "Wide",
    },
    ['animations:chichi'] = {
        title = "ChiChi",
        icon = "#animation-chichi",
        functionName = "dpemotes:set_walk_style",
        functionParameters = "Chichi",
    },
    ["expressions:angry"] = {
        title="Angry",
        icon="#expressions-angry",
        functionName = "expressions",
        functionParameters =  { "mood_angry_1" }
    },
    ["expressions:drunk"] = {
        title="Drunk",
        icon="#expressions-drunk",
        functionName = "expressions",
        functionParameters =  { "mood_drunk_1" }
    },
    ["expressions:dumb"] = {
        title="Dumb",
        icon="#expressions-dumb",
        functionName = "expressions",
        functionParameters =  { "pose_injured_1" }
    },
    ["expressions:electrocuted"] = {
        title="Electrocuted",
        icon="#expressions-electrocuted",
        functionName = "expressions",
        functionParameters =  { "electrocuted_1" }
    },
    ["expressions:grumpy"] = {
        title="Grumpy",
        icon="#expressions-grumpy",
        functionName = "expressions", 
        functionParameters =  { "mood_drivefast_1" }
    },
    ["expressions:happy"] = {
        title="Happy",
        icon="#expressions-happy",
        functionName = "expressions",
        functionParameters =  { "mood_happy_1" }
    },
    ["expressions:injured"] = {
        title="Injured",
        icon="#expressions-injured",
        functionName = "expressions",
        functionParameters =  { "mood_injured_1" }
    },
    ["expressions:joyful"] = {
        title="Joyful",
        icon="#expressions-joyful",
        functionName = "expressions",
        functionParameters =  { "mood_dancing_low_1" }
    },
    ["expressions:mouthbreather"] = {
        title="Mouthbreather",
        icon="#expressions-mouthbreather",
        functionName = "expressions",
        functionParameters = { "smoking_hold_1" }
    },
    ["expressions:normal"]  = {
        title="Normal",
        icon="#expressions-normal",
        functionName = "expressions:clear"
    },
    ["expressions:oneeye"]  = {
        title="One Eye",
        icon="#expressions-oneeye",
        functionName = "expressions",
        functionParameters = { "pose_aiming_1" }
    },
    ["expressions:shocked"]  = {
        title="Shocked",
        icon="#expressions-shocked",
        functionName = "expressions",
        functionParameters = { "shocked_1" }
    },
    ["expressions:sleeping"]  = {
        title="Sleeping",
        icon="#expressions-sleeping",
        functionName = "expressions",
        functionParameters = { "dead_1" }
    },
    ["expressions:smug"]  = {
        title="Smug",
        icon="#expressions-smug",
        functionName = "expressions",
        functionParameters = { "mood_smug_1" }
    },
    ["expressions:speculative"]  = {
        title="Speculative",
        icon="#expressions-speculative",
        functionName = "expressions",
        functionParameters = { "mood_aiming_1" }
    },
    ["expressions:stressed"]  = {
        title="Stressed",
        icon="#expressions-stressed",
        functionName = "expressions",
        functionParameters = { "mood_stressed_1" }
    },
    ["expressions:sulking"]  = {
        title="Sulking",
        icon="#expressions-sulking",
        functionName = "expressions",
        functionParameters = { "mood_sulk_1" },
    },
    ["expressions:weird"]  = {
        title="Weird",
        icon="#expressions-weird",
        functionName = "expressions",
        functionParameters = { "effort_2" }
    },
    ["expressions:weird2"]  = {
        title="Weird 2",
        icon="#expressions-weird2",
        functionName = "expressions",
        functionParameters = { "effort_3" }
    }
}

RegisterNetEvent('menu:isDead')
AddEventHandler('menu:isDead', function()
        isDead = true
end)

RegisterNetEvent('menu:notIsDead')
AddEventHandler('menu:notIsDead', function()
        isDead = false
end)

RegisterNetEvent("menu:hasOxygenTank")
AddEventHandler("menu:hasOxygenTank", function()
    hasOxygenTankOn = true
end)

RegisterNetEvent("menu:notHasOxygenTank")
AddEventHandler("menu:notHasOxygenTank", function()
    hasOxygenTankOn = false
end)

RegisterNetEvent("menu:hasParachute")
AddEventHandler("menu:hasParachute", function()
    hasParachute = true
end)

RegisterNetEvent("menu:notHasParachute")
AddEventHandler("menu:notHasParachute", function()
    hasParachute = false
end)

RegisterNetEvent("menu:hasNos")
AddEventHandler("menu:hasNos", function()
    hasNos = true
end)

RegisterNetEvent("menu:notHasNos")
AddEventHandler("menu:notHasNos", function()
    hasNos = false
end)

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local closestPed = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        for index,value in ipairs(players) do
            local target = GetPlayerPed(value)
            if(target ~= ply) then
                local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
                local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
                if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
                    closestPlayer = value
                    closestPed = target
                    closestDistance = distance
                end
            end
        end
        return closestPlayer, closestDistance, closestPed
    end
end