-------------------------------------
------- Created by T1GER#9080 -------
------------------------------------- 
Config 						= {}

-- General Settings:
Config.ESXSHAREDOBJECT 		= "esx:getSharedObject"	-- Change your getshared object event here, in case you are using anti-cheat.
Config.HasItemLabel			= true					-- set to false if your ESX doesn't support item labels.
Config.T1GER_DeliveryJob 	= true					-- set to false if u don't own this script. 

-- Settings:
Config.BuyShopWithCash 	 	= true		-- Set to false to purchase shops with bank.money.
Config.SellPercent		 	= 0.75		-- Means player gets 75% in return from original paid price.
Config.AccountsInCash		= true		-- Set to false to deposit/withdraw money into and from shop account with bank-money instead of cash money.
Config.ItemCompatibility	= true		-- If disabled, it doesnt check for type compatibility in Config.Items, meaning weapon shop owner could add bread, redgull etc.
Config.OrderItemPercent		= 75		-- Set percent between 1 and 100 of how much of the default item price is reduced, when ordering stock.
Config.BasketCommand		= 'basket'	-- Default command to open/view basket.
Config.InteractionMenuKey	= 178		-- Default [DEL]-

Config.ItemWeightSystem		= true		-- Set this to true if you are using weight instead of limit.
Config.WeaponLoadout		= false		-- Set this to false if you are using weapons as items.

Config.ShelfCreateDist		= 10.0 		-- Max distance from cashier to be able to create shelves.

-- Shops:
Config.Shops = {
    -- 24/7 / LTD
	[1] = {owned = false, type = "247LTD", price = 150000, buyable = true, b_menu = {-44.14,-1749.44,29.42}, cashier = {-47.29,-1756.7,29.42}, delivery = {-40.67,-1751.6,29.42}},             		-- Grove Street
	[2] = {owned = false, type = "247LTD", price = 175000, buyable = true, b_menu = {28.84,-1339.35,29.5}, cashier = {25.81,-1345.25,29.5}, delivery = {24.67,-1339.09,29.5}},                  	-- Innocence
	[3] = {owned = false, type = "247LTD", price = 150000, buyable = true, b_menu = {-709.51,-906.13,19.20}, cashier = {-707.32,-912.9,19.22}, delivery = {-705.08,-904.4,19.22}},               	-- Little Seoul
	[4] = {owned = false, type = "247LTD", price = 150000, buyable = true, b_menu = {1159.77,-315.23,69.21}, cashier = {1163.39,-322.21,69.21}, delivery = {1163.9,-313.6,69.21}},             		-- Mirror Park
	[5] = {owned = false, type = "247LTD", price = 175000, buyable = true, b_menu = {378.8,333.1,103.57}, cashier = {373.59,325.52,103.57}, delivery = {374.88,334.51,103.57}},                		-- Clinton Avenue
	[6] = {owned = false, type = "247LTD", price = 150000, buyable = true, b_menu = {-1828.29,797.87,138.19}, cashier = {-1821.45,793.84,138.11}, delivery = {-1825.97,801.41,138.11}},        		-- North Rockford Drive
	[7] = {owned = false, type = "247LTD", price = 175000, buyable = true, b_menu = {-3048.0,586.32,7.91}, cashier = {-3038.78,585.85,7.91}, delivery = {-3047.06,582.23,7.91}},               		-- Inseno Road
	[8] = {owned = false, type = "247LTD", price = 175000, buyable = true, b_menu = {-3249.82,1005.02,12.83}, cashier = {-3241.54,1001.14,12.83}, delivery = {-3250.63,1000.98,12.83}},        		-- Barbareno Road
	[9] = {owned = false, type = "247LTD", price = 175000, buyable = true, b_menu = {545.77,2662.87,42.16}, cashier = {547.77,2671.75,42.16}, delivery = {549.89,2662.95,42.16}},              		-- Route 68
	[10] = {owned = false, type = "247LTD", price = 150000, buyable = true, b_menu = {2673.21,3287.1,55.24}, cashier = {2679.15,3280.13,55.24}, delivery = {2670.82,3283.75,55.24}},             	-- South Senora
	[11] = {owned = false, type = "247LTD", price = 175000, buyable = true, b_menu = {1959.9,3749.09,32.34}, cashier = {1961.42,3740.09,32.34}, delivery = {1956.12,3747.44,32.34}},           		-- Sandy Shores
	[12] = {owned = false, type = "247LTD", price = 150000, buyable = true, b_menu = {1706.87,4921.07,42.06}, cashier = {1699.27,4923.54,42.06}, delivery = {1705.28,4917.2,42.07}},           		-- Grape Seed
	[13] = {owned = false, type = "247LTD", price = 150000, buyable = true, b_menu = {1735.31,6420.41,35.04}, cashier = {1728.69,6414.18,35.04}, delivery = {1731.85,6422.65,35.04}},          		-- North Senora
    -- AMMUNATIONS
    [14] = {owned = false, type = "weapon", price = 420000, buyable = true, b_menu = {846.24,-1030.89,28.19}, cashier = {842.18,-1034.01,28.19}, delivery = {841.65,-1025.63,28.19}},        		-- Vespucci Boulevard
    [15] = {owned = false, type = "weapon", price = 420000, buyable = false, b_menu = {13.89,-1106.35,29.8}, cashier = {22.35,-1106.8,29.8}, delivery = {18.05,-1111.11,29.8}},               		-- Adams Apple Boulevard
	[16] = {owned = false, type = "weapon", price = 420000, buyable = true, b_menu = {-666.62,-933.68,21.83}, cashier = {-662.0,-934.88,21.83}, delivery = {-661.8,-943.33,21.83}},          		-- Little Seoul
	[17] = {owned = false, type = "weapon", price = 420000, buyable = true, b_menu = {817.97,-2155.28,29.62}, cashier = {809.84,-2157.76,29.62}, delivery = {812.6,-2152.32,29.62}},         		-- Popular Street
	[18] = {owned = false, type = "weapon", price = 420000, buyable = true, b_menu = {255.21,-46.38,69.94}, cashier = {252.48,-50.46,69.94}, delivery = {244.47,-49.97,69.94}},              		-- Spanish Ave
	[19] = {owned = false, type = "weapon", price = 420000, buyable = true, b_menu = {2572.32,292.75,108.73}, cashier = {2567.53,293.86,108.73}, delivery = {2567.29,302.36,108.73}},        		-- Palemino FWY
	[20] = {owned = false, type = "weapon", price = 420000, buyable = true, b_menu = {-1122.17,2696.71,18.55}, cashier = {-1117.8,2699.0,18.55}, delivery = {-1111.99,2692.91,18.55}},       		-- Route 68
	[21] = {owned = false, type = "weapon", price = 420000, buyable = true, b_menu = {1689.3,3757.76,34.71}, cashier = {1693.37,3760.3,34.71}, delivery = {1699.71,3754.64,34.71}},          		-- Sandy Shores
	[22] = {owned = false, type = "weapon", price = 420000, buyable = true, b_menu = {-334.67,6081.79,31.45}, cashier = {-330.33,6084.49,31.45}, delivery = {-324.43,6078.36,31.45}},        		-- PaletoBay
    [23] = {owned = false, type = "weapon", price = 420000, buyable = true, b_menu = {-3169.7,1089.68,20.84}, cashier = {-3171.96,1087.91,20.84}, delivery = {-3175.06,1084.86,20.84}},      		-- Great Ocean Hwy
    -- LIQOUR STORES    
    [24] = {owned = false, type = "liqourshop", price = 150000, buyable = true, b_menu = {1125.82,-982.57,45.42}, cashier = {1135.64,-982.28,46.42}, delivery = {1131.17,-983.86,46.42}},     		-- Mirror Park
	[25] = {owned = false, type = "liqourshop", price = 150000, buyable = true, b_menu = {-1218.20,-915.67,11.33}, cashier = {-1222.86,-907.11,12.33}, delivery = {-1219.63,-910.47,12.33}},  		-- Vespucci
	[26] = {owned = false, type = "liqourshop", price = 150000, buyable = true, b_menu = {-2958.35,389.48,14.04}, cashier = {-2967.74,391.57,15.04}, delivery = {-2963.1,387.19,15.04}},      		-- Great Ocean Hwy
	[27] = {owned = false, type = "liqourshop", price = 150000, buyable = true, b_menu = {-1478.56,-375.04,39.16}, cashier = {-1487.67,-378.54,40.16}, delivery = {-1481.33,-377.97,40.16}},  		-- MorningWood
	-- SMOKE SHOPS    
    [28] = {owned = false, type = "smokeshop", price = 300000, buyable = true, b_menu = {-1169.93,-1570.0,4.66}, cashier = {-1169.08,-1573.36,4.66}, delivery = {-1165.1,-1566.3,4.45}},      		-- SmokeOnTheWater
	[29] = {owned = false, type = "smokeshop", price = 300000, buyable = true, b_menu = {-234.78,-306.81,29.89}, cashier = {-229.1,-313.76,29.89}, delivery = {-226.66,-317.24,29.89}},       		-- White Widow
    -- CUSTOM SHOPS 
    [30] = {owned = false, type = "customsshop", price = 350000, buyable = true, b_menu = {-200.81,-1317.58,31.09}, cashier = {-215.85,-1318.96,30.89}, delivery = {-206.96,-1341.83,34.89}}, 		-- Benny's
	[31] = {owned = false, type = "customsshop", price = 350000, buyable = true, b_menu = {964.02,-103.86,74.36}, cashier = {955.22,-115.95,75.01}, delivery = {956.74,-121.05,75.01}},       		-- Bondi Boys
	[32] = {owned = false, type = "notopen", price = 350000, buyable = false, b_menu = {951.23,-968.43,39.51}, cashier = {947.48,-966.92,39.50}, delivery = {911.68,-976.80,39.50}},       			-- ESP
	[33] = {owned = false, type = "customsshop", price = 350000, buyable = true, b_menu = {1172.48,2636.16,37.79}, cashier = {1187.24,2638.87,38.40}, delivery = {1189.55,2643.77,38.40}},        	-- Harmony
	[34] = {owned = false, type = "customsshop", price = 350000, buyable = true, b_menu = {109.95,6631.41,31.79}, cashier = {101.07,6618.85,32.44}, delivery = {102.68,6614.02,32.44}},           	-- Paleto Motors
	-- BANK SHOPS    
	[35] = {owned = false, type = "bank", price = 500000, buyable = false, b_menu = {247.72,208.82,110.28}, cashier = {241.42,225.34,106.29}, delivery = {242.22,230.14,106.29}},              		-- Pacific Standard
	-- GOV SHOPS    
	[36] = {owned = false, type = "vending", price = 15000, buyable = false, b_menu = {463.5,-984.96,30.69}, cashier = {460.91,-982.15,30.69}, delivery = {487.23,-996.99,30.69}},              	-- MissionRow
	[37] = {owned = false, type = "vending", price = 15000, buyable = false, b_menu = {385.11,794.03,190.49}, cashier = {377.88,793.42,190.49}, delivery = {376.42,799.01,187.57}},             	-- Ranger Station
	[38] = {owned = false, type = "vending", price = 15000, buyable = false, b_menu = {1836.96,3682.73,34.27}, cashier = {1845.26,3679.82,34.27}, delivery = {1854.46,3700.74,34.27}},             	-- Sandy Med
	[39] = {owned = false, type = "vending", price = 15000, buyable = false, b_menu = {-567.98,-199.91,38.21}, cashier = {-566.43,-209.96,38.21}, delivery = {-569.96,-209.41,38.21}},           	-- Cityhall
	[40] = {owned = false, type = "vending", price = 15000, buyable = false, b_menu = {-185.27,-1164.82,23.67}, cashier = {-191.01,-1166.43,23.67}, delivery = {-192.11,-1166.32,23.67}},           -- DOT Impound
	[41] = {owned = false, type = "vending", price = 15000, buyable = true, b_menu = {304.43,-599.88,43.28}, cashier = {310.53,-586.19,43.28}, delivery = {324.59,-598.62,43.28}},           		-- Pillbox
	-- MED SHOPS   
	[42] = {owned = false, type = "ems", price = 500000, buyable = false, b_menu = {310.33,-602.95,43.28}, cashier = {306.75,-594.92,43.28}, delivery = {313.37,-597.49,43.28}},               		-- Pillbox
	[43] = {owned = false, type = "ems", price = 500000, buyable = false, b_menu = {1825.77,3668.0,34.27}, cashier = {1832.67,3677.11,34.27}, delivery = {1816.09,3678.6,34.28}},               	-- Sandy Medical
    -- SPORTSMEN SHOPS   
	[44] = {owned = false, type = "weapon", price = 420000, buyable = false, b_menu = {-1681.25,-1067.65,13.15}, cashier = {-1686.8,-1072.46,13.15}, delivery = {-1674.17,-1073.81,13.15}}, 		-- SeaWord
	[45] = {owned = false, type = "weapon", price = 420000, buyable = true, b_menu = {-677.86,5841.87,17.33}, cashier = {-678.62,5838.26,17.33}, delivery = {-672.32,5835.87,17.33}},    			-- Hunting Shack
	[46] = {owned = false, type = "notopen", price = 420000, buyable = false, b_menu = {82.50,814.80,211.11}, cashier = {86.35,811.33,211.12}, delivery = {82.55,814.88,211.10}},                 	-- Vinewood Dam
	-- GREYMARKET SHOPS
	[47] = {owned = false, type = "notopen", price = 2500000, buyable = false, b_menu = {-1097.79,4951.49,218.35}, cashier = {-1111.30,4937.37,218.39}, delivery = {-1101.65,4940.93,218.35}},		-- Nudist Camp
	[48] = {owned = false, type = "notopen", price = 2500000, buyable = false, b_menu = {1520.39,6317.59,24.08}, cashier = {1522.56,6329.43,24.61}, delivery = {1538.95,6322.25,24.84}},        	-- ACID Camp house
	[49] = {owned = false, type = "notopen", price = 2500000, buyable = false, b_menu = {2440.08,4968.41,51.56}, cashier = {2434.34,4968.71,46.81}, delivery = {2435.84,4964.76,46.81}},	        -- O'Neil Ranch
	-- RESTAURANTS
    [50] = {owned = false, type = "rest", price = 250000, buyable = true, b_menu = {-634.72,227.16,81.88}, cashier = {-633.46,236.18,81.88}, delivery = {-633.28,233.28,81.88}},              		-- Bean Machine
    [51] = {owned = false, type = "rest", price = 250000, buyable = true, b_menu = {271.0,-975.51,29.87}, cashier = {282.21,-973.55,29.87}, delivery = {275.19,-976.96,29.87}},                		-- Sopranos
	[52] = {owned = false, type = "rest", price = 250000, buyable = true, b_menu = {1595.60,6454.05,26.01}, cashier = {1589.50,6455.04,26.01}, delivery = {1583.44,6459.18,26.01}},         		-- Pops
	[53] = {owned = false, type = "rest", price = 350000, buyable = true, b_menu = {-1875.88,2062.51,145.57}, cashier = {-1890.69,2058.64,140.98}, delivery = {-1868.77,2066.42,140.98}},           -- VineYard
	[54] = {owned = false, type = "rest", price = 300000, buyable = true, b_menu = {-1843.06, -1187.47, 14.31}, cashier = {-1818.50, -1197.98, 14.46}, delivery = {-1815.42, -1192.08, 14.30}}, 	-- Pearls
	[55] = {owned = false, type = "rest", price = 250000, buyable = true, b_menu = {-1192.2,-902.51,14.0}, cashier = {-1193.98,-892.86,14.0}, delivery = {-1177.80,-891.25,13.76}},          		-- BurgerShot
	[56] = {owned = false, type = "rest", price = 250000, buyable = true, b_menu = {13.13,-1596.62,29.38}, cashier = {13.8,-1602.3,29.38}, delivery = {17.7,-1599.62,29.38}},              			-- Taco Farmer
	[57] = {owned = false, type = "notopen", price = 250000, buyable = false, b_menu = {39.27,-1005.74,29.48}, cashier = {39.25,-1005.75,29.45}, delivery = {39.26,-1005.76,29.46}},              	-- Chihuahua Dogs 
	-- BARS / NIGHT CLUB
	[58] = {owned = false, type = "bar", price = 300000, buyable = true, b_menu = {1981.52,3051.3,47.22}, cashier = {1986.44,3055.37,47.22}, delivery = {1985.59,3048.84,47.22}},         		    -- Yellow Jack
	[59] = {owned = false, type = "notopen", price = 300000, buyable = false, b_menu = {-299.24,6271.88,28.27}, cashier = {-297.20,6264.29,31.54}, delivery = {-306.3,6266.69,28.27}},         		-- The Hen House
	[60] = {owned = false, type = "notopen", price = 300000, buyable = false, b_menu = {-1135.27,4955,.93,222.27}, cashier = {-1134.82,4953.14,222.27}, delivery = {-1141.42,4951.54,222.27}},      -- Nudist Bar
	[61] = {owned = false, type = "casino", price = 300000, buyable = true, b_menu = {1113.45,207.06,-49.44}, cashier = {1108.31,208.29,-49.44}, delivery = {930.35,37.24,81.1}},                   -- The Casino
	[62] = {owned = false, type = "bar", price = 300000, buyable = true, b_menu = {-571.63,289.0,79.18}, cashier = {-560.26,286.62,82.18}, delivery = {-563.25,287.32,85.38}},                     	-- Tequilala
	[63] = {owned = false, type = "notopen", price = 300000, buyable = false, b_menu = {-1619.55,-3010.96,-75.21}, cashier = {-1578.12,-3014.89,-79.01}, delivery = {-1570.73,-3013.37,-74.41}},    -- Club Tech
	[64] = {owned = false, type = "bar", price = 300000, buyable = true, b_menu = {-1381.66,-633.05,30.82}, cashier = {-1392.61,-607.80,30.32}, delivery = {-1390.82,-597.93,30.32}},              	-- Bahama Mamas
	[65] = {owned = false, type = "bar", price = 300000, buyable = true, b_menu = {92.55,-1291.93,29.26}, cashier = {128.42,-1285.69,29.27}, delivery = {132.59,-1287.64,29.27}},             		-- Vanilla Unicorn
	-- Other
	[66] = {owned = false, type = "vending", price = 100000, buyable = false, b_menu = {1778.66, 2563.76, 45.65}, cashier = {1780.97, 2558.90, 45.65}, delivery = {1786.29, 2563.89, 45.65}},	-- Prison 
	[67] = {owned = false, type = "bar", price = 300000, buyable = true, b_menu = {987.32,-92.61,74.85}, cashier = {988.2,-96.51,74.85}, delivery = {979.93,-103.14,74.85}},            			-- Lost Bar
	[68] = {owned = false, type = "digiden", price = 150000, buyable = true, b_menu = {1132.259,-466.89,66.48}, cashier = {1133.98,-469.47,66.48}, delivery = {1133.35,-471.75,66.46}},            	-- Digital Den
	[69] = {owned = false, type = "vending", price = 15000, buyable = false, b_menu = {-821.94, -1240.90, 7.32}, cashier = {-811.80, -1241.92, 7.32}, delivery = {-801.86, -1245.62, 7.32}},		-- Viceroy 
	[70] = {owned = false, type = "rest", price = 300000, buyable = true, b_menu = {-1238.38, -267.65, 37.75}, cashier = {-1236.79, -272.05, 37.75}, delivery = {-1228.70, -285.09, 37.73}},        -- Noodle Exchange
	[71] = {owned = false, type = "customsshop", price = 350000, buyable = true, b_menu = {-1428.27, -457.99, 35.90}, cashier = {-1429.97, -453.38, 35.90}, delivery = {-1435.16, -446.98, 35.54}},	-- Hayes Autos
	[72] = {owned = false, type = "greymarket", price = 2500000, buyable = false, b_menu = {1569.67, -2134.93, 77.57}, cashier = {1569.77, -2129.98, 78.32}, delivery = {1564.84, -2132.87, 77.58}},-- Industrial Grey Market

}

Config.MarkerSettings = { -- Marker Settings:
	['boss'] = { enable = true, drawDist = 10.0, type = 20, scale = {x = 0.35, y = 0.35, z = 0.35}, color = {r = 240, g = 52, b = 52, a = 100} },
	['shelves'] = { enable = true, drawDist = 10.0, type = 20, scale = {x = 0.30, y = 0.30, z = 0.30}, color = {r = 240, g = 52, b = 52, a = 100} },
	['cashier'] = { enable = true, drawDist = 10.0, type = 20, scale = {x = 0.30, y = 0.30, z = 0.30}, color = {r = 0, g = 200, b = 70, a = 100} }
}

-- Blip Settings:
Config.BlipSettings = { -- Blip Settings:
	['247LTD'] = { enable = false, sprite = 52, display = 4, scale = 0.65, color = 2, name = "Corner Store" },
	['weapon'] = { enable = true, sprite = 110, display = 4, scale = 0.65, color = 6, name = "Ammunation" },
	['liqourshop'] = { enable = false, sprite = 77, display = 4, scale = 0.65, color = 5, name = "Liquor Shop" },
    ['vending'] = { enable = false, sprite = 93, display = 4, scale = 0.65, color = 5, name = "Vending Machines" },
	['ems'] = { enable = false, sprite = 52, display = 4, scale = 0.65, color = 5, name = "Pharmacy" },
	['greymarket'] = { enable = false, sprite = 52, display = 4, scale = 0.65, color = 5, name = "Grey Market" },
	['bank'] = { enable = false, sprite = 52, display = 4, scale = 0.65, color = 5, name = "Bank" },
	['bar'] = { enable = false, sprite = 93, display = 4, scale = 0.65, color = 5, name = "Bar/Night Club" },
	['rest'] = { enable = false, sprite = 374, display = 4, scale = 0.65, color = 2, name = "Restaurant" },
	['casino'] = { enable = false, sprite = 93, display = 4, scale = 0.65, color =5, name = "Casino"},
	['customsshop'] = { enable = false, sprite = 402, display = 4, scale = 0.65, color = 5, name = "Custom Supply Shop" },
    ['smokeshop'] = { enable = false, sprite = 140, display = 4, scale = 0.95, color = 5, name = "Smoke Shop" },
	['digiden'] = { enable = false, sprite = 354, display = 4, scale = 0.95, color = 5, name = "Digital Den" },
	['notopen'] = { enable = false, sprite = 140, display = 4, scale = 0.95, color = 5, name = "Not Open" }
}

-- Shop Items:
Config.Items = {
    -- DRINKS
	{label = "Water", item = "water", type = {"247LTD","liqourshop","bar","rest","smokeshop","casino"}, price = 10},
	{label = "Beer", item = "drinkbeer", type = {"liqourshop","rest","casino"}, price = 20},
	{label = "Coffee", item = "drinkcoffee", type = {"247LTD","vending","rest"}, price = 20},
	{label = "Coca Cola", item = "drinkcola", type = {"247LTD","vending","liqourshop","bar","rest","smokeshop","casino"}, price = 20},
	{label = "Frappuccino", item = "drinkfrappuccino", type = {"rest"}, price = 20},
	{label = "Horchata", item = "drinkhorchata", type = {"rest"}, price = 20},
	{label = "Latte", item = "drinklatte", type = {"247LTD","vending","rest"}, price = 20},
	{label = "Tequila", item = "drinktequila", type = {"liqourshop","bar","casino"}, price = 50},
	{label = "Vodka", item = "drinkvodka", type = {"liqourshop","bar","casino"}, price = 50},
	{label = "Whiskey", item = "drinkwhiskey", type = {"liqourshop","bar","casino"}, price = 50},
	{label = "Ace Of Spades", item = "aceofspades", type = {"casino"}, price = 100},
	{label = "Tea", item = "drinktea", type = {"rest"}, price = 20},
    -- FOOD
	{label = "Sandwich", item = "bread", type = {"247LTD","bar","rest","casino"}, price = 20},
	{label = "Ramen", item = "foodramen", type = {"rest"}, price = 20},
	{label = "Burger", item = "foodburger", type = {"bar","rest","casino"}, price = 20},
	{label = "Big Burger", item = "foodburgerbig", type = {"rest"}, price = 30},
	{label = "Burrito", item = "foodburrito", type = {"rest"}, price = 20},
	{label = "Canoli", item = "foodcanoli", type = {"rest"}, price = 15},
	{label = "Chips", item = "foodchips", type = {"247LTD","liqourshop","bar","smokeshop","vending","casino"}, price = 15},
	{label = "Chocolate Bar ", item = "foodchocolatebar", type = {"247LTD","liqourshop","bar","smokeshop","vending","casino"}, price = 15},
	{label = "Cookie", item = "foodcookie", type = {"247LTD","vending","bar","smokeshop","casino"}, price = 15},
	{label = "Donut", item = "fooddonut", type = {"247LTD","vending","rest","casino"}, price = 15},
	{label = "Fried Eggs & Bacon", item = "foodeggsandbacon", type = {"rest"}, price = 30},
	{label = "French Fries", item = "foodfries", type = {"rest","bar","casino"}, price = 20},
	{label = "Hot Dog", item = "foodhotdog", type = {"247LTD"}, price = 20},
	{label = "Muffin", item = "foodmuffin", type = {"247LTD","bar","vending"}, price = 20},
	{label = "Pancakes", item = "foodpancakes", type = {"rest"}, price = 20},
	{label = "Pizza", item = "foodpizza", type = {"rest","casino"}, price = 20},
	{label = "Tacos", item = "foodtaco", type = {"rest"}, price = 20},
	{label = "Lobster", item = "foodlobster", type = {"rest"}, price = 30},
	{label = "Salmon", item = "foodsalmon", type = {"rest"}, price = 30},
    -- MISC SHOP ITEMS
     {label = "Phone", item = "phone", type = {"247LTD","digiden"}, price = 200},
     {label = "Watch", item = "watch", type = {"247LTD","digiden"}, price = 100},   
    -- SPORTSMEN ITEMS
    {label = "Fishing Rod", item = "fishingrod", type = {"weapon"}, price = 250},
    {label = "Bait", item = "bait", type = {"weapon"}, price = 50},
    {label = "Luxary Bait", item = "baitturtle", type = {"weapon"}, price = 100},
    {label = "Binoculars", item = "binoculars", type = {"weapon"}, price = 200},
    {label = "Scuba Gear", item = "scuba", type = {"weapon"}, price = 500},
	{label = "Radio", item = "radio", type = {"weapon","digiden"}, price = 200},
	-- WEAPON SHOP ITEMS
    {label = "Cuffs", item = "cuffs", type = {"weapon"}, price = 750},
	{label = "Suppressor", item = "suppressor", type = {"weapon"}, price = 1000},
	{label = "Scope", item = "scope", type = {"weapon"}, price = 1000},
	{label = "Flashlight Attachment", item = "flashlight", type = {"weapon"}, price = 1000},
	{label = "Grip", item = "grip", type = {"weapon"}, price = 1000},
    -- BANK ITEMS
	{label = "Safe", item = "playersafe", type = {"bank"}, price = 5000},
    -- SMOKE SHOP
    {label = "Joint", item = "joint", type = {"smokeshop"}, price = 10},
	{label = "Rolling Papers", item = "rollpaper", type = {"smokeshop"}, price = 2},
	{label = "Baggies", item = "drugempybag", type = {"smokeshop"}, price = 2},
	{label = "Scale", item = "drugscale", type = {"smokeshop"}, price = 50},
	{label = "Low Grade Female Seed", item = "lowgradefemaleseed", type = {"smokeshop"}, price = 420},
	{label = "Low Grade Male Seed", item = "lowgrademaleseed", type = {"smokeshop"}, price = 420},
	{label = "High Grade Fertilizer", item = "highgradefert", type = {"smokeshop"}, price = 20},
	{label = "Low Grade Fertilizer", item = "lowgradefert", type = {"smokeshop"}, price = 10},
	{label = "Plant Based Water", item = "purifiedwater", type = {"smokeshop"}, price = 2},
	{label = "Plant Pot", item = "plantpot", type = {"smokeshop"}, price = 5},
	{label = "Water Can", item = "wateringcan", type = {"smokeshop"}, price = 5},
	{label = "Ziplock Baggie Box", item = "drugemptyboxbag", type = {"smokeshop"}, price = 150},
	{label = "High Grade Seed (Male)", item = "highgrademaleseed", type = {"smokeshop"}, price = 1200},
	-- MEDS
	{label = "Bandage", item = "bandage", type = {"ems"}, price = 50},
    -- CUSTOM SHOPS
	{label = "Lockpick", item = "lockpick", type = {"customsshop"}, price = 1000},
	{label = "Advanced Lockpick", item = "advlockpick", type = {"customsshop"}, price = 1250},
	{label = "Repair Kit", item = "fixkit", type = {"customsshop"}, price = 1500},
	{label = "Advanced Repair Kit", item = "fixallkit", type = {"customsshop"}, price = 2500},
	{label = "Car Wash Kit", item = "carwashkit", type = {"customsshop"}, price = 25},
	{label = "NOS Bottle", item = "nos", type = {"customsshop"}, price = 2500},
	{label = "Racing Harness", item = "harness", type = {"customsshop"}, price = 3000},
    -- GREYMARKET ITEMS
    {label = "Modified Phone", item = "hackerdevice", type = {"digiden"}, price = 500},   
	{label = "Heavy Drill", item = "gruppe6heavydrill", type = {"greymarket"}, price = 750},
	{label = "Bolt/Wire Cutters", item = "gruppe6wirecutter", type = {"greymarket"}, price = 750},
	{label = "Fake Plate", item = "fakeplate", type = {"greymarket"}, price = 3500},
	{label = "Fake ID", item = "blankid", type = {"greymarket"}, price = 5000},
	{label = "USB-C", item = "drugItem", type = {"digiden"}, price = 1000},
	{label = "Radio Scanner", item = "radioscanner", type = {"greymarket","digiden"}, price = 5000},
	-- WEAPONS
    {label = "Taser", item = "WEAPON_STUNGUN", str_match = "weapon", type = {"weapon"}, price = 1000},
	{label = "Pistol", item = "WEAPON_PISTOL", str_match = "weapon", type = {"weapon"}, price = 2000},
	{label = "Wrench", item = "WEAPON_WRENCH", str_match = "weapon", type = {"weapon"}, price = 500},
	{label = "SNS Pistol", item = "WEAPON_SNSPISTOL", str_match = "weapon", type = {"weapon"}, price = 2250},
    {label = "Combat Pistol", item = "WEAPON_COMBATPISTOL", str_match = "weapon", type = {"weapon"}, price = 3500},
    {label = "Vintage Pistol", item = "WEAPON_VINTAGEPISTOL", str_match = "weapon", type = {"weapon"}, price = 4000},
    {label = "Bottle", item = "WEAPON_BOTTLE", str_match = "weapon", type = {"weapon"}, price = 250},
	{label = "Bat", item = "WEAPON_BAT", str_match = "weapon", type = {"weapon"}, price = 250},
    {label = "Crowbar", item = "WEAPON_CROWBAR", str_match = "weapon", type = {"weapon"}, price = 250},
    {label = "Golf Club", item = "WEAPON_GOLFCLUB", str_match = "weapon", type = {"weapon"}, price = 250},
	{label = "Hammer", item = "WEAPON_HAMMER", str_match = "weapon", type = {"weapon"}, price = 250},
    {label = "Knife", item = "WEAPON_KNIFE", str_match = "weapon", type = {"weapon"}, price = 250},
	{label = "Hatchet", item = "WEAPON_HATCHET", str_match = "weapon", type = {"weapon"}, price = 250},
	{label = "Machete", item = "WEAPON_MACHETE", str_match = "weapon", type = {"weapon"}, price = 250},
    {label = "Flashlight", item = "WEAPON_FLASHLIGHT", str_match = "weapon", type = {"weapon"}, price = 250},
    {label = "Fire Extinguisher", item = "WEAPON_FIREEXTINGUISHER", str_match = "weapon", type = {"weapon"}, price = 250},
    {label = "Parachute", item = "GADGET_PARACHUTE", str_match = "weapon", type = {"weapon"}, price = 250},
	{label = "Jerry Can", item = "WEAPON_PETROLCAN", str_match = "weapon", type = {"weapon"}, price = 250},
	-- WEAPON SKINS
	{label = "Stock weapon spray", item = "skin", type = {"weapon"}, price = 250},
	{label = "Dark green weapon spray", item = "skin1", type = {"weapon"}, price = 250},
	{label = "Gold weapon spray", item = "skin2", type = {"weapon"}, price = 250},
	{label = "Pink and White weapon spray", item = "skin3", type = {"weapon"}, price = 250},
	{label = "Beige weapon spray", item = "skin4", type = {"weapon"}, price = 250},
	{label = "Dark blue weapon spray", item = "skin5", type = {"weapon"}, price = 250},
	{label = "Orange and black weapon spray", item = "skin6", type = {"weapon"}, price = 250},
	{label = "Light grey weapon spray", item = "skin7", type = {"weapon"}, price = 250},
    -- WEAPON AMMO
	{label = "Pistol Ammo Small", item = "ammunition_pistol", ammo_type = 1950175060, str_match = "ammo", type = {"weapon"}, price = 25},
	{label = "Pistol Ammo Large", item = "ammunition_pistol_large", ammo_type = 1950175060, str_match = "ammo", type = {"weapon"}, price = 50},
	{label = "SMG Ammo Small", item = "ammunition_smg", ammo_type = 1820140472, str_match = "ammo", type = {"weapon"}, price = 50},
	{label = "SMG Ammo Large", item = "ammunition_smg_large", ammo_type = 1820140472, str_match = "ammo", type = {"weapon"}, price = 100},
	{label = "Rifle Ammo Small", item = "ammunition_rifle", ammo_type = 218444191, str_match = "ammo", type = {"weapon"}, price = 75},
	{label = "Rifle Ammo Large", item = "ammunition_rifle_large", ammo_type = 218444191, str_match = "ammo", type = {"weapon"}, price = 125},
	{label = "Shotgun Ammo Small", item = "ammunition_shotgun", ammo_type = 1878508229, str_match = "ammo", type = {"weapon"}, price = 100},
	{label = "Shotgun Ammo Large", item = "ammunition_shotgun_large", ammo_type = 1878508229, str_match = "ammo", type = {"weapon"}, price = 150},
	{label = "Taser Cartridge", item = "cartridge", type = {"weapon"}, price = 25},
	{label = "Body Armor", item = "armor", type = {"weapon"}, price = 5000},
	{label = "Fire Extinguisher Ammo", item = "ammunition_fireextinguisher", type = {"weapon"}, price = 25},
}

Config.AmmoTypes = {
	[1] = {label = "Pistol Ammo", hash = 1950175060},
	[2] = {label = "SMG Ammo", hash = 1820140472},
	[3] = {label = "Shotgun Ammo", hash = -1878508229},
	[4] = {label = "Rifle Ammo", hash = 218444191},
}

