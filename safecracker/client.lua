function safecracker:StartMinigame(rewards,stayClosed)
	if not self or not self.Config or not ESX then return; end

  if not self.Setup then
    self.Setup = true
  	local txd = CreateRuntimeTxd(self.Config.TextureDict)
  	for i = 1, 2 do CreateRuntimeTextureFromImage(txd, tostring(i), "LockPart" .. i .. ".PNG") end

    self.SoundID    = GetSoundId() 
    
  	if not RequestAmbientAudioBank(self.Config.AudioBank, false) then RequestAmbientAudioBank(self.Config.AudioBankName, false); end
  	if not HasStreamedTextureDictLoaded(self.Config.TextureDict, false) then RequestStreamedTextureDict(self.Config.TextureDict, false); end
  end

  self.MinigameOpen = true
  self.Timer      = GetGameTimer()
  self.StayClosed = (stayClosed or false)

	Citizen.CreateThread(function() self:Update(rewards,stayClosed); end)	
end

RegisterNetEvent('safecracker:StartMinigame')
AddEventHandler('safecracker:StartMinigame', function(rewards,stayClosed) safecracker:StartMinigame(rewards,stayClosed); end)

function safecracker:Update(rewards)
	Citizen.CreateThread(function() self:HandleMinigame(rewards,stayClosed); end)
	while self.MinigameOpen do
		self:InputCheck()  
		if IsEntityDead(GetPlayerPed(PlayerId())) then self:EndMinigame(false, false); end
		Citizen.Wait(0)
	end
end

function safecracker:InputCheck()
	if not self or not self.Config or not self.MinigameOpen then return; end	
	local leftKeyPressed 	= IsControlPressed( 0, Keys[ 'LEFT' ] ) 	or 0
	local rightKeyPressed 	= IsControlPressed( 0, Keys[ 'RIGHT' ] )	or 0
	if 		IsControlPressed( 0, Keys[ 'G' ] ) 			then self:EndMinigame(false); end
	if 		IsControlPressed( 0, Keys[ 'Z' ] ) 			then rotSpeed 	=   0.1; modifier = 33;
  elseif 	IsControlPressed( 0, Keys[ 'LEFTSHIFT' ] )	then rotSpeed 	=   1.0; modifier = 50; 
  else 																 rotSpeed	=   0.4; modifier = 90; end

    local lockRotation = math.max(modifier / rotSpeed, 0.1)

    if leftKeyPressed ~= 0 or rightKeyPressed ~= 0 then
    	self.LockRotation = self.LockRotation - ( rotSpeed * tonumber( leftKeyPressed ) )
    	self.LockRotation = self.LockRotation + ( rotSpeed * tonumber( rightKeyPressed ) )
    	if (GetGameTimer() - self.Timer) > lockRotation then 
    		PlaySoundFrontend(0, self.Config.SafeTurnSound, self.Config.SafeSoundset, false)
    		self.Timer = GetGameTimer() 
    	end
    end
end

function safecracker:HandleMinigame(rewards) 
	if not self or not self.Config or not self.MinigameOpen then return; end

	local lockRot 		 = math.random(385.00, 705.00)	

	local lockNumbers 	 = {}
	local correctGuesses = {}

	lockNumbers[1] = 1
	lockNumbers[2] = math.random(					 45.0, 					359.0)
	lockNumbers[3] = math.random(lockNumbers[2] -	719.0, lockNumbers[2] - 405.0)
	lockNumbers[4] = math.random(lockNumbers[3] +  	 45.0, lockNumbers[3] + 359.0)

	-----------------------
	-- REDO LOCK NUMBERS --
	-----------------------
	-- Make numbers persist if chosen.
	-- Add number count for difficulty.
	-- Multiples of 2 are positive, 45 - 359;
	-- Multiples of 3 are negative, 719 - 405;
	-- Everything else is negative, 45 - 359;

	---------------------------------------------
	-- Still havn't done, you're welcome to ^^ --
	---------------------------------------------

	print("Here ya go, bloody cheater.")
	for i = 1,4 do
		print(math.floor((lockNumbers[i] % 360) / 3.60))
	end
	--------------------------------------
	-- Comment this out for a challenge --
	--------------------------------------

  local correctCount	= 1
  local hasRandomized	= false

  self.LockRotation = 0.0 + lockRot
								
	while self.MinigameOpen do	
		--				Texture Dictionary, Texture Name, xPos, yPos, xSize, ySize, 		   Heading,   R,   G,   B,   A,
		DrawSprite(self.Config.TextureDict, 		 "1",  0.8,  0.5,  0.15,  0.26, -self.LockRotation, 255, 255, 255, 255)
		DrawSprite(self.Config.TextureDict, 		 "2",  0.8,  0.5, 0.176, 0.306, 		      -0.0, 255, 255, 255, 255)	

		hasRandomized = true

		local lockVal = math.floor(self.LockRotation)

		if 		correctCount > 1 and 	correctCount < 5 and lockVal + (self.Config.LockTolerance * 3.60) < lockNumbers[correctCount - 1] and lockNumbers[correctCount - 1] < lockNumbers[correctCount] then self:EndMinigame(false, rewards); self.MinigameOpen = false; 
		elseif 	correctCount > 1 and 	correctCount < 5 and lockVal - (self.Config.LockTolerance * 3.60) > lockNumbers[correctCount - 1] and lockNumbers[correctCount - 1] > lockNumbers[correctCount] then self:EndMinigame(false, rewards); self.MinigameOpen = false; 
		elseif 	correctCount > 4 then 	self:EndMinigame(true, rewards)
		end

		for k,v in pairs(lockNumbers) do
		  	if not hasRandomized then self.LockRotation = lockRot; end
			if lockVal == v and correctCount == k then
				local canAdd = true
				for key,val in pairs(correctGuesses) do
					if val == lockVal and key == correctCount then
						canAdd = false
					end
				end

				if canAdd then 				
					PlaySoundFrontend(-1, self.Config.SafePinSound, self.Config.SafeSoundset, true)
					correctGuesses[correctCount] = lockVal
					correctCount = correctCount + 1; 
				end   				  			
			end
		end
		Citizen.Wait(0)
	end
end


function safecracker:EndMinigame(won, rewards)
	if not self or not self.Config or not self.MinigameOpen then return; end

	self.MinigameOpen = false	

	local msg = ""
	if won then 
		PlaySoundFrontend(self.SoundID, self.Config.SafeFinalSound, self.Config.SafeSoundset, true)
		msg = "You cracked the lock."
    if not self.StayClosed then
		  self:OpenSafeDoor()	
    end

		Citizen.Wait(100)

		PlaySoundFrontend(self.SoundID, self.Config.SafeOpenSound, self.Config.SafeSoundset, true)
		TriggerServerEvent('safecracker:AddReward', rewards)
		
	else	
		PlaySoundFrontend(self.SoundID, self.Config.SafeResetSound, self.Config.SafeSoundset, true)
		msg = "You failed to crack the lock."
	end

  FreezeEntityPosition(PlayerPedId(),false)

	TriggerEvent('esx:showNotification', msg)
  TriggerEvent('safecracker:EndMinigame', won)
end

RegisterNetEvent('safecracker:EndGame')
AddEventHandler('safecracker:EndGame', function() safecracker:EndMinigame(); end)

function safecracker:OpenSafeDoor()
  Citizen.CreateThread(function(...)
    local objs = ESX.Game.GetObjects()
    local doorHash = (GetHashKey(safecracker.SafeModels.Door) % 0x100000000)
    for k,v in pairs(objs) do
      if (GetEntityModel(v)% 0x100000000) == doorHash then 

        local doorHeading = GetEntityPhysicsHeading(v)
        local doorPosition = GetEntityCoords(v)

        SetEntityCollision(v, false, false)
        FreezeEntityPosition(v, false)

        local targetHeading = doorHeading + 150
        local tick = 0
        while targetHeading > GetEntityHeading(v) and tick < 500 do    
          tick = tick + 1
          SetEntityHeading(v, GetEntityHeading(v) + 0.3)
          SetEntityCoords(v, doorPosition, false, false, false, false)
          Citizen.Wait(0)
        end

        if not (GetEntityHeading(v) >= targetHeading) then SetEntityHeading(v, targetHeading); end
      end
    end  
  end)
end

function safecracker:SpawnSafeObject(table, position, heading)
	if not table then table = self.SafeObjects; end
	if not table or not position or not heading then return; end
	if type(table) ~= 'table' or type(position) ~= 'vector3' or type(heading) ~= 'number' then return; end

	self:LoadModelTable(self.SafeModels)

	local retTable = {}
	local i = 0
	for k,v in pairs(table) do
		i = i + 1
		local hash = GetHashKey(v.ModelName) % 0x100000000
		local newHeading = heading + v.Heading

		local newObj = CreateObject(hash, v.Pos.x + position.x, v.Pos.y + position.y, v.Pos.z + position.z, false, false, false)

		if v.ModelName == self.SafeModels.Door then 
			self.DoorObj = newObj
			self.DoorHeading = GetEntityHeading(self.DoorObj)
		end

		SetEntityAsMissionEntity(newObj, true)
		FreezeEntityPosition(newObj, true)
		SetEntityHeading(newObj, newHeading)

		if v.Rot.x ~= 0.0 or v.Rot.y ~= 0.0 or v.Rot.z ~= 0.0 then SetEntityRotation(newObj, v.Rot.x, v.Rot.y, v.Rot.z, 1, true); end
		retTable[v.ModelName] = newObj		
	end

	self:ReleaseModelTable(self.SafeModels)
	self.Objects = retTable
	return retTable
end

function safecracker:DelSafe()
	for k,v in pairs(self.Objects) do DeleteObject(v); end
end

RegisterNetEvent('safecracker:SpawnSafe')
AddEventHandler('safecracker:SpawnSafe', function(tab, pos, heading, cb) if cb then cb(safecracker:SpawnSafeObject(tab,pos,heading)) else safecracker:SpawnSafeObject(tab,pos,heading); end; end)

function safecracker:LoadModelTable(table)
  if type(table) ~= 'table' then return false; end
  for k,v in pairs(table) do
    if type(v) == 'string' then
      local hk = GetHashKey(v)
      while not HasModelLoaded(hk) do
        RequestModel(hk)
        Citizen.Wait(0)
      end
    end
  end
  return true
end

function safecracker:ReleaseModelTable(table)
  if type(table) ~= 'table' then return false; end
  for k,v in pairs(table) do
    if type(v) == 'string' then
      local hk = GetHashKey(v)
      if HasModelLoaded(hk) then
        SetModelAsNoLongerNeeded(hk)
      end
    end
  end
  return true
end