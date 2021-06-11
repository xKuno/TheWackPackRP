local TeleportFromTo = {
	["PillboxElevator"] = {
		positionFrom = { ['x'] = 329.95, ['y'] = -600.98, ['z'] = 43.29, nom = "Roof"}, 
		positionTo = { ['x'] = 340.08, ['y'] = -582.68, ['z'] = 74.166, nom = "Main Floor"},
	},
	["PillboxElevator2"] = {
		positionFrom = { ['x'] = 345.168, ['y'] = -586.451, ['z'] = 28.797, nom = "Roof"}, 
		positionTo = { ['x'] = 338.99, ['y'] = -585.49, ['z'] = 74.166, nom = "Lower Pillbox"},
	},
    ["Pillbox Entrance LowerLevel Elevators"] = {
		positionFrom = { ['x'] =346.55, ['y'] = -582.744, ['z'] = 28.797, nom = "Enter"},
		positionTo = { ['x'] = 332.04, ['y'] = -595.49, ['z'] = 43.317, nom = "Lower Pillbox"},
    },
	["Pillbox Back Exit Elevators"] = {
		positionFrom = { ['x'] =327.26, ['y'] = -603.65, ['z'] = 43.29, nom = "Garage"},
		positionTo = { ['x'] = 340.58, ['y'] = -580.79, ['z'] = 28.8, nom = "Enter"},
    },
	["ViceroyElevator"] = {
		positionFrom = { ['x'] = -794.24, ['y'] = -1245.79, ['z'] = 7.52, nom = "Roof"}, 
		positionTo = { ['x'] = -773.89, ['y'] = -1207.31, ['z'] = 51.33, nom = "Main Floor"},
	},
	["Weazel News Little Seoul"] = {
		positionFrom = { ['x'] = -588.81, ['y'] = -929.54, ['z'] = 23.87, nom = "Enter"},
		positionTo = { ['x'] = -588.81, ['y'] = -929.54, ['z'] = 28.16, nom = "Exit"},
	},
    ["BahamaMammas"] = {
		positionFrom = { ['x'] = -1389.0, ['y'] = -585.99, ['z'] = 30.22, nom = "Enter"},
		positionTo = { ['x'] = -1387.54, ['y'] = -588.23, ['z'] = 30.32, nom = "Exit"},
    },
    ["Morgue"] = {
		positionFrom = { ['x'] = 294.7, ['y'] = -1448.1, ['z'] = 30.0, nom = "Enter Hospital"},
		positionTo = { ['x'] = 275.42, ['y'] = -1361.23, ['z'] = 24.54, nom = "Exit Hospital"},
	},
    ["CasinoDiamondEnter"] = {
		positionFrom = { ['x'] = 935.93, ['y'] = 46.86, ['z'] = 81.10, nom = "Enter"},
		positionTo = { ['x'] = 1089.65, ['y'] = 206.74, ['z'] = -49.0, nom = "Exit"},
	},
	["CasinoDiamondStaff"] = {
		positionFrom = { ['x'] = 1120.94, ['y'] = 214.74, ['z'] = -49.44, nom = "Enter"},
		positionTo = { ['x'] = 1120.8, ['y'] = 222.01, ['z'] = -49.44, nom = "Exit"},
	},
    ["Penthouse"] = {
		positionFrom = { ['x'] = 967.12, ['y'] = 64.19, ['z'] = 112.58, nom = "Enter Penthouse"},
		positionTo = { ['x'] = 970.6, ['y'] = 62.90, ['z'] = 112.66, nom = "Enter Rooftop"},
	},
	["Penthouse2"] = {
		positionFrom = { ['x'] = 1086.00, ['y'] = 215.0, ['z'] = -49.2, nom = "Enter Penthouse"},
		positionTo = { ['x'] = 964.67, ['y'] = 58.64, ['z'] = 112.58, nom = "Enter Casino"},
	},
    ["Penthouse3"] = {
		positionFrom = { ['x'] = 1119.46, ['y'] = 266.69, ['z'] = -51.04, nom = "Enter Penthouse"},
		positionTo = { ['x'] = 980.0, ['y'] = 57.0, ['z'] = 116.17, nom = "Enter Casino / Office"},
	},
	["VespccuiPD"] = {
		positionFrom = { ['x'] = -1098.55, ['y'] = -829.83, ['z'] = 19.5, nom = "Go Down"},
		positionTo = { ['x'] = -1158.66, ['y'] = -856.89, ['z'] = 3.95, nom = "Go Up"},
	},
	["ClubTech"] = {
		positionFrom = { ['x'] =345.94, ['y'] = -977.72, ['z'] = 29.37, nom = "Enter"},
		positionTo = { ['x'] = -1569.39, ['y'] = -3016.89, ['z'] = -74.41, nom = "Exit"},
	},

}

Drawing = setmetatable({}, Drawing)
Drawing.__index = Drawing


function Drawing.draw3DText(x,y,z,textInput,fontId,scaleX,scaleY,r, g, b, a)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*7
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(r, g, b, a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+0.3, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function Drawing.drawMissionText(m_text, showtime)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(m_text)
    DrawSubtitleTimed(showtime, 1)
end

function msginf(msg, duree)
    duree = duree or 500
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(msg)
    DrawSubtitleTimed(duree, 1)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local pos = GetEntityCoords(PlayerPedId(), true)

		for k, j in pairs(TeleportFromTo) do

			--msginf(k .. " " .. tostring(j.positionFrom.x), 15000)
			if(Vdist(pos.x, pos.y, pos.z, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z) < 100.0)then
				local hidden = false
				if j.positionFrom.hidden ~= nil then
					hidden = j.positionFrom.hidden
				end
				if not hidden then
					DrawMarker(27, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, .801, 36, 36, 35,255, 0, 0, 0,0)
				end
				if(Vdist(pos.x, pos.y, pos.z, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z) < 5.0)then
					if not hidden then
--						Drawing.draw3DText(j.positionFrom.x, j.positionFrom.y, j.positionFrom.z - 1.100, j.positionFrom.nom, 1, 0.2, 0.1, 255, 255, 255, 215)
					end
					if(Vdist(pos.x, pos.y, pos.z, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z) < 2.0)then
						ClearPrints()
						if not hidden then
    						SetTextEntry_2("STRING")
  	    					AddTextComponentString("Press ~r~E~w~ to ".. j.positionFrom.nom)
							DrawSubtitleTimed(100, 1)
						end
						if IsControlJustPressed(1, 38) then
							DoScreenFadeOut(500)
							Citizen.Wait(1000)
							SetEntityCoords(PlayerPedId(), j.positionTo.x, j.positionTo.y, j.positionTo.z - 1)
							if j.positionFrom.heading ~= nil then
								SetEntityHeading(PlayerPedId(), j.positionFrom.heading)
							end
							DoScreenFadeIn(500)
						end
					end
				end
			end

			if(Vdist(pos.x, pos.y, pos.z, j.positionTo.x, j.positionTo.y, j.positionTo.z) < 100.0)then
				local hidden = false
				if j.positionTo.hidden ~= nil then
					hidden = j.positionTo.hidden
				end
				if not hidden then
					DrawMarker(27, j.positionTo.x, j.positionTo.y, j.positionTo.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, .801, 36,36, 35,255, 0, 0, 0,0)
				end
				if(Vdist(pos.x, pos.y, pos.z, j.positionTo.x, j.positionTo.y, j.positionTo.z) < 5.0)then
					if not hidden then
--						Drawing.draw3DText(j.positionTo.x, j.positionTo.y, j.positionTo.z - 1.100, j.positionTo.nom, 1, 0.2, 0.1, 255, 255, 255, 215)
					end
					if(Vdist(pos.x, pos.y, pos.z, j.positionTo.x, j.positionTo.y, j.positionTo.z) < 2.0)then
						ClearPrints()
						if not hidden then
							SetTextEntry_2("STRING")
							AddTextComponentString("Press ~r~E~w~ to ".. j.positionTo.nom)
							DrawSubtitleTimed(100, 1)
						end
						if IsControlJustPressed(1, 38) then
							DoScreenFadeOut(500)
							Citizen.Wait(1000)
							SetEntityCoords(PlayerPedId(), j.positionFrom.x, j.positionFrom.y, j.positionFrom.z - 1)
							if j.positionTo.heading ~= nil then
								SetEntityHeading(PlayerPedId(), j.positionTo.heading)
							end
							DoScreenFadeIn(500)
						end
					end
				end
			end
		end
	end
end)
