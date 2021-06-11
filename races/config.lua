Config = {}

Config.EnableDebug = false

Config.DataStorage = { -- Do not change this unless you know what you're doing.
    Name = "WORLD_RACES"
}

Config.RacePayments = 5 -- This is how long before the payments are sent out. -- Specified in days.

Config.Races = {
    {
        Name = "STRIP_RACE",

        Label = "Time Trials",

        Sprite = 315, -- Blip sprite.

        Price = 150, -- The entry cost.

        Reward = 20000, -- Reward you will receive upon payment.

        Organizer = {
            Name = "Gustavo",

            Ped = {
                Location = vector3(1716.24, 3272.26, 41.15),
                Heading = 202.81,

                Model = 0x278C8CB7
            },

            Vehicle = {
                Location = vector3(1712.64, 3271.78, 41.15),
                Heading = 108.21,

                Model = GetHashKey("Stalion2")
            },

            Board = {
                Location = vector3(1718.85, 3272.95, 41.15),
                Heading = 329.1,
                HeadingRemoval = 298,

                Model = GetHashKey("prop_muster_wboard_02")
            }
        },

        Race = {
            Laps = 1, -- How many laps the race should have.

            Vehicle = GetHashKey("Stalion2"), -- Vehicle that will be driven.

            Checkpoints = { -- Add your checkpoints here.
                {
                    Location = vector3(1717.12, 3265.53, 39.14),
                    Heading = 104.48
                },
                {
                    Location = vector3(1556.42, 3221.56, 37.83),
                    Heading = 102.691
                },
                {
                    Location = vector3(1442.22, 3190, 37),
                    Heading = 104.72
                },
                {
                    Location = vector3(1277.29, 3145.81, 37.83),
                    Heading = 102.93
                },
                {
                    Location = vector3(1118.79, 3100.94, 37.8),
                    Heading = 110.75
                },
                {
                    Location = vector3(1092.13, 3021.91, 38.13),
                    Heading = 259.07676696777
                },
                {
                    Location = vector3(1200.88, 3047.23, 37.9),
                    Heading = 284
                },
                {
                    Location = vector3(1339.04, 3082.01, 37.9),
                    Heading = 285.47647094727
                },
                {
                    Location = vector3(1469.00, 3116.01, 37.01),
                    Heading = 285
                },
                {
                    Location = vector3(1557.01, 3155.01, 37.01),
                    Heading = 313.02
                },
                {
                    Location = vector3(1662.2, 3230.61, 40.6),
                    Heading = 277.78125
                },
            }
        }
    }
}    