--CONFIG--
local fov_max = 150.0
local fov_min = 7.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 10.0 -- camera zoom speed
local speed_lr = 8.0 -- speed by which the camera pans left-right 
local speed_ud = 8.0 -- speed by which the camera pans up-down

local usingBinoc = false
local usingCamera = false
local fov = (fov_max+fov_min)*0.5
local vision_state = 0 -- 0 is normal, 1 is nightmode, 2 is thermal vision

--THREADS--

Citizen.CreateThread(function()
	while true do

        Citizen.Wait(10)

		local playerPed = PlayerPedId()
		
		if usingBinoc then

			if not IsPedSittingInAnyVehicle(playerPed) then
				TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_BINOCULARS", 0, 1)
				PlayAmbientSpeech1(playerPed, "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
				else
			end	

			Wait(2000)

			SetTimecycleModifier("heliGunCam")

			SetTimecycleModifierStrength(0.3)

			local scaleform = RequestScaleformMovie("HELI_CAM")

			while not HasScaleformMovieLoaded(scaleform) do
				Citizen.Wait(10)
			end

			local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

			AttachCamToEntity(cam, playerPed, 0.0,0.0,1.0, true)
			SetCamRot(cam, 0.0,0.0,GetEntityHeading(playerPed))
			SetCamFov(cam, fov)
			RenderScriptCams(true, false, 0, 1, 0)
			PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
			PushScaleformMovieFunctionParameterInt(0) -- 0 for nothing, 1 for LSPD logo
			PopScaleformMovieFunctionVoid()

			while usingBinoc and not IsEntityDead(playerPed) do

				if IsControlJustPressed(0, 177) then -- Toggle usingBinoc
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					ClearPedTasks(playerPed)
					usingBinoc = false
				end
					
				local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)

				CheckInputRotation(cam, zoomvalue)

				HandleZoom(cam)
				HideHUDThisFrame()

				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
				Citizen.Wait(10)

			end

			usingBinoc = false

			ClearTimecycleModifier()

			fov = (fov_max+fov_min)*0.5

			RenderScriptCams(false, false, 0, 1, 0)

			SetScaleformMovieAsNoLongerNeeded(scaleform)

			DestroyCam(cam, false)
			SetNightvision(false)
			SetSeethrough(false)
		end
	end
end)

Citizen.CreateThread(function()
	while true do

        Citizen.Wait(10)

		local playerPed = PlayerPedId()
		
		if usingCamera then

			if not IsPedSittingInAnyVehicle(playerPed) then
				TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_PAPARAZZI", 0, false)
				else
			end	

			Wait(2000)

			local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

			AttachCamToEntity(cam, playerPed, 0.0,0.0,1.0, true)
			SetCamRot(cam, 0.0,0.0,GetEntityHeading(playerPed))
			SetCamFov(cam, fov)
			RenderScriptCams(true, false, 0, 1, 0)

			while usingCamera and not IsEntityDead(playerPed) do

				if IsControlJustPressed(0, 177) then
					ClearPedTasks(playerPed)
					usingCamera = false
				end

				if IsControlJustPressed(0, 47) then
					TriggerServerEvent('camera:TakePhoto')
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'Photo taken.'})
					TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3, 'photo', 1.0)
				end
					
				local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)

				CheckInputRotation(cam, zoomvalue)

				HandleZoom(cam)
				HideHUDThisFrame()

				Citizen.Wait(10)

			end

			usingCamera = false

			ClearTimecycleModifier()

			fov = (fov_max+fov_min)*0.5

			RenderScriptCams(false, false, 0, 1, 0)

			SetScaleformMovieAsNoLongerNeeded(scaleform)

			DestroyCam(cam, false)
			SetNightvision(false)
			SetSeethrough(false)
		end
	end
end)

--EVENTS--

RegisterNetEvent('binoculars:Active')
AddEventHandler('binoculars:Active', function()
	usingBinoc = not usingBinoc
end)

RegisterNetEvent('camera:Active')
AddEventHandler('camera:Active', function()
	usingCamera = not usingCamera
	TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 2500, text = 'Press [G] to take a photo.'})
end)

--FUNCTIONS--

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudComponentThisFrame(19) -- weapon wheel
	HideHudComponentThisFrame(1) -- Wanted Stars
	HideHudComponentThisFrame(2) -- Weapon icon
	HideHudComponentThisFrame(3) -- Cash
	HideHudComponentThisFrame(4) -- MP CASH
	HideHudComponentThisFrame(13) -- Cash Change
	HideHudComponentThisFrame(11) -- Floating Help Text
	HideHudComponentThisFrame(12) -- more floating help text
	HideHudComponentThisFrame(15) -- Subtitle Text
	HideHudComponentThisFrame(18) -- Game Stream
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	local playerPed = PlayerPedId()
	if not ( IsPedSittingInAnyVehicle( playerPed ) ) then

		if IsControlJustPressed(0,32) then
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,8) then
			fov = math.min(fov + zoomspeed, fov_max)	
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	else
		if IsControlJustPressed(0,241) then
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,242) then
			fov = math.min(fov + zoomspeed, fov_max)	
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05) 
	end
end

function GetVehicleInView(cam)
	local coords = GetCamCoord(cam)
	local forward_vector = RotAnglesToVec(GetCamRot(cam, 2))
	local rayhandle = CastRayPointToPoint(coords, coords+(forward_vector*200.0), 10, GetVehiclePedIsIn(PlayerPedId()), 0)
	local _, _, _, _, entityHit = GetRaycastResult(rayhandle)
	if entityHit>0 and IsEntityAVehicle(entityHit) then
		return entityHit
	else
		return nil
	end
end

function RotAnglesToVec(rot)
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end