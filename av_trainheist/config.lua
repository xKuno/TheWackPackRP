Config = {}

--[[
	Discord Config is inside server/main.lua
]]--

Config.DrillName = 'gruppe6heavydrill' -- Drill item name
Config.PC = {x = 2634.36, y = 2932.10, z = 44.73} -- PC location (1st step)
Config.PCitem = true -- PC needs item to be hacked?
Config.PCitemName = 'hackerdevice' -- Item needed to hack PC
Config.HackBlocks = 5 -- Number of blocks per side
Config.HackTime = 25 -- Time before hacking minigame ends
Config.PoliceJobName = {'police'} -- Who will receive the train alert and blip on map?
Config.MinPolice = 5 -- Min Police online to start the robbery
Config.Timer = 200 -- Countdown for drill to finish and robbers be able to rob the train (5 mins by default [300]).
Config.CooldownTime = 1800 -- Time before the robbery can be triggered again (1 hour by default).
Config.GiveMoney = true -- False if player don't get money when robbing the train
Config.Account = 'money' -- Just in case you use a different name for dirty money
Config.Money = 18000 -- Amount player receives when robbing the train. You can use math.random(minimum,maximum)
Config.GiveItems = true -- Give items?
Config.Items = {
	{name = 'gruppe61jewelry', count = 1},

} 
Config.GiveWeapons = false -- True if you want player to receive weapons
Config.Weapons = {
	{weapon = 'WEAPON_PISTOL', ammo = 150},
	{weapon = 'WEAPON_ASSAULTRIFLE', ammo = 150},
}

Config.Lang = {
['hack_pc'] = 'Press ~r~[E]~w~ to hack PC',
['pc_item'] = 'Missing item',
['cooldown'] = 'No trains available',
['robbery_started'] = 'Rob the loot from the train',
['drill'] = 'Drill installed',
['drill_countdown1'] = 'Drill: ~r~',
['drill_countdown2'] = '~w~ seconds remaining',
['rob_train'] = 'Press ~r~[E]~w~ to rob the train',
['you_stole'] = 'You stole ',
['rob_progress'] = 'Train robbery in progress, verify your GPS',
['train_cab'] = 'You only can rob the freight cart',
['failed'] = 'Robbery has failed',
}