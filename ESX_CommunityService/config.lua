Config = {}

-- # Locale to be used. You can create your own by simple copying the 'en' and translating the values.
Config.Locale       				= 'en'

-- # By how many services a player's community service gets extended if he tries to escape
Config.ServiceExtensionOnEscape		= 0

-- # Don't change this unless you know what you are doing.
Config.ServiceLocation 				= {x =  1767.52, y = 2500.98, z = 45.72}

-- # Don't change this unless you know what you are doing.
Config.ReleaseLocation				= {x = 1847.16, y = 2586.65, z = 45.67}

-- # Don't change this unless you know what you are doing.
Config.ServiceLocations = {
	{ type = "cleaning", coords = vector3(1770.23, 2494.25, 45.72) },
	{ type = "cleaning", coords = vector3(1772.99, 2489.98, 45.72) },
	{ type = "cleaning", coords = vector3(1769.48, 2486.57, 45.72) },
	{ type = "cleaning", coords = vector3(1764.33, 2491.51, 45.72) },
	{ type = "cleaning", coords = vector3(1760.98, 2487.57, 45.72) },
	{ type = "cleaning", coords = vector3(1755.033, 2483.63, 45.72) },
	{ type = "cleaning", coords = vector3(1756.44, 2479.66, 45.72) }
}

Config.Locations = {
    ["reclaim_items"] = { x = 1850.76, y = 2584.73, z = 44.85 },
    ["takephotos"] = { x = 402.9, y = -996.7, z = -100.0 },
}

Config.Uniforms = {
	prison_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1']  = 75, ['torso_2']  = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 0, ['pants_1']  = 69,
			['pants_2']  = 0,   ['shoes_1']  = 35,
			['shoes_2']  = 0,  ['chain_1']  = 0,
			['chain_2']  = 0
		},
		female = {
			['tshirt_1'] = 14,   ['tshirt_2'] = 0,
			['torso_1']  = 73,  ['torso_2']  = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 0,  ['pants_1'] = 40,
			['pants_2']  = 0,  ['shoes_1']  = 35,
			['shoes_2']  = 0,   ['chain_1']  = 0,
			['chain_2']  = 0
		}
	}
}