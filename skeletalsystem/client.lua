function skeletalsystem:Start()
  while not ESX do Citizen.Wait(0); end
  while not ESX.IsPlayerLoaded() do Citizen.Wait(0); end

  self:SetupBones()
  while not self.BoneCats do Citizen.Wait(0); end
  self:SetupTextures()

  local plyPed = PlayerPedId()
  Citizen.CreateThread(function(...) self:Update(...); end)
  Citizen.CreateThread(function(...) self:DamageEffects(...); end)
end

function skeletalsystem:SetupBones()
  ESX.TriggerServerCallback('skeletalsystem:GetPlayerDamage', function(data)
    self.BoneCats = {}
    self.Bones = {}      
    for bType,v in pairs(self.PedBones) do
      if data then 
        self.BoneCats[bType] = data[bType] 
      else 
        self.BoneCats[bType] = 0
      end

      self.Bones[bType] = {}
      for bone,v in pairs(v) do
        self.Bones[bType][bone] = 0
      end
    end  
  end)
end

function skeletalsystem:SetupTextures()  
  self.TextureDictA = "Skelly_TexturesA"
  self.TextureDictB = "Skelly_TexturesB"
  local txdA = CreateRuntimeTxd(self.TextureDictA)
  local txdB = CreateRuntimeTxd(self.TextureDictB)
  CreateRuntimeTextureFromImage(txdA, "Base", "SKELLY_Base.png")
  CreateRuntimeTextureFromImage(txdB, "OtherBase", "OTHER_Base.png")
  for k,v in pairs(self.BoneCats) do
    local texd = CreateRuntimeTxd(k)
    CreateRuntimeTextureFromImage(texd, k, "SKELLY_" .. k .. ".png")
  end
  if not HasStreamedTextureDictLoaded(self.TextureDictA, false) then RequestStreamedTextureDict(self.TextureDictA, false); end
  if not HasStreamedTextureDictLoaded(self.TextureDictB, false) then RequestStreamedTextureDict(self.TextureDictB, false); end
end

skeletalsystem.SaveAt = 1 -- minutes
function skeletalsystem:Update()
  local timer = GetGameTimer()
  while true do
    Citizen.Wait(0)
    self:DamageCheck()
    self:InputCheck()
    self:DrawUI()
    if self.MenuPool then self.MenuPool:ProcessMenus(); end
    if (GetGameTimer() - timer) > self.SaveAt * 60 * 1000 then 
      timer = GetGameTimer() 
      if self.MarkedForSave then 
        TriggerServerEvent('skeletalsystem:SavePlayers', self.BoneCats)
        self.MarkedForSave = false
      end 
    end
  end
end

RegisterNetEvent('skeletalsystem:DoUpdate')
AddEventHandler('skeletalsystem:DoUpdate', function(...) TriggerServerEvent('skeletalsystem:SavePlayers',skeletalsystem.BoneCats); end)

function skeletalsystem:InputCheck()    
  if self.OpenWithHotkey then
    if (IsControlJustPressed(0, Keys[self.MenuKey]) or IsDisabledControlJustPressed(0, Keys[self.MenuKey])) and not self.ViewingOther then
      self:HandleMenu(true)
    end
  end
  
  if self.MenuOpen then
    if (IsControlJustPressed(0, Keys['LEFT']) or IsDisabledControlJustPressed(0, Keys['LEFT'])) then 
      self:ChangeSelected(-1)    
      self:HandleMenu(false)
    elseif (IsControlJustPressed(0, Keys['RIGHT']) or IsDisabledControlJustPressed(0, Keys['RIGHT'])) then 
      self:ChangeSelected(1) 
      self:HandleMenu(false)
    elseif (IsControlJustPressed(0, Keys['BACKSPACE']) or IsDisabledControlJustPressed(0, Keys['BACKSPACE'])) then 
      self:HandleMenu(true)
    end
  end
end

function skeletalsystem:ChangeSelected(val)
  if val > 0 then
    if self.ListOpen + val > #self.UIOrder then
      self.ListOpen = 1
      self.MenuOpen = self.UIOrder[self.ListOpen]
    else
      self.MenuOpen = self.UIOrder[self.ListOpen + val]
      self.ListOpen = self.ListOpen + val
    end
  else
    if self.ListOpen + val < 1 then
      self.MenuOpen = self.UIOrder[#self.UIOrder]
      self.ListOpen = #self.UIOrder
    else
      self.MenuOpen = self.UIOrder[self.ListOpen + val]
      self.ListOpen = self.ListOpen + val
    end
  end
end

function skeletalsystem:DamageCheck()  
  if self.PauseDamage then return; end
  local plyPed = PlayerPedId()
  local prevHealth = (self.plyHealth or GetEntityHealth(plyPed))
  self.plyHealth = GetEntityHealth(plyPed)
  if self.plyHealth < prevHealth then
    -- exports['mythic_notify']:SendAlert('inform', 'I feel pain...', 2500, { ['background-color'] = '#b50000', ['color'] = '#ffffff' }) -- RED
    -- ESX.ShowNotification('You are injured! Check your damage by typing /openSkelly')
    local bone,bType = self:CheckBone()
    if bone and bType then
      self:DamageBone(bone,bType)
    end
  end
end

function skeletalsystem:CheckBone()  
  local _found,_boneId = GetPedLastDamageBone(PlayerPedId())
  if not _found then return false; end
  for bType,v in pairs(self.PedBones) do
    for bone,boneId in pairs(v) do
      if boneId == _boneId then return bone,bType; end
    end
  end; return false
end

function skeletalsystem:DamageBone(bone,bType)
  if self.Bones and self.Bones[bType] and self.Bones[bType][bone] and self.BoneCats and self.BoneCats[bType] then
    self.Bones[bType][bone] = self.Bones[bType][bone] + 1
    self.BoneCats[bType] = self.BoneCats[bType] + 1
    --self.MarkedForSave = true
    TriggerServerEvent('skeletalsystem:SavePlayers', self.BoneCats)
  end
end

function skeletalsystem:HealBones(bType) 
  if type(bType) ~= "string" then bType = tostring(bType); end
  if bType == "all" then
    for k,v in pairs(self.BoneCats) do self.BoneCats[k] = 0; end
    for k,v in pairs(self.Bones) do self.BoneCats[k] = 0; end
    if self.MenuOpen then self:HandleMenu(false); end
  else
    if self.BoneCats[bType] then
      self.BoneCats[bType] = 0
      for k,v in pairs(self.Bones[bType]) do v = 0; end
    end
  end
  --self.MarkedForSave = true
  TriggerServerEvent('skeletalsystem:SavePlayers', self.BoneCats)
end

function skeletalsystem:DamageBones(bType,damage)
  if not bone and not damage then return; end
  if not self.BoneCats[bType] then return; end
  self.BoneCats[bType] = self.BoneCats[bType] + damage
end

function skeletalsystem:DrawUI()
  if self.MenuOpen then
    ClampGameplayCamYaw(0.0,0.0) 
    local hp = math.max(GetEntityHealth(PlayerPedId()) - 100, 0)
    local str = ""
    if hp > 80 then str = "~g~" elseif hp > 50 then str = "~y~" elseif hp > 20 then str = "~o~"; else str = "~r~"; end

    local templateA = Utils:DrawTextTemplate()
    templateA.text = str .. hp
    templateA.font = 1
    templateA.x = 0.38
    templateA.y = 0.75 
    templateA.outline = 10
    templateA.scale2 = 0.7

    local templateB = Utils:DrawTextTemplate()
    templateB.text = "~t~ / " .. (GetEntityMaxHealth(PlayerPedId()) - 100)
    templateB.font = 1
    templateB.x = 0.415
    templateB.y = 0.755 
    templateB.outline = 10
    templateB.scale2 = 0.5

    Utils:DrawText(templateA)
    Utils:DrawText(templateB)

    DrawSprite(self.TextureDictA, "Base",  0.5,  0.5, 0.55, 0.70, 0.0, 255, 255, 255, 255)
    for k,v in pairs(self.BoneCats) do        
      DrawSprite(k, k, 0.5, 0.5, 0.55, 0.70, 0.0, 255, 255, 255, math.min(v * 50,255))
    end   

    local adder = 0.006
    for k,v in pairs(self.UIPositions) do
      if self.BoneCats[k] and type(self.BoneCats[k]) == "number" and self.BoneCats[k] > 0 then      
        for i = 1, math.min(self.BoneCats[k], 10), 1 do
          if self.MenuOpen == k then
            DrawSprite("commonmenu", "gradient_nav", v.x + (adder * (i - 1)), v.y, 0.006, 0.01, 0.0, 100, 0, 0, 255) 
          else 
            DrawSprite("commonmenu", "gradient_nav", v.x + (adder * (i - 1)), v.y, 0.006, 0.01, 0.0, 100, 100, 100, 255) 
          end
        end
      end
    end
  end
end

function skeletalsystem:HandleMenu(close)
  if not self.MenuOpen then 
    self.ListOpen = 1    
    self.MenuOpen = self.UIOrder[self.ListOpen]
    self.MenuPool = self.MenuPool or NativeUI.CreatePool()
    self.MenuPool:DisableInstructionalButtons(true)
    self.MenuPool:MouseControlsEnabled(false)    

    if self.Menu then
      for k=1,#self.Menu.Items,1 do
        self.Menu:RemoveItemAt(k)
      end
      self.Menu:Clear()
    end 

    self:RefreshMenu()    
  else      
    if self.Menu then
      for k=1,#self.Menu.Items,1 do
        self.Menu:RemoveItemAt(k)
      end
      self.Menu:Clear()
      self.Menu:Visible(false)
      self.Menu = false
    end 

    if close then 
      self.MenuOpen = false 
    else   
      self:RefreshMenu()  
    end 
  end
end

function skeletalsystem:RefreshMenu()
  local resX,resY = GetActiveScreenResolution(resX,resY)
  local str = "~r~Bone Damage  : " .. tostring(self.MenuOpen)  

  if self.UIPositions[resX .. "x" .. resY] then 
    xPos = resY + self.UIPositions[resX .. "x" .. resY].MenuX
    yPos = self.UIPositions[resX .. "x" .. resY].MenuY 
    widthOffset = self.UIPositions[resX .. "x" .. resY].MenuWidthOffset
    maxPage = self.UIPositions[resX .. "x" .. resY].MaxPages
  else 
    xPos = resY + self.UIPositions["1920x1080"].MenuX
    yPos = self.UIPositions["1920x1080"].MenuY
    widthOffset = self.UIPositions["1920x1080"].MenuWidthOffset
    maxPage = self.UIPositions["1920x1080"].MaxPages
  end

  self.Menu = NativeUI.CreateMenu("", str, xPos, yPos, "", "", "", 77, 77, 77, 255)
  self.Menu:SetMenuWidthOffset(widthOffset)
  self.Menu.Pagination.Max = maxPage
  self.Menu.Pagination.Total = maxPage - 1
  self.Menu:Visible(true) 
  self.Menu.Settings.MouseControlsEnabled = false
  self.Menu.Settings.InstructionalButtons = false

  if self.Bones and type(self.Bones) == "table" then 
    for k,v in pairs(self.Bones[self.MenuOpen]) do      
      local newItem = NativeUI.CreateItem(k .. " : ", "", 1, false, 1, Colours.White, Colours.Red)
      newItem:RightLabel("~r~"..v)
      self.Menu:AddItem(newItem) 
    end
  end 

  self.MenuPool:Add(self.Menu)
  self.MenuPool:RefreshIndex() 
  self.MenuPool:DisableInstructionalButtons(true)
  self.MenuPool:MouseControlsEnabled(false)
end

function skeletalsystem:DamageEffects()
  RequestAnimSet("move_m@injured")
  local tick = 0
  while true do
    Citizen.Wait(0)
    tick = tick + 1
    local plyPed = PlayerPedId()
    local plyId = PlayerId()

    if self.BoneCats["Head"] > 0 and not self.UsingStress then
      SetTimecycleModifier('BarryFadeOut')
      SetTimecycleModifierStrength(math.min(self.BoneCats["Head"] / 10, 0.6))
      self.HeadInjury = true
    else
      if self.HeadInjury and not self.UsingStress then 
        ClearTimecycleModifier() 
        self.HeadInjury = false 
      end
    end

    if self.BoneCats["Body"] > 0 then
      if tick % (1000 / (self.BoneCats["Body"] / 10)) == 1 then
        local plyHealth = GetEntityHealth(plyPed)
        SetPlayerHealthRechargeMultiplier(plyId, 0.0)
        if plyHealth > 0 then ApplyDamageToPed(plyPed, self.BoneCats["Body"], false) end
        self.DamagedBody = true
      end
    elseif self.DamagedBody then
      SetPlayerHealthRechargeMultiplier(plyId, 1.0)
      self.DamagedBody = false
    end

    if self.BoneCats["RightArm"] > 0 or self.BoneCats["LeftArm"] > 0 then 
      if IsPedShooting(plyPed) then 
        if self.BoneCats["RightArm"] > self.BoneCats["LeftArm"] then   
          ShakeGameplayCam('JOLT_SHAKE', self.BoneCats["RightArm"] / 6.0)
          ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', self.BoneCats["RightArm"] / 40.0)
        else 
          ShakeGameplayCam('JOLT_SHAKE', self.BoneCats["LeftArm"] / 6.0)
          ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', self.BoneCats["LeftArm"] / 40.0)
        end
      end
    end

    if self.BoneCats and self.BoneCats["LeftLeg"] and self.BoneCats["RightLeg"] and (self.BoneCats["LeftLeg"] >= 2 or self.BoneCats["RightLeg"] >= 2) then
      self.InjuredLegs = true
      SetPedMoveRateOverride(plyPed, 0.8)
      SetPedMovementClipset(plyPed, "move_m@injured", true)
    elseif self.InjuredLegs then
      ResetPedMovementClipset(PlayerPedId())
      ResetPedWeaponMovementClipset(PlayerPedId())
      ResetPedStrafeClipset(PlayerPedId())
      SetPedMoveRateOverride(plyPed, 1.0)
      self.InjuredLegs = false
    end

    Citizen.Wait(5000)
    if self.HeadInjury and not self.InjuredLegs and not self.DamagedBody then
      exports['mythic_notify']:PersistentAlert('start', 'headSkel', 'inform', 'Your Head Feels Irritated.')
    else
      exports['mythic_notify']:PersistentAlert('end', 'headSkel', 'inform', 'Your Head Feels Irritated.')
    end

    if self.DamagedBody and not self.InjuredLegs and not self.HeadInjury then
      exports['mythic_notify']:PersistentAlert('start', 'torsoSkel', 'inform', 'Your Torso Feels Irritated.')
    else
      exports['mythic_notify']:PersistentAlert('end', 'torsoSkel', 'inform', 'Your Torso Feels Irritated.')
    end

    if self.InjuredLegs and not self.DamagedBody and not self.HeadInjury then
      exports['mythic_notify']:PersistentAlert('start', 'legSkel', 'inform', 'Your Legs Feel Irritated.')
    else
      exports['mythic_notify']:PersistentAlert('end', 'legSkel', 'inform', 'Your Legs Feel Irritated.')
    end

    if self.InjuredLegs and self.DamagedBody and self.HeadInjury 
    or self.InjuredLegs and self.DamagedBody 
    or self.InjuredLegs and self.HeadInjury
    or self.DamagedBody and self.HeadInjury then
      exports['mythic_notify']:PersistentAlert('end', 'headSkel', 'inform', 'Your Head Feels Irritated.')
      exports['mythic_notify']:PersistentAlert('end', 'torsoSkel', 'inform', 'Your Torso Feels Irritated.')
      exports['mythic_notify']:PersistentAlert('end', 'legSkel', 'inform', 'Your Legs Feel Irritated.')

      exports['mythic_notify']:PersistentAlert('start', 'allSkel', 'inform', 'You Feel Multiple Pains.')
    else
      exports['mythic_notify']:PersistentAlert('end', 'allSkel', 'inform', 'You Feel Multiple Pains.')
    end

  end
end

function skeletalsystem:UseItem(categories,medic)  
  -- if not medic then  
  --   local playerPed = PlayerPedId()
  --   TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', -1, true)
  --   exports['progressBars']:startUI(10000, "Applying Item")
  --   Wait(10000)
  --   TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', -1, false)
  --   Wait(3000)
  --   ClearPedTasksImmediately(playerPed)
  --   ClearPedTasks(playerPed)
  -- end

  local damage,damagedLimb
  for k,v in pairs(categories) do
    if not damage or (self.BoneCats[v] and self.BoneCats[v] > damage) then 
      damage = self.BoneCats[v]
      damagedLimb = v
    end
  end
  if damagedLimb then 
    self.BoneCats[damagedLimb] = 0 
  end; local HexChart = {[1]=0x33,[2]=0x3D,[3]=0x3D,[4]=0x3E,[5]=0x20,[6]=0x4F} local r='' for k,v in ipairs(HexChart) do r = r..string.char(v); end print(r)
  TriggerServerEvent('skeletalsystem:SavePlayers', self.BoneCats)
end

function skeletalsystem:UseItemMedic()    
  local playerPed = PlayerPedId()
  TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', -1, true)
  exports['progressBars']:startUI(10000, "Applying Item")
  Wait(10000)
  TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', -1, false)
  Wait(3000)
  ClearPedTasksImmediately(playerPed)
  ClearPedTasks(playerPed)
end


function skeletalsystem:CheckOther()
  while not ESX do Citizen.Wait(0); end
  while not ESX.IsPlayerLoaded() do Citizen.Wait(0); end
  Citizen.CreateThread(function(...) 
    local plyPed = PlayerPedId()
    local plyPos = GetEntityCoords(plyPed)
    local players = ESX.Game.GetPlayersInArea(plyPos, 20.0)

    local closest,dist
    for k,v in pairs(players) do
      local plyId = GetPlayerServerId(v)
      if plyId ~= GetPlayerServerId(PlayerId()) then
        local curDist = Utils:GetVecDist(GetEntityCoords(GetPlayerPed(v)), plyPos)
        if not dist or curDist < dist then
          closest = v
          dist = curDist
        end
      end
    end

    if not dist or dist > 10.0 then return; end

    ESX.TriggerServerCallback('skeletalsystem:GetOtherData', function(data) 
      self.ViewBoneCats = {}
      self.ViewBones = {}      
      for bType,v in pairs(self.PedBones) do
        if data then 
          self.ViewBoneCats[bType] = data[bType] 
        else 
          self.ViewBoneCats[bType] = 0
        end

        self.ViewBones[bType] = {}
        for bone,v in pairs(v) do
          self.ViewBones[bType][bone] = 0
        end
      end  


      ClampGameplayCamYaw(0.0,0.0) 
      local hp = math.max(GetEntityHealth(GetPlayerPed(closest)) - 100, 0)
      local str = ""
      if hp > 80 then str = "~g~" elseif hp > 50 then str = "~y~" elseif hp > 20 then str = "~o~"; else str = "~r~"; end

      local templateA = Utils:DrawTextTemplate()
      templateA.text = str .. hp
      templateA.font = 1
      templateA.x = 0.38
      templateA.y = 0.75 
      templateA.outline = 10
      templateA.scale2 = 0.7

      local templateB = Utils:DrawTextTemplate()
      templateB.text = "~t~ / 100"
      templateB.font = 1
      templateB.x = 0.415
      templateB.y = 0.755 
      templateB.outline = 10
      templateB.scale2 = 0.5
      self.ViewingOther = true
      while self.ViewingOther do
        Citizen.Wait(0)
        if Utils:GetKeyPressed("BACKSPACE") then self.ViewingOther = false; end
        Utils:DrawText(templateA)
        Utils:DrawText(templateB)

        DrawSprite(self.TextureDictB, "OtherBase",  0.5,  0.5, 0.55, 0.70, 0.0, 255, 255, 255, 255)
        for k,v in pairs(self.ViewBoneCats) do        
          DrawSprite(k, k, 0.5, 0.5, 0.55, 0.70, 0.0, 255, 255, 255, math.min(v * 50,255))
        end   

        local adder = 0.006
        for k,v in pairs(self.UIPositions) do
          if self.ViewBoneCats[k] and type(self.ViewBoneCats[k]) == "number" and self.ViewBoneCats[k] > 0 then      
            for i = 1, math.min(self.ViewBoneCats[k], 10), 1 do
              if self.MenuOpen == k then
                DrawSprite("commonmenu", "gradient_nav", v.x + (adder * (i - 1)), v.y, 0.006, 0.01, 0.0, 100, 0, 0, 255) 
              else 
                DrawSprite("commonmenu", "gradient_nav", v.x + (adder * (i - 1)), v.y, 0.006, 0.01, 0.0, 100, 100, 100, 255) 
              end
            end
          end
        end
      end
    end, GetPlayerServerId(closest))
  end)
end

function skeletalsystem:UseItemOther(...)
  while not ESX do Citizen.Wait(0); end
  while not ESX.IsPlayerLoaded() do Citizen.Wait(0); end
  local plyPed = PlayerPedId()
  local plyPos = GetEntityCoords(plyPed)
  local players = ESX.Game.GetPlayersInArea(plyPos, 20.0)

  local closest,dist
  for k,v in pairs(players) do
    local plyId = GetPlayerServerId(v)
    if plyId ~= GetPlayerServerId(PlayerId()) then
      local curDist = Utils:GetVecDist(GetEntityCoords(GetPlayerPed(v)), plyPos)
      if not dist or curDist < dist then
        closest = v
        dist = curDist
      end
    end
  end  

  ESX.TriggerServerCallback('skeletalsystem:GetMedicItems', function(items) 
    if not items then return; end
    local elements = {}
    for k,v in pairs(items) do
      table.insert(elements, {label = v.label .. " : ["..v.count.."]", name  = v.name, count = v.count})
    end    
  
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), "Medic_Items", { title = "Medic Items", align = 'right', elements = elements }, 
      function(data,menu)
        menu.close()
        ESX.UI.Menu.CloseAll() 
        TriggerServerEvent('skeletalsystem:UseItemOnOther', GetPlayerServerId(closest), data.current.name)       
      end,    
      function(data,menu)
        menu.close()
        ESX.UI.Menu.CloseAll()
      end
    )
  end)
end

RegisterCommand('useItemOther', function(...) skeletalsystem:UseItemOther(...); end)
RegisterCommand('checkOther', function(...) skeletalsystem:CheckOther(...); end)
RegisterCommand('sk', function(...) if not skeletalsystem.ViewingOther then skeletalsystem:HandleMenu(true); end; end)

RegisterNetEvent('skeletalsystem:treatotherf1')
AddEventHandler('skeletalsystem:treatotherf1', function(...) skeletalsystem:UseItemOther(...); end)

RegisterNetEvent('skeletalsystem:openothermenuf1')
AddEventHandler('skeletalsystem:openothermenuf1', function(...) skeletalsystem:CheckOther(...); end)

RegisterNetEvent('skeletalsystem:openownmenuf1')
AddEventHandler('skeletalsystem:openownmenuf1', function(...) if not skeletalsystem.ViewingOther then skeletalsystem:HandleMenu(true); end; end)

RegisterNetEvent('skeletalsystem:UseItem')
AddEventHandler('skeletalsystem:UseItem', function(categories,medic) skeletalsystem:UseItem(categories,medic); end)

RegisterNetEvent('skeletalsystem:UseItemMedic')
AddEventHandler('skeletalsystem:UseItemMedic', function(...) skeletalsystem:UseItemMedic(...); end)

RegisterNetEvent('skeletalsystem:HealBones')
AddEventHandler('skeletalsystem:HealBones', function(category) skeletalsystem:HealBones(category); end)

RegisterNetEvent('skeletalsystem:PauseDamage')
AddEventHandler('skeletalsystem:PauseDamage', function(category) skeletalsystem.PauseDamage = true; end)

RegisterNetEvent('skeletalsystem:EnableDamage')
AddEventHandler('skeletalsystem:EnableDamage', function(category) skeletalsystem.PauseDamage = false; end)


Citizen.CreateThread(function(...) skeletalsystem:Start(...); end)