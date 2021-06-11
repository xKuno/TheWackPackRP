--AddSpeedZoneForCoord(float x, float y, float z, float radius, float speed, BOOL p5);

local speedZoneActive = false
local blip
local speedZone
local speedzones = {}
local player = PlayerPedId()

_menuPool = NativeUI.CreatePool()
trafficmenu = NativeUI.CreateMenu("Scene Menu", "~b~Traffic Control Advisor")
_menuPool:Add(trafficmenu)
_menuPool:MouseControlsEnabled(false)
_menuPool:ControlDisablingEnabled(false)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function ShowNotification(text)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(text)
  DrawNotification(false, false)
end

function SpeedZoneSubMenu(menu)
  local submenu = _menuPool:AddSubMenu(menu, "Speed Zone")
  local radiusnum = {
    "25",
    "50",
    "75",
    "100",
    "125",
    "150",
    "175",
    "200",
  }

  local speednum = {
    "0",
    "5",
    "10",
    "15",
    "20",
    "25",
    "30",
    "35",
    "40",
    "45",
    "50",
  }

  local zonecreate = NativeUI.CreateItem("Create Zone", "Creates a zone with the radius and speed specified.")
  local zoneradius = NativeUI.CreateSliderItem("Radius", radiusnum, 1, false)
  local zonespeed = NativeUI.CreateListItem("Speed", speednum, 1)
  local zonedelete = NativeUI.CreateItem("Delete Zone", "Deletes your placed zone.")

  submenu:AddItem(zoneradius)
  submenu:AddItem(zonespeed)
  submenu:AddItem(zonecreate)
  submenu:AddItem(zonedelete)

  zonecreate:SetRightBadge(BadgeStyle.Tick)

  submenu.OnSliderChange = function(sender, item, index)
        radius = item:IndexToItem(index)
        ShowNotification("Changing radius to ~r~" .. radius)
  end

  submenu.OnListChange = function(sender, item, index)
    speed = item:IndexToItem(index)
    ShowNotification("Changing speed to ~r~" .. speed)
  end

  zonedelete.Activated = function(sender, item, index)
      TriggerServerEvent('Disable')
      ShowNotification("Disabled zones.")
  end

  zonecreate.Activated = function(sender, item, index)

      if not speed then
        speed = 0
      end

      if not radius then
        ShowNotification("~r~Please change the radius!")
        return
      end

          speedZoneActive = true
          ShowNotification("Created Speed Zone.")
          local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
          radius = radius + 0.0
          speed = speed + 0.0
      
          local streetName, crossing = GetStreetNameAtCoord(x, y, z)
          streetName = GetStreetNameFromHashKey(streetName)
      
          local message = "^* ^1Traffic Announcement: ^r^*^7An accident has been reported on ^2" .. streetName .. " ^7,please travel at a speed of ^2" .. speed .. "mph ^7due to an incident." 
      
          TriggerServerEvent('ZoneActivated', message, speed, radius, x, y, z)
      

  end

end

SpeedZoneSubMenu(trafficmenu)


Citizen.CreateThread(function()
  local ped = PlayerPedId()
	while true do
		Citizen.Wait(0)
		_menuPool:ProcessMenus()
    
    if not IsPedInAnyVehicle(ped, false) then
      if IsControlJustPressed(0, 166) and GetLastInputMethod( 0 ) and PlayerData.job ~= nil then
        if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
  			 trafficmenu:Visible(not trafficmenu:Visible())
  			 PlaySoundFrontend(-1,"5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 1)
        end
      end
    end
	end
end)



RegisterNetEvent('Zone')
AddEventHandler('Zone', function(speed, radius, x, y, z)

  blip = AddBlipForRadius(x, y, z, radius)
      SetBlipColour(blip,idcolor)
      SetBlipAlpha(blip,80)
      SetBlipSprite(blip,9)
  speedZone = AddSpeedZoneForCoord(x, y, z, radius, speed, false)

  table.insert(speedzones, {x, y, z, speedZone, blip})

end)

RegisterNetEvent('RemoveBlip')
AddEventHandler('RemoveBlip', function()

    if speedzones == nil then
      return
    end
    local playerPed = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
    local closestSpeedZone = 0
    local closestDistance = 1000
    for i = 1, #speedzones, 1 do
        local distance = Vdist(speedzones[i][1], speedzones[i][2], speedzones[i][3], x, y, z)
        if distance < closestDistance then
            closestDistance = distance
            closestSpeedZone = i
        end
    end
    RemoveSpeedZone(speedzones[closestSpeedZone][4])
    RemoveBlip(speedzones[closestSpeedZone][5])
    table.remove(speedzones, closestSpeedZone)

end)