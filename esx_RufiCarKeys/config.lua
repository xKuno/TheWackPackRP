Config              = {}

Config.GetKeyOnStealNpcCars = true --- If TRUE when you steal occuped npc vehicle it gives you a temp key.
Config.PlateBypass = false  --- Allow to run vehicles on Allowed Plates with no key.
Config.AllowedPlates  = {"11558 ESD", "1190 ABC", "1059 GCO"}    --- If Config.PlateBypass = true then this vehicle models not need key to run.
Config.GiveToNearestPlayersOnly = true  --- On give key menu, show only nearest players.
Config.RemoveToNearestPlayersOnly = true --- On Remove key menu show only nearest players.
Config.GiveOwnershipToNearestPlayersOnly = true --- On give key ownership menu show only nearest players.
Config.UseProgressbar = true
Config.HotWiringTime = 20 * 1000
Config.LockPickingTime = 15
Config.AllowGroupAdminBypass = false
Config.ModelBypass = false  --- Allow to run vehicles on Config.AllowedModels with no key.
Config.AllowedModels  = {"sentinel", "bagger", "zentorno"}    --- If Config.ModelBypass = true then this vehicle models not need key to run.
Config.EnableKeyEngine = false    --- if TRUE vehicles only work if have correct key.
Config.JobBypass = true    --- if TRUE selected jobs on line 24 and 37 dont need keys to run engine of any vehicle
Config.MenuOpenKeyAllow = false --- If TRUE you can open the menu with keypress
Config.MenuOpenKey = Keys[""]  --- Key to open menu
Config.IgnitionKey = Keys[""]  --- Z by default
Config.RemoteKey = Keys["L"]  --- U by default