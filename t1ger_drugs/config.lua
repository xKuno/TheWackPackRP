-------------------------------------
------- Created by T1GER#9080 -------
------------------------------------- 

Config = {}

-- General Settings:
Config.ESXSHAREDOBJECT 	= "esx:getSharedObject"	-- Change your getshared object event here, in case you are using anti-cheat.
Config.HasItemLabel		= true					-- set to false if your ESX doesn't support item labels.

-- Police Settings:
Config.PoliceJobs = {"police"}	-- Jobs that can't do bankrobberies etc, but can secure the banks.
Config.PoliceAlerts	= true			-- enable police alerts upon lockpicking in drug job
Config.AlertBlipShow = true			-- enable or disable blip on map on police notify
Config.AlertBlipTime = 20			-- miliseconds that blip is active on map (this value is multiplied with 4 in the script)
Config.AlertBlipRadius = 50.0		-- set radius of the police notify blip
Config.AlertBlipAlpha = 250			-- set alpha of the blip
Config.AlertBlipColor = 3			-- set blip color

-- General Job Settings:
Config.DrugJob_Item 		= "drugItem"		-- item (USB) to start jobs
Config.RequiredCopsForJob 	= 2					-- set amount of cops required to start jobs.
Config.AllowCopsToDoJobs 	= false				-- set to true to allow police doing jobs.
Config.UsePhoneMSG 			= false 			-- Enable to receive job msg through phone, disable to use ESX.ShowNotification or anything else you'd like.
Config.mHacking 			= {enable = false, blocks = 5, time = 30}
Config.PayJobFeesWithCash 	= true			-- set to false to pay with bank money
Config.EnableCooldown		= true				-- Enable / disable cooldown feature
Config.CooldownTime 		= 5					-- Set cooldown time to wait before each drug jobs
Config.USB_CorruptChance	= 50				-- set chance in % for USB to corrupt after usage.
Config.EnableHeadshotKills 	= false 			-- Enable/Disable whether a player can headshot kill an NPC in one shot.
Config.EnableVehicleAlarm	= true				-- Enable/Disable vehicle clarm upon lockpicking 
Config.VehicleAlarmTime		= 60				-- Set duration of vehicle alarm upon lockpicking, in seconds.
Config.LockpickTime			= 10					-- Set duration of lockpicking, in seconds.

-- Drug USB Menu:
Config.DrugMenu = {
	[1] = {drug = 'drugcoke', label = 'Coke', enable = true, job_fees = 8500, reward = {min = 1, max = 2}},
	[2] = {drug = 'drugmeth', label = 'Meth', enable = true, job_fees = 5500, reward = {min = 2, max = 4}},
	[3] = {drug = 'drugweed', label = 'Weed', enable = true, job_fees = 3500, reward = {min = 4, max = 8}},
}

-- Drug Jobs:
Config.DrugJobs = {
	[1] = {
		pos = {-1027.39,-486.68,36.96,26.08},
		inUse = false, veh_spawned = false, goons_spawned = false, player = false,
		goons = {
			[1] = {pos = {-1024.58,-501.66,40.13,70.56}, ped = 'G_M_Y_MexGang_01', anim = {dict = 'amb@world_human_cop_idles@female@base', lib = 'base'}, weapon = 'WEAPON_CARBINERIFLE', armour = 100, accuracy = 60 },
			[2] = {pos = {-1038.13,-501.78,36.03,83.65}, ped = 'G_M_Y_MexGang_01', anim = {dict = 'rcmme_amanda1', lib = 'stand_loop_cop'}, weapon = 'WEAPON_MICROSMG', armour = 100, accuracy = 60 },
			[3] = {pos = {-1038.34,-495.03,36.6,102.75}, ped = 'G_M_Y_MexGang_01', anim = {dict = 'amb@world_human_leaning@male@wall@back@legs_crossed@base', lib = 'base'}, weapon = 'WEAPON_PISTOL', armour = 100, accuracy = 60 },
			[4] = {pos = {-1032.96,-488.35,36.9,113.14}, ped = 'G_M_Y_MexGang_01', anim = {dict = 'amb@world_human_cop_idles@female@base', lib = 'base'}, weapon = 'WEAPON_PISTOL', armour = 100, accuracy = 60 },
			[4] = {pos = {-1025.87,-484.53,36.95,301.06}, ped = 'G_M_Y_MexGang_01', anim = {dict = 'amb@world_human_cop_idles@female@base', lib = 'base'}, weapon = 'WEAPON_KNIFE', armour = 100, accuracy = 60 },
		},
		lockpick = {-1028.99,-486.64,36.95,298.12},
		blip = {sprite = 1, color = 1, scale = 0.65, label = "Drug Job", route = true},
	},
	[2] = {
		pos = {-356.15,32.53,47.83,259.21},
		inUse = false, veh_spawned = false, goons_spawned = false, player = false,
		goons = {
			[1] = {pos = {-375.91,44.58,54.43,124.95}, ped = 'G_M_Y_SalvaBoss_01', anim = {dict = 'amb@world_human_cop_idles@female@base', lib = 'base'}, weapon = 'WEAPON_CARBINERIFLE', armour = 100, accuracy = 60 },
			[2] = {pos = {-348.99,34.94,52.11,89.41}, ped = 'G_M_Y_SalvaBoss_01', anim = {dict = 'rcmme_amanda1', lib = 'stand_loop_cop'}, weapon = 'WEAPON_MICROSMG', armour = 100, accuracy = 60 },
			[3] = {pos = {-374.99,23.94,55.97,15.23}, ped = 'G_M_Y_SalvaBoss_01', anim = {dict = 'amb@world_human_leaning@male@wall@back@legs_crossed@base', lib = 'base'}, weapon = 'WEAPON_PISTOL50', armour = 100, accuracy = 60 },
			[4] = {pos = {-359.29,33.05,47.85,93.97}, ped = 'G_M_Y_SalvaBoss_01', anim = {dict = 'amb@world_human_cop_idles@female@base', lib = 'base'}, weapon = 'WEAPON_PISTOL50', armour = 100, accuracy = 60 },
			[5] = {pos = {-356.88,15.76,47.85,255.43}, ped = 'G_M_Y_SalvaBoss_01', anim = {dict = 'rcmme_amanda1', lib = 'stand_loop_cop'}, weapon = 'WEAPON_DBSHOTGUN', armour = 100, accuracy = 60 },
			[6] = {pos = {-339.41,31.55,47.86,86.55}, ped = 'G_M_Y_SalvaBoss_01', anim = {dict = 'rcmme_amanda1', lib = 'stand_loop_cop'}, weapon = 'WEAPON_PISTOL', armour = 100, accuracy = 60 },
			[7] = {pos = {-341.56,21.89,47.86,70.4}, ped = 'G_M_Y_SalvaBoss_01', anim = {dict = 'rcmme_amanda1', lib = 'stand_loop_cop'}, weapon = 'WEAPON_PISTOL', armour = 100, accuracy = 60 },
			[8] = {pos = {-353.19,42.64,47.96,172.8}, ped = 'G_M_Y_SalvaBoss_01', anim = {dict = 'rcmme_amanda1', lib = 'stand_loop_cop'}, weapon = 'WEAPON_PISTOL', armour = 100, accuracy = 60 },
		},
		lockpick = {-355.06,34.21,47.81,175.44},
		blip = {sprite = 1, color = 1, scale = 0.65, label = "Drug Job", route = true},
	},
	[3] = {
		pos = {-679.55,5797.94,17.33,244.95},
		inUse = false, veh_spawned = false, goons_spawned = false, player = false,
		goons = {
			[1] = {pos = {-679.20,5801.80,19.74,188.85}, ped = 'G_M_Y_Lost_02', anim = {dict = 'amb@world_human_cop_idles@female@base', lib = 'base'}, weapon = 'WEAPON_PISTOL', armour = 100, accuracy = 60 },
			[2] = {pos = {-684.60,5796.04,17.33,155.99}, ped = 'G_M_Y_Lost_02', anim = {dict = 'rcmme_amanda1', lib = 'stand_loop_cop'}, weapon = 'WEAPON_PISTOL', armour = 100, accuracy = 60 },
			[3] = {pos = {-669.90,5796.82,17.33,133.18}, ped = 'G_M_Y_Lost_02', anim = {dict = 'amb@world_human_leaning@male@wall@back@legs_crossed@base', lib = 'base'}, weapon = 'WEAPON_PISTOL', armour = 100, accuracy = 60 },
			[4] = {pos = {-676.41,5790.30,17.33,238.11}, ped = 'G_M_Y_Lost_02', anim = {dict = 'amb@world_human_cop_idles@female@base', lib = 'base'}, weapon = 'WEAPON_PISTOL', armour = 100, accuracy = 60 },
		},
		lockpick = {-678.38,5798.88,17.33,163.68},
		blip = {sprite = 1, color = 1, scale = 0.65, label = "Drug Job", route = true},
	},
	[4] = {
		pos = {1732.01,3314.65,41.24,193.94},
		inUse = false, veh_spawned = false, goons_spawned = false, player = false,
		goons = {
			[1] = {pos = {1702.44,3290.56,52.81,268.27}, ped = 'G_M_Y_Lost_02', anim = {dict = 'amb@world_human_cop_idles@female@base', lib = 'base'}, weapon = 'WEAPON_SNIPERRIFLE', armour = 40, accuracy = 20 },
			[2] = {pos = {1727.43,3294.69,41.22,219.85}, ped = 'G_M_Y_Lost_02', anim = {dict = 'rcmme_amanda1', lib = 'stand_loop_cop'}, weapon = 'WEAPON_MICROSMG', armour = 100, accuracy = 60 },
			[3] = {pos = {1742.19,3299.43,41.22,180.02}, ped = 'G_M_Y_Lost_02', anim = {dict = 'amb@world_human_leaning@male@wall@back@legs_crossed@base', lib = 'base'}, weapon = 'WEAPON_MICROSMG', armour = 100, accuracy = 60 },
			[4] = {pos = {1735.91,3296.67,41.22,203.54}, ped = 'G_M_Y_Lost_02', anim = {dict = 'amb@world_human_cop_idles@female@base', lib = 'base'}, weapon = 'WEAPON_MICROSMG', armour = 100, accuracy = 70 },
			[5] = {pos = {1690.83,3287.8,41.15,217.21}, ped = 'G_M_Y_Lost_02', anim = {dict = 'amb@world_human_cop_idles@female@base', lib = 'base'}, weapon = 'WEAPON_MICROSMG', armour = 100, accuracy = 50 },
			[6] = {pos = {1688.73,3286.01,41.15,243.33}, ped = 'G_M_Y_Lost_02', anim = {dict = 'amb@world_human_cop_idles@female@base', lib = 'base'}, weapon = 'WEAPON_DBSHOTGUN', armour = 100, accuracy = 50 },
			[7] = {pos = {1719.72,3286.15,41.53,210.45}, ped = 'G_M_Y_Lost_02', anim = {dict = 'amb@world_human_cop_idles@female@base', lib = 'base'}, weapon = 'WEAPON_CARBINERIFLE', armour = 100, accuracy = 60 },
		},
		lockpick = {1734.11,3314.42,41.22,102.92},
		blip = {sprite = 1, color = 1, scale = 0.65, label = "Drug Job", route = true},
	},
	[5] = {
		pos = {-1070.08,-1672.12,4.47,31.27},
		inUse = false, veh_spawned = false, goons_spawned = false, player = false,
		goons = {
			[1] = {pos = {-1080.76,-1666.12,14.19,26.18}, ped = 'G_M_Y_Lost_02', anim = {dict = 'rcmme_amanda1', lib = 'stand_loop_cop'}, weapon = 'WEAPON_SNIPERRIFLE', armour = 40, accuracy = 20 },
			[2] = {pos = {-1072.22,-1658.91,7.23,126.44}, ped = 'G_M_Y_Lost_02', anim = {dict = 'rcmme_amanda1', lib = 'stand_loop_cop'}, weapon = 'WEAPON_MICROSMG', armour = 100, accuracy = 60 },
			[3] = {pos = {-1090.42,-1651.96,10.37,294.82}, ped = 'G_M_Y_Lost_02', anim = {dict = 'rcmme_amanda1', lib = 'stand_loop_cop'}, weapon = 'WEAPON_MICROSMG', armour = 100, accuracy = 60 },
			[4] = {pos = {-1084.75,-1671.43,4.7,305.41}, ped = 'G_M_Y_Lost_02', anim = {dict = 'rcmme_amanda1', lib = 'stand_loop_cop'}, weapon = 'WEAPON_MICROSMG', armour = 100, accuracy = 70 },
			[5] = {pos = {-1134.54,-1592.14,7.51,2.46}, ped = 'G_M_Y_Lost_02', anim = {dict = 'rcmme_amanda1', lib = 'stand_loop_cop'}, weapon = 'WEAPON_MICROSMG', armour = 100, accuracy = 50 },
			[6] = {pos = {-1138.65,-1569.86,11.09,218.79}, ped = 'G_M_Y_Lost_02', anim = {dict = 'rcmme_amanda1', lib = 'stand_loop_cop'}, weapon = 'WEAPON_CARBINERIFLE', armour = 100, accuracy = 50 },
			[7] = {pos = {-1108.93,-1571.76,12.38,346.61}, ped = 'G_M_Y_Lost_02', anim = {dict = 'rcmme_amanda1', lib = 'stand_loop_cop'}, weapon = 'weapon_assaultrifle_mk2', armour = 100, accuracy = 60 },
			[8] = {pos = {-1127.22,-1605.68,4.4,317.59}, ped = 'G_M_Y_Lost_02', anim = {dict = 'rcmme_amanda1', lib = 'stand_loop_cop'}, weapon = 'weapon_ceramicpistol', armour = 100, accuracy = 60 },
			[9] = {pos = {-1106.39,-1601.5,4.67,133.15}, ped = 'G_M_Y_Lost_02', anim = {dict = 'rcmme_amanda1', lib = 'stand_loop_cop'}, weapon = 'weapon_autoshotgun', armour = 100, accuracy = 60 },
		},
		lockpick = {-1072.15,-1672.61,4.47,301.23},
		blip = {sprite = 1, color = 1, scale = 0.65, label = "Drug Job", route = true},
	},
}

-- Job Vehicles Randomizer:
Config.JobVehicles = {'rumpo2'}

-- Delivery Config:
Config.Delivery = {
	[1] = {
		pos = {1243.63,-3263.36,5.59},
		marker = {drawDist = 10.0, type = 27, scale = {x = 3.0, y = 3.0, z = 1.0}, color = {r = 240, g = 52, b = 52, a = 100}},
		blip = {sprite = 1, color = 1, label = "Delivery Spot", scale = 0.75, route = true}
	},
	[2] = {
		pos = {1016.09,-2904.82,5.9},
		marker = {drawDist = 10.0, type = 27, scale = {x = 3.0, y = 3.0, z = 1.0}, color = {r = 240, g = 52, b = 52, a = 100}},
		blip = {sprite = 1, color = 1, label = "Delivery Spot", scale = 0.75, route = true}
	},
	[3] = {
		pos = {1741.64,-1633.31,112.47},
		marker = {drawDist = 10.0, type = 27, scale = {x = 3.0, y = 3.0, z = 1.0}, color = {r = 240, g = 52, b = 52, a = 100}},
		blip = {sprite = 1, color = 1, label = "Delivery Spot", scale = 0.75, route = true}
	},
	[4] = {
		pos = {189.81,2786.62,45.6},
		marker = {drawDist = 10.0, type = 27, scale = {x = 3.0, y = 3.0, z = 1.0}, color = {r = 240, g = 52, b = 52, a = 100}},
		blip = {sprite = 1, color = 1, label = "Delivery Spot", scale = 0.75, route = true}
	},
}

-- ## DRUG SALE ## --
Config.BlackListedPeds = {"s_m_y_cop_01", "s_m_y_dealer_01", "mp_m_shopkeep_01"}
Config.Sell_Chance = 70					-- set chance in % for successfull sale. 70 means 70% success.
Config.CallCopsChance = 80				-- set chance in % for NPC to call cops on failed sale. 
Config.MinCopsOnlineToSell = 0			-- set min amount of cops online to sell, otherwise draw text will not appear on NPC's.
Config.DrugSaleCooldown = 5				-- Cooldown between each drug sale in seconds.
Config.SellDrugsTimer	= 7				-- time taken to negotiate with NPC in seconds
Config.MaxSellCap = 320					-- max amount of drugs to be sold per server restart per player, to disable set to 0.
Config.ReceiveDirtyCash = false			-- true = dirty cash (black_money) | false = normal cash
Config.SellableDrugs = {"drugcokebag", "drugmeth1g", "drugweedbag", "bagofdope", "drugcrack1g"}
Config.SaleSettings = {
	['drugcrack1g'] = {
		price = {min = 150, max = 400},
		cops_multiplier = {enable = true, count = 3, value = 90},
		sell_amount ={ [1] = {min = 1, max = 1}, [2] = {min = 1, max = 2}, [3] = {min = 1, max = 3}, [4] = {min = 1, max = 4}, [5] = {min = 3, max = 5} }
	},
	['drugcokebag'] = {
		price = {min = 125, max = 350},
		cops_multiplier = {enable = true, count = 3, value = 80},
		sell_amount ={ [1] = {min = 1, max = 1}, [2] = {min = 1, max = 2}, [3] = {min = 1, max = 3}, [4] = {min = 1, max = 4}, [5] = {min = 3, max = 5} }
	},
	['bagofdope'] = {
		price = {min = 100, max = 300},
		cops_multiplier = {enable = true, count = 3, value = 70},
		sell_amount = { [1] = {min = 1, max = 1}, [2] = {min = 1, max = 2}, [3] = {min = 1, max = 3}, [4] = {min = 1, max = 4}, [5] = {min = 3, max = 5} }
	},
	['drugmeth1g'] = {
		price = {min = 75, max = 225},
		cops_multiplier = {enable = true, count = 3, value = 60},
		sell_amount = { [1] = {min = 1, max = 1}, [2] = {min = 1, max = 2}, [3] = {min = 1, max = 3}, [4] = {min = 1, max = 4}, [5] = {min = 3, max = 5} }
	},
	['drugweedbag'] = {
		price = {min = 35, max = 105},
		cops_multiplier = {enable = true, count = 3, value = 50},
		sell_amount = { [1] = {min = 1, max = 1}, [2] = {min = 1, max = 2}, [3] = {min = 1, max = 3}, [4] = {min = 1, max = 4}, [5] = {min = 3, max = 5} }
	},
}

-- Conversion Settings:
Config.DrugEffects = {
	{ 
		UsableItem 				= "drugcokebag",						-- item name in database for usable item
		ProgressBarText			= "SMOKING CRACK COCAINE",		-- progress bar text
		UsableTime 				= 5000,							-- Smoking time in MS
		EffectDuration 			= 30,							-- Duration for effect in seconds
		FasterSprint 			= true,							-- Enable or disable faster sprint while on drugs
		SprintValue 			= 1.2,							-- 1.0 is default
		MotionBlur 				= true,							-- Enable or disable motion blur while on drugs
		TimeCycleModifier		= true,							-- Enable or disable time cycle modifer while on drugs
		TimeCycleModifierType	= "spectator5",					-- Set type of time cycle modificer, see full list here: https://pastebin.com/kVPwMemE 
		UnlimitedStamina		= true,							-- Apply unlimited stamina while on drugs 
		BodyArmor				= false,						-- Apply Body Armor when taking drugs
		AddArmorValue			= 10,							-- Set value for body armor thats going to be added
		PlayerHealth			= false,						-- Apply health to player when taking drugs
		AddHealthValue			= 20,							-- Set value for player health thats going to be added
	},
	{ 
		UsableItem 				= "drugmeth1g",						-- item name in database for usable item
		ProgressBarText			= "SMOKING METH",				-- progress bar text
		UsableTime 				= 5000,							-- item name in database for usable item
		EffectDuration 			= 30,							-- Duration for effect in seconds
		FasterSprint 			= false,						-- Enable or disable faster sprint while on drugs
		SprintValue 			= 1.2,							-- 1.0 is default
		MotionBlur 				= true,							-- Enable or disable motion blur while on drugs
		TimeCycleModifier		= true,							-- Enable or disable time cycle modifer while on drugs
		TimeCycleModifierType	= "spectator5",					-- Set type of time cycle modificer, see full list here: https://pastebin.com/kVPwMemE 
		UnlimitedStamina		= false,						-- Apply unlimited stamina while on drugs 
		BodyArmor				= true,						-- Apply Body Armor when taking drugs
		AddArmorValue			= 22,							-- Set value for body armor thats going to be added
		PlayerHealth			= false,							-- Apply health to player when taking drugs
		AddHealthValue			= 20,							-- Set value for player health thats going to be added
	},
	{ 
		UsableItem 				= "drugcrack1g",						-- item name in database for usable item
		ProgressBarText			= "SMOKING CRACK",				-- progress bar text
		UsableTime 				= 1000,							-- item name in database for usable item
		EffectDuration 			= 360,							-- Duration for effect in seconds
		FasterSprint 			= false,						-- Enable or disable faster sprint while on drugs
		SprintValue 			= 0.4,							-- 1.0 is default
		MotionBlur 				= true,							-- Enable or disable motion blur while on drugs
		TimeCycleModifier		= true,							-- Enable or disable time cycle modifer while on drugs
		TimeCycleModifierType	= "trevorspliff",					-- Set type of time cycle modificer, see full list here: https://pastebin.com/kVPwMemE 
		UnlimitedStamina		= false,						-- Apply unlimited stamina while on drugs 
		BodyArmor				= true,						-- Apply Body Armor when taking drugs
		AddArmorValue			= 50,							-- Set value for body armor thats going to be added
		PlayerHealth			= true,							-- Apply health to player when taking drugs
		AddHealthValue			= 20,							-- Set value for player health thats going to be added
	}
	-- { 
	-- 	UsableItem 				= "joint2g",					-- item name in database for usable item
	-- 	ProgressBarText			= "SMOKING JOINT",				-- progress bar text
	-- 	UsableTime 				= 5000,							-- item name in database for usable item
	-- 	EffectDuration 			= 30,							-- Duration for effect in seconds
	-- 	FasterSprint 			= false,						-- Enable or disable faster sprint while on drugs
	-- 	SprintValue 			= 1.2,							-- 1.0 is default
	-- 	MotionBlur 				= true,							-- Enable or disable motion blur while on drugs
	-- 	TimeCycleModifier		= true,							-- Enable or disable time cycle modifer while on drugs
	-- 	TimeCycleModifierType	= "spectator5",					-- Set type of time cycle modificer, see full list here: https://pastebin.com/kVPwMemE 
	-- 	UnlimitedStamina		= false,						-- Apply unlimited stamina while on drugs 
	-- 	BodyArmor				= true,							-- Apply Body Armor when taking drugs
	-- 	AddArmorValue			= 10,							-- Set value for body armor thats going to be added
	-- 	PlayerHealth			= false,						-- Apply health to player when taking drugs
	-- 	AddHealthValue			= 20,							-- Set value for player health thats going to be added
	-- }
}

-- Conversion Settings:
Config.DrugConversion = {
	{ 
		UsableItem 				= "drugcokebrick",					-- item name in database for usable item
		RewardItem 				= "drugcoke10g",					-- item name in database for required item
		RewardAmount 			= {a = 6, b = 10},				-- Amount of RewardItem player receives. "a" is without scale and "b" is with scale
		MaxRewardItemInv		= {e = 44, f = 40},				-- Amount of RewardItem player can hold in inventory. "e" is without scale and "f" is with scale
		RequiredItem 			= "drugempybag",					-- item name in database for required item
		RequiredItemAmount 		= {c = 6, d = 10},				-- Amount of RequiredItem for conversion. "c" is without scale and "d" is with scale
		HighQualityScale		= true,							-- enable/disable scale feature for the drugType
		hqscale					= "drugscale",					-- item name in database for hiqh quality scale item
		ProgressBarText			= "COKE BRICK > COKE 10G",		-- progress bar text
		ConversionTime			= 5000,							-- set conversion time in MS.
	},
	{ 
		UsableItem 				= "drugmethbrick",					-- item name in database for usable item
		RewardItem 				= "drugmeth10g",					-- item name in database for required item
		RewardAmount 			= {a = 6, b = 10},				-- Amount of RewardItem player receives. "a" is without scale and "b" is with scale
		MaxRewardItemInv		= {e = 44, f = 40},				-- Amount of RewardItem player can hold in inventory. "e" is without scale and "f" is with scale
		RequiredItem 			= "drugempybag",					-- item name in database for required item
		RequiredItemAmount 		= {c = 6, d = 10},				-- Amount of RequiredItem for conversion. "c" is without scale and "d" is with scale
		HighQualityScale		= true,							-- enable/disable scale feature for the drugType
		hqscale					= "drugscale",					-- item name in database for hiqh quality scale item
		ProgressBarText			= "METH BRICK > METH 10G",		-- progress bar text
		ConversionTime			= 5000,							-- set conversion time in MS.
	},
	{ 
		UsableItem 				= "drugweedbrick",					-- item name in database for usable item
		RewardItem 				= "drugweed10g",					-- item name in database for required item
		RewardAmount 			= {a = 8, b = 10},				-- Amount of RewardItem player receives. "a" is without scale and "b" is with scale
		MaxRewardItemInv		= {e = 44, f = 40},				-- Amount of RewardItem player can hold in inventory. "e" is without scale and "f" is with scale
		RequiredItem 			= "drugempybag",					-- item name in database for required item
		RequiredItemAmount 		= {c = 8, d = 10},				-- Amount of RequiredItem for conversion. "c" is without scale and "d" is with scale
		HighQualityScale		= true,							-- enable/disable scale feature for the drugType
		hqscale					= "drugscale",					-- item name in database for hiqh quality scale item
		ProgressBarText			= "WEED BRICK > WEED 10G",		-- progress bar text
		ConversionTime			= 5000,							-- set conversion time in MS.
	},
	{ 
		UsableItem 				= "drugcoke10g",					-- item name in database for usable item
		RewardItem 				= "drugcokebag",						-- item name in database for required item
		RewardAmount 			= {a = 6, b = 10},				-- Amount of RewardItem player receives. "a" is without scale and "b" is with scale
		MaxRewardItemInv		= {e = 44, f = 40},				-- Amount of RewardItem player can hold in inventory. "e" is without scale and "f" is with scale
		RequiredItem 			= "drugempybag",					-- item name in database for required item
		RequiredItemAmount 		= {c = 6, d = 10},				-- Amount of RequiredItem for conversion. "c" is without scale and "d" is with scale
		HighQualityScale		= true,							-- enable/disable scale feature for the drugType
		hqscale					= "drugscale",					-- item name in database for hiqh quality scale item
		ProgressBarText			= "COKE 10G > COKE 1G",			-- progress bar text
		ConversionTime			= 5000,							-- set conversion time in MS.
	},
	{ 
		UsableItem 				= "drugmeth10g",					-- item name in database for usable item
		RewardItem 				= "drugmeth1g",						-- item name in database for required item
		RewardAmount 			= {a = 6, b = 10},				-- Amount of RewardItem player receives. "a" is without scale and "b" is with scale
		MaxRewardItemInv		= {e = 44, f = 40},				-- Amount of RewardItem player can hold in inventory. "e" is without scale and "f" is with scale
		RequiredItem 			= "drugempybag",					-- item name in database for required item
		RequiredItemAmount 		= {c = 6, d = 10},				-- Amount of RequiredItem for conversion. "c" is without scale and "d" is with scale
		HighQualityScale		= true,							-- enable/disable scale feature for the drugType
		hqscale					= "drugscale",					-- item name in database for hiqh quality scale item
		ProgressBarText			= "METH 10G > METH 1G",			-- progress bar text
		ConversionTime			= 5000,							-- set conversion time in MS.
	},
	{ 
		UsableItem 				= "drugweed10g",					-- item name in database for usable item
		RewardItem 				= "drugweedbag",						-- item name in database for required item
		RewardAmount 			= {a = 4, b = 5},				-- Amount of RewardItem player receives. "a" is without scale and "b" is with scale
		MaxRewardItemInv		= {e = 46, f = 45},				-- Amount of RewardItem player can hold in inventory. "e" is without scale and "f" is with scale
		RequiredItem 			= "drugempybag",					-- item name in database for required item
		RequiredItemAmount 		= {c = 4, d = 5},				-- Amount of RequiredItem for conversion. "c" is without scale and "d" is with scale
		HighQualityScale		= true,							-- enable/disable scale feature for the drugType
		hqscale					= "drugscale",					-- item name in database for hiqh quality scale item
		ProgressBarText			= "WEED 10G > WEED 1G",			-- progress bar text
		ConversionTime			= 5000,							-- set conversion time in MS.
	},
	{ 
		UsableItem 				= "drugweedbag",						-- item name in database for usable item
		RewardItem 				= "joint",					-- item name in database for required item
		RewardAmount 			= 2,							-- Amount of RewardItem player receives
		MaxRewardItemInv		= {e = 44, f = 40},				-- Amount of RewardItem player can hold in inventory. "e" is without scale and "f" is with scale
		RequiredItem 			= "rollpaper",					-- item name in database for required item
		RequiredItemAmount 		= 2,							-- Amount of RequiredItem for conversion
		HighQualityScale		= false,						-- enable/disable scale feature for the drugType
		hqscale					= "drugscale",					-- item name in database for hiqh quality scale item
		ProgressBarText			= "WEED 4G > JOINT 2G",			-- progress bar text
		ConversionTime			= 5000,							-- set conversion time in MS.
	}
}

