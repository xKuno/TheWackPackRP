--in the mine area: x rocks with a maximum removable. It regenerates over time, if it reaches 0 you can't chaos_mineria.
local clicks = 0
local roca = nil
local npcvender = true --false if you don't want the npc that exchanges it for money
local level = 3

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('pop_university:setMineLevel')
AddEventHandler('pop_university:setMineLevel',function(totalLevel)
    level = totalLevel
end)

RegisterNetEvent('caos_mineria:recibodatacliente')
AddEventHandler('caos_mineria:recibodatacliente',function(data)
    rocas = data
end)

local job = nil
AddEventHandler('playerSpawned', function(spawn)
  TriggerServerEvent('caos_mineria:getJob')
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    TriggerServerEvent('caos_mineria:getJob')
end)
TriggerServerEvent('caos_mineria:getJob')
RegisterNetEvent('caos_mineria:setJob')
AddEventHandler('caos_mineria:setJob',function(jobu)
  job = jobu
end)

function DrawText3D(x,y,z, text) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
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

function DrawText3Dlittle(x,y,z, text) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 0.5*scale)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
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

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

 function get3DDistance(x1, y1, z1, x2, y2, z2)
    local a = (x1 - x2) * (x1 - x2)
    local b = (y1 - y2) * (y1 - y2)
    local c = (z1 - z2) * (z1 - z2)
    return math.sqrt(a + b + c)
end

Citizen.CreateThread(function()
    local  wanted_model= "A_M_O_Tramp_01"
     modelHash = GetHashKey(wanted_model)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
       	Wait(1)
    end
    createNPC() 
end)

function createNPC()
    --FIRST NPC
	local created_ped = CreatePed(5, modelHash ,1905.96,3718.96,31.76,40.1, true, true)
	FreezeEntityPosition(created_ped, true)
	SetEntityInvincible(created_ped, true)
	SetBlockingOfNonTemporaryEvents(created_ped, true)
	TaskStartScenarioInPlace(created_ped, "WORLD_HUMAN_SMOKING", 0, true)
end

function AbrirMenu()

	local elements = {
		{label = "Yes",value = "yes"},
		{label = "No",value = "no"}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'get_job',
		{
			title  = 'Do you want me to keep your minerals and give you money in return?',
			align    = 'right',
			elements = elements
		},
		function(data, menu)
			if data.current.value == 'yes' then
				TriggerServerEvent('caos_mineria:quitomin')
			end
			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

Citizen.CreateThread(function()
	while true do
        if IsPedDead then
            clicks = 0
            roca = nil
        end
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		for i=1, #rocas, 1 do
            if GetDistanceBetweenCoords(coords.x,coords.y,coords.z,rocas[i].x,rocas[i].y,rocas[i].z) < 75 then
                if rocas[i].vida >= 50 then
    		      DrawText3D(rocas[i].x,rocas[i].y,rocas[i].z, "Rock of ~b~"..rocas[i].tipo.."~w~ : ~g~"..rocas[i].vida.."/"..rocas[i].max)
                elseif rocas[i].vida >= 25 then
                   DrawText3D(rocas[i].x,rocas[i].y,rocas[i].z, "Rock of ~b~"..rocas[i].tipo.."~w~ : ~b~"..rocas[i].vida.."/"..rocas[i].max)
                elseif rocas[i].vida < 25 and rocas[i].vida ~= 0 then
                     DrawText3D(rocas[i].x,rocas[i].y,rocas[i].z, "Rock of ~b~"..rocas[i].tipo.."~w~ : ~y~"..rocas[i].vida.."/"..rocas[i].max)
                elseif rocas[i].vida <= 0 then
                     DrawText3D(rocas[i].x,rocas[i].y,rocas[i].z, "Rock of ~b~"..rocas[i].tipo.."~w~ : ~r~ "..rocas[i].vida.."/"..rocas[i].max)  
                end
            end
		end

        if GetCurrentPedWeapon(PlayerPedId(),"WEAPON_BATTLEAXE",true) then
            if IsControlJustReleased(1,  24) then --click left

                for i=1, #rocas, 1 do
                    if GetDistanceBetweenCoords(coords.x,coords.y,coords.z,rocas[i].x,rocas[i].y,rocas[i].z) < 1.8 and rocas[i].vida > 0 then
                        roca = i
                    end
                end
                if roca ~= nil then
                        click()
                        Citizen.Wait(2)
                end
            end
        end

        if get3DDistance(coords.x,coords.y,coords.z,2953.68,2790.68,41.28) > 150 then
            local nothing, weapon = GetCurrentPedWeapon(PlayerPedId(), true)
            if weapon == "WEAPON_BATTLEAXE" then
                    TriggerServerEvent('miner:removeWeapon')
	                SetNotificationTextEntry("STRING")
	                AddTextComponentString("The axe has been taken from you, it seems that you don't want to work anymore")
	                DrawNotification(false, true)
            end
        end

        if get3DDistance(2952.0,2748.8,43.48-1,coords.x,coords.y,coords.z) < 100 then
            DrawMarker(1,2952.0,2748.8,43.48-1, 0, 0, 0, 0, 0, 0, 1.5001, 1.5001, 1.5001, 1555, 132, 23,255, 0, 0, 0,0)
        end
        if get3DDistance(2952.0,2748.8,43.48-1,coords.x,coords.y,coords.z) < 1.5 then
                DisplayHelpText("Press ~INPUT_CONTEXT~ to take your work tool")
                if IsControlJustReleased(1,38) then
                    TriggerServerEvent('miner:giveWeapon')
                end
        end

        if npcvender then
        	if get3DDistance(1905.96,3718.96,31.76,coords.x,coords.y,coords.z) < 20 then
        		DrawText3Dlittle(1905.96,3718.96,33.76, "It seems this man can buy your minerals... ~y~E~s~ to interact")
        		if IsControlJustReleased(1,38) then
        			AbrirMenu()
        		end
        	end
    	end
	end
end)

function isPossible(typed)
    if level == 0 then
        return false
    elseif level == 1 then
        if typed == "iron" or typed == "silver" or typed == "gold" then
            return false
        end
    elseif level == 2 then
        if typed == "silver" or typed == "gold" then
            return false
        end
    elseif level == 2 then
        if typed == "gold" then
            return false
        end
    end
    return true
end

function click()
-- The clicks will have to be balanced to the dynamics of the server
    if roca ~= nil then
        if isPossible(rocas[roca].data) then
            
        else
        	exports['mythic_notify']:SendAlert('inform', 'You can\'t chop this kind of rock.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
            return false
        end
        if rocas[roca].vida > 0 then
           if clicks >= 1 then 
                clicks = 0
                rocas[roca].vida = rocas[roca].vida - 1
                TriggerServerEvent('caos_mineria:doymineral',rocas[roca].data)
                TriggerServerEvent('caos_mineria:recibodata',rocas)
                roca = nil
            else
                clicks = clicks + 1 
                roca = nil
            end
        end
    end

end

local blips = {
    {title="Mining", colour=2, id=486, x = 2952.0, y = 2748.8, z = 43.48},
    {title="Mining", colour=2, id=486, x = 1905.96,y = 3718.96,z = 31.76},
}
 
Citizen.CreateThread(function()
    Citizen.Wait(0)
    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 0.9)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end

end)