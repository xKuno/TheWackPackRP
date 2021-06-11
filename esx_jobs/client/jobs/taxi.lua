Config.Jobs.taxi = {
  BlipInfos = {
    Sprite = 198,
    Color = 28
  },
  Vehicles = {
    Truck = {
      Spawner = 1,
      Hash = "taxi",
      Trailer = "none",
      HasCaution = false
    }
  },
  Zones = {

    VehicleSpawner = {
      Pos   = { x = 908.75, y = -165.0, z = 73.25},
      Size  = {x = 2.0, y = 2.0, z = 0.2},
      Color = {r = 252, g = 0, b = 0},
      Marker= 27,
      Blip  = true,
      Name  = _U('taxi_name'),
      Type  = "vehspawner",
      Spawner = 1,
      Hint  = _U('taxi_garage'),
      Caution = 0
    },

    VehicleSpawnPoint = {
      Pos   = { x = 911.67, y = -163.75, z = 74.37 },
      Size  = {x = 3.0, y = 3.0, z = 1.0},
      Marker= -1,
      Blip  = false,
      Name  = _U('service_vh'),
      Type  = "vehspawnpt",
      Spawner = 1,
      Heading = 192.21
    },

    VehicleDeletePoint = {
      Pos   = { x = 916.52,  y = -170.76, z = 73.55 },
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
      Teleport = { x = 916.52,  y = -170.76, z = 74.44 }
    }
  }
}
