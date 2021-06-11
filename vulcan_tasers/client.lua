ESX                           = nil

local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local taserCartridgessLeft = 0

RegisterNetEvent('vulcan_taser:useTaserCartridge:Client')
AddEventHandler('vulcan_taser:useTaserCartridge:Client', function()
    if taserCartridgessLeft < 3 then
        taserCartridgessLeft = 3
        TriggerServerEvent('vulcan_tasers:removeCartridge')
    else
        exports['mythic_notify']:SendAlert('inform', 'Your Taser is already loaded.')
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local taserModel = GetHashKey("WEAPON_STUNGUN")

        if GetSelectedPedWeapon(playerPed) == taserModel then
            if IsPedShooting(playerPed) then
                taserCartridgessLeft = taserCartridgessLeft - 1
            end
        end

        if taserCartridgessLeft <= 0 then
            if GetSelectedPedWeapon(playerPed) == taserModel then
                SetPlayerCanDoDriveBy(playerPed, false)
                DisablePlayerFiring(playerPed, true)
                if IsControlJustReleased(0, 106) then
                    exports['mythic_notify']:SendAlert('inform', 'You have no Taser cartridges.')
                end
            end
        end
    end
end)