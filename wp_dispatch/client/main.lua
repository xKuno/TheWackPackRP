local currentPlate = ""
local currentType = 0

local job = ""
local grade = 0

local unitCooldown = false
local alertsToggled = true
local unitBlipsToggled = true
local callBlipsToggled = true

local callBlips = {}
local blips = {}

WeaponNames = {
	[tostring(GetHashKey('WEAPON_UNARMED'))] = 'Unarmed',
	[tostring(GetHashKey('GADGET_PARACHUTE'))] = 'Parachute',
	[tostring(GetHashKey('WEAPON_KNIFE'))] = 'Knife',
	[tostring(GetHashKey('WEAPON_NIGHTSTICK'))] = 'Nightstick',
	[tostring(GetHashKey('WEAPON_HAMMER'))] = 'Hammer',
	[tostring(GetHashKey('WEAPON_BAT'))] = 'Baseball Bat',
	[tostring(GetHashKey('WEAPON_CROWBAR'))] = 'Crowbar',
	[tostring(GetHashKey('WEAPON_GOLFCLUB'))] = 'Golf Club',
	[tostring(GetHashKey('WEAPON_BOTTLE'))] = 'Bottle',
	[tostring(GetHashKey('WEAPON_DAGGER'))] = 'Antique Cavalry Dagger',
	[tostring(GetHashKey('WEAPON_HATCHET'))] = 'Hatchet',
	[tostring(GetHashKey('WEAPON_KNUCKLE'))] = 'Knuckle Duster',
	[tostring(GetHashKey('WEAPON_MACHETE'))] = 'Machete',
	[tostring(GetHashKey('WEAPON_FLASHLIGHT'))] = 'Flashlight',
	[tostring(GetHashKey('WEAPON_SWITCHBLADE'))] = 'Switchblade',
	[tostring(GetHashKey('WEAPON_BATTLEAXE'))] = 'Battleaxe',
	[tostring(GetHashKey('WEAPON_POOLCUE'))] = 'Poolcue',
	[tostring(GetHashKey('WEAPON_PIPEWRENCH'))] = 'Wrench',
	[tostring(GetHashKey('WEAPON_STONE_HATCHET'))] = 'Stone Hatchet',

	[tostring(GetHashKey('WEAPON_PISTOL'))] = 'Pistol',
	[tostring(GetHashKey('WEAPON_PISTOL_MK2'))] = 'Pistol Mk2',
	[tostring(GetHashKey('WEAPON_COMBATPISTOL'))] = 'Combat Pistol',
	[tostring(GetHashKey('WEAPON_PISTOL50'))] = 'Pistol .50	',
	[tostring(GetHashKey('WEAPON_SNSPISTOL'))] = 'SNS Pistol',
	[tostring(GetHashKey('WEAPON_SNSPISTOL_MK2'))] = 'SNS Pistol Mk2',
	[tostring(GetHashKey('WEAPON_HEAVYPISTOL'))] = 'Heavy Pistol',
	[tostring(GetHashKey('WEAPON_VINTAGEPISTOL'))] = 'Vintage Pistol',
	[tostring(GetHashKey('WEAPON_MARKSMANPISTOL'))] = 'Marksman Pistol',
	[tostring(GetHashKey('WEAPON_REVOLVER'))] = 'Heavy Revolver',
	[tostring(GetHashKey('WEAPON_REVOLVER_MK2'))] = 'Heavy Revolver Mk2',
	[tostring(GetHashKey('WEAPON_DOUBLEACTION'))] = 'Double-Action Revolver',
	[tostring(GetHashKey('WEAPON_APPISTOL'))] = 'AP Pistol',
	[tostring(GetHashKey('WEAPON_STUNGUN'))] = 'Stun Gun',
	[tostring(GetHashKey('WEAPON_FLAREGUN'))] = 'Flare Gun',
	[tostring(GetHashKey('WEAPON_RAYPISTOL'))] = 'Up-n-Atomizer',

	[tostring(GetHashKey('WEAPON_MICROSMG'))] = 'Micro SMG',
	[tostring(GetHashKey('WEAPON_MACHINEPISTOL'))] = 'Machine Pistol',
	[tostring(GetHashKey('WEAPON_MINISMG'))] = 'Mini SMG',
	[tostring(GetHashKey('WEAPON_SMG'))] = 'SMG',
	[tostring(GetHashKey('WEAPON_SMG_MK2'))] = 'SMG Mk2	',
	[tostring(GetHashKey('WEAPON_ASSAULTSMG'))] = 'Assault SMG',
	[tostring(GetHashKey('WEAPON_COMBATPDW'))] = 'Combat PDW',
	[tostring(GetHashKey('WEAPON_MG'))] = 'MG',
	[tostring(GetHashKey('WEAPON_COMBATMG'))] = 'Combat MG	',
	[tostring(GetHashKey('WEAPON_COMBATMG_MK2'))] = 'Combat MG Mk2',
	[tostring(GetHashKey('WEAPON_GUSENBERG'))] = 'Gusenberg Sweeper',
	[tostring(GetHashKey('WEAPON_RAYCARBINE'))] = 'Unholy Deathbringer',

	[tostring(GetHashKey('WEAPON_ASSAULTRIFLE'))] = 'Assault Rifle',
	[tostring(GetHashKey('WEAPON_ASSAULTRIFLE_MK2'))] = 'Assault Rifle Mk2',
	[tostring(GetHashKey('WEAPON_CARBINERIFLE'))] = 'Carbine Rifle',
	[tostring(GetHashKey('WEAPON_CARBINERIFLE_MK2'))] = 'Carbine Rifle Mk2',
	[tostring(GetHashKey('WEAPON_ADVANCEDRIFLE'))] = 'Advanced Rifle',
	[tostring(GetHashKey('WEAPON_SPECIALCARBINE'))] = 'Special Carbine',
	[tostring(GetHashKey('WEAPON_SPECIALCARBINE_MK2'))] = 'Special Carbine Mk2',
	[tostring(GetHashKey('WEAPON_BULLPUPRIFLE'))] = 'Bullpup Rifle',
	[tostring(GetHashKey('WEAPON_BULLPUPRIFLE_MK2'))] = 'Bullpup Rifle Mk2',
	[tostring(GetHashKey('WEAPON_COMPACTRIFLE'))] = 'Compact Rifle',

	[tostring(GetHashKey('WEAPON_SNIPERRIFLE'))] = 'Sniper Rifle',
	[tostring(GetHashKey('WEAPON_HEAVYSNIPER'))] = 'Heavy Sniper',
	[tostring(GetHashKey('WEAPON_HEAVYSNIPER_MK2'))] = 'Heavy Sniper Mk2',
	[tostring(GetHashKey('WEAPON_MARKSMANRIFLE'))] = 'Marksman Rifle',
	[tostring(GetHashKey('WEAPON_MARKSMANRIFLE_MK2'))] = 'Marksman Rifle Mk2',

	[tostring(GetHashKey('WEAPON_GRENADE'))] = 'Grenade',
	[tostring(GetHashKey('WEAPON_STICKYBOMB'))] = 'Sticky Bomb',
	[tostring(GetHashKey('WEAPON_PROXMINE'))] = 'Proximity Mine',
	[tostring(GetHashKey('WAPAON_PIPEBOMB'))] = 'Pipe Bomb',
	[tostring(GetHashKey('WEAPON_SMOKEGRENADE'))] = 'Tear Gas',
	[tostring(GetHashKey('WEAPON_BZGAS'))] = 'BZ Gas',
	[tostring(GetHashKey('WEAPON_MOLOTOV'))] = 'Molotov',
	[tostring(GetHashKey('WEAPON_FIREEXTINGUISHER'))] = 'Fire Extinguisher',
	[tostring(GetHashKey('WEAPON_PETROLCAN'))] = 'Jerry Can',
	[tostring(GetHashKey('WEAPON_BALL'))] = 'Ball',
	[tostring(GetHashKey('WEAPON_SNOWBALL'))] = 'Snowball',
	[tostring(GetHashKey('WEAPON_FLARE'))] = 'Flare',

	[tostring(GetHashKey('WEAPON_GRENADELAUNCHER'))] = 'Grenade Launcher',
	[tostring(GetHashKey('WEAPON_RPG'))] = 'RPG',
	[tostring(GetHashKey('WEAPON_MINIGUN'))] = 'Minigun',
	[tostring(GetHashKey('WEAPON_FIREWORK'))] = 'Firework Launcher',
	[tostring(GetHashKey('WEAPON_RAILGUN'))] = 'Railgun',
	[tostring(GetHashKey('WEAPON_HOMINGLAUNCHER'))] = 'Homing Launcher',
	[tostring(GetHashKey('WEAPON_COMPACTLAUNCHER'))] = 'Compact Grenade Launcher',
	[tostring(GetHashKey('WEAPON_RAYMINIGUN'))] = 'Widowmaker',

	[tostring(GetHashKey('WEAPON_PUMPSHOTGUN'))] = 'Pump Shotgun',
	[tostring(GetHashKey('WEAPON_PUMPSHOTGUN_MK2'))] = 'Pump Shotgun Mk2',
	[tostring(GetHashKey('WEAPON_SAWNOFFSHOTGUN'))] = 'Sawed-off Shotgun',
	[tostring(GetHashKey('WEAPON_BULLPUPSHOTGUN'))] = 'Bullpup Shotgun',
	[tostring(GetHashKey('WEAPON_ASSAULTSHOTGUN'))] = 'Assault Shotgun',
	[tostring(GetHashKey('WEAPON_MUSKET'))] = 'Musket',
	[tostring(GetHashKey('WEAPON_HEAVYSHOTGUN'))] = 'Heavy Shotgun',
	[tostring(GetHashKey('WEAPON_DBSHOTGUN'))] = 'Double Barrel Shotgun',
	[tostring(GetHashKey('WEAPON_SWEEPERSHOTGUN'))] = 'Sweeper Shotgun',

	[tostring(GetHashKey('WEAPON_REMOTESNIPER'))] = 'Remote Sniper',
	[tostring(GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE'))] = 'Smoke Grenade Launcher',
	[tostring(GetHashKey('WEAPON_PASSENGER_ROCKET'))] = 'Passenger Rocket',
	[tostring(GetHashKey('WEAPON_AIRSTRIKE_ROCKET'))] = 'Airstrike Rocket',
	[tostring(GetHashKey('WEAPON_STINGER'))] = 'Stinger [Vehicle]',
	[tostring(GetHashKey('OBJECT'))] = 'Object',
	[tostring(GetHashKey('VEHICLE_WEAPON_TANK'))] = 'Tank Cannon',
	[tostring(GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET'))] = 'Rockets',
	[tostring(GetHashKey('VEHICLE_WEAPON_PLAYER_LASER'))] = 'Laser',
	[tostring(GetHashKey('AMMO_RPG'))] = 'Rocket',
	[tostring(GetHashKey('AMMO_TANK'))] = 'Tank',
	[tostring(GetHashKey('AMMO_SPACE_ROCKET'))] = 'Rocket',
	[tostring(GetHashKey('AMMO_PLAYER_LASER'))] = 'Laser',
	[tostring(GetHashKey('AMMO_ENEMY_LASER'))] = 'Laser',
	[tostring(GetHashKey('WEAPON_RAMMED_BY_CAR'))] = 'Rammed by Car',
	[tostring(GetHashKey('WEAPON_FIRE'))] = 'Fire',
	[tostring(GetHashKey('WEAPON_HELI_CRASH'))] = 'Heli Crash',
	[tostring(GetHashKey('WEAPON_RUN_OVER_BY_CAR'))] = 'Run over by Car',
	[tostring(GetHashKey('WEAPON_HIT_BY_WATER_CANNON'))] = 'Hit by Water Cannon',
	[tostring(GetHashKey('WEAPON_EXHAUSTION'))] = 'Exhaustion',
	[tostring(GetHashKey('WEAPON_EXPLOSION'))] = 'Explosion',
	[tostring(GetHashKey('WEAPON_ELECTRIC_FENCE'))] = 'Electric Fence',
	[tostring(GetHashKey('WEAPON_BLEEDING'))] = 'Bleeding',
	[tostring(GetHashKey('WEAPON_DROWNING_IN_VEHICLE'))] = 'Drowning in Vehicle',
	[tostring(GetHashKey('WEAPON_DROWNING'))] = 'Drowning',
	[tostring(GetHashKey('WEAPON_BARBED_WIRE'))] = 'Barbed Wire',
	[tostring(GetHashKey('WEAPON_VEHICLE_ROCKET'))] = 'Vehicle Rocket',
	[tostring(GetHashKey('VEHICLE_WEAPON_ROTORS'))] = 'Rotors',
	[tostring(GetHashKey('WEAPON_AIR_DEFENCE_GUN'))] = 'Air Defence Gun',
	[tostring(GetHashKey('WEAPON_ANIMAL'))] = 'Animal',
	[tostring(GetHashKey('WEAPON_COUGAR'))] = 'Cougar'
}

Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(0)
        end

        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end

        job = ESX.GetPlayerData().job.name
        grade = ESX.GetPlayerData().job.grade

        Citizen.Wait(5000)

        local jobInfo = {}
        jobInfo[Config.JobOne.job] = {
            color = Config.JobOne.color,
            column = 1,
            label = Config.JobOne.label,
            forwardCall = Config.JobOne.forwardCall,
            canRemoveCall = Config.JobOne.canRemoveCall
        }
        jobInfo[Config.JobTwo.job] = {
            color = Config.JobTwo.color,
            column = 2,
            label = Config.JobTwo.label,
            forwardCall = Config.JobTwo.forwardCall,
            canRemoveCall = Config.JobTwo.canRemoveCall
        }
        jobInfo[Config.JobThree.job] = {
            color = Config.JobThree.color,
            column = 3,
            label = Config.JobThree.label,
            forwardCall = Config.JobThree.forwardCall,
            canRemoveCall = Config.JobThree.canRemoveCall
        }
        jobInfo[Config.JobFour.job] = {
            color = Config.JobFour.color,
            column = 3,
            label = Config.JobFour.label,
            forwardCall = Config.JobFour.forwardCall,
            canRemoveCall = Config.JobFour.canRemoveCall
        }
        jobInfo[Config.JobFive.job] = {
            color = Config.JobFive.color,
            column = 3,
            label = Config.JobFive.label,
            forwardCall = Config.JobFive.forwardCall,
            canRemoveCall = Config.JobFive.canRemoveCall
        }
        jobInfo[Config.JobSix.job] = {
            color = Config.JobSix.color,
            column = 1,
            label = Config.JobSix.label,
            forwardCall = Config.JobSix.forwardCall,
            canRemoveCall = Config.JobSix.canRemoveCall
        }

        ESX.TriggerServerCallback(
            "wp_dispatch:getPersonalInfo",
            function(firstname, lastname)
                SendNUIMessage(
                    {
                        type = "Init",
                        firstname = firstname,
                        lastname = lastname,
                        jobInfo = jobInfo
                    }
                )
            end
        )
    end
)

RegisterNetEvent("esx:setJob")
AddEventHandler(
    "esx:setJob",
    function(j)
        job = j.name
        grade = j.grade
    end
)

RegisterKeyMapping(Config.OpenMenuCommand, "Open Dispach " .. Config.OpenMenuKey, "keyboard", Config.OpenMenuKey)

RegisterCommand(
    Config.OpenMenuCommand,
    function()
        openDispach()
    end,
    false
)

RegisterNetEvent("dispatchmenu:f1menu")
AddEventHandler("dispatchmenu:f1menu", function()
    openDispach()
end)

RegisterCommand(
    Config.CallSignChangeCommand,
    function(source, args, rawCommand)
       
        if (Config.JobOne.job == job or Config.JobTwo.job == job or Config.JobThree.job == job or Config.JobFour.job == job or Config.JobFive.job == job or Config.JobSix.job == job) then
            if string.len(args[1]) <= 4 then
                TriggerServerEvent('wp_dispatch:changeCallSign', args[1])
                SendTextMessage(Config.Text['callsign_changed'])
            else
                SendTextMessage(Config.Text['callsign_char_long'])
            end
        else
            SendTextMessage(Config.Text['no_permission'])
        end

    end,
    false
)

function addBlipForCall(sprite, color, coords, text)
    local alpha = 250
    local radius = AddBlipForRadius(coords, 40.0)
    local blip = AddBlipForCoord(coords)

    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.3)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, false)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(tostring(text))
    EndTextCommandSetBlipName(blip)

    SetBlipHighDetail(radius, true)
    SetBlipColour(radius, color)
    SetBlipAlpha(radius, alpha)
    SetBlipAsShortRange(radius, true)

    table.insert(callBlips, blip)
    table.insert(callBlips, radius)

    while alpha ~= 0 do
        Citizen.Wait(Config.CallBlipDisappearInterval)
        alpha = alpha - 1
        SetBlipAlpha(radius, alpha)

        if alpha == 0 then
            RemoveBlip(radius)
            RemoveBlip(blip)
         
            return
        end
    end
end

function addBlipsForUnits()
    ESX.TriggerServerCallback(
        "wp_dispatch:getUnits",
        function(units)
            local id = GetPlayerServerId(PlayerId())

            for _, z in pairs(blips) do
                RemoveBlip(z)
            end

            blips = {}

            for k, v in pairs(units) do
                if
                    k ~= id and
                        (Config.JobOne.job == v.job or Config.JobTwo.job == v.job or Config.JobThree.job == v.job or Config.JobFour.job == v.job or Config.JobFive.job == v.job or Config.JobSix.job == v.job)
                 then
                    local color = 0
                    local title = ""
                    if Config.JobOne.job == v.job then
                        color = Config.JobOne.blipColor
                        title = Config.JobOne.label
                    end
                    if Config.JobTwo.job == v.job then
                        color = Config.JobTwo.blipColor
                        title = Config.JobTwo.label
                    end
                    if Config.JobThree.job == v.job then
                        color = Config.JobThree.blipColor
                        title = Config.JobThree.label
                    end
                    if Config.JobFour.job == v.job then
                        color = Config.JobFour.blipColor
                        title = Config.JobFour.label
                    end
                    if Config.JobFive.job == v.job then
                        color = Config.JobFive.blipColor
                        title = Config.JobFive.label
                    end

                    local new_blip = AddBlipForEntity(NetworkGetEntityFromNetworkId(v.netId))

                    SetBlipSprite(new_blip, Config.Sprite[v.type])
                    ShowHeadingIndicatorOnBlip(new_blip, true)
                    HideNumberOnBlip(new_blip)
                    SetBlipScale(new_blip, 0.7)
                    SetBlipCategory(new_blip, 7)
                    SetBlipColour(new_blip, color)
                    SetBlipAsShortRange(new_blip, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("(" .. title .. ") " .. v.firstname .. " " .. v.lastname)
                    EndTextCommandSetBlipName(new_blip)

                    blips[k] = new_blip
                end
            end
        end
    )
end

function openDispach()

    if Config.JobOne.job == job or Config.JobTwo.job == job or Config.JobThree.job == job or Config.JobFour.job == job or Config.JobFive.job == job or Config.JobSix.job == job then
        SetNuiFocus(false, false)
        ESX.TriggerServerCallback(
            "wp_dispatch:getInfo",
            function(units, calls, ustatus, callsigns)
                SetNuiFocus(true, true)

                SendNUIMessage(
                    {
                        type = "open",
                        units = units,
                        calls = calls,
                        ustatus = ustatus,
                        job = job,
                        callsigns = callsigns,
                        id = GetPlayerServerId(PlayerId())
                    }
                )
            end
        )
    end
end

RegisterNetEvent("wp_dispatch:callAdded")
AddEventHandler(
    "wp_dispatch:callAdded",
    function(id, call, j, cooldown, sprite, color)
        if job == j and alertsToggled then
            SendNUIMessage(
                {
                    type = "call",
                    id = id,
                    call = call,
                    cooldown = cooldown
                }
            )

            if Config.AddCallBlips then
                addBlipForCall(sprite, color, vector3(call.coords[1], call.coords[2], call.coords[3]), id)
            end
        end
    end
)

RegisterNUICallback(
    "dismissCall",
    function(data)
        local id = data["id"]:gsub("call_", "")

        TriggerServerEvent("wp_dispatch:unitDismissed", id)
        DeleteWaypoint()
    end
)

RegisterNUICallback(
    "updatestatus",
    function(data)
        local id = data["id"]
        local status = data["status"]

        TriggerServerEvent("wp_dispatch:changeStatus", id, status)
    end
)

RegisterNUICallback(
    "sendnotice",
    function(data)
        local caller = data["caller"]
    end
)

RegisterNUICallback(
    "reqbackup",
    function(data)
        local j = data["job"]
        local req = data["requester"]
        local firstname = data["firstname"]
        local lastname = data["lastname"]
        SendTextMessage(Config.Text["backup_requested"])
        local cord = GetEntityCoords(PlayerPedId())
        TriggerServerEvent(
            "wp_dispatch:addCall",
            "10-13",
            req .. " is requesting help",
            {{icon = "fa-user-friends", info = firstname .. " " .. lastname}},
            {cord[1], cord[2], cord[3]},
            j
        )
    end
)

RegisterNUICallback(
    "toggleoffduty",
    function(data)
        ToggleDuty()
    end
)

RegisterNUICallback(
    "togglecallblips",
    function(data)
        callBlipsToggled = not callBlipsToggled

        if callBlipsToggled then
            for _, z in pairs(callBlips) do
                SetBlipDisplay(z, 4)
            end
            SendTextMessage(Config.Text["call_blips_turned_on"])
        else
            for _, z in pairs(callBlips) do
                SetBlipDisplay(z, 0)
            end

            SendTextMessage(Config.Text["call_blips_turned_off"])
        end
    end
)

RegisterNUICallback(
    "toggleunitblips",
    function(data)
        unitBlipsToggled = not unitBlipsToggled

        if unitBlipsToggled then
            addBlipsForUnits()
            SendTextMessage(Config.Text["unit_blips_turned_on"])
        else
            for _, z in pairs(blips) do
                RemoveBlip(z)
            end

            blips = {}
            SendTextMessage(Config.Text["unit_blips_turned_off"])
        end
    end
)

RegisterNUICallback(
    "togglealerts",
    function(data)
        alertsToggled = not alertsToggled

        if alertsToggled then
            SendTextMessage(Config.Text["alerts_turned_on"])
        else
            SendTextMessage(Config.Text["alerts_turned_off"])
        end
    end
)

RegisterNUICallback(
    "copynumber",
    function(data)
        SendTextMessage(Config.Text["phone_number_copied"])
    end
)

RegisterNUICallback(
    "forwardCall",
    function(data)
        local id = data["id"]:gsub("call_", "")

        SendTextMessage(Config.Text["call_forwarded"])
        TriggerServerEvent("wp_dispatch:forwardCall", id, data["job"])
    end
)

RegisterNUICallback(
    "acceptCall",
    function(data)
        local id = data["id"]:gsub("call_", "")

        SetNewWaypoint(tonumber(data["x"]), tonumber(data["y"]))

        TriggerServerEvent("wp_dispatch:unitResponding", id, job)
    end
)

RegisterNUICallback(
    "removeCall",
    function(data)
        local id = data["id"]:gsub("call_", "")
        SendTextMessage(Config.Text["call_removed"])
        TriggerServerEvent("wp_dispatch:removeCall", id)
    end
)

RegisterNUICallback(
    "close",
    function(data)
        SetNuiFocus(false, false)
    end
)

--Shots Fired
Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if IsPedShooting(playerPed) and not IsPedInAnyVehicle(playerPed) and not IsPedCurrentWeaponSilenced(playerPed) then
			local police = false
			local playerPos = GetEntityCoords(playerPed)
			local streetName,_ = GetStreetNameAtCoord(playerPos[1], playerPos[2], playerPos[3])
			local streetName = GetStreetNameFromHashKey(streetName)
			local gender = "unknown"
			local model = GetEntityModel(playerPed)
			if (model == GetHashKey("mp_f_freemode_01")) then
				gender = "female"
			end
			if (model == GetHashKey("mp_m_freemode_01")) then
				gender = "male"
			end
			PlayerData = ESX.GetPlayerData()
            
            if PlayerData.job.name == "police" then
                police = true
            end

			if not police then
			exports['wp_dispatch']:addCall("10-32", "Shots Fired In Progress", {
				{icon="fas fa-road", info = streetName},
				{icon="fa-venus-mars", info=gender},
				{icon="fas fa-comment-dots", info=WeaponNames[tostring(GetSelectedPedWeapon(playerPed))]}
				}, {playerPos[1], playerPos[2], playerPos[3]}, "police", 3000, 119, 1 )
			exports['wp_dispatch']:addCall("10-32", "Shots Fired In Progress", {
				{icon="fas fa-road", info = streetName},
				{icon="fa-venus-mars", info=gender},
				{icon="fas fa-comment-dots", info=WeaponNames[tostring(GetSelectedPedWeapon(playerPed))]}
				}, {playerPos[1], playerPos[2], playerPos[3]}, "dispatch", 3000, 119, 1 )
			Citizen.Wait(5000)
		end
	end
end

end)

--Shots Fired In Vehicle
Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if IsPedShooting(playerPed) and IsPedInAnyVehicle(playerPed) and not IsPedCurrentWeaponSilenced(playerPed) then
			local police = false
			local playerPos = GetEntityCoords(playerPed)
			local streetName,_ = GetStreetNameAtCoord(playerPos[1], playerPos[2], playerPos[3])
			local streetName = GetStreetNameFromHashKey(streetName)
			local gender = "unknown"
			local model = GetEntityModel(playerPed)
			local vehicle = GetVehiclePedIsIn(playerPed, true)
			local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
			local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
			local model = GetEntityModel(playerPed)
			if (model == GetHashKey("mp_f_freemode_01")) then
				gender = "female"
			end
			if (model == GetHashKey("mp_m_freemode_01")) then
				gender = "male"
			end
			PlayerData = ESX.GetPlayerData()
            
            if PlayerData.job.name == "police" then
                police = true
            end
				
			if not police then
			exports['wp_dispatch']:addCall("10-32", "Vehicle Shots Fired In Progress", {
				{icon="fas fa-road", info = streetName},
				{icon="fa-venus-mars", info=gender},
				{icon = "fa-car", info = vehicleLabel},
				{icon = "fa-car", info = plate}
				}, {playerPos[1], playerPos[2], playerPos[3]}, "police", 3000, 229, 1 )
			exports['wp_dispatch']:addCall("10-32", "Vehicle Shots Fired In Progress", {
				{icon="fas fa-road", info = streetName},
				{icon="fa-venus-mars", info=gender},
				{icon = "fa-car", info = vehicleLabel},
				{icon = "fa-car", info = plate}
				}, {playerPos[1], playerPos[2], playerPos[3]}, "dispatch", 3000, 229, 1 )
			Citizen.Wait(5000)
		end
	end
end

end)

--Brandishing
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(10)

--             local police = false
--             local ped = PlayerPedId()
--             local weapon = GetCurrentPedWeapon(ped, 0xA2719263) --Fists
--             PlayerData = ESX.GetPlayerData()

--             if PlayerData.job.name == "police" then
--                 police = true
--             end

--             if not police and weapon and math.random(1, 6) == 1 then
--                     local playerPos = GetEntityCoords(ped)
--                     local isInVehicle = IsPedInAnyVehicle(ped, true)
--                     local streetName,_ = GetStreetNameAtCoord(playerPos[1], playerPos[2], playerPos[3])
--                     local streetName = GetStreetNameFromHashKey(streetName)
--                     local gender = "unknown"
--                     local model = GetEntityModel(ped)
--                     if (model == GetHashKey("mp_f_freemode_01")) then
--                         gender = "female"
--                     end
--                     if (model == GetHashKey("mp_m_freemode_01")) then
--                         gender = "male"
--                     end

--                     exports['wp_dispatch']:addCall("10-32", "Person Brandishing A Firearm", {
--                         {icon="fas fa-road", info = streetName},
--                         {icon="fa-venus-mars", info=gender}
--                         }, {playerPos[1], playerPos[2], playerPos[3]}, "police", 3000, 110, 1 )
--                     exports['wp_dispatch']:addCall("10-32", "Person Brandishing A Firearm", {
--                         {icon="fas fa-road", info = streetName},
--                         {icon="fa-venus-mars", info=gender}
--                         }, {playerPos[1], playerPos[2], playerPos[3]}, "dispatch", 3000, 110, 1 )
--                     Citizen.Wait(30000)
--             else
--                 Citizen.Wait(2000)
--             end
--         end
--     end
-- )

--Carjacking
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)

        local playerPed = PlayerPedId()

        if (IsPedTryingToEnterALockedVehicle(playerPed) or IsPedJacking(playerPed)) then

        local cord = GetEntityCoords(PlayerPedId())
        local streetName, _ = GetStreetNameAtCoord(cord[1], cord[2], cord[3])
        local streetName = GetStreetNameFromHashKey(streetName)
        local gender = "unknown"
        local model = GetEntityModel(playerPed)
        if (model == GetHashKey("mp_f_freemode_01")) then
            gender = "female"
        end
        if (model == GetHashKey("mp_m_freemode_01")) then
            gender = "male"
        end

            Citizen.Wait(3000)
            local vehicle = GetVehiclePedIsIn(playerPed, true)

            if vehicle then
                local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))

                local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))

                if vehicleLabel == 'STOCKADE' then
                    exports['wp_dispatch']:addCall("10-90", "Truck Robbery In Progress", {
                        {icon = "fas fa-road", info = streetName},
                        {icon="fa-venus-mars", info=gender},
                        {icon = "fa-car", info = vehicleLabel},
                        {icon = "fa-car", info = plate}
                    }, {cord[1], cord[2], cord[3]}, "police", 3000, 67, 2 )
                    exports['wp_dispatch']:addCall("10-90", "Truck Robbery In Progress", {
                        {icon = "fas fa-road", info = streetName},
                        {icon="fa-venus-mars", info=gender},
                        {icon = "fa-car", info = vehicleLabel},
                        {icon = "fa-car", info = plate}
                    }, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 67, 2 )
                else
                    exports['wp_dispatch']:addCall("10-31", "Carjacking In Progress", {
                        {icon = "fas fa-road", info = streetName},
                        {icon="fa-venus-mars", info=gender},
                        {icon = "fa-car", info = vehicleLabel},
                        {icon = "fa-car", info = plate}
                    }, {cord[1], cord[2], cord[3]}, "police", 3000, 58, 1)
                    exports['wp_dispatch']:addCall("10-31", "Carjacking In Progress", {
                        {icon = "fas fa-road", info = streetName},
                        {icon="fa-venus-mars", info=gender},
                        {icon = "fa-car", info = vehicleLabel},
                        {icon = "fa-car", info = plate}
                    }, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 58, 1)
                end
            end
        end
    end
end)

-- --Reckless Driving
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(10)

--         local playerPed = PlayerPedId()
--         local vehicle = GetVehiclePedIsIn(playerPed, true)
--         local police = false
--         PlayerData = ESX.GetPlayerData()

--         if PlayerData.job.name == "police" then
--             police = true
--         end

--         if not police and GetEntitySpeed(vehicle) * 2.236936 >= 110 and not IsPedInAnyBoat(playerPed) and not IsPedInAnyHeli(playerPed) and not IsPedInAnyPlane(playerPed) then
--                 local cord = GetEntityCoords(PlayerPedId())
--                 local streetName, _ = GetStreetNameAtCoord(cord[1], cord[2], cord[3])
--                 local streetName = GetStreetNameFromHashKey(streetName)
--                 local speed = string.format("%.1f", GetEntitySpeed(vehicle) * 2.236936)
--                 local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))

--                 local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
--                 vehicleLabel = GetLabelText(vehicleLabel)

--                 exports['wp_dispatch']:addCall("10-31", "Speeding Vehicle Spotted", {
--                     {icon = "fas fa-road", info = streetName},
--                     {icon="fa-ruler", info=speed},
--                     {icon = "fa-car", info = vehicleLabel},
--                     {icon = "fa-car", info = plate}
--                 }, {cord[1], cord[2], cord[3]}, "police", 3000, 227, 1)
--                 exports['wp_dispatch']:addCall("10-31", "Speeding Vehicle Spotted", {
--                     {icon = "fas fa-road", info = streetName},
--                     {icon="fa-ruler", info=speed},
--                     {icon = "fa-car", info = vehicleLabel},
--                     {icon = "fa-car", info = plate}
--                 }, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 227, 1)
--             Citizen.Wait(20000)
--         end
--     end
-- end)

-- --Reckless Flying
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(10)

--         local playerPed = PlayerPedId()
--         local heli = IsPedInAnyHeli(playerPed)
--         local plane = IsPedInAnyPlane(playerPed)
--         local police = false
--         PlayerData = ESX.GetPlayerData()

--         if PlayerData.job.name == "police" then
--             police = true
--         end

--         if not police and (GetEntityHeightAboveGround(playerPed) * 3.28084) < 250 and heli or (GetEntityHeightAboveGround(playerPed) * 3.28084) < 250 and plane then
--                 local cord = GetEntityCoords(PlayerPedId())
--                 local streetName, _ = GetStreetNameAtCoord(cord[1], cord[2], cord[3])
--                 local streetName = GetStreetNameFromHashKey(streetName)
--                 local vehicle = GetVehiclePedIsIn(playerPed, true)
--                 local altitude = string.format("%.1f", GetEntityHeightAboveGround(playerPed) * 3.28084)
--                 local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))

--                 local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
--                 vehicleLabel = GetLabelText(vehicleLabel)

--                 exports['wp_dispatch']:addCall("10-31", "Low Flying Aerial Vehicle", {
--                     {icon = "fas fa-road", info = streetName},
--                     {icon="fa-ruler", info=altitude},
--                     {icon = "fa-car", info = vehicleLabel},
--                     {icon = "fa-car", info = plate}
--                 }, {cord[1], cord[2], cord[3]}, "police", 3000, 64, 1)
--                 exports['wp_dispatch']:addCall("10-31", "Low Flying Aerial Vehicle", {
--                     {icon = "fas fa-road", info = streetName},
--                     {icon="fa-ruler", info=altitude},
--                     {icon = "fa-car", info = vehicleLabel},
--                     {icon = "fa-car", info = plate}
--                 }, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 64, 1)
--             Citizen.Wait(20000)
--         end
--     end
-- end)

--Panic A
RegisterNetEvent('wp_dispatch:panica')
AddEventHandler('wp_dispatch:panica', function()
    local cord = GetEntityCoords(PlayerPedId())
    local streetName, _ = GetStreetNameAtCoord(cord[1], cord[2], cord[3])
    local streetName = GetStreetNameFromHashKey(streetName)
    local zone = tostring(GetNameOfZone(cord[1], cord[2], cord[3]))
    local area = GetLabelText(zone)

    exports['wp_dispatch']:addCall("10-13", "Panic Button", {
        {icon = "fas fa-road", info = streetName ..", ".. area}
    }, {cord[1], cord[2], cord[3]}, "police", 3000, 126, 1)
    exports['wp_dispatch']:addCall("10-13", "Panic Button", {
        {icon = "fas fa-road", info = streetName ..", ".. area}
    }, {cord[1], cord[2], cord[3]}, "ambulance", 3000, 126, 1)
    exports['wp_dispatch']:addCall("10-13", "Panic Button", {
        {icon = "fas fa-road", info = streetName ..", ".. area}
    }, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 126, 1)

    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5.0, 'panic', 0.3)
end)

--Panic B
RegisterNetEvent('wp_dispatch:panicb')
AddEventHandler('wp_dispatch:panicb', function()
    local cord = GetEntityCoords(PlayerPedId())
    local streetName, _ = GetStreetNameAtCoord(cord[1], cord[2], cord[3])
    local streetName = GetStreetNameFromHashKey(streetName)
    local zone = tostring(GetNameOfZone(cord[1], cord[2], cord[3]))
    local area = GetLabelText(zone)

    exports['wp_dispatch']:addCall("10-14", "Non-Emergency Panic Button", {
        {icon = "fas fa-road", info = streetName ..", ".. area}
    }, {cord[1], cord[2], cord[3]}, "police", 3000, 280, 5)
    exports['wp_dispatch']:addCall("10-14", "Non-Emergency Panic Button", {
        {icon = "fas fa-road", info = streetName ..", ".. area}
    }, {cord[1], cord[2], cord[3]}, "ambulance", 3000, 280, 5)
    exports['wp_dispatch']:addCall("10-14", "Non-Emergency Panic Button", {
        {icon = "fas fa-road", info = streetName ..", ".. area}
    }, {cord[1], cord[2], cord[3]}, "dispatch", 3000, 280, 5)

    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5.0, 'panic', 0.3)
end)

Citizen.CreateThread(
    function()
        while Config.EnableMapBlipsForUnits do
            if Config.JobOne.job == job or Config.JobTwo.job == job or Config.JobThree.job == job or Config.JobFour.job == job or Config.JobFive.job == job then
                if unitBlipsToggled then
                    addBlipsForUnits()
                end
            end

            Citizen.Wait(5000)
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            status = {
                carPlate = currentPlate,
                type = currentType,
                job = job,
                netId = NetworkGetNetworkIdFromEntity(PlayerPedId())
            }

            TriggerServerEvent("wp_dispatch:playerStatus", status)

            Citizen.Wait(5000)
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped, false)

            if vehicle ~= nil then
                local plate = GetVehicleNumberPlateText(vehicle)
                if plate ~= nil then
                    currentPlate = plate
                    currentType = GetVehicleClass(vehicle)
                else
                    currentPlate = ""
                end
            end

            Citizen.Wait(5000)
        end
    end
)

RegisterNetEvent('wp_dispatch:removeBlips')
AddEventHandler('wp_dispatch:removeBlips', function()
    for _, z in pairs(blips) do
        RemoveBlip(z)
    end
end)

RegisterNetEvent('wp_dispatch:removeCallBlips')
AddEventHandler('wp_dispatch:removeCallBlips', function()
    for _, z in pairs(callBlips) do
        RemoveBlip(z)
    end
end)

--EXPORTS

exports(
    "addCall",
    function(code, title, extraInfo, coords, job, cooldown, sprite, color)
        TriggerServerEvent("wp_dispatch:addCall", code, title, extraInfo, coords, job, cooldown or 5000, sprite or 11, color or 5)
    end
)

exports(
    "addMessage",
    function(message, coords, job, cooldown, sprite, color)
        TriggerServerEvent("wp_dispatch:addMessage", message, coords, job, cooldown or 5000, sprite or 11, color or 5)
    end
)