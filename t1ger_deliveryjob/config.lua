-------------------------------------
------- Created by T1GER#9080 -------
------------------------------------- 

Config = {}

Config.ESXSHAREDOBJECT = 'esx:getSharedObject'

-- T1GER Scripts:
Config.t1gerKeys = false
Config.T1GER_Shops	= true
Config.ShopsDeliveryLimit = 5 				-- How many orders can a delivery driver delivery to a company at once. Only effects if T1GER Shops is true.
Config.DeliveryJobName = "delivery"

-- Buttons:
Config.KeyToManageCompany		= 38		-- Default: [E]
Config.KeyToBuyCompany			= 38		-- Default: [E]	
Config.KeyToLoadJobVehicle		= 38		-- Default: [E]	
Config.KeyToPickUpParcel		= 38		-- Default: [E]	
Config.KeyToPutParcelInVeh		= 38		-- Default: [E]	
Config.KeyToDeliverParcel		= 47		-- Default: [G]	
Config.KeyToTakeParcelFromVeh	= 38		-- Default: [E]		
Config.KeyToReturnJobVehicle	= 38		-- Default: [E]				

-- General Settings:
Config.BuyableCompanyBlip 	    = true		-- Blip to show mechanic shops forsale
Config.PayCompanyWithCash		= true		-- Set to false to pay mech shop with bank
Config.ReciveSoldCompanyCash	= true		-- Set to false to receive bank money on sale of drug lab
Config.SellPercent				= 0.75		-- Means player gets 75% in return from original paid price
Config.CertificatePrice			= 2000		-- Set price to purchase certificate
Config.AddLevelAmount			= 2			-- Set amount of levels added upon completing a job

-- Blip & Marker Settings:
Config.BlipSettings = { enable = false, sprite = 477, display = 4, scale = 0.60 } 
Config.MarkerSettings = { enable = true, drawDist = 10.0, type = 20, scale = {x = 0.7, y = 0.7, z = 0.7}, color = {r = 240, g = 52, b = 52, a = 100} }

-- Job Settings:
Config.DepositInCash 			= true		-- set to false to pay vehicle deposit with bank money
Config.DamagePercent			= 50		-- if job veh body health is decreased more than 5%, then no payout for that specific delivery.
Config.DepositDamage			= 10		-- if vehicle is damaged more than x %, then deposit is not returned.

-- Reward Settings:
Config.Reward = { 
	min = 1750,
	max = 3000, 
	valueAddition = { [1] = 5, [2] = 15, [3] = 50, [4] = 50 }	-- adds x% to the math.random(min,max), where 1, 2, 3 are levels
}

Config.Companies = {
	[1] = { -- DOCKS 1
		menuPos = {1226.37,-3228.66,6.03},
		price = 15000,
		vehSpawn = {1233.36,-3228.38,5.84,359.38},
		refill = {pos = {1228.93,-3228.54,6.03}, marker = {drawDist = 20.0, type = 27, scale = {x=3.0,y=3.0,z=1.0}, color = {r=220,g=60,b=60,a=100}}},
		cargoMarker = {drawDist = 20.0, type = 27, scale = {x=0.3,y=0.3,z=0.3}, color = {r=220,g=60,b=60,a=100}},
		cargo = {
			[1] = {1220.82,-3226.28,5.87},
			[2] = {1223.29,-3226.30,5.87},
			[3] = {1225.64,-3226.35,5.87},
			[4] = {1228.32,-3226.36,5.88},
			[5] = {1230.54,-3226.19,5.87},
		},
		trailerSpawn = {1218.41,-3228.05,5.92,359.38},
		forklift = {pos = {1213.19,-3225.79,5.86,270.74}, model = "forklift"}
	},
	[2] = { -- DOCKS 2
		menuPos = {1239.25,-3206.90,6.03},
		price = 15000,
		vehSpawn = {1234.50,-3207.37,5.83,184.76},
		refill = {pos = {1242.85,-3206.78,6.03}, marker = {drawDist = 20.0, type = 27, scale = {x=3.0,y=3.0,z=1.0}, color = {r=220,g=60,b=60,a=100}}},
		cargoMarker = {drawDist = 10.0, type = 2, scale = {x=0.3,y=0.3,z=0.3}, color = {r=220,g=60,b=60,a=100}},
		cargo = {
			[1] = {1231.97,-3209.95,5.86},
			[2] = {1229.68,-3209.95,5.86},
			[3] = {1227.23,-3209.97,5.86},
			[4] = {1225.07,-3210.00,5.86},
			[5] = {1222.46,-3210.11,5.86},
		},
		trailerSpawn = {1219.26,3206.88,5.79,181.77},
		forklift = {pos = {1240.81,-3209.65,5.87,90.88}, model = "forklift"}
	},
	[3] = { -- MUTINY ROAD 1
		menuPos = {-657.83,-1706.07,24.84},
		price = 15000,
		vehSpawn = {-644.5,-1711.88,24.57,310.26},
		refill = {pos = {-651.76,-1715.99,24.69}, marker = {drawDist = 20.0, type = 27, scale = {x=3.0,y=3.0,z=1.0}, color = {r=220,g=60,b=60,a=100}}},
		cargoMarker = {drawDist = 10.0, type = 2, scale = {x=0.3,y=0.3,z=0.3}, color = {r=220,g=60,b=60,a=100}},
		cargo = {
			[1] = {-652.05,-1713.0,24.7},
			[2] = {-655.414,-1724.405,24.729},
			[3] = {-655.539,-1722.475,24.741},
			[4] = {-655.731,-1721.024,24.752},
			[5] = {-655.783,-1719.32,24.76},
		},
		trailerSpawn = {-637.64,-1726.06,24.28,40.94},
		forklift = {pos = {-652.46,-1721.66,24.68,191.97}, model = "forklift"}
	},
	[4] = { -- MUTINY ROAD 2
		menuPos = {-653.1,-1752.5,24.63},
		price = 15000,
		vehSpawn = {-655.77,-1746.65,24.72,90.13},
		refill = {pos = {-655.993,-1745.337,24.728}, marker = {drawDist = 20.0, type = 27, scale = {x=3.0,y=3.0,z=1.0}, color = {r=220,g=60,b=60,a=100}}},
		cargoMarker = {drawDist = 10.0, type = 2, scale = {x=0.3,y=0.3,z=0.3}, color = {r=220,g=60,b=60,a=100}},
		cargo = {
			[1] = {-635.395,-1743.093,24.114},
			[2] = {-636.332,-1743.851,24.138},
			[3] = {-637.789,-1745.029,24.174},
			[4] = {-638.921,-1745.98,24.203},
			[5] = {-640.075,-1746.981,24.232},
		},
		trailerSpawn = {-649.98,-1735.62,24.56,187.48},
		forklift = {pos = {-639.58,-1740.72,24.25,128.76}, model = "forklift"}
	},
	[5] = { -- ARSENAL STREET 1
		menuPos = {-469.69,-1721.64,18.69},
		price = 15000,
		vehSpawn = {-451.96,-1719.4,18.75,355.35},
		refill = {pos = {-466.63,-1721.33,18.64}, marker = {drawDist = 20.0, type = 27, scale = {x=3.0,y=3.0,z=1.0}, color = {r=220,g=60,b=60,a=100}}},
		cargoMarker = {drawDist = 10.0, type = 2, scale = {x=0.3,y=0.3,z=0.3}, color = {r=220,g=60,b=60,a=100}},
		cargo = {
			[1] = {-419.261,-1683.939,19.029},
			[2] = {-419.977,-1685.741,19.029},
			[3] = {-420.723,-1687.66,19.029},
			[4] = {-421.36,-1689.503,19.029},
			[5] = {-421.997,-1691.359,19.029},
		},
		trailerSpawn = {-451.82,-1694.38,18.94,158.96},
		forklift = {pos = {-462.13,-1721.25,18.63,343.63}, model = "forklift"}
	},
	[6] = { -- ARSENAL STREET 2
		menuPos = {-470.63,-1718.17,18.69},
		price = 15000,
		vehSpawn = {-457.39,-1717.8,18.63,353.77},
		refill = {pos = {-467.65,-1717.32,18.69}, marker = {drawDist = 20.0, type = 27, scale = {x=3.0,y=3.0,z=1.0}, color = {r=220,g=60,b=60,a=100}}},
		cargoMarker = {drawDist = 10.0, type = 2, scale = {x=0.3,y=0.3,z=0.3}, color = {r=220,g=60,b=60,a=100}},
		cargo = {
			[1] = {-422.494,-1674.837,19.029},
			[2] = {-420.692,-1675.463,19.029},
			[3] = {-418.968,-1676.098,19.029},
			[4] = {-416.942,-1676.852,19.029},
			[5] = {-414.258,-1677.849,19.029},
		},
		trailerSpawn = {-461.18,-1695.35,18.97,219.81},
		forklift = {pos = {-467.21,-1712.71,18.68,287.58}, model = "forklift"}
	},
	[7] = { -- SENORA ROAD 1
		menuPos = {1210.92,1857.76,78.91},
		price = 15000,
		vehSpawn = {1218.43,1873.01,78.93,113.0},
		refill = {pos = {1211.18,1862.78,78.91}, marker = {drawDist = 20.0, type = 27, scale = {x=3.0,y=3.0,z=1.0}, color = {r=220,g=60,b=60,a=100}}},
		cargoMarker = {drawDist = 10.0, type = 2, scale = {x=0.3,y=0.3,z=0.3}, color = {r=220,g=60,b=60,a=100}},
		cargo = {
			[1] = {1221.747,1869.012,78.893},
			[2] = {1220.148,1867.711,78.893},
			[3] = {1217.933,1865.703,78.888},
			[4] = {1216.247,1864.252,78.892},
			[5] = {1214.192,1862.485,78.898},
		},
		trailerSpawn = {1220.0,1886.37,78.76,148.2},
		forklift = {pos = {1223.52,1879.51,78.9,128.65}, model = "forklift"}
	},
	[8] = { -- SENORA ROAD 2
		menuPos = {1207.58,1854.78,78.91},
		price = 15000,
		vehSpawn = {1197.42,1850.14,78.84,137.78},
		refill = {pos = {1204.98,1856.1,78.92}, marker = {drawDist = 20.0, type = 27, scale = {x=3.0,y=3.0,z=1.0}, color = {r=220,g=60,b=60,a=100}}},
		cargoMarker = {drawDist = 10.0, type = 2, scale = {x=0.3,y=0.3,z=0.3}, color = {r=220,g=60,b=60,a=100}},
		cargo = {
			[1] = {1196.536,1843.15,78.772},
			[2] = {1195.634,1841.073,78.675},
			[3] = {1194.864,1839.003,78.587},
			[4] = {1193.881,1837.033,78.536},
			[5] = {1197.108,1839.906,78.705},
		},
		trailerSpawn = {1202.14,1867.97,78.02,140.66},
		forklift = {pos = {1204.27,1859.15,78.87,138.53}, model = "forklift"}
	},
	[9] = { -- SENORA ROAD 3
		menuPos = {1218.99,1848.49,78.95},
		price = 15000,
		vehSpawn = {1207.03,1833.69,78.88,112.21},
		refill = {pos = {1219.79,1844.82,79.04}, marker = {drawDist = 20.0, type = 27, scale = {x=3.0,y=3.0,z=1.0}, color = {r=220,g=60,b=60,a=100}}},
		cargoMarker = {drawDist = 10.0, type = 2, scale = {x=0.3,y=0.3,z=0.3}, color = {r=220,g=60,b=60,a=100}},
		cargo = {
			[1] = {1201.821,1837.973,78.868},
			[2] = {1199.954,1837.388,78.843},
			[3] = {1198.087,1836.949,78.81},
			[4] = {1196.257,1835.953,78.705},
			[5] = {1199.297,1839.34,78.775},
		},
		trailerSpawn = {1222.94,1825.72,79.3,29.97},
		forklift = {pos = {1216.17,1841.58,78.97,173.77}, model = "forklift"}
	},
	[10] = { -- SENORA ROAD 4
		menuPos = {1243.22,1869.45,78.97},
		price = 15000,
		vehSpawn = {1247.46,1856.43,79.68,131.74},
		refill = {pos = {1244.16,1865.08,79.21}, marker = {drawDist = 20.0, type = 27, scale = {x=3.0,y=3.0,z=1.0}, color = {r=220,g=60,b=60,a=100}}},
		cargoMarker = {drawDist = 10.0, type = 2, scale = {x=0.3,y=0.3,z=0.3}, color = {r=220,g=60,b=60,a=100}},
		cargo = {
			[1] = {1235.155,1855.684,79.342},
			[2] = {1236.083,1857.407,79.309},
			[3] = {1237.419,1859.969,79.198},
			[4] = {1238.537,1862.419,79.075},
			[5] = {1239.976,1864.667,79.02},
		},
		trailerSpawn = {1266.47,1874.73,80.78,132.89},
		forklift = {pos = {1241.99,1861.6,79.28,181.11}, model = "forklift"}
	},
	[11] = { -- ORCHADVILE AVE
		menuPos = {967.74,-1828.91,31.23},
		price = 15000,
		vehSpawn = {969.05,-1815.87,31.08,84.06},
		refill = {pos = {968.30,-1812.69,31.15}, marker = {drawDist = 20.0, type = 27, scale = {x=3.0,y=3.0,z=1.0}, color = {r=220,g=60,b=60,a=100}}},
		cargoMarker = {drawDist = 10.0, type = 2, scale = {x=0.3,y=0.3,z=0.3}, color = {r=220,g=60,b=60,a=100}},
		cargo = {
			[1] = {987.79,-1817.91,31.14},
			[2] = {988.31,-1812.65,31.16},
			[3] = {987.5,-1823.31,31.13},
			[4] = {987.03,-1828.91,31.1},
			[5] = {980.1,-1815.8,31.18},
		},
		trailerSpawn = {956.02,-1822.44,31.25,174.5},
		forklift = {pos = {976.59,-1826.04,31.16,355.95}, model = "forklift"}
	},
	[12] = { -- DEL PERO
		menuPos = {-1306.12,-801.63,17.56},
		price = 15000,
		vehSpawn = {-1312.312,-790.77,17.92,124.33},
		refill = {pos = {-1303.65,-794.66,17.56}, marker = {drawDist = 20.0, type = 27, scale = {x=3.0,y=3.0,z=1.0}, color = {r=220,g=60,b=60,a=100}}},
		cargoMarker = {drawDist = 10.0, type = 2, scale = {x=0.3,y=0.3,z=0.3}, color = {r=220,g=60,b=60,a=100}},
		cargo = {
			[1] = {-1287.66,-794.48,17.59},
			[2] = {-1295.85,-788.73,17.55},
			[3] = {-1271.51,-814.63,17.11},
			[4] = {-1281.08,-829.04,17.1},
			[5] = {-1316.71,-763.55,20.38},
		},
		trailerSpawn = {-1298.15,-790.88,17.57,37.81},
		forklift = {pos = {-1292.58,-808.03,17.58,307.29}, model = "forklift"}
	},
	[13] = { -- DEL PERO 2
		menuPos = {-1348.95,-760.3,22.46},
		price = 15000,
		vehSpawn = {-1342.36,-751.06,22.4,39.31},
		refill = {pos = {-1344.77,-756.54,22.46}, marker = {drawDist = 20.0, type = 27, scale = {x=3.0,y=3.0,z=1.0}, color = {r=220,g=60,b=60,a=100}}},
		cargoMarker = {drawDist = 10.0, type = 2, scale = {x=0.3,y=0.3,z=0.3}, color = {r=220,g=60,b=60,a=100}},
		cargo = {
			[1] = {-1335.29,-759.57,20.37},
			[2] = {-1339.79,-762.81,20.31},
			[3] = {-1344.34,-767.1,20.22},
			[4] = {-1348.16,-769.89,20.16},
			[5] = {-1351.25,-772.28,20.1},
		},
		trailerSpawn = {-1315.00,-769.49,20.04,217.81},
		forklift = {pos = {-1352.33,-751.81,22.29,308.42}, model = "forklift"}
	},
	[14] = { -- GoPostal
		menuPos = {53.41,114.7,79.2},
		price = 15000,
		vehSpawn = {58.29,117.16,79.09,252.7},
		refill = {pos = {65.78,112.6,79.09}, marker = {drawDist = 20.0, type = 27, scale = {x=3.0,y=3.0,z=1.0}, color = {r=220,g=60,b=60,a=100}}},
		cargoMarker = {drawDist = 10.0, type = 2, scale = {x=0.3,y=0.3,z=0.3}, color = {r=220,g=60,b=60,a=100}},
		cargo = {
			[1] = {58.37,122.1,79.21},
			[2] = {59.57,125.71,79.25},
			[3] = {60.84,129.24,79.22},
			[4] = {63.38,127.88,79.21},
			[5] = {66.41,126.71,79.18},
		},
		trailerSpawn = {70.08,119.41,79.15,161.06},
		forklift = {pos = {72.49,110.68,79.11,65.42}, model = "forklift"}
	},
}

-- Marker Settings for delivery spots
Config.DeliveryMarkerSpots = {type = 2, scale = {x=0.35,y=0.35,z=0.35}, color = {r=220,g=60,b=60,a=100} }

Config.JobValues = {
	[1] = {
		label = "Low", level = 0, certificate = false,
		vehicles = {
			[1] = {name = "Surfer 2", model = "surfer2", deposit = 50},
			[2] = {name = "Speedo", model = "speedo", deposit = 100},
			[3] = {name = "Burrito 3", model = "burrito3", deposit = 150},
			[4] = {name = "Rumpo", model = "rumpo", deposit = 200}
		}
	},
	[2] = {
		label = "Medium", level = 20, certificate = false,
		vehicles = {
			[1] = {name = "Boxville 2", model = "boxville2", deposit = 150},
			[2] = {name = "Boxville 4", model = "boxville4", deposit = 300}
		}
	},
	[3] = {
		label = "High", level = 50, certificate = true,
		vehicles = { 
			[1] = {name = "Hauler", model = "hauler", deposit = 150},
			[2] = {name = "Packer", model = "packer", deposit = 300},
			[3] = {name = "Phantom", model = "phantom", deposit = 450},
		}
	},
	[4] = {
		label = "Shops", level = 0, certificate = false,
		vehicles = { 
			[1] = {name = "Speedo", model = "speedo", deposit = 100},
			[2] = {name = "Burrito 3", model = "burrito3", deposit = 150},
			[3] = {name = "Boxville 2", model = "boxville2", deposit = 250},
			[4] = {name = "Boxville 4", model = "boxville4", deposit = 300},
		}
	},
}

Config.ParcelProp = "prop_cs_cardbox_01"		-- set prop type for low value jobs
Config.LowValueJobs = {
	[1] = {pos = {85.63,-1959.32,21.12}, done = false},
	[2] = {pos = {-14.09,-1442.06,31.1}, done = false},
	[3] = {pos = {334.67,-2057.93,20.94}, done = false},
	[4] = {pos = {479.67,-1736.01,29.15}, done = false},
	[5] = {pos = {-1075.48,-1645.37,4.5}, done = false},
	[6] = {pos = {-1132.46,-1455.88,4.87}, done = false},
	[7] = {pos = {-951.8,-1078.59,2.15}, done = false},
	[8] = {pos = {-911.93,-1511.76,5.02}, done = false},
	[9] = {pos = {-1112.03,-902.51,3.6}, done = false},
	[10] = {pos = {976.25,-580.07,59.64}, done = false},
	[11] = {pos = {1303.06,-527.99,71.46}, done = false}
}

Config.MedValueJobs = {
	[1] = {
		name = "Clothing",
		prop = "prop_tshirt_box_01",
		deliveries = {
			[1] = {pos = {79.34,-1389.52,29.38}, done = false},
			[2] = {pos = {-1198.24,-774.43,17.32}, done = false},
			[3] = {pos = {421.83,-809.75,29.49}, done = false},
			[4] = {pos = {-1456.23,-234.61,49.8}, done = false},
			[5] = {pos = {-3169.31,1052.05,20.86}, done = false},
			[6] = {pos = {-1096.36,2710.0,19.11}, done = false},
			[7] = {pos = {616.91,2754.84,42.09}, done = false},
			[8] = {pos = {126.58,-215.31,54.56}, done = false},
		},
	},
	[2] = {
		name = "Liquor",
		prop = "prop_crate_11e",
		deliveries = {
			[1] = {pos = {-56.64,-1750.96,29.42}, done = false},
			[2] = {pos = {33.64,-1346.68,29.5}, done = false},
			[3] = {pos = {-1487.03,-383.3,40.16}, done = false},
			[4] = {pos = {1137.89,-978.62,46.42}, done = false},
			[5] = {pos = {-1227.16,-906.51,12.33}, done = false},
			[6] = {pos = {381.54,324.29,103.57}, done = false},
			[7] = {pos = {1169.23,2706.28,38.16}, done = false},
			[8] = {pos = {539.92,2670.01,42.16}, done = false},
		},
	},
}

Config.HighValueJobs = {
	[1] = {
		name = "Liquor",
		trailer = "Trailers2",
		prop = "prop_boxpile_06a",
		route = {
			[1] = {pos = {-306.35,-2714.35,6.0,314.45}, pallet = {pickup = {-313.6,-2717.76,6.0,226.09}, drop_off = {-306.9,-2728.23,6.0}}, done = false},
			[2] = {pos = {-201.63,-2390.17,6.0,269.95}, pallet = {pickup = {-203.16,-2394.94,6.0,89.49}, drop_off = {-211.23,-2385.75,6.0}}, done = false},
			[3] = {pos = {-536.15,-2841.45,6.0,19.78}, pallet = {pickup = {-527.42,-2840.9,6.0,119.35}, drop_off = {-536.44,-2849.78,6.01}}, done = false},
			[4] = {pos = {58.26,-2529.96,6.01,328.5}, pallet = {pickup = {60.87,-2534.63,6.0,61.36}, drop_off = {49.01,-2531.46,6.01}}, done = false},
			[5] = {pos = {-161.28,-2659.04,6.0,271.15}, pallet = {pickup = {-164.27,-2664.0,6.0,359.45}, drop_off = {-168.86,-2654.88,6.0}}, done = false},
		},
	},
	[2] = {
		name = "Groceries",
		trailer = "Trailers2",
		prop = "prop_boxpile_06a",
		route = {
			[1] = {pos = {-306.35,-2714.35,6.0,314.45}, pallet = {pickup = {-313.6,-2717.76,6.0,226.09}, drop_off = {-306.9,-2728.23,6.0}}, done = false},
			[2] = {pos = {-201.63,-2390.17,6.0,269.95}, pallet = {pickup = {-203.16,-2394.94,6.0,89.49}, drop_off = {-211.23,-2385.75,6.0}}, done = false},
			[3] = {pos = {-536.15,-2841.45,6.0,19.78}, pallet = {pickup = {-527.42,-2840.9,6.0,119.35}, drop_off = {-536.44,-2849.78,6.01}}, done = false},
			[4] = {pos = {58.26,-2529.96,6.01,328.5}, pallet = {pickup = {60.87,-2534.63,6.0,61.36}, drop_off = {49.01,-2531.46,6.01}}, done = false},
			[5] = {pos = {-161.28,-2659.04,6.0,271.15}, pallet = {pickup = {-164.27,-2664.0,6.0,359.45}, drop_off = {-168.86,-2654.88,6.0}}, done = false},
		},
	},
}

