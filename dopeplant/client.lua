
dopeplant.Characters = {}
function dopeplant:Awake(...)
    while not ESX do Citizen.Wait(0); end
    while not ESX.IsPlayerLoaded() do Citizen.Wait(0); end
    self.PlayerData = ESX.GetPlayerData()
    ESX.TriggerServerCallback('dopeplant:GetStartData', function(retData) self:Start(retData); end)
end

function dopeplant:Start(plant)
  self.Plants = plant
  self.SpawnedPlants = {}
  self:Update()
end

function dopeplant:Update(...)
  self.FirstSpawn = true
  local syncTimer = GetGameTimer()
  local keyTimer = GetGameTimer()
  local adder = false
  if self.PlayerData.job.name == self.PoliceJob then adder = '\n~r~Press H to destroy~s~'; end
  while true do
    Citizen.Wait(0)
    local closest,dist = self:GetClosestPlant()
    if dist and dist < self.DrawDist then
      local text = closest.plantdata.state
      if adder then text = text..adder; end
      Utils.DrawText3D(closest.location.x, closest.location.y, closest.location.z, text)
      if closest.plantdata.state == '~p~Press E to harvest~s~' and dist < self.InteractDist then
        if IsControlJustPressed(0,38) and (GetGameTimer() - keyTimer) > 150 then 
          keyTimer = GetGameTimer()
          self:HarvestPlant(closest)
        elseif IsControlJustPressed(0, 74) and (GetGameTimer() - keyTimer) > 150 then
          keyTimer = GetGameTimer()
          self:DestroyPlant(closest)
        end
      elseif IsControlJustPressed(0, 74) and (GetGameTimer() - keyTimer) > 150 then
        keyTimer = GetGameTimer()
        self:DestroyPlant(closest)
      end
    end
  end
end

function dopeplant:HarvestPlant(plant)
  TriggerServerEvent('dopeplant:HarvestPlant',plant)  
  local plyPed = PlayerPedId()
  local loc = vector3(plant.location.x,plant.location.y,plant.location.z)
  TaskTurnPedToFaceEntity(plyPed, loc, -1)
  Citizen.Wait(1000)
  exports['progressBars']:startUI(self.ActionTimer * 1000, "Harvesting")
  TaskStartScenarioInPlace(plyPed, "PROP_HUMAN_BUM_BIN", 0, true)
  Wait(self.ActionTimer * 1000)
  TaskStartScenarioInPlace(plyPed, "PROP_HUMAN_BUM_BIN", 0, false)
  Wait(1000)
  ClearPedTasksImmediately(plyPed)
end

function dopeplant:DestroyPlant(plant)
  TriggerServerEvent('dopeplant:DestroyPlant',plant)
end

function dopeplant:GetClosestPlant(...)
  local plyPed = PlayerPedId()
  local plyPos = GetEntityCoords(plyPed)
  local closestPlant,closestDist
  for k,v in pairs(self.Plants) do

    if v and v.plantdata and ((v.plantdata.instance and self.Instance and v.plantdata.instance == self.Instance) or (not self.Instance and not v.plantdata.instance)) then
      local oPos = (v.location)
      local dist = Utils.GetVecDist(plyPos,oPos)
      if not closestDist or dist < closestDist then
        closestDist = dist
        closestPlant = v
      end

      if dist < self.SpawnDist and not self.SpawnedPlants[k] then
        local key = closestPlant.plantdata.stage
        local hash = GetHashKey(self.Objects[key])
        while not HasModelLoaded(hash) do RequestModel(hash); Citizen.Wait(0); end
        local pos = v.location
        local adder
        if v.plantdata.stage >= 4 then adder = -3.5 else adder = -1.0; end
        local newObj = CreateObject(hash, pos.x,pos.y,pos.z + adder, false,false,false)
        SetEntityAsMissionEntity(newObj,true,true)
        FreezeEntityPosition(newObj,true)
        SetModelAsNoLongerNeeded(hash)
        self.SpawnedPlants[k] = {obj = newObj, id = v.plantid}
      end
    end
  end
  if closestDist then return closestPlant,closestDist else return false,999999; end
end

function dopeplant:UseSeed(plant)
  ESX.ShowNotification("You have planted a seed.")
  if self.Instance then plant.instance = self.Instance; end
  TriggerServerEvent('dopeplant:PlantSeed', plant, GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId()))
end

function dopeplant:SeedPlanted(plant)
  self.Plants[(#self.Plants or 0)+1] = plant
end

function dopeplant:GrowPlant(plant,del)
  --print('growing')
  for k,v in pairs(self.Plants) do
    if v.plantid == plant.plantid then self.Plants[k] = plant; end
  end
  if del then
    for k,v in pairs(self.SpawnedPlants) do
      if v.id == plant.plantid then DeleteObject(v.obj); self.SpawnedPlants[k] = nil; Citizen.Wait(100) end
    end
  end
end

function dopeplant:UseItem(item)
  local closest,dist = self:GetClosestPlant()
  if dist and dist < self.DrawDist then
    TriggerServerEvent('dopeplant:ItemUsed', closest, item)
  end
end

function dopeplant:PlantRemoved(plant)
  local key = false
  for k,v in pairs(self.Plants) do if v.plantid == plant.plantid then key = k; end; end
  if key then self.Plants[key] = nil; end
  local keyB = false
  for k,v in pairs(self.SpawnedPlants) do if v.id == plant.plantid then keyB = k; end; end
  if keyB then DeleteObject(self.SpawnedPlants[keyB].obj); self.SpawnedPlants[keyB] = nil; end
end

function dopeplant:EnterInstance(instance)
  ESX.TriggerServerCallback('dopeplant:GetInstanceOwner', function(identifier)
    if identifier then self.Instance = identifier; else print("Couldnt find identifier."); end
  end, instance.host)
end

function dopeplant:LeaveInstance()
  self.Instance = false; 
  for k,v in pairs(self.Plants) do
    if v.plantdata.instance then
      local plantId = v.plantid
      local match = false
      for k,v in pairs(self.SpawnedPlants) do
        if v.id == plantId then match = k; end
      end
      if match then DeleteObject(self.SpawnedPlants[match].obj); self.SpawnedPlants[match] = nil; end
    end
  end
end

function dopeplant:UseBag(canUse, msg)
  Citizen.CreateThread(function(...)
    local plyPed = PlayerPedId()
    if canUse then 
      TaskStartScenarioInPlace(plyPed, "PROP_HUMAN_PARKING_METER", 0, true) 
      Wait(5000)
      ClearPedTasksImmediately(plyPed)
    end
    ESX.ShowNotification(msg) 
  end)
end

RegisterNetEvent('dopeplant:UseSeed')
AddEventHandler('dopeplant:UseSeed', function(plant) dopeplant:UseSeed(plant); end)

RegisterNetEvent('dopeplant:UseItem')
AddEventHandler('dopeplant:UseItem', function(item) dopeplant:UseItem(item); end)

RegisterNetEvent('dopeplant:SeedPlanted')
AddEventHandler('dopeplant:SeedPlanted', function(plant) dopeplant:SeedPlanted(plant); end)

RegisterNetEvent('dopeplant:GrowPlant')
AddEventHandler('dopeplant:GrowPlant', function(plant,del) dopeplant:GrowPlant(plant,del); end)

RegisterNetEvent('dopeplant:PlantRemoved')
AddEventHandler('dopeplant:PlantRemoved', function(plant) dopeplant:PlantRemoved(plant); end)

RegisterNetEvent('dopeplant:UseBag')
AddEventHandler('dopeplant:UseBag', function(canUse,msg) dopeplant:UseBag(canUse,msg); end)

RegisterNetEvent('instance:onEnter')
RegisterNetEvent('instance:onLeave')
AddEventHandler('instance:onEnter', function(instance) while not dopeplant.Plants do Citizen.Wait(0); end; dopeplant:EnterInstance(instance); end)
AddEventHandler('instance:onLeave', function(instance) while not dopeplant.Plants do Citizen.Wait(0); end; dopeplant:LeaveInstance(); end)

Citizen.CreateThread(function(...) dopeplant:Awake(...); end)