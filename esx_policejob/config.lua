Config                            = {}
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }
Config.EnableLicenses             = true
Config.Locale = 'en'

Config.EnableBudget = false -- Enables the use of the budget through yow_banking

Config.Plates = {
  [0] = {plate = 'LSPD'..math.random(1000, 9999)},
  [1] = {plate = 'CID'..math.random(10000, 99999)},
  [2] = {plate = 'SWAT'..math.random(1000, 9999)},
  [3] = {plate = 'SASPR'..math.random(100, 999)},
  [4] = {plate = 'BCSO'..math.random(1000, 9999)},
  [5] = {plate = 'SASP'..math.random(1000, 9999)},
  [6] = {plate = 'DOC'..math.random(10000, 99999)},
}

Config.PoliceStations = {

  MRPD = {

    Blip = {
      Pos     = { x = 0.0, y = 0.0, z = 0.0 },
      Sprite  = 60,
      Display = 4,
      Scale   = 1.2,
      Colour  = 29,
    },

		AuthorizedWeapons = {
			{ name = 'WEAPON_NIGHTSTICK',       	price = 0 },
			{ name = 'WEAPON_STUNGUN',          	price = 0 },
			{ name = 'WEAPON_FLASHLIGHT',       	price = 0 },
			{ name = 'WEAPON_FIREEXTINGUISHER', 	price = 0 },
			{ name = 'WEAPON_FLAREGUN',         	price = 0 },
			{ name = 'WEAPON_PISTOL_MK2',       	price = 200 },
			{ name = 'WEAPON_PUMPSHOTGUN_MK2',  	price = 300 },
			{ name = 'WEAPON_CARBINERIFLE_MK2', 	price = 1200 },
			{ name = 'WEAPON_SPECIALCARBINE_MK2',   price = 1350 },
			{ name = 'WEAPON_SMG',       			price = 1000 },
			{ name = 'WEAPON_REVOLVER_MK2',       	price = 0 },
		},

    AuthorizedVehicles = {
      { name = 'npolvic',      label = '2011 FORD CVPI', rank = 0 },
      { name = 'poltaurus', 	label = '2016 FORD TAURUS', rank = 0 },
      { name = 'polchar',     label = '2012 DODGE CHARGER', rank = 0 },
      { name = 'poltah', 	label = '2016 CHEVY TAHOE', rank = 0 },
      { name = 'polraptor', 	label = '2016 FORD RANGER', rank = 0 },
      { name = 'pol9', 	label = '2016 FORD RAPTOR', rank = 0 },
      { name = '', 	label = '====INTERCEPTORS====', rank = 0 },
      { name = 'pol718', 	label = '2016 PORSCHE 718 CAYMAN S', rank = 0 },
      { name = '',  label = '=======MOTORBIKES=======', rank = 0 },
      { name = 'pol8',  label = '2016 BMW 1200RT', rank = 0 },
      { name = '',  label = '=======SWAT=======', rank = 0 },
      { name = 'fbi2',  label = 'UNMARKED GRANGER', rank = 0 },
      { name = 'bcat',  label = 'SWAT BEARCAT', rank = 0 },
      { name = '', 	label = '====SPECIAL====', rank = 0 },
      { name = 'pbus2',   label = 'PRISON TRANSPORT BUS', rank = 0 },
      { name = 'emsv',   label = 'FORENSIC VAN', rank = 0 },
      { name = '',  label = '=======UNDERCOVER=======', rank = 0 },
      { name = 'fbi',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'police4',   label = 'UNMARKED VAPID CRUISER', rank = 0 },
      { name = 'ucballer',   label = 'UNMARKED BALLER', rank = 0 },
      { name = 'ucbanshee',   label = 'UNMARKED BANSHEE', rank = 0 },
      { name = 'ucbuffalo',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'uccomet',   label = 'UNMARKED COMET', rank = 0 },
      { name = 'uccoquette',   label = 'UNMARKED COOQUETTE', rank = 0 },
      { name = 'ucprimo',   label = 'UNMARKED PRIMO', rank = 0 },
      { name = 'ucrancher',   label = 'UNMARKED RANCHER', rank = 0 },
      { name = 'ucwashington',   label = 'UNMARKED WASHINGTON', rank = 0 },
      },

    Vehicles = {
      {
        Spawner    = vector3(458.739, -992.312, 24.7),
        SpawnPoint = vector3(458.739, -992.312, 24.7),
        Heading    = 178.283,
      }
    },

    VehicleDeleters = {
        vector3(445.4, -996.9, 24.7),
    },

  },
  PALETO = {

    Blip = {
      Pos     = { x = 0.0, y = 0.0, z = 0.0 },
      Sprite  = 60,
      Display = 4,
      Scale   = 1.2,
      Colour  = 29,
    },

		AuthorizedWeapons = {
			{ name = 'WEAPON_NIGHTSTICK',       	price = 0 },
			{ name = 'WEAPON_STUNGUN',          	price = 0 },
			{ name = 'WEAPON_FLASHLIGHT',       	price = 0 },
			{ name = 'WEAPON_FIREEXTINGUISHER', 	price = 0 },
			{ name = 'WEAPON_FLAREGUN',         	price = 0 },
			{ name = 'WEAPON_PISTOL_MK2',       	price = 200 },
			{ name = 'WEAPON_PUMPSHOTGUN_MK2',  	price = 300 },
			{ name = 'WEAPON_CARBINERIFLE_MK2', 	price = 1200 },
			{ name = 'WEAPON_SPECIALCARBINE_MK2',   price = 1350 },
			{ name = 'WEAPON_SMG',       			price = 1000 },
			{ name = 'WEAPON_REVOLVER_MK2',       	price = 0 },
		},

    AuthorizedVehicles = {
      { name = 'npolvic',      label = '2011 FORD CVPI', rank = 0 },
      { name = 'poltaurus', 	label = '2016 FORD TAURUS', rank = 0 },
      { name = 'polchar',     label = '2012 DODGE CHARGER', rank = 0 },
      { name = 'poltah', 	label = '2016 CHEVY TAHOE', rank = 0 },
      { name = 'polraptor', 	label = '2016 FORD RANGER', rank = 0 },
      { name = 'pol9', 	label = '2016 FORD RAPTOR', rank = 0 },
      { name = '', 	label = '====INTERCEPTORS====', rank = 0 },
      { name = 'pol718', 	label = '2016 PORSCHE 718 CAYMAN S', rank = 0 },
      { name = '',  label = '=======MOTORBIKES=======', rank = 0 },
      { name = 'pol8',  label = 'BMW 1200RT', rank = 0 },
      { name = '',  label = '=======SWAT=======', rank = 0 },
      { name = 'fbi2',  label = 'UNMARKED GRANGER', rank = 0 },
      { name = 'bcat',  label = 'SWAT TRUCK', rank = 0 },
      { name = '', 	label = '====SPECIAL====', rank = 0 },
      { name = 'pbus2',   label = 'PRISON TRANSPORT BUS', rank = 0 },
      { name = 'emsv',   label = 'FORENSIC VAN', rank = 0 },
      { name = '',  label = '=======UNDERCOVER=======', rank = 0 },
      { name = 'fbi',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'police4',   label = 'UNMARKED VAPID CRUISER', rank = 0 },
      { name = 'ucballer',   label = 'UNMARKED BALLER', rank = 0 },
      { name = 'ucbanshee',   label = 'UNMARKED BANSHEE', rank = 0 },
      { name = 'ucbuffalo',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'uccomet',   label = 'UNMARKED COMET', rank = 0 },
      { name = 'uccoquette',   label = 'UNMARKED COOQUETTE', rank = 0 },
      { name = 'ucprimo',   label = 'UNMARKED PRIMO', rank = 0 },
      { name = 'ucrancher',   label = 'UNMARKED RANCHER', rank = 0 },
      { name = 'ucwashington',   label = 'UNMARKED WASHINGTON', rank = 0 },
      },

    Vehicles = {
      {
        Spawner    = vector3(-452.30313110352, 6005.6704101563, 30.840929031372),
        SpawnPoint = vector3(-454.96899414063, 6001.8876953125, 30.340549468994), 
        Heading    = 87.0,
      }
    },

    VehicleDeleters = {
        vector3(-448.12, 5994.41, 30.34),
    },

  },
  SANDY = {

    Blip = {
      Pos     = { x = 0.0, y = 0.0, z = 0.0 },
      Sprite  = 60,
      Display = 4,
      Scale   = 1.2,
      Colour  = 29,
    },

		AuthorizedWeapons = {
			{ name = 'WEAPON_NIGHTSTICK',       	price = 0 },
			{ name = 'WEAPON_STUNGUN',          	price = 0 },
			{ name = 'WEAPON_FLASHLIGHT',       	price = 0 },
			{ name = 'WEAPON_FIREEXTINGUISHER', 	price = 0 },
			{ name = 'WEAPON_FLAREGUN',         	price = 0 },
			{ name = 'WEAPON_PISTOL_MK2',       	price = 200 },
			{ name = 'WEAPON_PUMPSHOTGUN_MK2',  	price = 300 },
			{ name = 'WEAPON_CARBINERIFLE_MK2', 	price = 1200 },
			{ name = 'WEAPON_SPECIALCARBINE_MK2',   price = 1350 },
			{ name = 'WEAPON_SMG',       			price = 1000 },
			{ name = 'WEAPON_REVOLVER_MK2',       	price = 0 },
		},

    AuthorizedVehicles = {
      { name = 'npolvic',      label = '2011 FORD CVPI', rank = 0 },
      { name = 'poltaurus', 	label = '2016 FORD TAURUS', rank = 0 },
      { name = 'polchar',     label = '2012 DODGE CHARGER', rank = 0 },
      { name = 'poltah', 	label = '2016 CHEVY TAHOE', rank = 0 },
      { name = 'polraptor', 	label = '2016 FORD RANGER', rank = 0 },
      { name = 'pol9', 	label = '2016 FORD RAPTOR', rank = 0 },
      { name = '', 	label = '====INTERCEPTORS====', rank = 0 },
      { name = 'pol718', 	label = '2016 PORSCHE 718 CAYMAN S', rank = 0 },
      { name = '',  label = '=======MOTORBIKES=======', rank = 0 },
      { name = 'pol8',  label = 'BMW 1200RT', rank = 0 },
      { name = '',  label = '=======SWAT=======', rank = 0 },
      { name = 'fbi2',  label = 'UNMARKED GRANGER', rank = 0 },
      { name = 'bcat',  label = 'SWAT TRUCK', rank = 0 },
      { name = '', 	label = '====SPECIAL====', rank = 0 },
      { name = 'pbus2',   label = 'PRISON TRANSPORT BUS', rank = 0 },
      { name = 'emsv',   label = 'FORENSIC VAN', rank = 0 },
      { name = '',  label = '=======UNDERCOVER=======', rank = 0 },
      { name = 'fbi',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'police4',   label = 'UNMARKED VAPID CRUISER', rank = 0 },
      { name = 'ucballer',   label = 'UNMARKED BALLER', rank = 0 },
      { name = 'ucbanshee',   label = 'UNMARKED BANSHEE', rank = 0 },
      { name = 'ucbuffalo',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'uccomet',   label = 'UNMARKED COMET', rank = 0 },
      { name = 'uccoquette',   label = 'UNMARKED COOQUETTE', rank = 0 },
      { name = 'ucprimo',   label = 'UNMARKED PRIMO', rank = 0 },
      { name = 'ucrancher',   label = 'UNMARKED RANCHER', rank = 0 },
      { name = 'ucwashington',   label = 'UNMARKED WASHINGTON', rank = 0 },
      },

    Vehicles = {
      {
        Spawner    = vector3(1866.364136, 3693.763428, 32.81095703),
        SpawnPoint = vector3(1872.9417724609, 3690.5759277344, 33.999962640381),
        Heading    = 210.0,
      }
    },


    VehicleDeleters = {
        vector3(1865.86, 3700.35, 32.52),
    },

  },
  PARKR = {

    Blip = {
      Pos     = { x = 0.0, y = 0.0, z = 0.0 },
      Sprite  = 60,
      Display = 4,
      Scale   = 1.2,
      Colour  = 29,
    },

		AuthorizedWeapons = {
			{ name = 'WEAPON_NIGHTSTICK',       	price = 0 },
			{ name = 'WEAPON_STUNGUN',          	price = 0 },
			{ name = 'WEAPON_FLASHLIGHT',       	price = 0 },
			{ name = 'WEAPON_FIREEXTINGUISHER', 	price = 0 },
			{ name = 'WEAPON_FLAREGUN',         	price = 0 },
			{ name = 'WEAPON_PISTOL_MK2',       	price = 200 },
			{ name = 'WEAPON_PUMPSHOTGUN_MK2',  	price = 300 },
			{ name = 'WEAPON_CARBINERIFLE_MK2', 	price = 1200 },
			{ name = 'WEAPON_SPECIALCARBINE_MK2',   price = 1350 },
			{ name = 'WEAPON_SMG',       			price = 1000 },
			{ name = 'WEAPON_REVOLVER_MK2',       	price = 0 },
		},

    AuthorizedVehicles = {
      { name = 'npolvic',      label = '2011 FORD CVPI', rank = 0 },
      { name = 'poltaurus', 	label = '2016 FORD TAURUS', rank = 0 },
      { name = 'polchar',     label = '2012 DODGE CHARGER', rank = 0 },
      { name = 'poltah', 	label = '2016 CHEVY TAHOE', rank = 0 },
      { name = 'polraptor', 	label = '2016 FORD RANGER', rank = 0 },
      { name = 'pol9', 	label = '2016 FORD RAPTOR', rank = 0 },
      { name = '', 	label = '====INTERCEPTORS====', rank = 0 },
      { name = 'pol718', 	label = '2016 PORSCHE 718 CAYMAN S', rank = 0 },
      { name = '',  label = '=======MOTORBIKES=======', rank = 0 },
      { name = 'pol8',  label = 'BMW 1200RT', rank = 0 },
      { name = '',  label = '=======SWAT=======', rank = 0 },
      { name = 'fbi2',  label = 'UNMARKED GRANGER', rank = 0 },
      { name = 'bcat',  label = 'SWAT TRUCK', rank = 0 },
      { name = '', 	label = '====SPECIAL====', rank = 0 },
      { name = 'pbus2',   label = 'PRISON TRANSPORT BUS', rank = 0 },
      { name = 'emsv',   label = 'FORENSIC VAN', rank = 0 },
      { name = '',  label = '=======UNDERCOVER=======', rank = 0 },
      { name = 'fbi',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'police4',   label = 'UNMARKED VAPID CRUISER', rank = 0 },
      { name = 'ucballer',   label = 'UNMARKED BALLER', rank = 0 },
      { name = 'ucbanshee',   label = 'UNMARKED BANSHEE', rank = 0 },
      { name = 'ucbuffalo',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'uccomet',   label = 'UNMARKED COMET', rank = 0 },
      { name = 'uccoquette',   label = 'UNMARKED COOQUETTE', rank = 0 },
      { name = 'ucprimo',   label = 'UNMARKED PRIMO', rank = 0 },
      { name = 'ucrancher',   label = 'UNMARKED RANCHER', rank = 0 },
      { name = 'ucwashington',   label = 'UNMARKED WASHINGTON', rank = 0 },
      },


      Vehicles = {
        {
          Spawner    = vector3(377.25, 789.71, 186.63),
          SpawnPoint = vector3(373.07, 787.84, 186.84),
          Heading    = 165.2,
        }
      },
  
  
      VehicleDeleters = {
          vector3(373.07, 787.84, 185.84),
      },

  },
  HUNTINGPARKR = {

    -- Blip = {
    --   Pos     = { x = 0.0, y = 0.0, z = 0.0 },
    --   Sprite  = 60,
    --   Display = 4,
    --   Scale   = 1.2,
    --   Colour  = 29,
    -- },

		AuthorizedWeapons = {
			{ name = 'WEAPON_NIGHTSTICK',       	price = 0 },
			{ name = 'WEAPON_STUNGUN',          	price = 0 },
			{ name = 'WEAPON_FLASHLIGHT',       	price = 0 },
			{ name = 'WEAPON_FIREEXTINGUISHER', 	price = 0 },
			{ name = 'WEAPON_FLAREGUN',         	price = 0 },
			{ name = 'WEAPON_PISTOL_MK2',       	price = 200 },
			{ name = 'WEAPON_PUMPSHOTGUN_MK2',  	price = 300 },
			{ name = 'WEAPON_CARBINERIFLE_MK2', 	price = 1200 },
			{ name = 'WEAPON_SPECIALCARBINE_MK2',   price = 1350 },
			{ name = 'WEAPON_SMG',       			price = 1000 },
			{ name = 'WEAPON_REVOLVER_MK2',       	price = 0 },
		},

    AuthorizedVehicles = {
      { name = 'npolvic',      label = '2011 FORD CVPI', rank = 0 },
      { name = 'poltaurus', 	label = '2016 FORD TAURUS', rank = 0 },
      { name = 'polchar',     label = '2012 DODGE CHARGER', rank = 0 },
      { name = 'poltah', 	label = '2016 CHEVY TAHOE', rank = 0 },
      { name = 'polraptor', 	label = '2016 FORD RANGER', rank = 0 },
      { name = 'pol9', 	label = '2016 FORD RAPTOR', rank = 0 },
      { name = '', 	label = '====INTERCEPTORS====', rank = 0 },
      { name = 'pol718', 	label = '2016 PORSCHE 718 CAYMAN S', rank = 0 },
      { name = '',  label = '=======MOTORBIKES=======', rank = 0 },
      { name = 'pol8',  label = 'BMW 1200RT', rank = 0 },
      { name = '',  label = '=======SWAT=======', rank = 0 },
      { name = 'fbi2',  label = 'UNMARKED GRANGER', rank = 0 },
      { name = 'bcat',  label = 'SWAT TRUCK', rank = 0 },
      { name = '', 	label = '====SPECIAL====', rank = 0 },
      { name = 'pbus2',   label = 'PRISON TRANSPORT BUS', rank = 0 },
      { name = 'emsv',   label = 'FORENSIC VAN', rank = 0 },
      { name = '',  label = '=======UNDERCOVER=======', rank = 0 },
      { name = 'fbi',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'police4',   label = 'UNMARKED VAPID CRUISER', rank = 0 },
      { name = 'ucballer',   label = 'UNMARKED BALLER', rank = 0 },
      { name = 'ucbanshee',   label = 'UNMARKED BANSHEE', rank = 0 },
      { name = 'ucbuffalo',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'uccomet',   label = 'UNMARKED COMET', rank = 0 },
      { name = 'uccoquette',   label = 'UNMARKED COOQUETTE', rank = 0 },
      { name = 'ucprimo',   label = 'UNMARKED PRIMO', rank = 0 },
      { name = 'ucrancher',   label = 'UNMARKED RANCHER', rank = 0 },
      { name = 'ucwashington',   label = 'UNMARKED WASHINGTON', rank = 0 },
      },


      Vehicles = {
        {
          Spawner    = vector3(-1492.13, 4986.59, 61.63),
          SpawnPoint = vector3(-1492.2, 4892.15, 61.91),
          Heading    = 170.0,
        }
      },
  
  
      VehicleDeleters = {
          vector3(-1493.18, 4975.51, 62.74),
      },

  },
  DELPERO = {

    Blip = {
      Pos     = { x = 0.0, y = 0.0, z = 0.0 },
      Sprite  = 60,
      Display = 4,
      Scale   = 1.2,
      Colour  = 29,
    },

		AuthorizedWeapons = {
			{ name = 'WEAPON_NIGHTSTICK',       	price = 0 },
			{ name = 'WEAPON_STUNGUN',          	price = 0 },
			{ name = 'WEAPON_FLASHLIGHT',       	price = 0 },
			{ name = 'WEAPON_FIREEXTINGUISHER', 	price = 0 },
			{ name = 'WEAPON_FLAREGUN',         	price = 0 },
			{ name = 'WEAPON_PISTOL_MK2',       	price = 200 },
			{ name = 'WEAPON_PUMPSHOTGUN_MK2',  	price = 300 },
			{ name = 'WEAPON_CARBINERIFLE_MK2', 	price = 1200 },
			{ name = 'WEAPON_SPECIALCARBINE_MK2',   price = 1350 },
			{ name = 'WEAPON_SMG',       			price = 1000 },
			{ name = 'WEAPON_REVOLVER_MK2',       	price = 0 },
		},

    AuthorizedVehicles = {
      { name = 'npolvic',      label = '2011 FORD CVPI', rank = 0 },
      { name = 'poltaurus', 	label = '2016 FORD TAURUS', rank = 0 },
      { name = 'polchar',     label = '2012 DODGE CHARGER', rank = 0 },
      { name = 'poltah', 	label = '2016 CHEVY TAHOE', rank = 0 },
      { name = 'polraptor', 	label = '2016 FORD RANGER', rank = 0 },
      { name = 'pol9', 	label = '2016 FORD RAPTOR', rank = 0 },
      { name = '', 	label = '====INTERCEPTORS====', rank = 0 },
      { name = 'pol718', 	label = '2016 PORSCHE 718 CAYMAN S', rank = 0 },
      { name = '',  label = '=======MOTORBIKES=======', rank = 0 },
      { name = 'pol8',  label = 'BMW 1200RT', rank = 0 },
      { name = '',  label = '=======SWAT=======', rank = 0 },
      { name = 'fbi2',  label = 'UNMARKED GRANGER', rank = 0 },
      { name = 'bcat',  label = 'SWAT TRUCK', rank = 0 },
      { name = '', 	label = '====SPECIAL====', rank = 0 },
      { name = 'pbus2',   label = 'PRISON TRANSPORT BUS', rank = 0 },
      { name = 'emsv',   label = 'FORENSIC VAN', rank = 0 },
      { name = '',  label = '=======UNDERCOVER=======', rank = 0 },
      { name = 'fbi',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'police4',   label = 'UNMARKED VAPID CRUISER', rank = 0 },
      { name = 'ucballer',   label = 'UNMARKED BALLER', rank = 0 },
      { name = 'ucbanshee',   label = 'UNMARKED BANSHEE', rank = 0 },
      { name = 'ucbuffalo',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'uccomet',   label = 'UNMARKED COMET', rank = 0 },
      { name = 'uccoquette',   label = 'UNMARKED COOQUETTE', rank = 0 },
      { name = 'ucprimo',   label = 'UNMARKED PRIMO', rank = 0 },
      { name = 'ucrancher',   label = 'UNMARKED RANCHER', rank = 0 },
      { name = 'ucwashington',   label = 'UNMARKED WASHINGTON', rank = 0 },
      },
    Vehicles = {
      {
        Spawner    = vector3(-1631.9, -1015.44, 12.13),
        SpawnPoint = vector3(-1625.25, -1014.34, 12.13),
        Heading    = 323.02,
      }
    },

    VehicleDeleters = {
      vector3(-1625.25, -1014.34, 12.13),
    },

  },
  HELI2 = {

    AuthorizedWeapons = {

    },

    AuthorizedVehicles = {
  { name = 'polmav',  label = 'POLICE TACTICAL MAVERICK', rank = 0 },
  { name = 'maverick2',  label = 'POLICE INTERCEPTOR MAVERICK', rank = 0 },
  { name = 'polas350',  label = 'POLICE HELICOPTER', rank = 0 },
  { name = 'seasparrow',   label = 'SEASPARROW', rank = 0 },

},

    Vehicles = {
        {
            Spawner    = vector3(457.32, -988.31, 42.69),
            SpawnPoint = vector3(448.87, -981.23, 43.69),
            Heading    = 269.0,
        }
    },

    VehicleDeleters = {
        vector3(481.4, -982.2, 40.01),
    },

},

HELI3 = {

    AuthorizedWeapons = {

    },

    AuthorizedVehicles = {
  { name = 'polmav',  label = 'POLICE TACTICAL MAVERICK', rank = 0 },
  { name = 'maverick2',  label = 'POLICE INTERCEPTOR MAVERICK', rank = 0 },
  { name = 'polas350',  label = 'POLICE HELICOPTER', rank = 0 },
  { name = 'seasparrow',   label = 'SEASPARROW', rank = 0 },

},

    Vehicles = {
        {
            Spawner    = vector3(-459.61, 5990.09, 30.32),
            SpawnPoint = vector3(-475.25, 5988.58, 31.34),
            Heading    = 315.0,
        }
    },

    VehicleDeleters = {
        vector3(-475.25, 5988.58, 30.34),
    },

},

HELI4 = {

  AuthorizedWeapons = {

  },

  AuthorizedVehicles = {
{ name = 'polmav',  label = 'POLICE TACTICAL MAVERICK', rank = 0 },
{ name = 'maverick2',  label = 'POLICE INTERCEPTOR MAVERICK', rank = 0 },
{ name = 'polas350',  label = 'POLICE HELICOPTER', rank = 0 },
{ name = 'seasparrow',   label = 'SEASPARROW', rank = 0 },

},

  Vehicles = {
      {
          Spawner    = vector3(1866.75, 3657.94, 34.63),
          SpawnPoint = vector3(1864.56, 3650.43, 34.63),
          Heading    = 210.11,
      }
  },

  VehicleDeleters = {
      vector3(1841.26, 3646.04, 33.18),
  },

},

HELI5 = {

  AuthorizedWeapons = {

  },

  AuthorizedVehicles = {
{ name = 'polmav',  label = 'POLICE TACTICAL MAVERICK', rank = 0 },
{ name = 'maverick2',  label = 'POLICE INTERCEPTOR MAVERICK', rank = 0 },
{ name = 'polas350',  label = 'POLICE HELICOPTER', rank = 0 },
{ name = 'seasparrow',   label = 'SEASPARROW', rank = 0 },

},

  Vehicles = {
      {
          Spawner    = vector3(394.68, 768.72, 185.52),
          SpawnPoint = vector3(406.28, 764.95, 190.06),
          Heading    = 83.83,
      }
  },

  VehicleDeleters = {
      vector3(406.28, 764.95, 189.06),
  },

},

HELI6 = {

  AuthorizedWeapons = {

  },

  AuthorizedVehicles = {
{ name = 'polmav',  label = 'POLICE TACTICAL MAVERICK', rank = 0 },
{ name = 'maverick2',  label = 'POLICE INTERCEPTOR MAVERICK', rank = 0 },
{ name = 'polas350',  label = 'POLICE HELICOPTER', rank = 0 },
{ name = 'seasparrow',   label = 'SEASPARROW', rank = 0 },

},

  Vehicles = {
      {
          Spawner    = vector3(346.77, -581.44, 73.15),
          SpawnPoint = vector3(352.06, -588.56, 73.15),
          Heading    = 337.26,
      }
  },

  VehicleDeleters = {
      vector3(352.06, -588.56, 73.15),
  },

},

	BOAT2 = {

		AuthorizedWeapons = {

		},

		AuthorizedVehicles = {
      { name = '',  label = '=======BOATS=======', rank = 0 },
      { name = 'predator',  label = 'POLICE BOAT', rank = 0 },
      { name = 'dinghy4',   label = 'POLICE DINGHY', rank = 0 },
    },

		Vehicles = {
			{
				Spawner    = vector3(-718.39, -1326.55, 0.6),
				SpawnPoint = vector3(-717.48, -1347.5, 0.1),
				Heading    = 115.0,
			}
		},

		VehicleDeleters = {
			vector3(-717.48, -1347.5, 0.1),
		},

	},

	BOAT3 = {

		AuthorizedWeapons = {

		},

		AuthorizedVehicles = {
      { name = '',  label = '=======BOATS=======', rank = 0 },
      { name = 'predator',  label = 'POLICE BOAT', rank = 0 },
      { name = 'dinghy4',   label = 'POLICE DINGHY', rank = 0 },
    },

		Vehicles = {
			{
				Spawner    = vector3(-2078.7, 2603.27, 1.03),
				SpawnPoint = vector3(-2076.74, 2599.53, 0.04),
				Heading    = 111.0,
			}
		},

		VehicleDeleters = {
            vector3(-2076.74, 2599.53, 0.04),
		},

	},

	BOAT4 = {

		AuthorizedWeapons = {

		},

		AuthorizedVehicles = {
      { name = '',  label = '=======BOATS=======', rank = 0 },
      { name = 'predator',  label = 'POLICE BOAT', rank = 0 },
      { name = 'dinghy4',   label = 'POLICE DINGHY', rank = 0 },
    },

		Vehicles = {
			{
				Spawner    = vector3(713.59, 4093.89, 33.73),
				SpawnPoint = vector3(707.63, 4095.71, 29.07),
				Heading    = 175.0,
			}
		},

		VehicleDeleters = {
			vector3(707.63, 4095.71, 30.07),
		},
	},

	BOAT5 = {

		AuthorizedWeapons = {

		},

		AuthorizedVehicles = {
      { name = '',  label = '=======BOATS=======', rank = 0 },
      { name = 'predator',  label = 'POLICE BOAT', rank = 0 },
      { name = 'dinghy4',   label = 'POLICE DINGHY', rank = 0 },
    },

		Vehicles = {
			{
				Spawner    = vector3(-483.74, 6488.42, 0.27),
				SpawnPoint = vector3(-486.53, 6490.85, 0.1),
				Heading    = 136.0,
			}
		},

		VehicleDeleters = {
            vector3(-486.53, 6490.85, 0.17),
		},

	},

	BOAT6 = {

		AuthorizedWeapons = {

		},

		AuthorizedVehicles = {
      { name = '',  label = '=======BOATS=======', rank = 0 },
      { name = 'predator',  label = 'POLICE BOAT', rank = 0 },
      { name = 'dinghy4',   label = 'POLICE DINGHY', rank = 0 },
    },

		Vehicles = {
			{
				Spawner    = vector3(3370.43, 5184.11, 0.46),
				SpawnPoint = vector3(3372.55, 5179.45, 0.45), 
				Heading    = 262.0,
			}
		},


		VehicleDeleters = {
            vector3(3372.55, 5179.45, 0.05),
		},

	},

  BOAT7 = {

		AuthorizedWeapons = {

		},

		AuthorizedVehicles = {
      { name = '',  label = '=======BOATS=======', rank = 0 },
      { name = 'predator',  label = 'POLICE BOAT', rank = 0 },
      { name = 'dinghy4',   label = 'POLICE DINGHY', rank = 0 },
    },

		Vehicles = {
			{
				Spawner    = vector3(-1801.47, -1229.22, 0.62),
				SpawnPoint = vector3(-1801.47, -1234.22, 1.62), 
				Heading    = 140.0,
			}
		},


		VehicleDeleters = {
            vector3(-1794.87, -1221.17, -0.50),
		},

	},

	COURTHOUSEGARAGE = {

		AuthorizedWeapons = {

		},

    AuthorizedVehicles = {
      { name = 'npolvic',      label = '2011 FORD CVPI', rank = 0 },
      { name = 'poltaurus', 	label = '2016 FORD TAURUS', rank = 0 },
      { name = 'polchar',     label = '2012 DODGE CHARGER', rank = 0 },
      { name = 'poltah', 	label = '2016 CHEVY TAHOE', rank = 0 },
      { name = 'polraptor', 	label = '2016 FORD RANGER', rank = 0 },
      { name = 'pol9', 	label = '2016 FORD RAPTOR', rank = 0 },
      { name = '', 	label = '====INTERCEPTORS====', rank = 0 },
      { name = 'pol718', 	label = '2016 PORSCHE 718 CAYMAN S', rank = 0 },
      { name = '',  label = '=======MOTORBIKES=======', rank = 0 },
      { name = 'pol8',  label = 'BMW 1200RT', rank = 0 },
      { name = '',  label = '=======SWAT=======', rank = 0 },
      { name = 'fbi2',  label = 'UNMARKED GRANGER', rank = 0 },
      { name = 'bcat',  label = 'SWAT TRUCK', rank = 0 },
      { name = '', 	label = '====SPECIAL====', rank = 0 },
      { name = 'pbus2',   label = 'PRISON TRANSPORT BUS', rank = 0 },
      { name = 'emsv',   label = 'FORENSIC VAN', rank = 0 },
      { name = '',  label = '=======UNDERCOVER=======', rank = 0 },
      { name = 'fbi',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'police4',   label = 'UNMARKED VAPID CRUISER', rank = 0 },
      { name = 'ucballer',   label = 'UNMARKED BALLER', rank = 0 },
      { name = 'ucbanshee',   label = 'UNMARKED BANSHEE', rank = 0 },
      { name = 'ucbuffalo',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'uccomet',   label = 'UNMARKED COMET', rank = 0 },
      { name = 'uccoquette',   label = 'UNMARKED COOQUETTE', rank = 0 },
      { name = 'ucprimo',   label = 'UNMARKED PRIMO', rank = 0 },
      { name = 'ucrancher',   label = 'UNMARKED RANCHER', rank = 0 },
      { name = 'ucwashington',   label = 'UNMARKED WASHINGTON', rank = 0 },
      },

    Vehicles = {
      {
        Spawner    = vector3(259.57, -335.44, 44.02),
        SpawnPoint = vector3(272.65, -339.05, 43.92),
        Heading    = 157.73,
      }
    },

    VehicleDeleters = {
      vector3(265.66, -335.31, 43.92),
    },
    
  },

	VINEWOODGARAGE = {

		AuthorizedWeapons = {

		},

    AuthorizedVehicles = {
      { name = 'npolvic',      label = '2011 FORD CVPI', rank = 0 },
      { name = 'poltaurus', 	label = '2016 FORD TAURUS', rank = 0 },
      { name = 'polchar',     label = '2012 DODGE CHARGER', rank = 0 },
      { name = 'poltah', 	label = '2016 CHEVY TAHOE', rank = 0 },
      { name = 'polraptor', 	label = '2016 FORD RANGER', rank = 0 },
      { name = 'pol9', 	label = '2016 FORD RAPTOR', rank = 0 },
      { name = '', 	label = '====INTERCEPTORS====', rank = 0 },
      { name = 'pol718', 	label = '2016 PORSCHE 718 CAYMAN S', rank = 0 },
      { name = '',  label = '=======MOTORBIKES=======', rank = 0 },
      { name = 'pol8',  label = 'BMW 1200RT', rank = 0 },
      { name = '',  label = '=======SWAT=======', rank = 0 },
      { name = 'fbi2',  label = 'UNMARKED GRANGER', rank = 0 },
      { name = 'bcat',  label = 'SWAT TRUCK', rank = 0 },
      { name = '', 	label = '====SPECIAL====', rank = 0 },
      { name = 'pbus2',   label = 'PRISON TRANSPORT BUS', rank = 0 },
      { name = 'emsv',   label = 'FORENSIC VAN', rank = 0 },
      { name = '',  label = '=======UNDERCOVER=======', rank = 0 },
      { name = 'fbi',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'police4',   label = 'UNMARKED VAPID CRUISER', rank = 0 },
      { name = 'ucballer',   label = 'UNMARKED BALLER', rank = 0 },
      { name = 'ucbanshee',   label = 'UNMARKED BANSHEE', rank = 0 },
      { name = 'ucbuffalo',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'uccomet',   label = 'UNMARKED COMET', rank = 0 },
      { name = 'uccoquette',   label = 'UNMARKED COOQUETTE', rank = 0 },
      { name = 'ucprimo',   label = 'UNMARKED PRIMO', rank = 0 },
      { name = 'ucrancher',   label = 'UNMARKED RANCHER', rank = 0 },
      { name = 'ucwashington',   label = 'UNMARKED WASHINGTON', rank = 0 },
      },

    Vehicles = {
      {
        Spawner    = vector3(596.64, 91.39, 92.13),
        SpawnPoint = vector3(606.75, 88.57, 92.48),
        Heading    = 179.11,
      }
    },
    VehicleDeleters = {
    vector3(598.55, 98.46, 91.91),
    },
  },


  	VESPUCCIGARAGE = {

      AuthorizedWeapons = {

      },

    AuthorizedVehicles = {
      { name = 'npolvic',      label = '2011 FORD CVPI', rank = 0 },
      { name = 'poltaurus', 	label = '2016 FORD TAURUS', rank = 0 },
      { name = 'polchar',     label = '2012 DODGE CHARGER', rank = 0 },
      { name = 'poltah', 	label = '2016 CHEVY TAHOE', rank = 0 },
      { name = 'polraptor', 	label = '2016 FORD RANGER', rank = 0 },
      { name = 'pol9', 	label = '2016 FORD RAPTOR', rank = 0 },
      { name = '', 	label = '====INTERCEPTORS====', rank = 0 },
      { name = 'pol718', 	label = '2016 PORSCHE 718 CAYMAN S', rank = 0 },
      { name = '',  label = '=======MOTORBIKES=======', rank = 0 },
      { name = 'pol8',  label = 'BMW 1200RT', rank = 0 },
      { name = '',  label = '=======SWAT=======', rank = 0 },
      { name = 'fbi2',  label = 'UNMARKED GRANGER', rank = 0 },
      { name = 'bcat',  label = 'SWAT TRUCK', rank = 0 },
      { name = '', 	label = '====SPECIAL====', rank = 0 },
      { name = 'pbus2',   label = 'PRISON TRANSPORT BUS', rank = 0 },
      { name = 'emsv',   label = 'FORENSIC VAN', rank = 0 },
      { name = '',  label = '=======UNDERCOVER=======', rank = 0 },
      { name = 'fbi',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'police4',   label = 'UNMARKED VAPID CRUISER', rank = 0 },
      { name = 'ucballer',   label = 'UNMARKED BALLER', rank = 0 },
      { name = 'ucbanshee',   label = 'UNMARKED BANSHEE', rank = 0 },
      { name = 'ucbuffalo',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'uccomet',   label = 'UNMARKED COMET', rank = 0 },
      { name = 'uccoquette',   label = 'UNMARKED COOQUETTE', rank = 0 },
      { name = 'ucprimo',   label = 'UNMARKED PRIMO', rank = 0 },
      { name = 'ucrancher',   label = 'UNMARKED RANCHER', rank = 0 },
      { name = 'ucwashington',   label = 'UNMARKED WASHINGTON', rank = 0 },
      },

    Vehicles = {
      {
        Spawner    = vector3(-1113.44, -848.85, 12.44),
        SpawnPoint = vector3(-1135.51, -856.04, 13.53),
        Heading    = 39.45,
      }
    },

    VehicleDeleters = {
      vector3(-1115.48, -857.51, 12.53),
    },


  },

    GRAPESEEDPD = {

      AuthorizedWeapons = {

      },

    AuthorizedVehicles = {
      { name = 'npolvic',      label = '2011 FORD CVPI', rank = 0 },
      { name = 'poltaurus', 	label = '2016 FORD TAURUS', rank = 0 },
      { name = 'polchar',     label = '2012 DODGE CHARGER', rank = 0 },
      { name = 'poltah', 	label = '2016 CHEVY TAHOE', rank = 0 },
      { name = 'polraptor', 	label = '2016 FORD RANGER', rank = 0 },
      { name = 'pol9', 	label = '2016 FORD RAPTOR', rank = 0 },
      { name = '', 	label = '====INTERCEPTORS====', rank = 0 },
      { name = 'pol718', 	label = '2016 PORSCHE 718 CAYMAN S', rank = 0 },
      { name = '',  label = '=======MOTORBIKES=======', rank = 0 },
      { name = 'pol8',  label = 'BMW 1200RT', rank = 0 },
      { name = '',  label = '=======SWAT=======', rank = 0 },
      { name = 'fbi2',  label = 'UNMARKED GRANGER', rank = 0 },
      { name = 'bcat',  label = 'SWAT TRUCK', rank = 0 },
      { name = '', 	label = '====SPECIAL====', rank = 0 },
      { name = 'pbus2',   label = 'PRISON TRANSPORT BUS', rank = 0 },
      { name = 'emsv',   label = 'FORENSIC VAN', rank = 0 },
      { name = '',  label = '=======UNDERCOVER=======', rank = 0 },
      { name = 'fbi',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'police4',   label = 'UNMARKED VAPID CRUISER', rank = 0 },
      { name = 'ucballer',   label = 'UNMARKED BALLER', rank = 0 },
      { name = 'ucbanshee',   label = 'UNMARKED BANSHEE', rank = 0 },
      { name = 'ucbuffalo',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'uccomet',   label = 'UNMARKED COMET', rank = 0 },
      { name = 'uccoquette',   label = 'UNMARKED COOQUETTE', rank = 0 },
      { name = 'ucprimo',   label = 'UNMARKED PRIMO', rank = 0 },
      { name = 'ucrancher',   label = 'UNMARKED RANCHER', rank = 0 },
      { name = 'ucwashington',   label = 'UNMARKED WASHINGTON', rank = 0 },
      },
	
    Vehicles = {
      {
        Spawner    = vector3(1656.11, 4883.28, 40.98),
        SpawnPoint = vector3(1660.88, 4885.62, 41.06),
        Heading    = 186.12,
      }
    },


    VehicleDeleters = {
      vector3(1663.77, 4870.16, 41.05),
    },

  },

    DAVISGARAGE = {

      AuthorizedWeapons = {

      },

    AuthorizedVehicles = {
      { name = 'npolvic',      label = '2011 FORD CVPI', rank = 0 },
      { name = 'poltaurus', 	label = '2016 FORD TAURUS', rank = 0 },
      { name = 'polchar',     label = '2012 DODGE CHARGER', rank = 0 },
      { name = 'poltah', 	label = '2016 CHEVY TAHOE', rank = 0 },
      { name = 'polraptor', 	label = '2016 FORD RANGER', rank = 0 },
      { name = 'pol9', 	label = '2016 FORD RAPTOR', rank = 0 },
      { name = '', 	label = '====INTERCEPTORS====', rank = 0 },
      { name = 'pol718', 	label = '2016 PORSCHE 718 CAYMAN S', rank = 0 },
      { name = '',  label = '=======MOTORBIKES=======', rank = 0 },
      { name = 'pol8',  label = 'BMW 1200RT', rank = 0 },
      { name = '',  label = '=======SWAT=======', rank = 0 },
      { name = 'fbi2',  label = 'UNMARKED GRANGER', rank = 0 },
      { name = 'bcat',  label = 'SWAT TRUCK', rank = 0 },
      { name = '', 	label = '====SPECIAL====', rank = 0 },
      { name = 'pbus2',   label = 'PRISON TRANSPORT BUS', rank = 0 },
      { name = 'emsv',   label = 'FORENSIC VAN', rank = 0 },
      { name = '',  label = '=======UNDERCOVER=======', rank = 0 },
      { name = 'fbi',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'police4',   label = 'UNMARKED VAPID CRUISER', rank = 0 },
      { name = 'ucballer',   label = 'UNMARKED BALLER', rank = 0 },
      { name = 'ucbanshee',   label = 'UNMARKED BANSHEE', rank = 0 },
      { name = 'ucbuffalo',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'uccomet',   label = 'UNMARKED COMET', rank = 0 },
      { name = 'uccoquette',   label = 'UNMARKED COOQUETTE', rank = 0 },
      { name = 'ucprimo',   label = 'UNMARKED PRIMO', rank = 0 },
      { name = 'ucrancher',   label = 'UNMARKED RANCHER', rank = 0 },
      { name = 'ucwashington',   label = 'UNMARKED WASHINGTON', rank = 0 },
      },

    Vehicles = {
      {
        Spawner    = vector3(383.69, -1613.54, 28.29),
        SpawnPoint = vector3(394.84, -1616.87, 28.29),
        Heading    = 316.18,
      }
    },

    VehicleDeleters = {
      vector3(391.49, -1610.89, 28.29),
    },

  },

    PRISONGARAGE = {

		AuthorizedWeapons = {

		},

    AuthorizedVehicles = {
      { name = 'npolvic',      label = '2011 FORD CVPI', rank = 0 },
      { name = 'poltaurus', 	label = '2016 FORD TAURUS', rank = 0 },
      { name = 'polchar',     label = '2012 DODGE CHARGER', rank = 0 },
      { name = 'poltah', 	label = '2016 CHEVY TAHOE', rank = 0 },
      { name = 'polraptor', 	label = '2016 FORD RANGER', rank = 0 },
      { name = 'pol9', 	label = '2016 FORD RAPTOR', rank = 0 },
      { name = '', 	label = '====INTERCEPTORS====', rank = 0 },
      { name = 'pol718', 	label = '2016 PORSCHE 718 CAYMAN S', rank = 0 },
      { name = '',  label = '=======MOTORBIKES=======', rank = 0 },
      { name = 'pol8',  label = 'BMW 1200RT', rank = 0 },
      { name = '',  label = '=======SWAT=======', rank = 0 },
      { name = 'fbi2',  label = 'UNMARKED GRANGER', rank = 0 },
      { name = 'bcat',  label = 'SWAT TRUCK', rank = 0 },
      { name = '', 	label = '====SPECIAL====', rank = 0 },
      { name = 'pbus2',   label = 'PRISON TRANSPORT BUS', rank = 0 },
      { name = 'emsv',   label = 'FORENSIC VAN', rank = 0 },
      { name = '',  label = '=======UNDERCOVER=======', rank = 0 },
      { name = 'fbi',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'police4',   label = 'UNMARKED VAPID CRUISER', rank = 0 },
      { name = 'ucballer',   label = 'UNMARKED BALLER', rank = 0 },
      { name = 'ucbanshee',   label = 'UNMARKED BANSHEE', rank = 0 },
      { name = 'ucbuffalo',   label = 'UNMARKED BUFFALO', rank = 0 },
      { name = 'uccomet',   label = 'UNMARKED COMET', rank = 0 },
      { name = 'uccoquette',   label = 'UNMARKED COOQUETTE', rank = 0 },
      { name = 'ucprimo',   label = 'UNMARKED PRIMO', rank = 0 },
      { name = 'ucrancher',   label = 'UNMARKED RANCHER', rank = 0 },
      { name = 'ucwashington',   label = 'UNMARKED WASHINGTON', rank = 0 },
      },

    Vehicles = {
      {
        Spawner    = vector3(1853.72, 2582.22, 44.67),
        SpawnPoint = vector3(1864.83, 2593.01, 44.67),
        Heading    = 357.85,
      }
    },

    VehicleDeleters = {
      vector3(1855.41, 2575.02, 44.67),
    },
  },
  
}