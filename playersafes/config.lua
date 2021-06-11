playersafes = {}

playersafes.UpdateVersion = '1.0.12'

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)

Citizen.CreateThread(function(...)
  while not ESX do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)
    Citizen.Wait(0)
  end
end)

playersafes.DrawTextDist  = 001.0
playersafes.InteractDist  = 001.0
playersafes.LoadSafeDist  = 050.0
playersafes.DespawnDist   = 100.0

playersafes.UsingESXWeight = true  -- if using latest esx versions
playersafes.UsingESXLimits = false   -- if not using weight?

playersafes.PoliceJobName = "police"
playersafes.PoliceMustCrack = false

-- true = using disc-inventoryhud
-- false = using esx_inventoryhud
playersafes.UsingDiscInventoryHud = false
playersafes.SafeSlotCount = 100 -- only for disc