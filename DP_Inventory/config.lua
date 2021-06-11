Config = {}
Config.ServerName = 'WackPackRP'
Config.Locale = 'en' -- Currently supported: nl, en, tr, fr, br, de, fa, pt, es. Your translation file is really appreciated. Send it to our Github repo or Discord server.
Config.ExcludeAccountsList = {'bank', 'money'} -- DO NOT TOUCH!

Config.IncludeCash = true -- Include cash in inventory? true or false.
Config.IncludeAccounts = false -- Include accounts (bank, black money, ...)? true or false.
Config.CameraAnimationPocket = false -- Set camera focus towards player if in inventory.
Config.CameraAnimationBag = false -- Set camera focus towards player if in inventory.
Config.CameraAnimationTrunk = false -- Set camera focus towards player if in inventory.
Config.CameraAnimationGlovebox = false -- Set camera focus towards player if in inventory.
Config.EverybodyCanRob = false -- Rob a dead or mugging or handcuffed person or allow jobs only?
Config.JobOnlyInventory = false -- Can jobs use /openinventory ID from anywere? If False only admins can do this.
Config.AllowModerators = false -- Can moderators use /openinventory ID from anywere?
Config.CheckOwnership = false -- If true, Only owner of vehicle can store items in trunk and glovebox. Only if this is on TRUE Config.AllowJOBNAME will work.
Config.AllowPolice = true -- If true, police will be able to search players' trunks.
Config.AllowNightclub = false -- If true, nightclub will be able to search players' trunks.
Config.AllowMafia = false -- If true, mafia will be able to search players' trunks.
Config.IllegalshopOpen = false -- if true everybody can enter this shop. If false only Config.InventoryJob.Illegal can enter this shop.
Config.UseLicense = false -- You must have esx_license working on your server. 
Config.useAdvancedShop = false -- es_extended shop system. Not shared, sorry. Just set to false and use the in-build custom shop.
Config.disableVersionCheck = false
Config.disableVersionMessage = false
Config.versionCheckDelay = 60 -- In minutes

Config.Command = {Steal = 'steal', CloseInv = 'closeinventory', Unequip = 'unequip'} -- NOT YET SUPPORTED, CHANGE IN /server/main.lua/.
Config.Attachments = {'flashlight', 'mag', 'drummag', 'suppressor', 'scope', 'grip', 'skin', 'skin1', 'skin2', 'skin3', 'skin4', 'skin5', 'skin6','skin7'} -- SUPPORTED.
Config.InventoryJob = {Police = 'police', Nightclub = 'nightclub', Mafia = 'mafia', Illegal = nil, Ambulance = 'ambulance'} -- This must be the name used in your database/jobs table.
Config.CloseUiItems = {'phone', 'weed_seed', 'tunerchip', 'fixkit', 'medikit', 'firstaid', 'vicodin', 'adrenaline', 'vuurwerk', 'vuurwerk2', 'vuurwerk3', 'vuurwerk4', 'armbrace', 'neckbrace', 'bodybandage', 'legbrace', 'bandage', 'billet'} -- List of item names that will close ui when used.
Config.License = {Weapon = 'weapon', Police = 'weapon', Nightclub = 'weapon'} -- What license is needed for this shop?

Config.OpenControl = 289 -- F2. player inventory, it is recommend to use the same as CloseControl.
Config.CloseControl = 289 -- F2. player inventory, it is recommend to use the same as OpenControl.
Config.BagControl = 168 -- F7. player bag inventory
Config.SearchBag = 249 -- N. Search a bag on the ground
Config.TakeBag = 38 -- E. Take bag on the ground
Config.OpenKeyGlovebox = 170 -- F3. glovebox inventory (in-car), it is recommend to use the same as OpenKeyTrunk.
Config.OpenKeyTrunk = 170 -- F3. trunk inventory (behind-car), it is recommend to use the same as OpenKeyGlovebox.
Config.RobKeyOne = 38 -- E
Config.RobKeyTwo = 60 -- CTRL

Config.ReloadTime = 2000 -- in miliseconds for reloading your ammunition.

Config.InitialLockerRentPrice = 450
Config.DailyLockerRentPrice = 250
Config.LockerExterior = ''--vector3(-286.23, 280.84, 89.89)
Config.LockerInterior = ''--vector3(1173.24, -3196.62, -39.01)

Config.Lockers = {

	-- ['locker1'] = {
	-- 	locker_name = 'Kluisje #1',
	-- 	location = vector3(1161.87, -3199.07, -39.01),
	-- },
	
	-- ['locker2'] = {
	-- 	locker_name = 'Kluisje #2',
	-- 	location = vector3(1156.71, -3195.3, -39.01),
	-- },
	
	-- ['locker3'] = {
	-- 	locker_name = 'Kluisje #3',
	-- 	location = vector3(1157.61, 3198.92, -39.01),
	-- },
	
	-- ['locker4'] = {
	-- 	locker_name = 'Kluisje #4',
	-- 	location = vector3(1167.05, -3194.64, -39.01),
	-- },
	
	-- ['locker5'] = {
	-- 	locker_name = 'Kluisje #5',
	-- 	location = vector3(1173.29, -3194.47, -39.01),
	-- },
	
	-- ['locker6'] = {
	-- 	locker_name = 'Kluisje #6',
	-- 	location = vector3(1171.73, -3198.81, -39.01),
	-- },
	
}

Config.LicensePrice = 25000

Config.ShopMinimumGradePolice = 0 -- minimum grade to open the police shop
Config.ShopMinimumGradeNightclub = 0
Config.ShopMinimumGradeMafia = 0

-- BLIPS & MARKERS
Config.MarkerSize = {x = 1.5, y = 1.5, z = 1.5}
Config.MarkerColor = {r = 0, g = 128, b = 255}
Config.Color = 0 -- currently used for most shop blip color.
Config.WeaponColor = 1 -- to be optimized....

Config.ShowDrugMarketBlip = false
Config.DrugStoreBlipID = 140
Config.ShowRegularShopBlip = false
Config.ShopBlipID = 59
Config.ShowRobsLiquorBlip = false
Config.LiquorBlipID = 93
Config.ShowYouToolBlip = false
Config.YouToolBlipID = 402
Config.ShowBlackMarketBlip = false
Config.BlackMarketBlipID = 110
Config.ShowPoliceShopBlip = false
Config.PoliceShopBlipID = 110
Config.ShowNightclubShopBlip = false
Config.NightclubShopBlipID = 110
Config.ShowWeaponShopBlip = false
Config.WeaponShopBlipID = 110
Config.ShowIllegalShopBlip = false
Config.IllegalShopBlipID = 110
Config.ShowPrisonShopBlip = false
Config.PrisonShopBlipID = 52
Config.ShowLockerRentBlip = false
Config.LockerRentBlipID = 357
Config.LockerRentBlipSize = 1.0
Config.LockerRentBlipColor = 3

Config.Weight = 200.00 -- Limit, unit can be whatever you want. Originally grams (as average people can hold 25kg).
Config.DefaultWeight = 1 -- Default weight for an item.
Config.MaxBagWeight = 40
Config.MaxBagItemCount = 50 
Config.MaxDifferentBagItems = 5

Config.localWeight = { -- Fill this with all your items. This is only for trunk and glovebox! Change your pocket inventory weights in your database! (items table)
	advlockpick = 3,
	ammunition_fireextinguisher = 5,
	ammunition_pistol = 5,
	ammunition_pistol_large = 10,
	ammunition_rifle = 5,
	ammunition_rifle_large = 10,
	ammunition_shotgun = 5,
	ammunition_shotgun_large = 10,
	ammunition_smg = 5,
	ammunition_smg_large = 10,
	ammunition_snp = 5,
	ammunition_snp_large = 10,
	armor = 5,
	armorpolice = 5,
	armorswat = 5,
	badge = 1,
	bait = 1,
	baitturtle = 1,
	bandage = 2,
	binoculars = 2,
	blankid = 1,
	blowpipe = 2,
	bread = 2,
	camera = 1,
	cartridge = 1,
	carwashkit = 12,
	chopbumperfront = 5,
	chopbumperrear = 5,
	chopcarbattery = 3,
	chopcarhood = 5,
	chopglass = 2,
	chopheadlights = 2,
	choprims = 5,
	chopscrapmetal = 2,
	chopspoiler = 5,
	coal = 2,
	cuffs = 2,
	dojidcard = 2,
	drinkbeer = 2,
	drinkcoffee = 2,
	drinkcola = 2,
	drinkfrappuccino = 2,
	drinkhorchata = 2,
	drinklatte = 2,
	drinktequila = 2,
	drinkvodka = 2,
	drinkwhiskey = 2,
	drugcoke10g = 2,
	drugcokebag = 1,
	drugcokebrick = 20,
	drugcoketray = 1,
	drugempybag = 1,
	drugItem = 2,
	drugmeth10g = 2,
	drugmeth1g = 1,
	drugmethbrick = 20,
	drugscale = 1,
	drugweed20g = 4,
	drugweedbag = 12,
	drugweedbrick = 20,
	drummag = 2,
	fish = 3,
	fishingrod = 5,
	fixallkit = 6,
	fixkit = 2,
	flashlight = 2,
	foodburger = 2,
	foodburgerbig = 2,
	foodburrito = 2,
	foodcanoli = 2,
	foodchips = 2,
	foodchocolatebar = 2,
	foodcookie = 2,
	fooddonut = 2,
	foodeggsandbacon = 2,
	foodfries = 2,
	foodhotdog = 2,
	foodmuffin = 2,
	foodpancakes = 2,
	foodpizza = 2,
	foodtaco = 2,
	fsafe = 20,
	GADGET_PARACHUTE = 2,
	gangblue = 0,
	gangbondi = 0,
	ganggreen = 0,
	ganglost = 1,
	gangpurple = 0,
	gangred = 0,
	gangredtie = 0,
	gangyellow = 0,
	gold = 2,
	goldbar = 1,
	goldchain = 1,
	goldring = 1,
	goldwatch = 1,
	grip = 2,
	gruppe61jewelry = 1,
	gruppe62fleeca = 1,
	gruppe62pac = 1,
	gruppe6heavydrill = 1,
	gruppe6wirecutter = 1,
	hackerdevice = 2,
	huntingcarcass1 = 7,
	huntingcarcass2 = 7,
	huntingcarcass3 = 7,
	huntingcarcass4 = 7,
	ifak = 2,
	iron = 2,
	joint = 2,
	leather = 4,
	licenseplate = 4,
	lockpick = 2,
	mag = 2,
	meat = 2,
	nos = 5,
	oxy = 2,
	phone = 1,
	radio = 1,
	rollpaper = 1,
	scope = 1,
	scuba = 3,
	silver = 2,
	skin = 2,
	skin1 = 2,
	skin2 = 2,
	skin3 = 2,
	skin4 = 2,
	skin5 = 2,
	skin6 = 2,
	skin7 = 2,
	suppressor = 2,
	turtle = 9,
	uvlight = 1,
	watch = 1,
	water = 2,
	WEAPON_ADVANCEDRIFLE = 7,
	WEAPON_APPISTOL = 3,
	WEAPON_ASSAULTRIFLE = 7,
	WEAPON_ASSAULTSMG = 5,
	WEAPON_BAT = 2,
	WEAPON_BATTLEAXE = 1,
	WEAPON_BOTTLE = 2,
	WEAPON_CARBINERIFLE = 7,
	WEAPON_CARBINERIFLE_MK2 = 7,
	WEAPON_COMBATPDW = 5,
	WEAPON_COMBATPISTOL = 3,
	WEAPON_CROWBAR = 2,
	WEAPON_DBSHOTGUN = 4,
	WEAPON_DOUBLEACTION = 3,
	WEAPON_FIREEXTINGUISHER = 1,
	WEAPON_FLARE = 1,
	WEAPON_FLAREGUN = 2,
	WEAPON_FLASHLIGHT = 2,
	WEAPON_GOLFCLUB = 2,
	WEAPON_GUSENBERG = 2,
	WEAPON_HAMMER = 2,
	WEAPON_HATCHET = 2,
	WEAPON_HEAVYPISTOL = 3,
	WEAPON_HEAVYSNIPER_MK2 = 15,
	WEAPON_KNIFE = 2,
	WEAPON_KNUCKLE = 1,
	WEAPON_MACHETE = 2,
	WEAPON_MACHINEPISTOL = 4,
	WEAPON_MICROSMG = 4,
	WEAPON_MINISMG = 4,
	WEAPON_MOLOTOV = 2,
	WEAPON_MUSKET = 7,
	WEAPON_NIGHTSTICK = 2,
	WEAPON_PISTOL = 3,
	WEAPON_PISTOL50 = 3,
	WEAPON_PISTOL_MK2 = 3,
	WEAPON_POOLCUE = 2,
	WEAPON_PUMPSHOTGUN = 5,
	WEAPON_PUMPSHOTGUN_MK2 = 6,
	WEAPON_REVOLVER = 5,
	WEAPON_REVOLVER_MK2 = 5,
	WEAPON_SMG = 5,
	WEAPON_SMG_MK2 = 5,
	WEAPON_SNIPERRIFLE = 12,
	WEAPON_SNOWBALL = 1,
	WEAPON_SNSPISTOL = 2,
	WEAPON_SPECIALCARBINE_MK2 = 7,
	WEAPON_STUNGUN = 2,
	WEAPON_SWITCHBLADE = 1,
	WEAPON_VINTAGEPISTOL = 3,
	WEAPON_WRENCH = 3,
}

Config.GloveboxSize = { -- Related to Config.localWeight.
	[0] = 50, --Compact
	[1] = 50, --Sedan
	[2] = 50, --SUV
	[3] = 50, --Coupes
	[4] = 50, --Muscle
	[5] = 50, --Sports Classics
	[6] = 50, --Sports
	[7] = 50, --Super
	[8] = 50, --Motorcycles
	[9] = 50, --Off-road
	[10] = 50, --Industrial
	[11] = 50, --Utility
	[12] = 50, --Vans
	[13] = 50, --Cycles
	[14] = 50, --Boats
	[15] = 50, --Helicopters
	[16] = 50, --Planes
	[17] = 50, --Service
	[18] = 50, --Emergency
	[19] = 50, --Military
	[20] = 50, --Commercial
	[21] = 50 --Trains
}

Config.TrunkSize = { -- Related to Config.localWeight.
	[0] = 400, --Compact
	[1] = 800, --Sedan
	[2] = 1200, --SUV
	[3] = 550, --Coupes
	[4] = 500, --Muscle
	[5] = 300, --Sports Classics
	[6] = 300, --Sports
	[7] = 150, --Super
	[8] = 50, --Motorcycles
	[9] = 1500, --Off-road
	[10] = 2000, --Industrial
	[11] = 2000, --Utility
	[12] = 1800, --Vans
	[13] = 0, --Cycles
	[14] = 100, --Boats
	[15] = 200, --Helicopters
	[16] = 0, --Planes
	[17] = 800, --Service
	[18] = 800, --Emergency
	[19] = 0, --Military
	[20] = 2200, --Commercial
	[21] = 0 --Trains
}

Config.VehiclePlate = {
	taxi = 'TAXI',
	cop = 'police',
	police = 'police',
	ambulance = 'ambulance',
	mecano = 'mechano',
	mechanic = 'mechanic',
	police = 'police',
	nightclub = 'nightclub',
	nightclub = 'nightclub',
	bahamas = 'bahamas',
	cardealer = 'dealer'
}

Config.Shops = {
	RegularShop = {
		Locations = {
			-- {x = 190.7,   y = -888.52,  z = 29.71},
			-- {x = 374.875,   y = 327.896,  z = 102.566},
			-- {x = 2557.458,  y = 382.282,  z = 107.622},
			-- {x = -3038.939, y = 585.954,  z = 6.908},
			-- {x = -3241.927, y = 1001.462, z = 11.830},
			-- {x = 547.431,   y = 2671.710, z = 41.156},
			-- {x = 1961.464,  y = 3740.672, z = 31.343},
			-- {x = 2678.916,  y = 3280.671, z = 54.241},
			-- {x = 1729.216,  y = 6414.131, z = 34.037},
			-- {x = -48.519,   y = -1757.514, z = 28.421},
			-- {x = 1163.373,  y = -323.801,  z = 68.205},
			-- {x = -707.501,  y = -914.260,  z = 18.215},
			-- {x = -1820.523, y = 792.518,   z = 137.118},
			-- {x = 1698.388,  y = 4924.404,  z = 41.063},
			-- {x = 25.723,   y = -1346.966, z = 28.497}
		},
		Items = {
			{name = 'bread', price = 5},
			{name = 'water', price = 5},
			{name = 'phone', price = 100},
			{name = 'bandage', price = 150},
			{name = 'blowpipe', price = 50},
			{name = 'bag', price = 50},
			{name = 'radio', price = 50},
		}
	},

	GroothandelSupermarkt = {
		Locations = {
			-- { x = 50.57, y = -1754.93, z = 28.61 }
		},
		Items = {
			{ name = 'blowpipe', price = 50},
			{ name = 'carokit', price = 100},
			{ name = 'carotool', price = 100},
			{ name = 'fixkit', price = 100},
			{ name = 'fixtool', price = 100},
			{ name = 'gazbottle', price = 100},
			{ name = 'WEAPON_PETROLCAN', price = 100},
		}
	},

	IlegalShop = {
		Locations = {
			-- { x = 468.58, y = -3205.64, z = 9.79 }
		},
		Items = {
			{ name = 'bread', price = 1},
			{ name = 'water', price = 1}
		}
	},

	DrugShop = {
		Locations = {
			-- { x = 377.0, y = -828.49, z = 28.3 }
		},
		Items = {
			{ name = 'joint', price = 10},
			{ name = 'blunt', price = 15}
		}
	},

	RobsLiquor = {
		Locations = {
		 	-- { x = 964.38, y = 33.54, z = 73.88 }
		},
		Items = {
			{name = 'beer', price = 12},
			{name = 'wine', price = 12},
			{name = 'vodka', price = 18},
			{name = 'tequila', price = 18},
			{name = 'whiskey', price = 20}
		}
	},

	YouTool = {
		Locations = {
			-- { x = 2748.0, y = 3473.0, z = 55.68 }
		},
		Items = {
			{name = 'drill', price = 1},
			{name = 'binocular', price = 1},
			{name = 'fixkit', price = 1},
			{name = 'gps', price = 1},
			{name = 'lockpick', price = 1},
			{name = 'scubagear', price = 1},
			{name = 'blowtorch', price = 1},
			{name = '1gbag', price = 1},
			{name = '5gbag', price = 1},
			{name = '50gbag', price = 1},
			{name = '100gbag', price = 1},
			{name = 'lowgradefert', price = 1},
			{name = 'highgradefert', price = 1},
			{name = 'plantpot', price = 1},
			{name = 'drugscales', price = 1}
		}
	},

	PrisonShop = {
		Locations = {
		 	-- { x = -1103.05, y = -823.72, z = 14.48 }
		},
		Items = {
			{name = 'bread', price = 1},
			{name = 'water', price = 1},
			{name = 'cigarette', price = 1},
			{name = 'lighter'}, price = 1,
			{name = 'sandwich', price = 1},
			{name = 'chips', price = 1}
		}
	},

	WeaponShop = {
		Locations = {
			-- { x = 22.09, y = -1107.28, z = 28.80 }
		},
		Items = {
			{name = 'ammunition_pistol', price = 1},
			{name = 'ammunition_pistol_large', price = 1},
			{name = 'ammunition_shotgun', price = 1},
			{name = 'ammunition_shotgun_large', price = 1},
			{name = 'ammunition_smg', price = 1},
			{name = 'ammunition_smg_large', price = 1},
			{name = 'ammunition_rifle', price = 1},
			{name = 'ammunition_rifle_large', price = 1},
			{name = 'ammunition_snp', price = 1},
			{name = 'ammunition_snp_large', price = 1},
			{name = 'flashlight',price = 1},
			--{name = 'grip',price = 1},
			--{name = 'scope',price = 1},
			--{name = 'skin',price = 1},
			--{name = 'suppressor',price = 1}
		}
	},

	PoliceShop = { -- available for Config.InventoryJob.Police
		Locations = {
			-- { x = 482.68 , y = -995.99, z = 29.69 }
		},
		Items = {
			{name = 'WEAPON_FLASHLIGHT', price = 100},
			{name = 'WEAPON_STUNGUN', price = 100},
			{name = 'WEAPON_NIGHTSTICK', price = 100},
			{name = 'WEAPON_PISTOL', price = 100},
			{name = 'WEAPON_FIREEXTINGUISHER',price = 100},
			{name = 'ammunition_pistol',price = 100},
			{name = 'ammunition_pistol_large',price = 100},
			{name = 'ammunition_shotgun',price = 100},
			{name = 'ammunition_shotgun_large',price = 100},
			{name = 'ammunition_smg',price = 100},
			{name = 'ammunition_smg_large',price = 100},
			{name = 'ammunition_rifle',price = 100},
			{name = 'ammunition_rifle_large',price = 100},
			{name = 'ammunition_snp',price = 100},
			{name = 'ammunition_snp_large',price = 100},
			{name = 'ammunition_fireextinguisher',price = 100},
			{name = 'bulletproof',price = 1000},
			--{name = 'binoculars',price = 50},
			{name = 'flashlight',price = 100}
		}
	},

	BlackMarket = { -- available for Config.InventoryJob.Mafia
		Locations = {
			-- { x = -1297.96, y = -392.60, z = 35.47 }
		},
		Items = {
			{name = 'WEAPON_PISTOL', price = 10000},
			{name = 'ammunition_pistol',price = 1000},
			{name = 'ammunition_pistol_large',price = 1000}
		}
	},

	LicenseShop = {
		Locations = {
	    	-- {x = 12.47, y = -1105.5, z = 29.8}
		}
	},

	ShopNightclub = { -- available for Config.InventoryJob.Nightclub
		Locations = {
	    	-- { x = -2677.92, y = 1334.81, z = 139.88 },
	    	-- { x = -1879.94, y = 2063.07, z = 134.92 }
		},
		Items = {
			{name = 'WEAPON_FLASHLIGHT', price = 1000},
			{name = 'WEAPON_KNIFE', price = 1000},
			{name = 'WEAPON_BAT', price = 1000},
			{name = 'WEAPON_PISTOL', price = 10000},
			{name = 'WEAPON_PUMPSHOTGUN',price = 10000},
			{name = 'WEAPON_SMOKEGRENADE',price = 1000},
			{name = 'WEAPON_FIREEXTINGUISHER',price = 1000},
			{name = 'WEAPON_CROWBAR',price = 1000},
			{name = 'WEAPON_BZGAS',price = 1000},
			{name = 'ammunition_pistol',price = 100},
			{name = 'ammunition_pistol_large',price = 200},
			{name = 'ammunition_shotgun',price = 100},
			{name = 'ammunition_shotgun_large',price = 200},
			{name = 'ammunition_smg',price = 100},
			{name = 'ammunition_smg_large',price = 200},
			{name = 'ammunition_rifle',price = 100},
			{name = 'ammunition_rifle_large',price = 200},
			{name = 'ammunition_snp',price = 100},
			{name = 'ammunition_snp_large',price = 200},
			{name = 'ammunition_fireextinguisher',price = 100},
			{name = 'bulletproof',price = 1000},
			--{name = 'binoculars',price = 50},
			{name = 'flashlight',price = 100}
		}
	},
}

Config.Throwables = { -- WEAPON NAME & WEAPON HASH
	WEAPON_MOLOTOV = 615608432,
	WEAPON_GRENADE = -1813897027,
	WEAPON_STICKYBOMB = 741814745,
	WEAPON_PROXMINE = -1420407917,
	WEAPON_SMOKEGRENADE = -37975472,
	WEAPON_PIPEBOMB = -1169823560,
	WEAPON_FLARE = 1233104067,
	WEAPON_SNOWBALL = 126349499
}

Config.FuelCan = 883325847

Config.PropList = { -- Here you can change the prop when using the item.
	cash = {['model'] = 'prop_cash_pile_02', ['bone'] = 28422, ['x'] = 0.02, ['y'] = 0.02, ['z'] = -0.08, ['xR'] = 270.0, ['yR'] = 180.0, ['zR'] = 0.0}
}

Config.EnableInventoryHUD = true

Config.Ammo = {
	{
		name = 'ammunition_pistol',
		weapons = {
			'WEAPON_PISTOL',
			'WEAPON_PISTOL_MK2',
			'WEAPON_APPISTOL',
			'WEAPON_SNSPISTOL',
			'WEAPON_SNSPISTOL_MK2',
			'WEAPON_COMBATPISTOL',
			'WEAPON_HEAVYPISTOL',
			'WEAPON_MACHINEPISTOL',
			'WEAPON_MARKSMANPISTOL',
			'WEAPON_PISTOL50',
			'WEAPON_VINTAGEPISTOL',
			'WEAPON_REVOLVER',
			'WEAPON_REVOLVER_MK2',
			'WEAPON_DOUBLEACTION',
			'WEAPON_CERAMICPISTOL'
		},
		count = 30
	},
	{
		name = 'ammunition_pistol_large',
		weapons = {
			'WEAPON_PISTOL',
			'WEAPON_PISTOL_MK2',
			'WEAPON_APPISTOL',
			'WEAPON_SNSPISTOL',
			'WEAPON_SNSPISTOL_MK2',
			'WEAPON_COMBATPISTOL',
			'WEAPON_HEAVYPISTOL',
			'WEAPON_MACHINEPISTOL',
			'WEAPON_MARKSMANPISTOL',
			'WEAPON_PISTOL50',
			'WEAPON_VINTAGEPISTOL',
			'WEAPON_REVOLVER',
			'WEAPON_REVOLVER_MK2',
			'WEAPON_DOUBLEACTION',
			'WEAPON_CERAMICPISTOL'
		},
		count = 60
	},
	{
		name = 'ammunition_shotgun',
		weapons = {
			'WEAPON_PUMPSHOTGUN',
			'WEAPON_PUMPSHOTGUN_MK2',
			'WEAPON_DBSHOTGUN',
			'WEAPON_MUSKET',
			'WEAPON_SAWNOFFSHOTGUN'
		},
		count = 12
	},
	{
		name = 'ammunition_shotgun_large',
		weapons = {
			'WEAPON_PUMPSHOTGUN',
			'WEAPON_PUMPSHOTGUN_MK2',
			'WEAPON_DBSHOTGUN',
			'WEAPON_MUSKET',
			'WEAPON_SAWNOFFSHOTGUN'
		},
		count = 60
	},
	{
		name = 'ammunition_smg',
		weapons = {
			'WEAPON_MICROSMG',
			'WEAPON_MINISMG',
			'WEAPON_SMG',
			'WEAPON_SMG_MK2',
			'WEAPON_ASSAULTSMG',
			'WEAPON_COMBATPDW',
			'WEAPON_MACHINEPISTOL',
            'WEAPON_GUSENBERG'
		},
		count = 45
	},
	{
		name = 'ammunition_smg_large',
		weapons = {
			'WEAPON_MICROSMG',
			'WEAPON_MINISMG',
			'WEAPON_SMG',
			'WEAPON_SMG_MK2',
			'WEAPON_ASSAULTSMG',
			'WEAPON_COMBATPDW',
			'WEAPON_MACHINEPISTOL',
            'WEAPON_GUSENBERG'
		},
		count = 65
	},
	{
		name = 'ammunition_rifle',
		weapons = {
			'WEAPON_ASSAULTRIFLE',
			'WEAPON_CARBINERIFLE',
			'WEAPON_CARBINERIFLE_MK2',
			'WEAPON_ADVANCEDRIFLE',
			'WEAPON_SPECIALCARBINE_MK2',
			'WEAPON_COMPACTRIFLE'
		},
		count = 45
	},
	{
		name = 'ammunition_rifle_large',
		weapons = {
			'WEAPON_ASSAULTRIFLE',
			'WEAPON_CARBINERIFLE',
			'WEAPON_CARBINERIFLE_MK2',
			'WEAPON_ADVANCEDRIFLE',
			'WEAPON_SPECIALCARBINE_MK2',
			'WEAPON_COMPACTRIFLE'
		},
		count = 65
	},
	{
		name = 'ammunition_snp',
		weapons = {
            'WEAPON_SNIPERRIFLE',
			'WEAPON_HEAVYSNIPER_MK2'
		},
		count = 10
	},
	{
		name = 'ammunition_snp_large',
		weapons = {
            'WEAPON_SNIPERRIFLE',
			'WEAPON_HEAVYSNIPER_MK2'
		},
		count = 30
	},
	{
		name = 'ammunition_fireextinguisher',
		weapons = {
			'WEAPON_FIREEXTINGUISHER'
		},
		count = 100
	}
}

Config.VaultBox = 'p_v_43_safe_s'
Config.Vault = {
	vault = {
	-- 	coords = vector3(-544.61, -197.39, 37.22),
	-- 	heading = 298.73,
	-- 	needItemLicense = 'apple', --'licence_vault' -- If you don't want to use items Allow you to leave it blank or needItemLicense = nil
	-- 	InfiniteLicense = true, -- Should one License last forever?
	-- 	show=true,
	-- },
	-- police = { -- blokkenpark kantoor
	-- 	coords = vector3(452.99, -973.48, 29.69),
	-- 	heading = 270.00,
	-- 	needItemLicense = false,
	-- 	show=true,
	-- },
	-- ambulance = {
	-- 	coords = vector3(337.54, -584.01, 27.9),
	-- 	heading = 74.52,
	-- 	needItemLicense = false,
	-- 	show=true,
	-- },
	-- mechanic = {
	-- 	coords = vector3(-201.79, -1314.48, 30.09),
	-- 	heading = 358.01,
	-- 	needItemLicense = false,
	-- 	show=true,
	-- },
	-- nightclub = {
	-- 	coords = vector3(-1496.15, 124.61, 55.67),
	-- 	heading = 229.74,
	-- 	needItemLicense = false,
	-- 	show=true,
	-- },
	-- bahamas = {
	-- 	coords = vector3(-1382.2, -610.09, 29.82),
	-- 	heading = 344.18,
	-- 	needItemLicense = false,
	-- 	show=true,
	-- },
	-- taxi = {
	-- 	coords = vector3(891.57, -173.07, 73.67),
	-- 	heading = 57.67,
	-- 	needItemLicense = false,
	-- 	show=true,
	-- },
	-- pizza = {
	-- 	coords = vector3(447.25, 140.5, 99.2),
	-- 	heading = 160.61,
	-- 	needItemLicense = false,
	-- 	show=true,
	-- },
	-- cardealer = {
	-- 	coords = vector3(-12.53, -1663.25, 32.04),
	-- 	heading = 169.96,
	-- 	needItemLicense = false,
	-- 	show=true,
	-- },
	-- starbucks = {
	-- 	coords = vector3(-632.35, 226.28, 80.88),
	-- 	heading = 86.65,
	-- 	needItemLicense = false,
	-- 	show=true,
	-- },
	-- gemeente = {
	-- 	coords = vector3(-549.06, -199.27, 69.98),
	-- 	heading = 212.86,
	-- 	needItemLicense = false,
	-- 	show=true,
	-- },
	-- pilot = {
	-- 	coords = vector3(-931.34, -2933.14, 12.95),
	-- 	heading = 327.39,
	-- 	needItemLicense = false,
	-- 	show=true,
	-- },
	-- peaky = {
	-- 	coords = vector3(1391.55,1158.81,114.33),
	-- 	heading = 270.52,
	-- 	needItemLicense = false,
	-- 	show=false,
	-- },
	-- diablo = {
	-- 	coords = vector3(-96.3,817.32,235.72),
	-- 	heading = 192.25,
	-- 	needItemLicense = false,
	-- 	show=false,
	-- },
	-- pericolo = {
	-- 	coords = vector3(-1798.63,451.42,127.29),
	-- 	heading = 0.55,
	-- 	needItemLicense = false,
	-- 	show=true,
	
	}
}
