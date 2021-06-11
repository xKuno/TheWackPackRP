Config = {}

Config.webhook = "WEBHOOK"						-- Webhook to send logs to discord
Config.lang = "en"								-- Set the file language [en/br]

Config.ESX = {									-- ESX settings, if you are using vRP just ignore
	['ESXSHAREDOBJECT'] = "esx:getSharedObject",-- Change your getshared object event here, if you are using anti-cheat
	['account_stores'] = 'bank',				-- Change here the account that should be used with gas station expenses
}

Config.format = {
	['currency'] = 'USD',						-- This is the currency format, so that your currency symbol appears correctly [Examples: BRL, USD]
	['location'] = 'en-US'						-- This is the location of your country, to format the decimal places according to your standard [Examples: pt-BR, en-US]
}

Config.max_stations_per_player = 1				-- Maximum number of stores that each player can have

-- Here are the places where the person can open the gas station menu
-- You can add as many locations as you like, just use the location already created as an example
Config.gas_station_locations = {
	["gas_station_1"] = {										-- ID
		['buy_price'] = 150000,									-- Price to buy this gas station
		['sell_price'] = 112500,	     							-- Price to sell this gas station
		['coord'] = {289.27,-1267.01,29.45},					-- Coordinates to open the menu
		['truck_coord'] = {278.33,-1243.18,29.2,185.71},		-- Garage coordinates, where trucks will spawn (coordinates made up of x, y, z, h)
		['trailer_coord'] = {284.9,-1245.9,29.22,178.75},		-- Garage coordinates, where the truck trailers will spawn (coordinates composed of x, y, z, h)
		['deliveryman_coord'] = {288.56,-1269.86,29.45},		-- Coordinates where the delivery person will take the jobs you created
		['type'] = 'small_gas_station', 						-- Enter the gas station type ID here
	},
	["gas_station_2"] = { -- Vespucci Boul - ESP
		['buy_price'] = 150000,
		['sell_price'] = 112500,
		['coord'] = {818.1,-1040.54,26.76},
		['truck_coord'] = {827.26,-1045.28,27.25,352.23},
		['trailer_coord'] = {825.43,-1058.54,27.95,349.77},
		['deliveryman_coord'] = {820.73,-1040.27,26.76},
		['type'] = 'small_gas_station',
	},
	["gas_station_3"] = { -- El Rancho
		['buy_price'] = 150000,
		['sell_price'] = 112500,
		['coord'] = {1211.36,-1389.19,35.38},
		['truck_coord'] = {1197.71,-1403.83,35.23,174.42},
		['trailer_coord'] = {1197.73,-1392.26,35.23,179.75},
		['deliveryman_coord'] = {1207.58,-1389.69,35.38},
		['type'] = 'small_gas_station',
	},
	["gas_station_4"] = { -- Mirror Park
		['buy_price'] = 125000,
		['sell_price'] = 112500,
		['coord'] = {1167.22,-321.45,69.28,101.94},
		['truck_coord'] = {1158.52,-339.37,68.07,195.21},
		['trailer_coord'] = {1154.73,-340.22,67.78,182.82},
		['deliveryman_coord'] = {1164.85,-326.2,69.25,16.22},
		['type'] = 'small_gas_station',
	},
	["gas_station_5"] = { -- Clinton Avenue
		['buy_price'] = 150000,
		['sell_price'] = 112500,
		['coord'] = {642.37,260.39,103.3,240.42},
		['truck_coord'] = {640.34,275.72,103.14,148.4},
		['trailer_coord'] = {644.27,274.14,103.14,149.89},
		['deliveryman_coord'] = {646.51,267.58,103.26,241.78},
		['type'] = 'small_gas_station',
	},
	["gas_station_6"] = { -- Palemino FWY
		['buy_price'] = 150000,
		['sell_price'] = 112500,
		['coord'] = {2559.1,373.79,108.63,89.26},
		['truck_coord'] = {2583.31,407.09,108.46,180.32},
		['trailer_coord'] = {2588.93,407.35,108.46,177.83},
		['deliveryman_coord'] = {2559.44,356.5,108.63,85.51},
		['type'] = 'small_gas_station',
	},
	["gas_station_7"] = { --  Davis Avenue
		['buy_price'] = 150000,
		['sell_price'] = 112500,
		['coord'] = {166.83,-1553.26,29.27,42.35},
		['truck_coord'] = {181.51,-1552.6,29.18,220.92},
		['trailer_coord'] = {184.35,-1549.41,29.19,212.39},
		['deliveryman_coord'] = {164.66,-1556.33,29.27,43.06},
		['type'] = 'small_gas_station',
	},
	["gas_station_8"] = {  -- Alta Street
		['buy_price'] = 150000,
		['sell_price'] = 112500,
		['coord'] = {-342.5,-1475.09,30.75,87.6},
		['truck_coord'] = {-332.91,-1486.36,30.62,12.0},
		['trailer_coord'] = {-337.62,-1486.47,30.59,1.16},
		['deliveryman_coord'] = {-342.61,-1485.99,30.76,89.84},
		['type'] = 'small_gas_station',
	},
	["gas_station_9"] = {  -- Sandy Airfeild
		['buy_price'] = 150000,
		['sell_price'] = 112500,
		['coord'] = {1776.34,3327.44,41.44,118.91},
		['truck_coord'] = {1784.93,3322.97,41.42,317.42},
		['trailer_coord'] = {1787.89,3318.95,41.62,301.42},
		['deliveryman_coord'] = {1777.64,3325.0,41.44,120.45},
		['type'] = 'small_gas_station',
	},
	["gas_station_10"] = { -- Route 68 Zero Market
		['buy_price'] = 150000,
		['sell_price'] = 112500,
		['coord'] = {46.66,2789.41,57.88,322.54},
		['truck_coord'] = {61.19,2780.46,57.88,145.73},
		['trailer_coord'] = {64.39,2777.86,57.88,145.99},
		['deliveryman_coord'] = {56.1,2785.75,57.88,325.04},
		['type'] = 'small_gas_station',
	},
	["gas_station_11"] = { -- Joshua Road
		['buy_price'] = 150000,
		['sell_price'] = 112500,
		['coord'] = {265.9,2598.27,44.84,187.59},
		['truck_coord'] = {236.38,2602.51,45.32,15.15},
		['trailer_coord'] = {241.88,2605.24,45.15,98.1},
		['deliveryman_coord'] = {268.28,2598.66,44.84,193.58},
		['type'] = 'small_gas_station',
	},
	["gas_station_12"] = { --  Route 68 - Cafe Gas
		['buy_price'] = 150000,
		['sell_price'] = 112500,
		['coord'] = {1039.27,2664.23,39.56,184.1},
		['truck_coord'] = {1028.3,2669.53,39.56,359.01},
		['trailer_coord'] = {1022.44,2669.65,39.56,2.54},
		['deliveryman_coord'] = {1036.28,2664.8,39.56,173.18},
		['type'] = 'small_gas_station',
	},
	["gas_station_13"] = { -- Harmony Garage
		['buy_price'] = 150000,
		['sell_price'] = 112500,
		['coord'] = {1200.68,2655.62,37.86,129.51},
		['truck_coord'] = {1211.54,2645.8,37.83,350.83},
		['trailer_coord'] = {1194.27,2664.12,37.81,307.48},
		['deliveryman_coord'] = {1204.73,2653.79,37.86,130.24},
		['type'] = 'small_gas_station',
	},
	["gas_station_14"] = { -- Route 68 - Rex's Diner
		['buy_price'] = 150000,
		['sell_price'] = 112500,
		['coord'] = {2561.88,2590.69,38.09,111.26},
		['truck_coord'] = {2537.62,2614.28,37.95,284.28 },
		['trailer_coord'] = {2539.67,2609.49,37.95,294.62},
		['deliveryman_coord'] = {2560.25,2595.21,38.09,111.04},
		['type'] = 'small_gas_station',
	},
	["gas_station_15"] = { -- South Senora
		['buy_price'] = 125000,
		['sell_price'] = 112500,
		['coord'] = {2673.71,3266.88,55.25,65.02},
		['truck_coord'] = {2663.11,3250.49,54.96,240.18},
		['trailer_coord'] = {2666.79,3256.28,55.25,245.83},
		['deliveryman_coord'] = {2677.61,3272.99,55.41,60.26},
		['type'] = 'small_gas_station',
	},
	["gas_station_16"] = { -- Sandy Shores
		['buy_price'] = 150000,
		['sell_price'] = 112500,
		['coord'] = {2001.46,3779.97,32.19,27.27},
		['truck_coord'] = {1977.54,3769.05,32.19,208.79},
		['trailer_coord'] = {1983.13,3771.28,32.19,205.63},
		['deliveryman_coord'] = {2006.31,3782.1,32.19,31.42},
		['type'] = 'small_gas_station',
	},
	["gas_station_17"] = { -- Grape Seed
		['buy_price'] = 125000,
		['sell_price'] = 112500,
		['coord'] = {1702.81,4917.25,42.23,327.75},
		['truck_coord'] = {1685.22,4923.52,42.08,51.58},
		['trailer_coord'] = {1682.18,4920.22,42.08,53.27},
		['deliveryman_coord'] = {1696.73,4927.44,42.24,234.67},
		['type'] = 'small_gas_station',
	},
	["gas_station_18"] = { -- North Senora
		['buy_price'] = 125000,
		['sell_price'] = 112500,
		['coord'] = {1706.25,6425.88,32.78,337.42},
		['truck_coord'] = {1711.78,6415.53,32.95,157.15},
		['trailer_coord'] = {1716.57,6412.93,33.53,156.53},
		['deliveryman_coord'] = {1698.68,6426.06,32.77,337.51},
		['type'] = 'small_gas_station',
	},
	["gas_station_19"] = { -- Paleto Bay Garage
		['buy_price'] = 150000,
		['sell_price'] = 112500,
		['coord'] = {156.4,6628.03,31.84,320.48},
		['truck_coord'] = {167.99,6602.3,31.85,182.23},
		['trailer_coord'] = {162.8,6600.87,31.86,189.62},
		['deliveryman_coord'] = {180.97,6600.43,32.05,99.79},
		['type'] = 'small_gas_station',
	},
	["gas_station_20"] = { -- Paleto Boul
		['buy_price'] = 150000,
		['sell_price'] = 112500,
		['coord'] = {-92.59,6409.92,31.65,227.57},
		['truck_coord'] = {-84.41,6425.86,31.5,45.22},
		['trailer_coord'] = {-80.86,6430.33,31.5,46.0},
		['deliveryman_coord'] = {-90.66,6414.05,31.65,221.1},
		['type'] = 'small_gas_station',
	},
	["gas_station_21"] = {  -- Route 68 / Fort Zancudo
		['buy_price'] = 150000,
		['sell_price'] = 112500,
		['coord'] = {-2544.05,2315.94,33.22,188.89},
		['truck_coord'] = {-2520.51,2338.61,33.06,208.15},
		['trailer_coord'] = {-2524.16,2336.7,33.06,209.23},
		['deliveryman_coord'] = {-2552.98,2315.94,33.22,172.08},
		['type'] = 'small_gas_station',
	},
	["gas_station_22"] = { -- North Rockford
		['buy_price'] = 125000,
		['sell_price'] = 112500,
		['coord'] = {-1818.72,796.68,138.14,128.86},
		['truck_coord'] = {-1819.58,774.97,136.93,208.09},
		['trailer_coord'] = {-1816.09,777.12,137.05,215.49},
		['deliveryman_coord'] = {-1818.08,791.34,138.12,41.34},
		['type'] = 'small_gas_station',
	},
	["gas_station_23"] = { -- Morningwood Boul
		['buy_price'] = 150000,
		['sell_price'] = 112500,
		['coord'] = {-1427.92,-268.1,46.23,309.63},
		['truck_coord'] = {-1425.13,-285.27,46.22,128.54},
		['trailer_coord'] = {-1418.41,-284.97,46.27,127.03},
		['deliveryman_coord'] = {-1435.93,-259.56,46.27,318.99},
		['type'] = 'small_gas_station',
	},
	["gas_station_24"] = { -- West Eclipse
		['buy_price'] = 150000,
		['sell_price'] = 112500,
		['coord'] = {-2073.02,-327.4,13.32,265.21},
		['truck_coord'] = {-2086.82,-331.87,13.03,81.77},
		['trailer_coord'] = {-2087.14,-335.31,13.04,79.5},
		['deliveryman_coord'] = {-2073.57,-324.56,13.32,263.24},
		['type'] = 'small_gas_station',
	},
	["gas_station_25"] = {  -- Little Seoul
		['buy_price'] = 125000,
		['sell_price'] = 112500,
		['coord'] = {-703.0,-916.85,19.22,359.45},
		['truck_coord'] = {-711.72,-929.02,19.02,177.74},
		['trailer_coord'] = {-706.4,-929.02,19.02,177.91},
		['deliveryman_coord'] = {-706.55,-917.16,19.22,356.88},
		['type'] = 'small_gas_station',
	},
	["gas_station_26"] = { -- Dutch London
		['buy_price'] = 150000,
		['sell_price'] = 112500,
		['coord'] = {-531.43,-1221.15,18.46,152.6},
		['truck_coord'] = {-514.5,-1201.33,19.1,314.81},
		['trailer_coord'] = {-511.64,-1206.39,18.75,315.84},
		['deliveryman_coord'] = {-535.7,-1218.22,18.46,149.83},
		['type'] = 'small_gas_station',
	},
	["gas_station_27"] = {  -- Grove Street
		['buy_price'] = 125000,
		['sell_price'] = 112500,
		['coord'] = {-49.33,-1760.37,29.44,316.8},
		['truck_coord'] = {-68.88,-1744.15,29.36,123.63},
		['trailer_coord'] = {-67.02,-1748.64,29.45,108.54},
		['deliveryman_coord'] = {-51.57,-1758.84,29.44,317.78},
		['type'] = 'small_gas_station',
	}
}

-- Here you configure each type of gas station available for purchase
Config.gas_station_types = {
	['small_gas_station'] = {					-- Gas station type ID
		['stock_capacity'] = 1000,				-- Maximum stock capacity
		['min_gas_price'] = 200,					-- Minimum price that the owner can apply
		['max_gas_price'] = 5,					-- Maximum price that the owner can apply
		['upgrades'] = {						-- Definition of each upgrade
			['stock'] = {						-- Stock capacity
				['price'] = 25000,				-- Price
				['level_reward'] = {			-- Reward for each level (maximum level: 5)
					[0] = 0,
					[1] = 250,
					[2] = 500,
					[3] = 1000,
					[4] = 1500,
					[5] = 2000,
				}
			},
			['truck'] = {						-- Truck capacity
				['price'] = 40000,
				['level_reward'] = {
					[0] = 0,
					[1] = 10,
					[2] = 20,
					[3] = 30,
					[4] = 40,
					[5] = 50,
				}
			},
			['relationship'] = {                -- Relationship
                ['price'] = 50000,
                ['level_reward'] = {
                    [0] = 0,
                    [1] = 5,
                    [2] = 10,
                    [3] = 15,
                    [4] = 20,
                    [5] = 25,
                }
            },
		},
		['ressuply_deliveryman'] = {					-- Driver contracts
			['max_amount'] = 500,						-- Maximum amount of fuel per contract
			['price_per_liter'] = 1  					-- Standard price per contract liter
		},
		['ressuply'] = {								-- Definition of contracts for the owner
			[1] = {
				['name'] = 'Small cargo',				-- Name in contract
				['price_per_liter_to_import'] = 1,		-- Price per liter to import
				['price_per_liter_to_export'] = 2,		-- Price per liter to export
				['liters'] = 50,						-- Delivery liters
				['max_distance'] = 3,					-- Maximum distance that a delivery is generated
				['truck_level'] = 0,					-- Required truck level
				['img'] = 'combustivel.png'				-- Image
			},
			[2] = {
				['name'] = 'Medium cargo',
				['price_per_liter_to_import'] = 1,
				['price_per_liter_to_export'] = 2,
				['liters'] = 100,
				['max_distance'] = 5.5,
				['truck_level'] = 2,
				['img'] = 'barril.png'
			},
			[3] = {
				['name'] = 'Large cargo',
				['price_per_liter_to_import'] = 1,
				['price_per_liter_to_export'] = 2,
				['liters'] = 200,
				['max_distance'] = 99,
				['truck_level'] = 5,
				['img'] = 'caminhao.png'
			}
		},
		['blips'] = {							-- Create the blips on the map
			['id'] = 361,						-- Blip ID [Set this value to 0 to not have a blip]
			['name'] = "Gas Station",			-- Blip Name
			['color'] = 41,						-- Blip Color
			['scale'] = 0.5,					-- Blip Scale
		}
	}
}

-- Configuration to remove stores from those who are inactive
Config.clear_gas_stations = {
	['active'] = true,				-- Set to false to disable this function
	['min_stock_amount'] = 5,		-- Minimum percentage of inventory to consider an inactive store. Stores that have been inactive for a long time will be removed
	['cooldown'] = 120				-- Time (in hours) that the store needs to be below the minimum amount of stock to be removed
}

-- Trucks for each level by improving truck load
Config.trucks = {
	[0] = {
		['truck'] = 'speedo',
		['trailer'] = nil,
	},
	[1] = {
		['truck'] = 'gburrito',
		['trailer'] = nil,
	},
	[2] = {
		['truck'] = 'mule',
		['trailer'] = nil,
	},
	[3] = {
		['truck'] = 'mule3',
		['trailer'] = nil,
	},
	[4] = {
		['truck'] = 'pounder',
		['trailer'] = nil,
	},
	[5] = {
		['truck'] = 'hauler',
		['trailer'] = 'tanker',
	}
}
Config.keyToUnlockTruck = 182 	-- L key

-- Fuel locations
Config.delivery_locations = {
	{-758.14,5540.96,33.49,110.53},
	{-3046.19,143.27,11.6,11.14},
	{-1153.01,2672.99,18.1,312.25},
	{622.67,110.27,92.59,340.75},
	{-574.62,-1147.27,22.18,177.7},
	{376.31,2638.97,44.5,286.38},
	{1738.32,3283.89,41.13,16.24},
	{1419.98,3618.63,34.91,195.33},
	{1452.67,6552.02,14.89,138.69},
	{3472.4,3681.97,33.79,76.44},
	{2485.73,4116.13,38.07,66.71},
	{65.02,6345.89,31.22,206.64},
	{-303.28,6118.17,31.5,135.24},
	{-63.41,-2015.25,18.02,299.48},
	{-46.35,-2112.38,16.71,290.84},
	{-746.6,-1496.67,5.01,28.08},
	{369.54,272.07,103.11,247.94},
	{907.61,-44.12,78.77,323.08},
	{-1517.31,-428.29,35.45,55.77},
	{235.04,-1520.18,29.15,316.76},
	{34.8,-1730.13,29.31,226.06},
	{350.4,-2466.9,6.4,169.38},
	{1213.97,-1229.01,35.35,270.74},
	{1395.7,-2061.38,52.0,135.81},
	{729.09,-2023.63,29.31,268.75},
	{840.72,-1952.59,28.85,81.46},
	{551.76,-1840.26,25.34,40.72},
	{723.78,-1372.08,26.29,106.65},
	{-339.92,-1284.25,31.32,89.06},
	{1137.23,-1285.05,34.6,189.65},
	{466.93,-1231.55,29.95,267.14},
	{442.28,-584.28,28.5,252.12},
	{1560.52,888.69,77.46,19.02},
	{2561.78,426.67,108.46,301.57},
	{569.21,2730.83,42.07,91.35},
	{2665.4,1700.63,24.49,269.33},
	{1120.1,2652.5,38.0,181.77},
	{2004.23,3071.87,47.06,237.58},
	{2038.78,3175.7,45.09,140.47},
	{1635.54,3562.84,35.23,296.61},
	{2744.55,3412.43,56.57,247.48},
	{1972.17,3839.16,32.0,304.36},
	{1980.59,3754.65,32.18,211.64},
	{1716.0,4706.41,42.69,91.44},
	{1691.36,4918.42,42.08,57.29},
	{1971.07,5165.12,47.64,125.93},
	{1908.78,4932.06,48.97,340.08},
	{140.79,-1077.85,29.2,262.4},
	{-323.98,-1522.86,27.55,258.59},
	{-1060.53,-221.7,37.84,299.01},
	{2471.47,4463.07,35.3,277.56},
	{2699.47,3444.81,55.8,153.49},
	{-1060.53,-221.7,37.84,299.01},
	{2655.38,3281.01,55.24,63.99},
	{2730.39,2778.2,36.01,134.51},
	{-2966.68,363.37,14.77,359.8},
	{2788.89,2816.49,41.72,296.22},
	{-604.45,-1212.24,14.95,227.43},
	{2534.83,2589.08,37.95,2.48},
	{-143.31,205.88,92.12,86.41},
	{2347.04,2633.25,46.67,30.15},
	{860.47,-896.87,25.53,181.8},
	{973.34,-1038.19,40.84,272.3},
	{-409.04,1200.44,325.65,164.59},
	{-1617.77,3068.17,32.27,94.64},
	{-71.8,-1089.98,26.56,339.06},
	{-409.04,1200.44,325.65,164.59},
	{-1617.77,3068.17,32.27,94.64},
	{1246.34,1860.78,79.47,315.78},
	{-1777.63,3082.36,32.81,236.17},
	{-1775.87,3088.13,32.81,239.97},
	{-1827.5,2934.11,32.82,59.53},
	{-2123.69,3270.14,32.82,145.14},
	{-2444.59,2981.63,32.82,283.55},
	{-2448.59,2962.8,32.82,333.19},
	{-2277.86,3176.57,32.81,236.61},
	{-2969.0,366.46,14.77,292.99},
	{-1637.61,-814.53,10.17,139.15},
	{-1494.72,-891.67,10.11,73.06},
	{-902.27,-1528.42,5.03,106.23},
	{-1173.93,-1749.87,3.97,211.53},
	{-1087.8,-2047.55,13.23,314.93},
	{-1133.74,-2035.99,13.21,314.41},
	{-1234.4,-2092.3,13.93,173.93},
	{-1025.97,-2223.62,8.99,224.96},
	{850.42,2197.69,51.93,243.19},
	{42.61,2803.45,57.88,145.49},
	{-1193.54,-2155.4,13.2,138.82},
	{-1184.37,-2185.67,13.2,336.13},
	{2041.76,3172.26,44.98,155.2},
	{-465.48,-2169.09,10.01,9.47},
	{-3150.77,1086.55,20.7,339.24},
	{-433.69,-2277.29,7.61,268.97},
	{-395.18,-2182.97,10.29,94.54},
	{-3029.7,591.68,7.79,199.33},
	{-3029.7,591.68,7.79,199.33},
	{-1007.29,-3021.72,13.95,65.31},
	{-61.32,-1832.75,26.8,227.87},
	{822.72,-2134.28,29.29,349.36},
	{942.22,-2487.76,28.34,89.41},
	{729.29,-2086.53,29.3,89.29},
	{783.08,-2523.98,20.51,5.67},
	{717.8,-2111.18,29.22,272.62},
	{787.05,-1612.38,31.17,48.33},
	{913.52,-1556.87,30.74,272.14},
	{777.64,-2529.46,20.13,96.09},
	{846.71,-2496.12,28.34,81.07},
	{711.79,-1395.19,26.35,103.31},
	{723.38,-1286.3,26.3,90.13},
	{983.0,-1230.77,25.38,121.4},
	{818.01,-2422.85,23.6,174.28},
	{885.53,-1166.38,24.99,94.77},
	{700.85,-1106.93,22.47,163.11},
	{882.26,-2384.1,28.0,179.16},
	{977.83,-1821.21,31.17,354.2},
	{-1138.73,-759.77,18.87,234.36},
	{938.71,-1154.36,25.38,178.46},
	{973.0,-1156.18,25.43,267.36},
	{689.41,-963.48,23.49,178.61},
	{140.72,-375.29,43.26,336.19},
	{-497.09,-62.13,39.96,353.27},
	{-606.34,187.43,70.01,270.65},
	{117.12,-356.15,42.59,252.09},
	{53.91,-1571.07,29.47,137.1},
	
	{1528.1,1719.32,109.97,34.6},
	{1411.29,1060.33,114.34,269.14},
	{1145.76,-287.73,68.96,284.29},
	{1117.71,-488.25,65.25,166.07},
	{874.28,-949.16,26.29,358.46},
	{829.28,-874.08,25.26,270.18},
	{725.37,-874.53,24.67,265.96},
	{693.66,-1090.43,22.45,174.62},
	{977.51,-1013.67,41.32,270.83},
	{901.89,-1129.9,24.08,86.26},
	{911.7,-1258.04,25.58,33.69},
	{847.06,-1397.72,26.14,151.79},
	{830.67,-1409.13,26.16,334.64},
	{130.47,-1066.12,29.2,160.09},
	{-52.79,-1078.65,26.93,67.2},
	{-131.74,-1097.38,21.69,335.25},
	{-621.47,-1106.05,22.18,1.07},
	{-668.65,-1182.07,10.62,208.79},
	{-111.84,-956.71,27.27,339.83},
	{-1323.51,-1165.11,4.73,359.27},
	{-1314.65,-1254.96,4.58,19.95},
	{-1169.18,-1768.78,3.87,306.82},
	{-1343.38,-744.02,22.28,309.26},
	{-1532.84,-578.16,33.63,304.2},
	{-1461.4,-362.39,43.89,219.06},
	{-1457.25,-384.15,38.51,114.12},
	{-1544.42,-411.45,41.99,226.04},
	{-1432.72,-250.32,46.37,130.83},
	{-1040.24,-499.88,36.07,118.78},
	{346.43,-1107.19,29.41,177.11},
	{523.99,-2112.7,5.99,182.08},
	{977.19,-2539.34,28.31,353.75,357.42},
	{1101.01,-2405.39,30.76,259.61},
	{1591.9,-1714.0,88.16,120.75},
	{1693.41,-1497.45,113.05,66.92},
	{1029.44,-2501.31,28.43,149.34},
	{2492.55,-320.89,93.0,82.83},
	{2846.31,1463.1,24.56,74.93},
	{3631.05,3768.61,28.52,320.0},
	{3572.5,3665.53,33.9,75.93},
	{2919.03,4337.85,50.31,203.77},
	{2521.47,4203.47,39.95,327.93},
	{2926.2,4627.28,48.55,143.26},
	{3808.59,4463.22,4.37,87.61},
	{3323.71,5161.1,18.4,147.02},
	{2133.06,4789.57,40.98,26.62},
	{1900.83,4913.82,48.87,154.21},
	{381.06,3591.37,33.3,82.49},
	{642.8,3502.47,34.09,95.04},
	{277.33,2884.71,43.61,296.91},
	{-60.3,1961.45,190.19,294.86},
	{225.63,1244.33,225.46,194.24},
	{-1136.15,4925.14,220.01,262.73},
	{-519.96,5243.84,79.95,72.76},
	{-602.87,5326.63,70.46,168.65},
	{-797.95,5400.61,34.24,86.78},
	{-776.0,5579.11,33.49,167.58},
	{-704.2,5772.55,17.34,68.44},
	{-299.24,6300.27,31.5,134.2},
	{402.52,6619.61,28.26,357.71},
	{-247.72,6205.46,31.49,45.5},
	{-267.5,6043.45,31.78,50.59},
	{-16.29,6452.44,31.4,226.65},
	{2204.73,5574.04,53.74,351.31},
	{1638.98,4840.41,42.03,185.92},
	{1961.26,4640.93,40.71,293.6},
	{1776.61,4584.67,37.65,181.45},
	{137.29,281.73,109.98,335.6},
	{588.37,127.87,98.05,250.47},
	{199.8,2788.78,45.66,276.37},
	{708.58,-295.1,59.19,277.93},
	{581.28,2799.43,42.1,1.52},
	{1296.73,1424.35,100.45,178.89},
	{955.85,-22.89,78.77,147.51}
}