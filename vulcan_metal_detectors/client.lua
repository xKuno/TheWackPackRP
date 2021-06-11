ESX                           = nil

local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local metalDetectorLocations = {
    [1] = {x = -536.18, y = -185.76, z = 38.21}, --City Hall 1st Floor
    [2] = {x = -537.65, y = -186.56, z = 42.75}, --City Hall 2nd Floor
    [3] = {x = 433.93, y = -981.34, z = 30.69}, --MRPD Front Door
    [4] = {x = 1843.14, y = 2585.90, z = 46.01}, --Prison 1
    [5] = {x = 1833.90, y = 2594.37, z = 46.01}, --Prison 2
}

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000)
        for i=1,#metalDetectorLocations do
            if (GetDistanceBetweenCoords(metalDetectorLocations[i]["x"],metalDetectorLocations[i]["y"],metalDetectorLocations[i]["z"], GetEntityCoords(PlayerPedId())) < Config.MetalDetectorRadius) then
                ESX.TriggerServerCallback('vulcan_metal_detectors:getItems', function(hasContraband)
                    if hasContraband == true and not passed then
                        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5, 'metaldetector', 0.5)
                        passed = true
                    end
                end)
            end
        end
        if passed == true then
            Citizen.Wait(5000)
            passed = false
        end
    end
end)