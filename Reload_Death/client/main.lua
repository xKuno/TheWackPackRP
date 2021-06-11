ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(0)
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

local ped = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        ped = PlayerPedId()
    end
end)

-------------------Set Health Max-------------------

AddEventHandler("playerSpawned", function()
    if GetPedMaxHealth(ped) ~= 200 and not IsEntityDead(ped) then
        SetPedMaxHealth(ped, 200)
        SetEntityHealth(ped, 200)
    end
end)

-------------------Disable Air Control-------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local veh = GetVehiclePedIsIn(ped, false)
        if DoesEntityExist(veh) and not IsEntityDead(veh) then
            local model = GetEntityModel(veh)
            if not IsThisModelABoat(model) and not IsThisModelAHeli(model) and not IsThisModelAPlane(model) and not IsThisModelABicycle(model) and IsEntityInAir(veh) then
                -- DisableControlAction(0, 59) -- Leaning Left/Right
                DisableControlAction(0, 60) -- Leaning Up/Down
            end
        end
    end
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/rskin', 'Refresh your skin fixing any items stuck to you and returning your hat/glasses.')
    TriggerEvent('chat:addSuggestion', '/RefreshSkin', 'Refresh your skin fixing any items stuck to you and returning your hat/glasses.')
    TriggerEvent('chat:addSuggestion', '/refreshskin', 'Refresh your skin fixing any items stuck to you and returning your hat/glasses.')
end)

-------------------Skin Refresh-------------------

RegisterCommand("RefreshSkin", function(source, args, rawCommand)
    reloadSkin()
end)
  
RegisterCommand("rskin", function(source, args, rawCommand)
    reloadSkin()
end)
  
function reloadSkin()

    local armour = GetPedArmour(ped)
    local health = GetEntityHealth(ped)
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
    local model = nil
            
    if skin.sex == 0 then
        model = GetHashKey("mp_m_freemode_01")
    else
        model = GetHashKey("mp_f_freemode_01")
    end

    RequestModel(model)

    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)

    TriggerEvent('skinchanger:loadSkin', skin)
    TriggerEvent('esx:restoreLoadout')

    Citizen.Wait(1000)
    SetEntityHealth(ped, health)
    SetPedArmour(ped, armour)
    end)
end

-------------------Stagger When Shot-------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        local RNG = math.random(1,100)
            if HasEntityBeenDamagedByWeapon(ped, 3523564046, 0) or HasEntityBeenDamagedByWeapon(ped, 3219281620, 0) then
                if RNG >= 95 then
                    WoopsTripped(ped, RNG)
			end
			    ClearEntityLastDamageEntity(ped)
	        end
        end
end)

function WoopsTripped(ped, r)
    if IsEntityDead(ped) then return false end
    SetPedToRagdoll(ped, 2000, 2000, 3, 0, 0, 0)
end

-------------------Fall When Punched-------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        local RNG = math.random(1,100)
            if HasEntityBeenDamagedByWeapon(ped, 2725352035, 0) or HasEntityBeenDamagedByWeapon(ped, 1737195953, 0) or HasEntityBeenDamagedByWeapon(ped, 2508868239, 0) or HasEntityBeenDamagedByWeapon(ped, 1141786504, 0) then
                if RNG >= 90 then
                    WoopsTrippedFist(ped, RNG)
			end
			    ClearEntityLastDamageEntity(ped)
	        end
        end
end)

function WoopsTrippedFist(ped, r)
    if IsEntityDead(ped) then return false end
    SetPedToRagdoll(ped, 2000, 2000, 0, 0, 0, 0)
end

-------------------Recoil At Speed By Anthony.#8754-------------------

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        
        local veh = GetVehiclePedIsIn(ped, false)
        local speed = GetEntitySpeed(ped)

        local current_mph =math.floor(speed * 2.23694 + 0.5)
        if DoesEntityExist(veh) and IsPedShooting(ped) and not IsEntityDead(veh) then
            if current_mph >= 10 then
                ShakeGameplayCam('JOLT_SHAKE', 0.2)
            end
            if current_mph >= 40 then
                ShakeGameplayCam('JOLT_SHAKE', 0.4)
            end
            if current_mph >= 60 then
                ShakeGameplayCam('JOLT_SHAKE', 0.6)
            end
            if current_mph >= 80 then
                ShakeGameplayCam('JOLT_SHAKE', 0.8)
            end
            if current_mph >= 100 then
                ShakeGameplayCam('JOLT_SHAKE', 1.9)
            end
        end
    end
end)

-------------------Simple Stats By Vulcan#5487 & Anthony.#8754-------------------

local gsw = false
local stab = false
local marijuana = false
local dilated = false
local prongs = false
local gswcount = 0 
local gun = {
    "weapon_pistol",
    "weapon_pistol_mk2",
    "weapon_combatpistol",
    "weapon_ceramicpistol",
    "weapon_appistol",
    "weapon_pistol50",
    "weapon_snspistol",
    "weapon_heavypistol",
    "weapon_vintagepistol",
    "weapon_microsmg",
    "weapon_smg",
    "weapon_smg_mk2",
    "weapon_combatpdw",
    "weapon_machinepistol",
    "weapon_minismg",
    "weapon_pumpshotgun_mk2",
    "weapon_dbshotgun",
    "weapon_assaultrifle",
    "weapon_carbinerifle",
    "weapon_carbinerifle_mk2",
    "weapon_specialcarbine_mk2",
    "weapon_compactrifle",
    "weapon_sniperrifle",
}

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        for k, v in pairs(gun) do
            if HasEntityBeenDamagedByWeapon(ped, GetHashKey(v), 0) then
                gsw = true
                gswcount = gswcount + 1 
                ClearEntityLastDamageEntity(ped)
            end
            if HasEntityBeenDamagedByWeapon(ped, GetHashKey('WEAPON_STUNGUN'), 0) then
                prongs = true
                ClearEntityLastDamageEntity(ped)
            end
            if HasEntityBeenDamagedByWeapon(ped, 0, 1) then
                stab = true
                ClearEntityLastDamageEntity(ped)
            end
        end
    end
end)

RegisterNetEvent("Reload_Death:Checked")
AddEventHandler("Reload_Death:Checked", function(targetid)
    if gsw then
        TriggerServerEvent("Reload_Death:SetState", "gsw")
        TriggerServerEvent("Reload_Death:SetCount", gswcount)
        exports['mythic_notify']:SendAlert('inform', 'You have '..gswcount..' gunshot wounds', 5000)
    end
    if stab then
        TriggerServerEvent("Reload_Death:SetState", "stab")
        exports['mythic_notify']:SendAlert('inform', 'You have blunt/stab wounds', 5000)
    end
    if marijuana then
        TriggerServerEvent("Reload_Death:SetState", "marijuana")
        exports['mythic_notify']:SendAlert('inform', 'You smell like marijuana', 5000)
    end 
    if dilated then
        TriggerServerEvent("Reload_Death:SetState", "dilated")
        exports['mythic_notify']:SendAlert('inform', 'Your eyes are dilated', 5000)
    end 
    if prongs then
        TriggerServerEvent("Reload_Death:SetState", "prongs")
        exports['mythic_notify']:SendAlert('inform', 'You have Taser Prongs piercing your skin.', 5000)
    end
end)

AddEventHandler('skeletalsystem:openothermenuf1', function()
    local player, distance = ESX.Game.GetClosestPlayer()
    if distance ~= -1 and distance <= 3 then
        TriggerServerEvent("Reload_Death:CheckedPlayer", GetPlayerServerId(player))
    end
end)

AddEventHandler('Reload_Death:policeCheckOther', function()
    local player, distance = ESX.Game.GetClosestPlayer()
    if distance ~= -1 and distance <= 3 then
        TriggerServerEvent("Reload_Death:CheckedPlayer", GetPlayerServerId(player))
    end
end)

RegisterNetEvent('Reload_Death:ResetStatus')
AddEventHandler('Reload_Death:ResetStatus', function()
    gsw = false
    gswcount = 0
    stab = false
    prongs = false
end)

RegisterNetEvent('Reload_Death:SmellMarijuana')
AddEventHandler('Reload_Death:SmellMarijuana', function()
    marijuana = true
    Citizen.Wait(900000)
    marijuana = false
end)

RegisterNetEvent('Reload_Death:EyesDilated')
AddEventHandler('Reload_Death:EyesDilated', function()
    dilated = true
    Citizen.Wait(1800000)
    dilated = false
end)