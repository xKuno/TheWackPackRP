-------------------------------------
------- Created by T1GER#9080 -------
------------------------------------- 

ESX 		= nil
PlayerData 	= {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.ESXSHAREDOBJECT, function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
	TriggerServerEvent('t1ger_shops:fetchPlyShops')
	Wait(200)
	TriggerServerEvent('t1ger_shops:fetchShopShelves')
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('t1ger_shops:ShowNotifyESX')
AddEventHandler('t1ger_shops:ShowNotifyESX', function(msg)
    exports['mythic_notify']:SendAlert('inform', msg)
end)

function ShowNotifyESX(msg)
    exports['mythic_notify']:SendAlert('inform', msg)
end

shopBlips = {}
function CreateShopBlips(k,v,label)
	local mk = Config.BlipSettings[v.type]
	if mk.enable then
		blip = AddBlipForCoord(v.cashier[1], v.cashier[2], v.cashier[3])
		SetBlipSprite (blip, mk.sprite)
		SetBlipDisplay(blip, mk.display)
		SetBlipScale  (blip, mk.scale)
		SetBlipColour (blip, mk.color)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(label..mk.name)
		EndTextCommandSetBlipName(blip)
		table.insert(shopBlips, blip)
	end
end

-- Round Function:
function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- Comma Function:
function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

-- Load Anim
function LoadAnim(animDict)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(10)
	end
end

function LoadModel(model)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(10)
	end
end

-- Function for 3D text:
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

