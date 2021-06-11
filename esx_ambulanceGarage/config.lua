

Config = {}

Config.Locale = 'en'

Config.KeyToOpenCarGarage = 38			-- default 38 is E
Config.KeyToOpenHeliGarage = 38			-- default 38 is E
Config.KeyToOpenBoatGarage = 38			-- default 38 is E
Config.KeyToOpenExtraGarage = 38		-- default 38 is E

Config.ambulanceDatabaseName = 'ambulance'	-- set the exact name from your jobs database for ambulance

--ambulance Car Garage:
Config.CarZones = {
	ambulanceCarGarage = {
		Pos = {
			{x = 337.228, y = -579.565, z = 28.797},
			{x =288.85, y =-586.86, z =43.15},
			{x =296.6, y =-1438.28, z =29.8},
			{x =1219.9, y =-1516.41, z =34.7},
			{x =224.33, y =-1632.87, z =29.27},
			{x =1807.45, y =3682.08, z =34.22},
			{x =1837.97, y =3660.82, z =34.13},
			{x =-241.79, y =6336.6, z =32.38},
			{x =-353.15, y =6126.76, z =31.44},
			{x =-873.88, y =-293.66, z =40.01},
			{x =-677.88, y =290.27, z =82.05},
			{x =-467.7, y =-338.95, z =34.37},
			{x =1696.59, y =3603.08, z =35.54},
			{x =-1472.75, y =-1032.61, z =5.69},
			{x =275.31, y =-326.76, z =44.92},
			{x =1696.59, y =3603.08, z =35.54},
			{x =-829.16, y =-1218.17, z =6.9},
		}
	}
}

--ambulance Heli Garage:
Config.HeliZones = {
	ambulanceHeliGarage = {
		Pos = {
			{x = 448.65,  y = -981.25, z = -43.69},
			{x = 632.216,  y = -156.131, z = -54.037},
			{x =351.03, y =-589.42, z =74.17},
			{x =-724.44, y =-1443.69, z =5.0},
			{x =313.28, y =-1465.68, z =46.51},
			{x =-475.5, y =5988.18, z =31.34},
			{x =1829.58, y =3631.98, z =34.4},
			{x =-1497.05, y =-1051.26, z =5.73},
			{x =-791.20, y=-1191.6, z =53.02},
			
		}
	}
}

--ambulance Boat Garage:
Config.BoatZones = {
	ambulanceBoatGarage = {
		Pos = {
			{x =-715.77, y =-1329.03, z =-0.40},
			{x =5.42, y =-2774.4, z =0.15},
			{x =-486.99, y =6494.27, z =-0.50},
			{x =705.86, y =4093.21, z =29.85},
			{x =-2084.7, y =2601.81, z =-0.47},
			{ x = 713.59, y = 4093.89, z = 33.73 },
			{ x = -483.74, y = 6488.42, z = 0.27 },
			{ x = 3370.43, y = 5184.11, z = 0.46 },
			{x =-1626.53, y =-1182.76, z =0.30},
		}
	}
}

-- ambulance Car Garage Marker Settings:
Config.ambulanceCarMarker = 27 												-- marker type
Config.ambulanceCarMarkerColor = { r = 50, g = 50, b = 204, a = 100 } 			-- rgba color of the marker
Config.ambulanceCarMarkerScale = { x = 1.5, y = 1.5, z = 1.0 }  				-- the scale for the marker on the x, y and z axis
Config.CarDraw3DText = "[E] To open the garage"			-- set your desired text here

-- ambulance Heli Garage Marker Settings:
Config.ambulanceHeliMarker = 27 												-- marker type
Config.ambulanceHeliMarkerColor = { r = 50, g = 50, b = 204, a = 100 } 		-- rgba color of the marker
Config.ambulanceHeliMarkerScale = { x = 5.5, y = 5.5, z = 1.0 }  				-- the scale for the marker on the x, y and z axis
Config.HeliDraw3DText = "[E] To open the garage"		-- set your desired text here

-- ambulance Boat Garage Marker Settings:
Config.ambulanceBoatMarker = 27 												-- marker type
Config.ambulanceBoatMarkerColor = { r = 50, g = 50, b = 204, a = 100 } 		-- rgba color of the marker
Config.ambulanceBoatMarkerScale = { x = 3.0, y = 3.0, z = 1.0 }  				-- the scale for the marker on the x, y and z axis
Config.BoatDraw3DText = "[E] To open the garage"		-- set your desired text here

-- ambulance Cars:
Config.ambulanceVehicles = {	
	{model = 'emsa', label = ('Ambulance')},
	{model = 'emsnspeedo', label = ('Ambulance Speedo')},
	{model = 'emst', label = ('EMS Tahoe')},
	{model = 'emsc', label = ('EMS Charger')},
	{model = 'emsf', label = ('EMS F350')},
	{model = 'emsv', label = ('Coroner Van')},
	{model = 'romero', label = ('Hearse')},
	{model = 'lguard', label = ('Lifeguard SUV')},
	{model = 'blazer2', label = ('Lifeguard Quad')},
}

-- ambulance Helicopters:
Config.ambulanceHelicopters = {
	{ model = 'emsaw139', label = 'EMS Saw', livery = 0, price = 0 },
	{ model = 'seasparrow', label = 'Sea Sparrow', livery = 0, price = 0 },
}

-- ambulance Boats:
Config.ambulanceBoats = {
	{ model = 'seashark2', label = 'Lifeguard Seashark', livery = 0, price = 0 },
	{ model = 'dinghy4', label = 'Dinghy', livery = 0, price = 0 },
}

-- Menu Labels & Titles:
Config.LabelStoreVeh = "Returning a Vehicle"
Config.LabelGetVeh = "Take a vehicle"
Config.LabelPrimaryCol = "Primary"
Config.LabelSecondaryCol = "Secondary"
Config.LabelExtra = "Extra"
Config.LabelLivery = "Livery"
Config.TitleambulanceGarage = "EMS Garage"
Config.TitleambulanceExtra = "Extra"
Config.TitleambulanceLivery = "Livery"
Config.TitleColorType = "Color Type"
Config.TitleValues = "Value"

-- ESX.ShowNotifications:
Config.VehicleParked = "Your vehicle is put away"
Config.NoVehicleNearby = "You don't have a vehicle"
Config.CarOutFromPolGar = "You took out a Vehicle from the Garage"
Config.HeliOutFromPolGar = "You took out a Helicopter from the Heli Garage"
Config.BoatOutFromPolGar = "You took out a Boat from the Boat Garage!"

Config.VehicleLoadText = "Wait for vehicle to spawn"			-- text on screen when vehicle model is being loaded

-- Distance from garage marker to the point where /fix and /clean shall work
Config.Distance = 20

Config.DrawDistance      = 100.0
Config.TriggerDistance 	 = 3.0
Config.Marker 			 = {Type = 27, r = 0, g = 127, b = 22}