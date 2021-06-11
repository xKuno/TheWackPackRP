RegisterNetEvent("gas_station:Notify")
AddEventHandler("gas_station:Notify", function(type,msg)
	-- Você pode mudar a notificação como desejar
	SendNUIMessage({ 
		notification = msg,
		notification_type = type,
	})

	-- local prefix = ""
	-- if type == "negado" then
	-- 	prefix = "~r~"
    -- elseif type == "importante" then
	-- 	prefix = "~y~"
    -- elseif type == "sucesso" then
    --     prefix = "~g~"
	-- end
	-- SetNotificationTextEntry("STRING")
	-- AddTextComponentString(prefix..msg)
	-- DrawNotification(false, false)
end)

function DrawMarker_blip(x,y,z)
	DrawMarker(21,x,y,z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,0,0,50,0,0,0,1)
end
function DrawMarker_truck(x,y,z)
	DrawMarker(39,x,y,z-0.6,0,0,0,0.0,0,0,1.0,1.0,1.0,255,0,0,50,0,0,0,1)
end

function DrawText3D2(x,y,z, text, size)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
	local dist = #(vector3(px,py,pz) - vector3(x,y,z))
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, size*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- spawnVehicle
-----------------------------------------------------------------------------------------------------------------------------------------

function spawnVehicle(name,x,y,z,h)
	local mhash = GetHashKey(name)
	while not HasModelLoaded(mhash) do
		RequestModel(mhash)
		Citizen.Wait(10)
	end

	if HasModelLoaded(mhash) then
		vehicle = CreateVehicle(mhash,x,y,z+0.5,h,true,false)
		local networkId = NetworkGetNetworkIdFromEntity(vehicle)

		SetNetworkIdCanMigrate(networkId, true)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')
		SetModelAsNoLongerNeeded(mhash)
		SetVehicleNumberPlateText(vehicle,Lang[Config.lang]['truck_plate'])

		SetVehicleFuelLevel(vehicle,100.0)
		DecorSetFloat(vehicle, "_FUEL_LEVEL", GetVehicleFuelLevel(vehicle))
	
		blip = AddBlipForEntity(vehicle)
		SetBlipSprite(blip,477)
		SetBlipColour(blip,26)
		SetBlipAsShortRange(blip,false)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Lang[Config.lang]['truck_blip'])
		EndTextCommandSetBlipName(blip)
	end
	return vehicle,blip
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- addBlip
-----------------------------------------------------------------------------------------------------------------------------------------

function addBlip(x,y,z,idtype,idcolor,text,scale)
	if idtype ~= 0 then
		local blip = AddBlipForCoord(x,y,z)
		SetBlipSprite(blip,idtype)
		SetBlipAsShortRange(blip,true)
		SetBlipColour(blip,idcolor)
		SetBlipScale(blip,scale)

		if text then
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(text)
			EndTextCommandSetBlipName(blip)
		end
		return blip
	end
end

-- Citizen.CreateThread(function()
-- 	for k,v in pairs(Config.gas_station_locations) do
-- 		local x,y,z = table.unpack(v.coord)
-- 		local blips = Config.gas_station_types[v.type].blips
-- 		addBlip(x,y,z,blips.id,blips.color,blips.name,blips.scale)
-- 	end
-- end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- IsSpawnPointClear
-----------------------------------------------------------------------------------------------------------------------------------------

function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
	local nearbyEntities = {}

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	for k,entity in pairs(entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if distance <= maxDistance then
			table.insert(nearbyEntities, isPlayerEntities and k or entity)
		end
	end

	return nearbyEntities
end

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
		local next = true

		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

GetVehicles = function()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

GetVehiclesInArea = function(coords, maxDistance) return EnumerateEntitiesWithinDistance(GetVehicles(), false, coords, maxDistance) end
IsSpawnPointClear = function(coords, maxDistance) return #GetVehiclesInArea(coords, maxDistance) == 0 end

-----------------------------------------------------------------------------------------------------------------------------------------
-- createBlip
-----------------------------------------------------------------------------------------------------------------------------------------

function createBlip(x,y,z)
	blip = AddBlipForCoord(x,y,z)
	SetBlipSprite(blip,478)
	SetBlipColour(blip,5)
	SetBlipAsShortRange(blip,false)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Lang[Config.lang]['blip_route'])
	EndTextCommandSetBlipName(blip)
	SetBlipRoute(blip, 1)
	return blip
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- showScaleform
-----------------------------------------------------------------------------------------------------------------------------------------

function showScaleform(title, desc, sec)
	function Initialize(scaleform)
		local scaleform = RequestScaleformMovie(scaleform)

		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end
		PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
		PushScaleformMovieFunctionParameterString(title)
		PushScaleformMovieFunctionParameterString(desc)
		PopScaleformMovieFunctionVoid()
		return scaleform
	end
	scaleform = Initialize("mp_big_message_freemode")
	while sec > 0 do
		sec = sec - 0.02
		Citizen.Wait(0)
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
	end
	SetScaleformMovieAsNoLongerNeeded(scaleform)
end