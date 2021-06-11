local colors = {
{name = "Black", colorindex = 0},{name = "Dark Night", colorindex = 15},
{name = "Deep Black", colorindex = 16},{name = "Oil", colorindex = 21},
{name = "Carbon Black", colorindex = 147},{name = "Graphite", colorindex = 1},
{name = "Anthracite Black", colorindex = 11},{name = "Black Steel", colorindex = 2},
{name = "Dark Steel", colorindex = 3},{name = "Silver", colorindex = 4},
{name = "Bluish Silver", colorindex = 5},{name = "Rolled Steel", colorindex = 6},
{name = "Shadow Silver", colorindex = 7},{name = "Stone Silver", colorindex = 8},
{name = "Midnight Silver", colorindex = 9},{name = "Cast Iron Silver", colorindex = 10},
{name = "Asphalt Grey", colorindex = 17},{name = "Grey Concrete", colorindex = 18},
{name = "Dark Silver", colorindex = 19},{name = "Magnesite", colorindex = 20},
{name = "Nickel", colorindex = 22},{name = "Zinc", colorindex = 23},
{name = "Dolomite", colorindex = 24},{name = "Blue Silver", colorindex = 25},
{name = "Titanium", colorindex = 26},{name = "Champagne", colorindex = 93},
{name = "Grey Hunter", colorindex = 144},{name = "Grey", colorindex = 156},
{name = "Red", colorindex = 27},{name = "Torino Red", colorindex = 28},
{name = "Formula Red", colorindex = 29},{name = "Lava Red", colorindex = 150},
{name = "Blaze Red", colorindex = 30},{name = "Grace Red", colorindex = 31},
{name = "Garnet Red", colorindex = 32},{name = "Sunset Red", colorindex = 33},
{name = "Cabernet Red", colorindex = 34},{name = "Wine Red", colorindex = 143},
{name = "Candy Red", colorindex = 35},{name = "Red Pulp", colorindex = 43},
{name = "Brilliant Red", colorindex = 44},{name = "Pale Red", colorindex = 46},
{name = "Hot Pink", colorindex = 135},{name = "Pfsiter Pink", colorindex = 137},
{name = "Salmon Pink", colorindex = 136},{name = "Sunrise Orange", colorindex = 36},
{name = "Orange", colorindex = 38},{name = "Light Orange", colorindex = 123},
{name = "Peach", colorindex = 124},{name = "Pumpkin", colorindex = 130},
{name = "Bright Orange", colorindex = 138},{name = "Gold", colorindex = 99},
{name = "Bronze", colorindex = 90},{name = "Yellow", colorindex = 88},
{name = "Race Yellow", colorindex = 89},{name = "Dew Yellow", colorindex = 91},
{name = "Light Yellow", colorindex = 126},{name = "Dark Green", colorindex = 49},
{name = "Racing Green", colorindex = 50},{name = "Sea Green", colorindex = 51},
{name = "Olive Green", colorindex = 52},{name = "Bright Green", colorindex = 53},
{name = "Gasoline Green", colorindex = 54},{name = "Forest Green", colorindex = 56},
{name = "Lawn Green", colorindex = 57},{name = "Imperial Green", colorindex = 58},
{name = "Green Bottle", colorindex = 59},{name = "Lime Green", colorindex = 92},
{name = "Green Anis", colorindex = 125},{name = "Army Green", colorindex = 133},
{name = "Light Blue", colorindex = 60},{name = "Galaxy Blue", colorindex = 61},
{name = "Dark Blue", colorindex = 62},{name = "Saxon Blue", colorindex = 63},
{name = "Midnight Blue", colorindex = 141},
{name = "Blue", colorindex = 64},{name = "Mariner Blue", colorindex = 65},
{name = "Harbor Blue", colorindex = 66},{name = "Diamond Blue", colorindex = 67},
{name = "Surf Blue", colorindex = 68},{name = "Nautical Blue", colorindex = 69},
{name = "Racing Blue", colorindex = 73},{name = "Ultra Blue", colorindex = 70},
{name = "Light Blue", colorindex = 74},{name = "Blue Night", colorindex = 75},
{name = "Cyan Blue", colorindex = 77},{name = "Cobolt", colorindex = 78},
{name = "Electric Blue", colorindex = 79},{name = "Horizon Blue", colorindex = 80},
{name = "Zirconium", colorindex = 85},{name = "Spinel", colorindex = 86},
{name = "Tour Maline", colorindex = 87},{name = "Paradise", colorindex = 127},
{name = "Bubble Gum", colorindex = 140},{name = "Copper", colorindex = 45},
{name = "Light Brown", colorindex = 47},{name = "Dark Brown", colorindex = 48},
{name = "Forbidden Blue", colorindex = 146},{name = "Glacier Blue", colorindex = 157},
{name = "Chocolate Brown", colorindex = 96},{name = "Bison Brown", colorindex = 101},
{name = "Bleached Brown", colorindex = 106},{name = "Brown", colorindex = 108},
{name = "Hazelnut", colorindex = 109},{name = "Shell", colorindex = 110},
{name = "Mahogany", colorindex = 114},{name = "Cauldron", colorindex = 115},
{name = "Blonde", colorindex = 116},{name = "Gravel", colorindex = 129},
{name = "Schafter Purple", colorindex = 71},{name = "Spinnaker Purple", colorindex = 72},
{name = "Dark Violet", colorindex = 76},{name = "Amethyst", colorindex = 81},
{name = "Midnight Purple", colorindex = 142},{name = "Bright Purple", colorindex = 145},
{name = "Cream", colorindex = 107},{name = "Ice White", colorindex = 111},
{name = "Frost White", colorindex = 112},{name = "Beige", colorindex = 113},
{name = "Snow", colorindex = 122},{name = "Alabaster", colorindex = 132}}
local metalcolors = {
{name = "Brushed Steel",colorindex = 117},
{name = "Brushed Black Steel",colorindex = 118},
{name = "Brushed Aluminum",colorindex = 119},
{name = "Pure Gold",colorindex = 158},
{name = "Brushed Gold",colorindex = 159},
{name = "Light Gold", colorindex = 160},
{name = "Chrome", colorindex = 120}
}
local mattecolors = {
{name = "Black", colorindex = 12},
{name = "Gray", colorindex = 13},
{name = "Light Gray", colorindex = 14},
{name = "Ice White", colorindex = 131},
{name = "Blue", colorindex = 83},
{name = "Dark Blue", colorindex = 82},
{name = "Midnight Blue", colorindex = 84},
{name = "Midnight Purple", colorindex = 149},
{name = "Schafter Purple", colorindex = 148},
{name = "Red", colorindex = 39},
{name = "Dark Red", colorindex = 40},
{name = "Orange", colorindex = 41},
{name = "Yellow", colorindex = 42},
{name = "Lime Green", colorindex = 55},
{name = "Green", colorindex = 128},
{name = "Frost Green", colorindex = 151},
{name = "Foliage Green", colorindex = 155},
{name = "Olive Darb", colorindex = 152},
{name = "Matte White", colorindex = 121},
{name = "Dark Earth", colorindex = 153},
{name = "Desert Tan", colorindex = 154}
}



LSC_Config = {}
LSC_Config.prices = {}

------Model Blacklist--------
--Does'nt allow specific vehicles to be upgraded
LSC_Config.ModelBlacklist = {
	"bus",
}

--Sets if garage will be locked if someone is inside it already
LSC_Config.lock = false

--Enable/disable old entering way
LSC_Config.oldenter = true



-------Prices---------
LSC_Config.prices = {

------Window tint------
	windowtint = {
		{ name = "Pure Black", tint = 1, price = 500},
		{ name = "Darksmoke", tint = 2, price = 500},
		{ name = "Lightsmoke", tint = 3, price = 500},
		{ name = "Limo", tint = 4, price = 500},
		{ name = "Green", tint = 5, price = 500},
	},

-------Respray--------
----Primary color---
	--Chrome 
	chrome = {
		colors = {
			{name = "Chrome", colorindex = 120}
		},
		price = 300
	},
	--Classic 
	classic = {
		colors = colors,
		price = 200
	},
	--Matte 
	matte = {
		colors = mattecolors,
		price = 200
	},
	--Metallic 
	metallic = {
		colors = colors,
		price = 200
	},
	--Metals 
	metal = {
		colors = metalcolors,
		price = 200
	},

----Secondary color---
	--Chrome 
	chrome2 = {
		colors = {
			{name = "Chrome", colorindex = 120}
		},
		price = 300
	},
	--Classic 
	classic2 = {
		colors = colors,
		price = 200
	},
	--Matte 
	matte2 = {
		colors = mattecolors,
		price = 200
	},
	--Metallic 
	metallic2 = {
		colors = colors,
		price = 200
	},
	--Metals 
	metal2 = {
		colors = metalcolors,
		price = 200
	},

------Neon layout------
	neonlayout = {
		{name = "Front,Back and Sides", price = 200},
	},
	--Neon color
	neoncolor = {
		{ name = "White", neon = {255,255,255}, price = 500},
		{ name = "Blue", neon = {0,0,255}, price = 500},
		{ name = "Electric Blue", neon = {0,150,255}, price = 500},
		{ name = "Mint Green", neon = {50,255,155}, price = 500},
		{ name = "Lime Green", neon = {0,255,0}, price = 500},
		{ name = "Yellow", neon = {255,255,0}, price = 500},
		{ name = "Golden Shower", neon = {204,204,0}, price = 500},
		{ name = "Orange", neon = {255,128,0}, price = 500},
		{ name = "Red", neon = {255,0,0}, price = 500},
		{ name = "Pony Pink", neon = {255,102,255}, price = 500},
		{ name = "Hot Pink",neon = {255,0,255}, price = 500},
		{ name = "Purple", neon = {153,0,153}, price = 500},
		{ name = "Brown", neon = {139,69,19}, price = 500},
	},
	
--------Plates---------
	plates = {
		{ name = "Blue on White 1", plateindex = 0, price = 100},
		{ name = "Blue On White 2", plateindex = 3, price = 100},
		{ name = "Blue On White 3", plateindex = 4, price = 100},
		{ name = "Yellow on Blue", plateindex = 2, price = 100},
		{ name = "Yellow on Black", plateindex = 1, price = 100},
	},
	
--------Wheels--------
----Wheel accessories----
	wheelaccessories = {
		{ name = "Stock Tires", price = 0},
		{ name = "Custom Tires", price = 250},
---		{ name = "Bulletproof Tires", price = 500},
		{ name = "White Tire Smoke",smokecolor = {254,254,254}, price = 200},
		{ name = "Black Tire Smoke", smokecolor = {1,1,1}, price = 200},
		{ name = "Blue Tire Smoke", smokecolor = {0,150,255}, price = 200},
		{ name = "Yellow Tire Smoke", smokecolor = {255,255,50}, price = 200},
		{ name = "Orange Tire Smoke", smokecolor = {255,153,51}, price = 200},
		{ name = "Red Tire Smoke", smokecolor = {255,10,10}, price = 200},
		{ name = "Green Tire Smoke", smokecolor = {10,255,10}, price = 200},
		{ name = "Purple Tire Smoke", smokecolor = {153,10,153}, price = 200},
		{ name = "Pink Tire Smoke", smokecolor = {255,102,178}, price = 200},
		{ name = "Gray Tire Smoke",smokecolor = {128,128,128}, price = 200},
	},

----Wheel color----
	wheelcolor = {
		colors = colors,
		price = 1000,
	},

----Front wheel (Bikes)----
	frontwheel = {
		{name = "Stock", wtype = 6, mod = -1, price = 300},
		{name = "Speedway", wtype = 6, mod = 0, price = 300},
		{name = "Streetspecial", wtype = 6, mod = 1, price = 300},
		{name = "Racer", wtype = 6, mod = 2, price = 300},
		{name = "Trackstar", wtype = 6, mod = 3, price = 300},
		{name = "Overlord", wtype = 6, mod = 4, price = 300},
		{name = "Trident", wtype = 6, mod = 5, price = 300},
		{name = "Triplethreat", wtype = 6, mod = 6, price = 300},
		{name = "Stilleto", wtype = 6, mod = 7, price = 300},
		{name = "Wires", wtype = 6, mod = 8, price = 300},
		{name = "Bobber", wtype = 6, mod = 9, price = 300},
		{name = "Solidus", wtype = 6, mod = 10, price = 300},
		{name = "Iceshield", wtype = 6, mod = 11, price = 300},
		{name = "Loops", wtype = 6, mod = 12, price = 300},
	},

----Back wheel (Bikes)-----
	backwheel = {
		{name = "Stock", wtype = 6, mod = -1, price = 300},
		{name = "Speedway", wtype = 6, mod = 0, price = 300},
		{name = "Streetspecial", wtype = 6, mod = 1, price = 300},
		{name = "Racer", wtype = 6, mod = 2, price = 300},
		{name = "Trackstar", wtype = 6, mod = 3, price = 300},
		{name = "Overlord", wtype = 6, mod = 4, price = 300},
		{name = "Trident", wtype = 6, mod = 5, price = 300},
		{name = "Triplethreat", wtype = 6, mod = 6, price = 300},
		{name = "Stilleto", wtype = 6, mod = 7, price = 300},
		{name = "Wires", wtype = 6, mod = 8, price = 300},
		{name = "Bobber", wtype = 6, mod = 9, price = 300},
		{name = "Solidus", wtype = 6, mod = 10, price = 300},
		{name = "Iceshield", wtype = 6, mod = 11, price = 300},
		{name = "Loops", wtype = 6, mod = 12, price = 300},
	},

----Chrome Front wheel (Bikes)----
	chromefrontwheel = {
		{name = "Stock", wtype = 6, mod = -1, price = 300},
		{name = "Speedway", wtype = 6, mod = 13, price = 300},
		{name = "Streetspecial", wtype = 6, mod = 14, price = 300},
		{name = "Racer", wtype = 6, mod = 15, price = 300},
		{name = "Trackstar", wtype = 6, mod = 16, price = 300},
		{name = "Overlord", wtype = 6, mod = 17, price = 300},
		{name = "Trident", wtype = 6, mod = 18, price = 300},
		{name = "Triplethreat", wtype = 6, mod = 19, price = 300},
		{name = "Stilleto", wtype = 6, mod = 20, price = 300},
		{name = "Wires", wtype = 6, mod = 21, price = 300},
		{name = "Bobber", wtype = 6, mod = 22, price = 300},
		{name = "Solidus", wtype = 6, mod = 23, price = 300},
		{name = "Iceshield", wtype = 6, mod = 24, price = 300},
		{name = "Loops", wtype = 6, mod = 25, price = 300},
	},

----Chrome Back wheel (Bikes)-----
	chromebackwheel = {
		{name = "Stock", wtype = 6, mod = -1, price = 300},
		{name = "Speedway", wtype = 6, mod = 13, price = 300},
		{name = "Streetspecial", wtype = 6, mod = 14, price = 300},
		{name = "Racer", wtype = 6, mod = 15, price = 300},
		{name = "Trackstar", wtype = 6, mod = 16, price = 300},
		{name = "Overlord", wtype = 6, mod = 17, price = 300},
		{name = "Trident", wtype = 6, mod = 18, price = 300},
		{name = "Triplethreat", wtype = 6, mod = 19, price = 300},
		{name = "Stilleto", wtype = 6, mod = 20, price = 300},
		{name = "Wires", wtype = 6, mod = 21, price = 300},
		{name = "Bobber", wtype = 6, mod = 22, price = 300},
		{name = "Solidus", wtype = 6, mod = 23, price = 300},
		{name = "Iceshield", wtype = 6, mod = 24, price = 300},
		{name = "Loops", wtype = 6, mod = 25, price = 300},
	},	

----Sport wheels-----
	sportwheels = {
		{name = "Stock", wtype = 0, mod = -1, price = 300},
		{name = "Inferno", wtype = 0, mod = 0, price = 300},
		{name = "Deepfive", wtype = 0, mod = 1, price = 300},
		{name = "Lozspeed", wtype = 0, mod = 2, price = 300},
		{name = "Diamondcut", wtype = 0, mod = 3, price = 300},
		{name = "Chrono", wtype = 0, mod = 4, price = 300},
		{name = "Feroccirr", wtype = 0, mod = 5, price = 300},
		{name = "Fiftynine", wtype = 0, mod = 6, price = 300},
		{name = "Mercie", wtype = 0, mod = 7, price = 300},
		{name = "Syntheticz", wtype = 0, mod = 8, price = 300},
		{name = "Organictyped", wtype = 0, mod = 9, price = 300},
		{name = "Endov1", wtype = 0, mod = 10, price = 300},
		{name = "Gtone", wtype = 0, mod = 11, price = 300},
		{name = "Duper7", wtype = 0, mod = 12, price = 300},
		{name = "Uzer", wtype = 0, mod = 13, price = 300},
		{name = "Groundride", wtype = 0, mod = 14, price = 300},
		{name = "Spacer", wtype = 0, mod = 15, price = 300},
		{name = "Venum", wtype = 0, mod = 16, price = 300},
		{name = "Cosmo", wtype = 0, mod = 17, price = 300},
		{name = "Dashvip", wtype = 0, mod = 18, price = 300},
		{name = "Icekid", wtype = 0, mod = 19, price = 300},
		{name = "Ruffeld", wtype = 0, mod = 20, price = 300},
		{name = "Wangenmaster", wtype = 0, mod = 21, price = 300},
		{name = "Superfive", wtype = 0, mod = 22, price = 300},
		{name = "Endov2", wtype = 0, mod = 23, price = 300},
		{name = "Slitsix", wtype = 0, mod = 24, price = 300},
	},
	
----chrome Sport wheels-----
	csportwheels = {
		{name = "Stock", wtype = 0, mod = -1, price = 300},
		{name = "Inferno", wtype = 0, mod = 25, price = 300},
		{name = "Deepfive", wtype = 0, mod = 26, price = 300},
		{name = "Lozspeed", wtype = 0, mod = 27, price = 300},
		{name = "Diamondcut", wtype = 0, mod = 28, price = 300},
		{name = "Chrono", wtype = 0, mod = 29, price = 300},
		{name = "Feroccirr", wtype = 0, mod = 30, price = 300},
		{name = "Fiftynine", wtype = 0, mod = 31, price = 300},
		{name = "Mercie", wtype = 0, mod = 32, price = 300},
		{name = "Syntheticz", wtype = 0, mod = 33, price = 300},
		{name = "Organictyped", wtype = 0, mod = 34, price = 300},
		{name = "Endov1", wtype = 0, mod = 35, price = 300},
		{name = "Gtone", wtype = 0, mod = 36, price = 300},
		{name = "Duper7", wtype = 0, mod = 37, price = 300},
		{name = "Uzer", wtype = 0, mod = 38, price = 300},
		{name = "Groundride", wtype = 0, mod = 39, price = 300},
		{name = "Spacer", wtype = 0, mod = 40, price = 300},
		{name = "Venum", wtype = 0, mod = 41, price = 300},
		{name = "Cosmo", wtype = 0, mod = 42, price = 300},
		{name = "Dashvip", wtype = 0, mod = 43, price = 300},
		{name = "Icekid", wtype = 0, mod = 44, price = 300},
		{name = "Ruffeld", wtype = 0, mod = 45, price = 300},
		{name = "Wangenmaster", wtype = 0, mod = 46, price = 300},
		{name = "Superfive", wtype = 0, mod = 47, price = 300},
		{name = "Endov2", wtype = 0, mod = 48, price = 300},
		{name = "Slitsix", wtype = 0, mod = 49, price = 300},
	},	
-----Suv wheels------
	suvwheels = {
		{name = "Stock", wtype = 3, mod = -1, price = 300},
		{name = "Vip", wtype = 3, mod = 0, price = 300},
		{name = "Benefactor", wtype = 3, mod = 1, price = 300},
		{name = "Cosmo", wtype = 3, mod = 2, price = 300},
		{name = "Bippu", wtype = 3, mod = 3, price = 300},
		{name = "Royalsix", wtype = 3, mod = 4, price = 300},
		{name = "Fagorme", wtype = 3, mod = 5, price = 300},
		{name = "Deluxe", wtype = 3, mod = 6, price = 300},
		{name = "Icedout", wtype = 3, mod = 7, price = 300},
		{name = "Cognscenti", wtype = 3, mod = 8, price = 300},
		{name = "Lozspeedten", wtype = 3, mod = 9, price = 300},
		{name = "Supernova", wtype = 3, mod = 10, price = 300},
		{name = "Obeyrs", wtype = 3, mod = 11, price = 300},
		{name = "Lozspeedballer", wtype = 3, mod = 12, price = 300},
		{name = "Extra vaganzo", wtype = 3, mod = 13, price = 300},
		{name = "Splitsix", wtype = 3, mod = 14, price = 300},
		{name = "Empowered", wtype = 3, mod = 15, price = 300},
		{name = "Sunrise", wtype = 3, mod = 16, price = 300},
		{name = "Dashvip", wtype = 3, mod = 17, price = 300},
		{name = "Cutter", wtype = 3, mod = 18, price = 300},
	},
	-----chrome Suv wheels------
	csuvwheels = {
		{name = "Stock", wtype = 3, mod = -1, price = 300},
		{name = "Vip", wtype = 3, mod = 19, price = 300},
		{name = "Benefactor", wtype = 3, mod = 20, price = 300},
		{name = "Cosmo", wtype = 3, mod = 21, price = 300},
		{name = "Bippu", wtype = 3, mod = 22, price = 300},
		{name = "Royalsix", wtype = 3, mod = 23, price = 300},
		{name = "Fagorme", wtype = 3, mod = 24, price = 300},
		{name = "Deluxe", wtype = 3, mod = 25, price = 300},
		{name = "Icedout", wtype = 3, mod = 26, price = 300},
		{name = "Cognscenti", wtype = 3, mod = 27, price = 300},
		{name = "Lozspeedten", wtype = 3, mod = 28, price = 300},
		{name = "Supernova", wtype = 3, mod = 29, price = 300},
		{name = "Obeyrs", wtype = 3, mod = 30, price = 300},
		{name = "Lozspeedballer", wtype = 3, mod = 31, price = 300},
		{name = "Extra vaganzo", wtype = 3, mod = 32, price = 300},
		{name = "Splitsix", wtype = 3, mod = 33, price = 300},
		{name = "Empowered", wtype = 3, mod = 34, price = 300},
		{name = "Sunrise", wtype = 3, mod = 35, price = 300},
		{name = "Dashvip", wtype = 3, mod = 36, price = 300},
		{name = "Cutter", wtype = 3, mod = 37, price = 300},
	},
-----Offroad wheels-----
	offroadwheels = {
		{name = "Stock", wtype = 4, mod = -1, price = 300},
		{name = "Raider", wtype = 4, mod = 0, price = 300},
		{name = "Mudslinger", wtype = 4, mod = 1, price = 300},
		{name = "Nevis", wtype = 4, mod = 2, price = 300},
		{name = "Cairngorm", wtype = 4, mod = 3, price = 300},
		{name = "Amazon", wtype = 4, mod = 4, price = 300},
		{name = "Challenger", wtype = 4, mod = 5, price = 300},
		{name = "Dunebasher", wtype = 4, mod = 6, price = 300},
		{name = "Fivestar", wtype = 4, mod = 7, price = 300},
		{name = "Rockcrawler", wtype = 4, mod = 8, price = 300},
		{name = "Milspecsteelie", wtype = 4, mod = 9, price = 300},
	},
	
-----Chrome Offroad wheels-----
	coffroadwheels = {
		{name = "Stock", wtype = 4, mod = -1, price = 300},
		{name = "Raider", wtype = 4, mod = 10, price = 300},
		{name = "Mudslinger", wtype = 4, mod = 11, price = 300},
		{name = "Nevis", wtype = 4, mod = 12, price = 300},
		{name = "Cairngorm", wtype = 4, mod = 13, price = 300},
		{name = "Amazon", wtype = 4, mod = 14, price = 300},
		{name = "Challenger", wtype = 4, mod = 15, price = 300},
		{name = "Dunebasher", wtype = 4, mod = 16, price = 300},
		{name = "Fivestar", wtype = 4, mod = 17, price = 300},
		{name = "Rockcrawler", wtype = 4, mod = 18, price = 300},
		{name = "Milspecsteelie", wtype = 4, mod = 19, price = 300},
	},	
-----Tuner wheels------
	tunerwheels = {
		{name = "Stock", wtype = 5, mod = -1, price = 300},
		{name = "Cosmo", wtype = 5, mod = 0, price = 300},
		{name = "Supermesh", wtype = 5, mod = 1, price = 300},
		{name = "Outsider", wtype = 5, mod = 2, price = 300},
		{name = "Rollas", wtype = 5, mod = 3, price = 300},
		{name = "Driffmeister", wtype = 5, mod = 4, price = 300},
		{name = "Slicer", wtype = 5, mod = 5, price = 300},
		{name = "Elquatro", wtype = 5, mod = 6, price = 300},
		{name = "Dubbed", wtype = 5, mod = 7, price = 300},
		{name = "Fivestar", wtype = 5, mod = 8, price = 300},
		{name = "Slideways", wtype = 5, mod = 9, price = 300},
		{name = "Apex", wtype = 5, mod = 10, price = 300},
		{name = "Stancedeg", wtype = 5, mod = 11, price = 300},
		{name = "Countersteer", wtype = 5, mod = 12, price = 300},
		{name = "Endov1", wtype = 5, mod = 13, price = 300},
		{name = "Endov2dish", wtype = 5, mod = 14, price = 300},
		{name = "Guppez", wtype = 5, mod = 15, price = 300},
		{name = "Chokadori", wtype = 5, mod = 16, price = 300},
		{name = "Chicane", wtype = 5, mod = 17, price = 300},
		{name = "Saisoku", wtype = 5, mod = 18, price = 300},
		{name = "Dishedeight", wtype = 5, mod = 19, price = 300},
		{name = "Fujiwara", wtype = 5, mod = 20, price = 300},
		{name = "Zokusha", wtype = 5, mod = 21, price = 300},
		{name = "Battlevill", wtype = 5, mod = 22, price = 300},
		{name = "Rallymaster", wtype = 5, mod = 23, price = 300},
	},
-----Chrome Tuner wheels------
	ctunerwheels = {
		{name = "Stock", wtype = 5, mod = -1, price = 300},
		{name = "Cosmo", wtype = 5, mod = 24, price = 300},
		{name = "Supermesh", wtype = 5, mod = 25, price = 300},
		{name = "Outsider", wtype = 5, mod = 26, price = 300},
		{name = "Rollas", wtype = 5, mod = 27, price = 300},
		{name = "Driffmeister", wtype = 5, mod = 28, price = 300},
		{name = "Slicer", wtype = 5, mod = 29, price = 300},
		{name = "Elquatro", wtype = 5, mod = 30, price = 300},
		{name = "Dubbed", wtype = 5, mod = 31, price = 300},
		{name = "Fivestar", wtype = 5, mod = 32, price = 300},
		{name = "Slideways", wtype = 5, mod = 33, price = 300},
		{name = "Apex", wtype = 5, mod = 34, price = 300},
		{name = "Stancedeg", wtype = 5, mod = 35, price = 300},
		{name = "Countersteer", wtype = 5, mod = 36, price = 300},
		{name = "Endov1", wtype = 5, mod = 37, price = 300},
		{name = "Endov2dish", wtype = 5, mod = 38, price = 300},
		{name = "Guppez", wtype = 5, mod = 39, price = 300},
		{name = "Chokadori", wtype = 5, mod = 40, price = 300},
		{name = "Chicane", wtype = 5, mod = 41, price = 300},
		{name = "Saisoku", wtype = 5, mod = 42, price = 300},
		{name = "Dishedeight", wtype = 5, mod = 43, price = 300},
		{name = "Fujiwara", wtype = 5, mod = 44, price = 300},
		{name = "Zokusha", wtype = 5, mod = 45, price = 300},
		{name = "Battlevill", wtype = 5, mod = 46, price = 300},
		{name = "Rallymaster", wtype = 5, mod = 47, price = 300},
	},	
	
-----Highend wheels------
	highendwheels = {
		{name = "Stock", wtype = 7, mod = -1, price = 300},
		{name = "Shadow", wtype = 7, mod = 0, price = 300},
		{name = "Hyper", wtype = 7, mod = 1, price = 300},
		{name = "Blade", wtype = 7, mod = 2, price = 300},
		{name = "Diamond", wtype = 7, mod = 3, price = 300},
		{name = "Supagee", wtype = 7, mod = 4, price = 300},
		{name = "Chromaticz", wtype = 7, mod = 5, price = 300},
		{name = "Merciechlip", wtype = 7, mod = 6, price = 300},
		{name = "Obeyrs", wtype = 7, mod = 7, price = 300},
		{name = "Gtchrome", wtype = 7, mod = 8, price = 300},
		{name = "Cheetahr", wtype = 7, mod = 9, price = 300},
		{name = "Solar", wtype = 7, mod = 10, price = 300},
		{name = "Splitten", wtype = 7, mod = 11, price = 300},
		{name = "Dashvip", wtype = 7, mod = 12, price = 300},
		{name = "Lozspeedten", wtype = 7, mod = 13, price = 300},
		{name = "Carboninferno", wtype = 7, mod = 14, price = 300},
		{name = "Carbonshadow", wtype = 7, mod = 15, price = 300},
		{name = "Carbonz", wtype = 7, mod = 16, price = 300},
		{name = "Carbonsolar", wtype = 7, mod = 17, price = 300},
		{name = "Carboncheetahr", wtype = 7, mod = 18, price = 300},
		{name = "Carbonsracer", wtype = 7, mod = 19, price = 300},
	},
-----Chrome Highend wheels------
	chighendwheels = {
		{name = "Stock", wtype = 7, mod = -1, price = 300},
		{name = "Shadow", wtype = 7, mod = 20, price = 300},
		{name = "Hyper", wtype = 7, mod = 21, price = 300},
		{name = "Blade", wtype = 7, mod = 22, price = 300},
		{name = "Diamond", wtype = 7, mod = 23, price = 300},
		{name = "Supagee", wtype = 7, mod = 24, price = 300},
		{name = "Chromaticz", wtype = 7, mod = 25, price = 300},
		{name = "Merciechlip", wtype = 7, mod = 26, price = 300},
		{name = "Obeyrs", wtype = 7, mod = 27, price = 300},
		{name = "Gtchrome", wtype = 7, mod = 28, price = 300},
		{name = "Cheetahr", wtype = 7, mod = 29, price = 300},
		{name = "Solar", wtype = 7, mod = 30, price = 300},
		{name = "Splitten", wtype = 7, mod = 31, price = 300},
		{name = "Dashvip", wtype = 7, mod = 32, price = 300},
		{name = "Lozspeedten", wtype = 7, mod = 33, price = 300},
		{name = "Carboninferno", wtype = 7, mod = 34, price = 300},
		{name = "Carbonshadow", wtype = 7, mod = 35, price = 300},
		{name = "Carbonz", wtype = 7, mod = 36, price = 300},
		{name = "Carbonsolar", wtype = 7, mod = 37, price = 300},
		{name = "Carboncheetahr", wtype = 7, mod = 38, price = 300},
		{name = "Carbonsracer", wtype = 7, mod = 39, price = 300},
	},	
-----Lowrider wheels------
	lowriderwheels = {
		{name = "Stock", wtype = 2, mod = -1, price = 300},
		{name = "Flare", wtype = 2, mod = 0, price = 300},
		{name = "Wired", wtype = 2, mod = 1, price = 300},
		{name = "Triplegolds", wtype = 2, mod = 2, price = 300},
		{name = "Bigworm", wtype = 2, mod = 3, price = 300},
		{name = "Sevenfives", wtype = 2, mod = 4, price = 300},
		{name = "Splitsix", wtype = 2, mod = 5, price = 300},
		{name = "Freshmesh", wtype = 2, mod = 6, price = 300},
		{name = "Leadsled", wtype = 2, mod = 7, price = 300},
		{name = "Turbine", wtype = 2, mod = 8, price = 300},
		{name = "Superfin", wtype = 2, mod = 9, price = 300},
		{name = "Classicrod", wtype = 2, mod = 10, price = 300},
		{name = "Dollar", wtype = 2, mod = 11, price = 300},
		{name = "Dukes", wtype = 2, mod = 12, price = 300},
		{name = "Lowfive", wtype = 2, mod = 13, price = 300},
		{name = "Gooch", wtype = 2, mod = 14, price = 300},
	},
-----Chrome Lowrider wheels------
	clowriderwheels = {
		{name = "Stock", wtype = 2, mod = -1, price = 300},
		{name = "Flare", wtype = 2, mod = 15, price = 300},
		{name = "Wired", wtype = 2, mod = 16, price = 300},
		{name = "Triplegolds", wtype = 2, mod = 17, price = 300},
		{name = "Bigworm", wtype = 2, mod = 18, price = 300},
		{name = "Sevenfives", wtype = 2, mod = 19, price = 300},
		{name = "Splitsix", wtype = 2, mod = 20, price = 300},
		{name = "Freshmesh", wtype = 2, mod = 21, price = 300},
		{name = "Leadsled", wtype = 2, mod = 22, price = 300},
		{name = "Turbine", wtype = 2, mod = 23, price = 300},
		{name = "Superfin", wtype = 2, mod = 24, price = 300},
		{name = "Classicrod", wtype = 2, mod = 25, price = 300},
		{name = "Dollar", wtype = 2, mod = 26, price = 300},
		{name = "Dukes", wtype = 2, mod = 27, price = 300},
		{name = "Lowfive", wtype = 2, mod = 28, price = 300},
		{name = "Gooch", wtype = 2, mod = 29, price = 300},
	},	
-----Muscle wheels-----
	musclewheels = {
		{name = "Stock", wtype = 1, mod = -1, price = 300},
		{name = "Classicfive", wtype = 1, mod = 0, price = 300},
		{name = "Dukes", wtype = 1, mod = 1, price = 300},
		{name = "Musclefreak", wtype = 1, mod = 2, price = 300},
		{name = "Kracka", wtype = 1, mod = 3, price = 300},
		{name = "Azrea", wtype = 1, mod = 4, price = 300},
		{name = "Mecha", wtype = 1, mod = 5, price = 300},
		{name = "Blacktop", wtype = 1, mod = 6, price = 300},
		{name = "Dragspl", wtype = 1, mod = 7, price = 300},
		{name = "Revolver", wtype = 1, mod = 8, price = 300},
		{name = "Classicrod", wtype = 1, mod = 9, price = 300},
		{name = "Farlie", wtype = 1, mod = 10, price = 300},
		{name = "Spooner", wtype = 1, mod = 11, price = 300},
		{name = "Fivestar", wtype = 1, mod = 12, price = 300},
		{name = "Oldschool", wtype = 1, mod = 13, price = 300},
		{name = "Eljefe", wtype = 1, mod = 14, price = 300},
		{name = "Dodman", wtype = 1, mod = 15, price = 300},
		{name = "Sixgun", wtype = 1, mod = 16, price = 300},
		{name = "Mercenary", wtype = 1, mod = 17, price = 300},
	},
-----Chrome Muscle wheels-----
	cmusclewheels = {
		{name = "Stock", wtype = 1, mod = -1, price = 300},
		{name = "Classicfive", wtype = 1, mod = 18, price = 300},
		{name = "Dukes", wtype = 1, mod = 19, price = 300},
		{name = "Musclefreak", wtype = 1, mod = 20, price = 300},
		{name = "Kracka", wtype = 1, mod = 21, price = 300},
		{name = "Azrea", wtype = 1, mod = 22, price = 300},
		{name = "Mecha", wtype = 1, mod = 23, price = 300},
		{name = "Blacktop", wtype = 1, mod = 24, price = 300},
		{name = "Dragspl", wtype = 1, mod = 25, price = 300},
		{name = "Revolver", wtype = 1, mod = 26, price = 300},
		{name = "Classicrod", wtype = 1, mod = 27, price = 300},
		{name = "Farlie", wtype = 1, mod = 28, price = 300},
		{name = "Spooner", wtype = 1, mod = 29, price = 300},
		{name = "Fivestar", wtype = 1, mod = 30, price = 300},
		{name = "Oldschool", wtype = 1, mod = 31, price = 300},
		{name = "Eljefe", wtype = 1, mod = 32, price = 300},
		{name = "Dodman", wtype = 1, mod = 33, price = 300},
		{name = "Sixgun", wtype = 1, mod = 34, price = 300},
		{name = "Mercenary", wtype = 1, mod = 35, price = 300},
	},		
-----bennys original wheels-----
	originalwheels = {
		{name = "Stock", wtype = 1, mod = -1, price = 300},
		{name = "OG Hunnets", wtype = 8, mod = 0, price = 300},
		{name = "OG Hunnets Chrome Lip", wtype = 8, mod = 1, price = 300},
		{name = "Knock-Offs", wtype = 8, mod = 2, price = 300},
		{name = "Knock-Offs Chrome Lip", wtype = 8, mod = 3, price = 300},
		{name = "Spoked Out", wtype = 8, mod = 4, price = 300},
		{name = "Spoked Out Chrome Lip", wtype = 8, mod = 5, price = 300},
		{name = "Vintage Wire", wtype = 8, mod = 6, price = 300},
		{name = "Vintage Wire Chrome Lip", wtype = 8, mod = 7, price = 300},
		{name = "Smoothie", wtype = 8, mod = 8, price = 300},
		{name = "Smoothie Chrome Lip", wtype = 8, mod = 9, price = 300},
		{name = "Smoothie Solid Color", wtype = 8, mod = 10, price = 300},
		{name = "Rod Me Up", wtype = 8, mod = 11, price = 300},
		{name = "Rod Me Up Chrome Lip", wtype = 8, mod = 12, price = 300},
		{name = "Rod Me Up Solid Color", wtype = 8, mod = 13, price = 300},
		{name = "Clean", wtype = 8, mod = 14, price = 300},
		{name = "Lotta Chrome", wtype = 8, mod = 15, price = 300},
		{name = "Spindles", wtype = 8, mod = 16, price = 300},
		{name = "Viking", wtype = 8, mod = 17, price = 300},
		{name = "Triple Spoke", wtype = 8, mod = 18, price = 300},
		{name = "Pharohe", wtype = 8, mod = 19, price = 300},
		{name = "Tiger Style", wtype = 8, mod = 20, price = 300},
		{name = "Three Wheelin", wtype = 8, mod = 21, price = 300},
		{name = "Big Bar", wtype = 8, mod = 22, price = 300},
		{name = "Biohazard", wtype = 8, mod = 23, price = 300},
		{name = "Waves", wtype = 8, mod = 24, price = 300},
		{name = "Lick Lick", wtype = 8, mod = 25, price = 300},
		{name = "Spiralizer", wtype = 8, mod = 26, price = 300},
		{name = "Hypnotics", wtype = 8, mod = 27, price = 300},
		{name = "Psycho-Delic", wtype = 8, mod = 28, price = 300},
		{name = "Half Cut", wtype = 8, mod = 29, price = 300},
		{name = "Super Electric", wtype = 8, mod = 30, price = 300},
	},
-----bennys bespoke wheels-----
	bespokewheels = {
		{name = "Stock", wtype = 1, mod = -1, price = 300},
		{name = "Chrome OG Hunnets", wtype = 9, mod = 0, price = 300},
		{name = "Gold OG Hunnets", wtype = 9, mod = 1, price = 300},
		{name = "Chrome Wires", wtype = 9, mod = 2, price = 300},
		{name = "Gold Wires", wtype = 9, mod = 3, price = 300},
		{name = "Chrome Spoked Out", wtype = 9, mod = 4, price = 300},
		{name = "Gold Spoked Out", wtype = 9, mod = 5, price = 300},
		{name = "Chrome Knock-Offs", wtype = 9, mod = 6, price = 300},
		{name = "Gold Knock-Offs", wtype = 9, mod = 7, price = 300},
		{name = "Chrome Bigger Worm", wtype = 9, mod = 8, price = 300},
		{name = "Gold Bigger Worm", wtype = 9, mod = 9, price = 300},
		{name = "Chrome Vintage Wire", wtype = 9, mod = 10, price = 300},
		{name = "Gold Vintage Wire", wtype = 9, mod = 11, price = 300},
		{name = "Chrome Classic Wire", wtype = 9, mod = 12, price = 300},
		{name = "Gold Classic Wire", wtype = 9, mod = 13, price = 300},
		{name = "Chrome Smoothie", wtype = 9, mod = 14, price = 300},
		{name = "Gold Smoothie", wtype = 9, mod = 15, price = 300},
		{name = "Chrome Classic Rod", wtype = 9, mod = 16, price = 300},
		{name = "Gold Classic Rod", wtype = 9, mod = 17, price = 300},
		{name = "Chrome Dollar", wtype = 9, mod = 18, price = 300},
		{name = "Gold Dollar", wtype = 9, mod = 19, price = 300},
		{name = "Chrome Mighty Star", wtype = 9, mod = 20, price = 300},
		{name = "Gold Mighty Star", wtype = 9, mod = 21, price = 300},
		{name = "Chrome Decadent Dish", wtype = 9, mod = 22, price = 300},
		{name = "Gold Decadent Dish", wtype = 9, mod = 23, price = 300},
		{name = "Chrome Razor Style", wtype = 9, mod = 24, price = 300},
		{name = "Gold Razor Style", wtype = 9, mod = 25, price = 300},
		{name = "Chrome Celtic Knot", wtype = 9, mod = 26, price = 300},
		{name = "Gold Celtic Knot", wtype = 9, mod = 27, price = 300},
		{name = "Chrome Warrior Dish", wtype = 9, mod = 28, price = 300},
		{name = "Gold Warrior Dish", wtype = 9, mod = 29, price = 300},
		{name = "Gold Big Dog Spokes", wtype = 9, mod = 30, price = 300},
	},	
	
---------Trim color--------
	trim = {
		colors = colors,
		price = 500
	},
	
----------Mods-----------
	mods = {
	
----------Liveries--------
	[48] = {
		startprice = 500,
		increaseby = 100
	},
	
----------Windows--------
	[46] = {
		startprice = 500,
		increaseby = 100
	},
	
----------Tank--------
	[45] = {
		startprice = 500,
		increaseby = 100
	},
	
----------Trim--------
	[44] = {
		startprice = 500,
		increaseby = 100
	},
	
----------Aerials--------
	[43] = {
		startprice = 500,
		increaseby = 100
	},

----------Arch cover--------
	[42] = {
		startprice = 500,
		increaseby = 100
	},

----------Struts--------
	[41] = {
		startprice = 500,
		increaseby = 100
	},
	
----------Air filter--------
	[40] = {
		startprice = 500,
		increaseby = 100
	},
	
----------Engine block--------
	[39] = {
		startprice = 500,
		increaseby = 0
	},

----------Hydraulics--------
	[38] = {
		startprice = 1500,
		increaseby = 100
	},
	
----------Trunk--------
	[37] = {
		startprice = 500,
		increaseby = 100
	},

----------Speakers--------
	[36] = {
		startprice = 500,
		increaseby = 100
	},

----------Plaques--------
	[35] = {
		startprice = 500,
		increaseby = 100
	},
	
----------Shift leavers--------
	[34] = {
		startprice = 500,
		increaseby = 100
	},
	
----------Steeringwheel--------
	[33] = {
		startprice = 500,
		increaseby = 100
	},
	
----------Seats--------
	[32] = {
		startprice = 500,
		increaseby = 100
	},
	
----------Door speaker--------
	[31] = {
		startprice = 500,
		increaseby = 100
	},

----------Dial--------
	[30] = {
		startprice = 500,
		increaseby = 100
	},
----------Dashboard--------
	[29] = {
		startprice = 500,
		increaseby = 100
	},
	
----------Ornaments--------
	[28] = {
		startprice = 500,
		increaseby = 100
	},
	
----------Trim--------
	[27] = {
		startprice = 500,
		increaseby = 100
	},
	
----------Vanity plates--------
	[26] = {
		startprice = 500,
		increaseby = 100
	},
	
----------Plate holder--------
	[25] = {
		startprice = 500,
		increaseby = 100
	},
	
---------Headlights---------
	[22] = {
		{name = "Stock Lights", mod = 0, price = 0},
		{name = "Xenon Lights", mod = 1, price = 1000},
	},
	
----------Turbo---------
	[18] = {
		{ name = "None", mod = 0, price = 0},
		{ name = "Turbo Tuning", mod = 1, price = 5000},
	},
	
-----------Armor-------------
	[16] = {
		{name = "Armor Upgrade 20%",modtype = 16, mod = 0, price = 1000},
		{name = "Armor Upgrade 40%",modtype = 16, mod = 1, price = 2000},
		{name = "Armor Upgrade 60%",modtype = 16, mod = 2, price = 3000},
		{name = "Armor Upgrade 80%",modtype = 16, mod = 3, price = 4000},
		{name = "Armor Upgrade 100%",modtype = 16, mod = 4, price = 5000},
	},

---------Suspension-----------
	[15] = {
		{name = "Lowered Suspension",mod = 0, price = 1000},
		{name = "Street Suspension",mod = 1, price = 2000},
		{name = "Sport Suspension",mod = 2, price = 3000},
		{name = "Competition Suspension",mod = 3, price = 4000},
	},

-----------Horn----------
	[14] = {
		{name = "Truck Horn", mod = 0, price = 2000},
		{name = "Police Horn", mod = 1, price = 2000},
		{name = "Clown Horn", mod = 2, price = 2000},
		{name = "Musical Horn 1", mod = 3, price = 2000},
		{name = "Musical Horn 2", mod = 4, price = 2000},
		{name = "Musical Horn 3", mod = 5, price = 2000},
		{name = "Musical Horn 4", mod = 6, price = 2000},
		{name = "Musical Horn 5", mod = 7, price = 2000},
		{name = "Sadtrombone Horn", mod = 8, price = 2000},
		{name = "Calssical Horn 1", mod = 9, price = 2000},
		{name = "Calssical Horn 2", mod = 10, price = 2000},
		{name = "Calssical Horn 3", mod = 11, price = 2000},
		{name = "Calssical Horn 4", mod = 12, price = 2000},
		{name = "Calssical Horn 5", mod = 13, price = 2000},
		{name = "Calssical Horn 6", mod = 14, price = 2000},
		{name = "Calssical Horn 7", mod = 15, price = 2000},
		{name = "Scaledo Horn", mod = 16, price = 2000},
		{name = "Scalere Horn", mod = 17, price = 2000},
		{name = "Scalemi Horn", mod = 18, price = 2000},
		{name = "Scalefa Horn", mod = 19, price = 2000},
		{name = "Scalesol Horn", mod = 20, price = 2000},
		{name = "Scalela Horn", mod = 21, price = 2000},
		{name = "Scaleti Horn", mod = 22, price = 2000},
		{name = "Scaledo Horn High", mod = 23, price = 2000},
		{name = "Jazz Horn 1", mod = 25, price = 2000},
		{name = "Jazz Horn 2", mod = 26, price = 2000},
		{name = "Jazz Horn 3", mod = 27, price = 2000},
		{name = "Jazzloop Horn", mod = 28, price = 2000},
		{name = "Starspangban Horn 1", mod = 29, price = 2000},
		{name = "Starspangban Horn 2", mod = 30, price = 2000},
		{name = "Starspangban Horn 3", mod = 31, price = 2000},
		{name = "Starspangban Horn 4", mod = 32, price = 2000},
		{name = "Classicalloop Horn 1", mod = 33, price = 2000},
		{name = "Classicalloop Horn 2", mod = 34, price = 2000},
		{name = "Classicalloop Horn 3", mod = 35, price = 2000},
	},

----------Transmission---------
	[13] = {
		{name = "Street Transmission", mod = 0, price = 2000},
		{name = "Sports Transmission", mod = 1, price = 3000},
		{name = "Race Transmission", mod = 2, price = 4000},
	},
	
-----------Brakes-------------
	[12] = {
		{name = "Street Brakes", mod = 0, price = 2000},
		{name = "Sport Brakes", mod = 1, price = 3000},
		{name = "Race Brakes", mod = 2, price = 4000},
	},
	
------------Engine----------
	[11] = {
		{name = "Engine Upgrade, Level 2", mod = 0, price = 2000},
		{name = "Engine Upgrade, Level 3", mod = 1, price = 3000},
		{name = "Engine Upgrade, Level 4", mod = 2, price = 4000},
	},
	
-------------Roof----------
	[10] = {
		startprice = 500,
		increaseby = 100
	},
	
------------Right Fender---
	[9] = {
		startprice = 500,
		increaseby = 100
	},

------------Left Fender----
	[8] = {
		startprice = 500,
		increaseby = 100
	},
	
------------Hood----------
	[7] = {
		startprice = 500,
		increaseby = 100
	},
	
----------Grille----------
	[6] = {
		startprice = 500,
		increaseby = 100
	},
	
----------Roll cage----------
	[5] = {
		startprice = 500,
		increaseby = 100
	},
	
----------Exhaust----------
	[4] = {
		startprice = 500,
		increaseby = 100
	},
	
----------Skirts----------
	[3] = {
		startprice = 500,
		increaseby = 100
	},
	
-----------Rear bumpers----------
	[2] = {
		startprice = 500,
		increaseby = 100
	},
	
----------Front bumpers----------
	[1] = {
		startprice = 500,
		increaseby = 100
	},
	
----------Spoiler----------
	[0] = {
		startprice = 500,
		increaseby = 100
	},
	}
	
}


--Menu settings
LSC_Config.menu = {

-------Controls--------
	controls = {
		menu_up = 27,
		menu_down = 173,
		menu_left = 174,
		menu_right = 175,
		menu_select = 201,
		menu_back = 177
	},

-------Menu position-----
	--Possible positions:
	--Left
	--Right
	--Custom position, example: position = {x = 0.2, y = 0.2}
	position = "left",

-------Menu theme--------
	--Possible themes: light, darkred, bluish, greenish
	--Custom example:
	--[[theme = {
		text_color = { r = 255,g = 255, b = 255, a = 255},
		bg_color = { r = 0,g = 0, b = 0, a = 155},
		--Colors when button is selected
		stext_color = { r = 0,g = 0, b = 0, a = 255},
		sbg_color = { r = 255,g = 255, b = 0, a = 200},
	},]]
	theme = "yellow",
	
--------Max buttons------
	--Default: 10
	maxbuttons = 10,

-------Size---------
	--[[
	Default:
	width = 0.24
	height = 0.36
	]]
	width = 0.24,
	height = 0.36

}
