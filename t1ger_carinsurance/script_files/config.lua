-------------------------------------
------- Created by T1GER#9080 -------
------------------------------------- 

Config = {}

Config.GETSHAREDOBJECT = "esx:getSharedObject"

Config.InsCompany = {{
	Pos = {-291.38,-429.7,30.24},
	Key = 38,
	Marker = {
		Enable = true,
		DrawDist = 10.0,
		Type = 27,
		Scale = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 240, g = 52, b = 52, a = 100},
	}
}}

Config.Blip = {{
	Enable 	= false,
	Pos 	= {-291.38,-429.7,30.24},
	Sprite 	= 523,
	Color 	= 3,
	Name 	= "Insurance",
	Scale 	= 0.8,
	Display = 4,
}}

Config.KeyToHidePaper	= 177			-- set key control to hide insurance paper, when it's opened
Config.ProgBarWaitTime	= 2				-- set progbar wait time on buying/cancelling insurance (at least 2 seconds is recommended for fetching data purposes)
Config.ShopMenuAlign 	= "right"		-- set allignment of insurance shop menu
Config.VehCheckChatMSG	= true			-- set to false if u want to use any other kind of notification instead of chat message upon checking a plate
Config.DistToShow		= 2.0			-- set distance between player 1 and player 2 when showing insurance paper to each other.
Config.PaymentFactor	= 1				-- set percent of vehicle price that player has to pay for a vehicle in insurances, 5 means: 5/100 = 0,05 (which is then multiplied with vehicle price)
Config.PoliceJobLabel	= "police"		-- database name for police job

-- DB SETTINGS:
Config.OwnedVehicles = 'owned_vehicles'	-- set name of owned vehicles table from you db