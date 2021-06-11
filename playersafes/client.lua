function playersafes:Awake(...)
  while not ESX do Citizen.Wait(0); end
  while not ESX.IsPlayerLoaded() do Citizen.Wait(0); end
  self.PlayerData = ESX.GetPlayerData()
  TriggerServerEvent('playersafes:GetStartup')
end

function playersafes:Start(data)
  self.Safes = data or {}
  self.SpawnedSafes = {}
  self:Update()
end

RegisterNetEvent('playersafes:GotStartup')
AddEventHandler('playersafes:GotStartup', function(...) playersafes:Start(...); end)

function playersafes:Update(...)
  local ownerText = "Press [~r~E~s~] To Access The Safe.\nPress [~r~G~s~] To Pick Up The Safe."
  local notOwnerText = "Press [~r~E~s~] To Access The Safe.\nPress [~r~G~s~] To Crack The Safe."
  while true do
    Citizen.Wait(0)
    if self.UsingSafe and self.NUIClosed then 
      TriggerServerEvent('playersafes:StopUsing',self.UsingSafe.safeid)
      self.UsingSafe = false 
    end
    local closestSafe,closestDist = self:GetClosestSafe()
    if closestDist and closestDist < self.DrawTextDist and not self.UsingSafe and ((not self.Instance and closestSafe.instance == 'false') or (self.Instance and self.Instance == closestSafe.instance)) then
      local text = ''
      local isOwner = false
      if (closestSafe.owner and closestSafe.owner == self.PlayerData.identifier and not self.KashId) or (self.KashId and self.KashId == closestSafe.owner) or ((self.CharId == 1 or self.CharId == '1') and self.PlayerData.identifier == closestSafe.owner) then 
        isOwner = true
        text = ownerText
      else
        text = notOwnerText
      end
      local match = false
      for k,v in pairs(self.SpawnedSafes) do
        if type(v) ~= 'boolean' then
          if v.id == closestSafe.safeid then match = k; end
        end
      end
      local offset = false
      if match then
        if self.SpawnedSafes[match] and self.SpawnedSafes[match].obj then
          local fwd,right,up,pos = GetEntityMatrix(self.SpawnedSafes[match].obj['bkr_prop_biker_safebody_01a'])
          offset = -right/2.8
        end
      end
      local newPos = closestSafe.location
      if offset then newPos = vector3(newPos.x + offset.x,newPos.y + offset.y,newPos.z + offset.z); end
      Utils.DrawText3D(newPos.x,newPos.y,newPos.z, text)
      if IsControlJustPressed(0, 38) and closestDist <= self.InteractDist then

        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'SafeLocks_Input', {
          title = "Enter Safe Pin"
        },
        function(data, menu)
        local pin = tonumber(data.value)
        if pin == nil or pin == "" then
            exports['mythic_notify']:SendAlert('inform', 'No code specified.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
            menu.close()
        else
            menu.close()
            if pin == closestSafe.code then
              ESX.TriggerServerCallback('playersafes:TryAccessSafe',function(inUse)
                if inUse then
                  ESX.ShowNotification("Somebody else is using this safe.")
                else
                  self.NUIClosed = false
                  self.UsingSafe = closestSafe
                  ESX.TriggerServerCallback('playersafes:GetSafeInventory', function(inventory)
                    TriggerEvent("DP_Inventory:openPropertyInventory", inventory, closestSafe)
                  end, closestSafe.safeid)          
                end
              end,closestSafe.safeid)
            else
              ESX.ShowNotification("Incorrect pin.")
            end
          end
        end, function(data, menu)
          menu.close()
        end)

        elseif IsControlJustPressed(0, 58) and not isOwner then
          self.UsingSafe = closestSafe
          self.CrackingSafe = closestSafe
          local minigame = exports["pd-safe"]:createSafe({math.random(0,99),math.random(0,99)})
          if minigame then

            ESX.TriggerServerCallback('playersafes:TryAccessSafe',function(inUse)
              if inUse then
                ESX.ShowNotification("Somebody else is using this safe.")
              else
                self.NUIClosed = false
                self.UsingSafe = closestSafe
                ESX.TriggerServerCallback('playersafes:GetSafeInventory', function(inventory)
                  TriggerEvent("DP_Inventory:openPropertyInventory", inventory, closestSafe)
                end, closestSafe.safeid)          
              end
            end,closestSafe.safeid)

          elseif not minigame then
            self.UsingSafe = false
            self.CrackingSafe = false
            playersafes.NUIClosed = true
          end

        elseif IsControlJustPressed(0, 58) and isOwner then
          if closestDist <= self.InteractDist then
            self.UsingSafe = closestSafe
            TriggerServerEvent('playersafes:PickupSafe',closestSafe)
            Citizen.Wait(2000)
            self.UsingSafe = false
        end
      end
    end
  end
end

function playersafes:DestroySafe(safe)
  local rList = {}
  for k,v in pairs(self.SpawnedSafes) do
    if v and v.id and v.id == safe.safeid then
      for k,v in pairs(v.obj) do DeleteObject(v); end
      table.insert(rList,k)
    end
  end
  for k,v in pairs(rList) do self.SpawnedSafes[v] = nil; self.Safes[v] = nil; end
end

function playersafes:EndMinigame(didWin)
  if not self.CrackingSafe then return; end
  FreezeEntityPosition(PlayerPedId(),false)
  local safe = self.CrackingSafe
  if didWin then     
    if playersafes.UsingDiscInventoryHud then
      TriggerEvent('disc-inventoryhud:openInventory', {
        type = 'safe',
        owner = "s-"..safe.safeid
      })
    else
      ESX.TriggerServerCallback('playersafes:GetSafeInventory', function(inventory)
        TriggerEvent("DP_Inventory:openPropertyInventory", inventory, safe)
      end, safe.safeid)     
      self.NUIClosed = false
      self.UsingSafe = safe
      self.CrackingSafe = false
    end
  else
    self.NUIClosed = true
    self.UsingSafe = safe
    self.CrackingSafe = false
  end
end

function playersafes:GetClosestSafe()
  local plyPed = PlayerPedId()
  local plyPos = GetEntityCoords(plyPed)
  local closest,closestDist
  for k,v in pairs(self.Safes) do
    local dist = Utils.GetVecDist(plyPos,v.location)
    if not closestDist or dist < closestDist then
      closest = v
      closestDist = dist
    end
    if dist < self.LoadSafeDist and not self.SpawnedSafes[k] and ((not self.Instance and v.instance == "false") or (self.Instance and v.instance and self.Instance == v.instance)) then
      self:SpawnThisSafe(k,v.location)
    elseif dist > self.DespawnDist and self.SpawnedSafes[k] then
      for key,val in pairs(self.SpawnedSafes[k].obj) do DeleteObject(val); end
      self.SpawnedSafes[k] = false
    end
  end
  if closestDist then return closest,closestDist
  else return false,999999
  end
end

function playersafes:SpawnThisSafe(key,pos)
  local safeData = self.Safes[key]
  local plyPed = PlayerPedId()
  local forward,right,up,pPos = GetEntityMatrix(plyPed)
  local nPos = vector3(pos.x,pos.y,pos.z - 0.9)
  TriggerEvent('safecracker:SpawnSafe', false, nPos, safeData.location.heading, function(safe) 
    self.SpawnedSafes[key] = { obj = safe, id = safeData.safeid } 
  end)  
  while not self.SpawnedSafes[key] do Citizen.Wait(0); end
end

function playersafes:DoNotifyPolice(pos)
  Citizen.CreateThread(function(...)
    local timer = GetGameTimer()
    local nearStreet = GetStreetNameFromHashKey(GetStreetNameAtCoord(pos.x,pos.y,pos.z))
    ESX.ShowNotification("Somebody reported suspicious activity at "..nearStreet..". [~g~LEFTALT~s~]")
    local blip = AddBlipForRadius(pos.x,pos.y,pos.z, 100.0)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 1)
    SetBlipAlpha (blip, 128)
    while GetGameTimer() - timer < self.NotifyPoliceTimer * 1000 do
      if IsControlJustPressed(0, 19) then
        SetNewWaypoint(pos.x,pos.y)
      end
    end
    RemoveBlip(blip)
  end)
end

function playersafes:EnterInstance(instance)  
  ESX.TriggerServerCallback('playersafes:GetInstanceOwner', function(identifier)
    if identifier then self.Instance = identifier; end
  end, instance.host)
  while not self.Instance do Citizen.Wait(0); end
end

function playersafes:LeaveInstance(instance)
  self.Instance = false; 
  for k,v in pairs(self.Safes) do
    if v.instance and v.instance ~= "false" then
      local safeId = v.safeid
      local match = false
      for k,v in pairs(self.SpawnedSafes) do
        if v and safeId and v.id == safeId then match = k; end
      end
      if match then         
        for k,v in pairs(self.SpawnedSafes[match].obj) do DeleteObject(v); end;
        self.SpawnedSafes[match] = nil
      end
    end
  end
end

function playersafes:SpawnSafe(safe)
  local plyPed = PlayerPedId()
  local forward,right,up,pPos = GetEntityMatrix(plyPed)
  local pos = (pPos + (forward / 2)) + (right / 4)
  local heading = GetEntityHeading(plyPed)
  if self.Instance then safe.instance = self.Instance; end
  safe.location = {x = pos.x, y = pos.y, z = pos.z, heading = heading}
  TriggerServerEvent('playersafes:SafeSpawned',safe)
end


RegisterNetEvent('playersafes:DoNotify')
AddEventHandler('playersafes:DoNotify', function(pos) playersafes:DoNotifyPolice(pos); end)

RegisterCommand('fixsafe', function()
  playersafes.NUIClosed = true
end)

RegisterNetEvent('playersafes:SpawnSafe')
AddEventHandler('playersafes:SpawnSafe', function(safe) playersafes:SpawnSafe(safe); end)

RegisterNetEvent('playersafes:SafeAdded')
AddEventHandler('playersafes:SafeAdded', function(safe,key) playersafes.Safes[key] = safe; end)

RegisterNetEvent('playersafes:DelSafe')
AddEventHandler('playersafes:DelSafe', function(safe) playersafes:DestroySafe(safe); end)

RegisterNetEvent('playersafes:CharSet')
AddEventHandler('playersafes:CharSet', function(id,char) playersafes.KashId = id; playersafes.CharId = char; end)

RegisterNetEvent('playersafes:SetSafes')
AddEventHandler('playersafes:SetSafes', function(safes) playersafes.Safes = safes; end)


RegisterNetEvent('instance:onEnter')
AddEventHandler('instance:onEnter', function(instance) while not playersafes.Safes do Citizen.Wait(0); end; playersafes:EnterInstance(instance); end)

RegisterNetEvent('instance:onLeave')
AddEventHandler('instance:onLeave', function(instance) while not playersafes.Safes do Citizen.Wait(0); end; playersafes:LeaveInstance(); end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job) playersafes.PlayerData.job = job; end)

AddEventHandler('safecracker:EndMinigame', function(didWin) playersafes:EndMinigame(didWin); end)

Citizen.CreateThread(function(...) playersafes:Awake(...); end)

RegisterNetEvent('playersafe:InputCode:Client')
AddEventHandler('playersafe:InputCode:Client', function()
  ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'SafeLocks', {
    title = "Enter Safe Pin"
  },
  function(data, menu)
  local pin = tonumber(data.value)
  if pin == nil or pin == "" then
      exports['mythic_notify']:SendAlert('inform', 'No code specified.', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' })
      menu.close()
  else
      menu.close()
      TriggerServerEvent('playersafe:UpdatePin', pin)
  end

  end, function(data, menu)
    menu.close()
  end)
end)