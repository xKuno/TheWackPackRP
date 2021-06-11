Config = {}

-- Script locale (only .Lua)
Config.Locale = 'en'

Config.FixePhone = {
  -- Mission Row
  ['911'] = { 
    name =  _U('mission_row'), 
    coords = { x = 441.29, y = -996.61, z = 34.97 } 
  },
  ['311'] = { 
    name =  _U('pillbox_hospital'), 
    coords = { x = 311.12, y = -597.23, z = 43.28 } 
  },
  
  ['008-0001'] = { name = "Pay", coords = { x = 372.25, y = -965.75, z = 28.58 } },
  ['008-0002'] = { name = "Pay", coords = { x = -700.45, y = -917.48, z = 19.21 } },
  ['008-0003'] = { name = "Pay", coords = { x = -36.04, y = -1379.78, z = 29.33 } },
  ['008-0004'] = { name = "Pay", coords = { x = -26.23, y = -110.18, z = 57.08 } },
  ['008-0005'] = { name = "Pay", coords = { x = -753.87, y = -1416.97, z = 5.0 } },
  ['008-0006'] = { name = "Pay", coords = { x = 213.92, y = -853.3, z = 30.4 } },
  ['008-0007'] = { name = "Pay", coords = { x = 140.4, y = -1032.49, z = 29.35 } },
  ['008-0008'] = { name = "Pay", coords = {x = -1097.10, y = -807.05, z = 18.28} },
  ['008-0009'] = { name = "Prison Pay", coords = {x = 1828.85, y = 2580.38, z = 46.01} },
}

Config.KeyOpenClose = 244 -- F1
Config.KeyTakeCall  = 38  -- E

Config.UseMumbleVoIP = true -- Use Frazzle's Mumble-VoIP Resource (Recommended!) https://github.com/FrazzIe/mumble-voip
Config.UseTokoVoIP   = false

Config.ShowNumberNotification = true -- Show Number or Contact Name when you receive new SMS

Config.ShareRealtimeGPSDefaultTimeInMs = 1000 * 60 -- Set default realtime GPS sharing expiration time in milliseconds
Config.ShareRealtimeGPSJobTimer = 10 -- Default Job GPS Timer (Minutes)

-- Optional Features (Can all be set to true or false.)
Config.ItemRequired = true -- If true, must have the item "phone" to use it.
Config.NoPhoneWarning = true -- If true, the player is warned when trying to open the phone that they need a phone. To edit this message go to the locales for your language.

-- Optional Discord Logging
Config.UseTwitterLogging = false -- Set the Discord webhook in twitter.lua line 284