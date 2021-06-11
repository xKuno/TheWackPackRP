Config = {}

Config.Price = 100

Config.DrawDistance = 100.0
Config.MarkerSize   = {x = 1.5, y = 1.5, z = 1.0}
Config.MarkerColor  = {r = 217, g = 171, b = 25}
Config.MarkerType   = 27
Config.Locale = 'fr'

Config.Zones = {}

Config.Shops = {
---  {x = 269.5230435,  y = -1360.380615,  z = 23.53778648},
---   {x=242.5429382, y=-416.4046021, z=-119.1996307},
---    {x=141.67, y=-1705.9, z=28.30},
---    {x=-808.42, y=-179.66, z=36.57},
---    {x=-1278.0, y=-1119.33, z=6.00},
---    {x=1930.95, y=3735.41, z=31.90},
---    {x=1216.51, y=-475.96, z=65.21},
---    {x=-36.54, y=-156.24, z=56.08},
---    {x=-276.31, y=6223.36, z=30.7},
---    {x=1644.41, y=4875.76, z=41.1},
{x=314.45, y=-562.77, z=42.58}, -- Pillbox
}

for i=1, #Config.Shops, 1 do

    Config.Zones['Shop_' .. i] = {
         Pos   = Config.Shops[i],
         Size  = Config.MarkerSize,
         Color = Config.MarkerColor,
         Type  = Config.MarkerType
  }

end
