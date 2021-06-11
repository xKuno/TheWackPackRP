Config.Jobs.reporter = {
  BlipInfos = {
    Sprite = 184,
    Color = 1
  },
  Vehicles = {
    Truck = {
      Spawner = 1,
      Hash = "newsvan",
      Trailer = "none",
      HasCaution = false
    },
    Boat = {
      Spawner = 2,
      Hash = "maverick2",
      Trailer = "none",
      HasCaution = false
    }
  },
  Zones = {
    BoatSpawner = {
      Pos   = {x = -583.55, y = -930.61, z = 35.87},
      Size  = {x = 8.0, y = 8.0, z = 8.0},
      Color = {r = 252, g = 0, b = 0},
      Marker= 27,
      Blip  = false,
      Name  = _U('reporter_name'),
      Type  = "vehspawner",
      Spawner = 2,
      Hint  = _U('reporter_heli'),
      Caution = 0,
    },

    BoatSpawnPoint = {
      Pos   = {x = -583.55, y = -930.61, z = 35.95},
      Size  = {x = 3.0, y = 3.0, z = 1.0},
      Marker= -1,
      Blip  = false,
      Name  = _U('service_vh'),
      Type  = "vehspawnpt",
      Spawner = 2,
      Heading = 268.63
    },

    BoatDeletePoint = {
      Pos   = {x = -573.19, y = -918.2, z = 35.87},
      Size  = {x = 3.0, y = 3.0, z = 0.2},
      Color = {r = 252, g = 0, b = 0},
      Marker= 1,
      Blip  = false,
      Name  = _U('return_vh'),
      Type  = "vehdelete",
      Hint  = _U('return_vh_button'),
      Spawner = 2,
      Caution = 0,
      GPS = 0,
      Teleport = {x = -573.19, y = -918.2, z = 35.83}
    },

    VehicleSpawner = {
      Pos   = { x = -611.65, y = -927.84, z = 22.86},
      Size  = {x = 2.0, y = 2.0, z = 0.2},
      Color = {r = 252, g = 0, b = 0},
      Marker= 27,
      Blip  = true,
      Name  = _U('reporter_name'),
      Type  = "vehspawner",
      Spawner = 1,
      Hint  = _U('reporter_garage'),
      Caution = 0
    },

    VehicleSpawnPoint = {
      Pos   = { x = -621.41, y = -924.39, z = 22.06 },
      Size  = {x = 3.0, y = 3.0, z = 1.0},
      Marker= -1,
      Blip  = false,
      Name  = _U('service_vh'),
      Type  = "vehspawnpt",
      Spawner = 1,
      Heading = 357.57
    },

    VehicleDeletePoint = {
      Pos   = { x = -615.92,  y = -911.84, z = 23.05 },
      Size  = {x = 3.0, y = 3.0, z = 0.2},
      Color = {r = 252, g = 0, b = 0},
      Marker= 1,
      Blip  = false,
      Name  = _U('return_vh'),
      Type  = "vehdelete",
      Hint  = _U('return_vh_button'),
      Spawner = 1,
      Caution = 0,
      GPS = 0,
      Teleport = { x = -615.92,  y = -911.84, z = 23.05 }
    }
  }
}
