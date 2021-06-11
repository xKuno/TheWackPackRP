Config = {}

-- Turn this to false if you want everyone to use this.
Config.OnlyPolicemen = true

-- This is how much ammo you should get per weapon you take out.
Config.ReceiveAmmo = 250
Config.EMSReceiveAmmo = 250

Config.PdJob = "police"

-- You don't need to edit these if you don't want to.
Config.Armory = vector3(478.844, -996.791, 30.692)
Config.ArmoryHead = 270.0
Config.ArmoryPed = { ["x"] = 480.366, ["y"] = -996.643, ["z"] = 30.69, ["h"] = 91.422, ["hash"] = "s_m_y_cop_01" }
Config.EMSArmory = vector3(312.11, -592.54, 43.28)
Config.EmsHead = 180.0
Config.EMSArmoryPed = { ["x"] = 311.63, ["y"] = -594.14, ["z"] = 43.28, ["h"] = 339.12, ["hash"] = "s_f_y_scrubs_01" }
Config.BlackArmory = vector3(34.82, -2679.9, 12.04)
Config.BlackHead = 274.21
Config.BlackPed =  { ["x"] = 35.52, ["y"] = -2679.98, ["z"] = 12.04, ["h"] = 88.78, ["hash"] = "g_m_m_chicold_01" }
Config.RangerArmory = vector3(381.54, 797.35, 187.68)
Config.RangerHead = 1.61
Config.RangerPed =  { ["x"] = 381.71, ["y"] = 798.89, ["z"] = 187.65, ["h"] = 175.68, ["hash"] = "s_f_y_ranger_01" }

Config.EnableBudget = false -- Enables the use of the budget through yow_banking


-- This is the available weapons you can pick out.
Config.Items = {

    { ["name"] = "Flare Gun      = $400", ["Price"] = 400, ["ItemID"] = "WEAPON_FLAREGUN"},
    { ["name"] = "Flashlight      = $400", ["Price"] = 400, ["ItemID"] = "WEAPON_FLASHLIGHT"},
    { ["name"] = "Nightstick      = $400", ["Price"] = 400, ["ItemID"] = "WEAPON_NIGHTSTICK"},
    { ["name"] = "Stun Gun      = $200", ["Price"] = 200, ["ItemID"] = "WEAPON_STUNGUN"},
    { ["name"] = "Pistol MK2      = $200", ["Price"] = 200, ["ItemID"] = "WEAPON_PISTOL_MK2"},
    { ["name"] = "Beanbag Shotgun      = $400", ["Price"] = 400, ["ItemID"] = "WEAPON_PUMPSHOTGUN"},
    { ["name"] = "Pump Shotgun MK2      = $400", ["Price"] = 400, ["ItemID"] = "WEAPON_PUMPSHOTGUN_MK2"},
    { ["name"] = "Carbine Rifle MK2      = $400", ["Price"] = 400, ["ItemID"] = "WEAPON_CARBINERIFLE_MK2"},
    { ["name"] = "Parachute      = $50", ["Price"] = 50, ["ItemID"] = "GADGET_PARACHUTE"},
    { ["name"] = "Scope      = $50", ["Price"] = 50, ["ItemID"] = "scope"},
    { ["name"] = "Foregrip      = $50", ["Price"] = 50, ["ItemID"] = "grip"},
    { ["name"] = "Flashlight Attachment      = $50", ["Price"] = 50, ["ItemID"] = "flashlight"},
    { ["name"] = "Police Vest      = $150", ["Price"] = 150, ["ItemID"] = "armorpolice"},
    { ["name"] = "Ifak      = $10", ["Price"] = 10, ["ItemID"] = "ifak"},
    { ["name"] = "Scuba Gear      = $10", ["Price"] = 10, ["ItemID"] = "scuba"},
    { ["name"] = "Phone        = $10", ["Price"] = 10, ["ItemID"] = "phone"},
	{ ["name"] = "Radio        = $10", ["Price"] = 10, ["ItemID"] = "radio"},
	{ ["name"] = "Watch        = $10", ["Price"] = 10, ["ItemID"] = "watch"},
	{ ["name"] = "Binoculars        = $10", ["Price"] = 10, ["ItemID"] = "binoculars"},
    { ["name"] = "Camera      = $10", ["Price"] = 10, ["ItemID"] = "camera"},
    { ["name"] = "Large Pistol Ammo Box      = $5", ["Price"] = 5, ["ItemID"] = "ammunition_pistol_large"},
    { ["name"] = "Large Shotgun Ammo Box      = $30", ["Price"] = 30, ["ItemID"] = "ammunition_shotgun_large"},
    { ["name"] = "Large Rifle Ammo Box      = $50", ["Price"] = 50, ["ItemID"] = "ammunition_rifle_large"},
    { ["name"] = "Taser Cartridge      = $50", ["Price"] = 50, ["ItemID"] = "cartridge"},
    { ["name"] = "Ankle Tracker      = $50", ["Price"] = 50, ["ItemID"] = "ankletracker"},
    { ["name"] = "Bolt Cutter      = $50", ["Price"] = 50, ["ItemID"] = "gruppe6wirecutter"},
  
}

Config.SwatItem = {
    { ["name"] = "SMG MK2      = $600", ["Price"] = 600, ["ItemID"] = "WEAPON_SMG_MK2"},
    { ["name"] = "Special Carbine MK2      = $600", ["Price"] = 600, ["ItemID"] = "WEAPON_SPECIALCARBINE_MK2"},
    { ["name"] = "Suppressor      = $50", ["Price"] = 50, ["ItemID"] = "suppressor"},
    { ["name"] = "SWAT Vest      = $300", ["Price"] = 300, ["ItemID"] = "armorswat"},
    { ["name"] = "Large SMG Ammo Box      = $50", ["Price"] = 50, ["ItemID"] = "ammunition_smg_large"},
    { ["name"] = "Blank ID      = $200", ["Price"] = 200, ["ItemID"] = "blankid"},
    { ["name"] = "UV Flashlight      = $50", ["Price"] = 50, ["ItemID"] = "uvlight"},
    { ["name"] = "Police Badge      = $50", ["Price"] = 50, ["ItemID"] = "badge"},
    { ["name"] = "Night Vision      = $5000", ["Price"] = 5000, ["ItemID"] = "nvg"},

}

Config.RangerItems = {

    { ["name"] = "Flare Gun      = $400", ["Price"] = 400, ["ItemID"] = "WEAPON_FLAREGUN"},
    { ["name"] = "Flashlight      = $400", ["Price"] = 400, ["ItemID"] = "WEAPON_FLASHLIGHT"},
    { ["name"] = "Nightstick      = $400", ["Price"] = 400, ["ItemID"] = "WEAPON_NIGHTSTICK"},
    { ["name"] = "Stun Gun      = $200", ["Price"] = 200, ["ItemID"] = "WEAPON_STUNGUN"},
    { ["name"] = "Pistol MK2      = $500", ["Price"] = 200, ["ItemID"] = "WEAPON_PISTOL_MK2"},
    { ["name"] = "Beanbag Shotgun      = $500", ["Price"] = 500, ["ItemID"] = "WEAPON_PUMPSHOTGUN"},
    { ["name"] = "Pump Shotgun MK2      = $500", ["Price"] = 500, ["ItemID"] = "WEAPON_PUMPSHOTGUN_MK2"},
    -- { ["name"] = "SMG MK2      = $600", ["Price"] = 600, ["ItemID"] = "WEAPON_SMG_MK2"},
    { ["name"] = "Carbine Rifle MK2      = $500", ["Price"] = 500, ["ItemID"] = "WEAPON_CARBINERIFLE_MK2"},
    -- { ["name"] = "Special Carbine MK2      = $600", ["Price"] = 600, ["ItemID"] = "WEAPON_SPECIALCARBINE_MK2"},
    { ["name"] = "Parachute      = $50", ["Price"] = 50, ["ItemID"] = "GADGET_PARACHUTE"},
    { ["name"] = "Scope      = $10", ["Price"] = 10, ["ItemID"] = "scope"},
    { ["name"] = "Foregrip      = $5", ["Price"] = 5, ["ItemID"] = "grip"},
    { ["name"] = "Flashlight Attachment      = $5", ["Price"] = 5, ["ItemID"] = "flashlight"},
    { ["name"] = "Suppressor      = $500", ["Price"] = 500, ["ItemID"] = "suppressor"},
    { ["name"] = "Police Vest      = $200", ["Price"] = 200, ["ItemID"] = "armorpolice"},
    -- { ["name"] = "SWAT Vest      = $300", ["Price"] = 300, ["ItemID"] = "armorswat"},
    { ["name"] = "Ifak      = $50", ["Price"] = 50, ["ItemID"] = "ifak"},
    { ["name"] = "Scuba Gear      = $10", ["Price"] = 10, ["ItemID"] = "scuba"},
    { ["name"] = "Phone        = $25", ["Price"] = 25, ["ItemID"] = "phone"},
	{ ["name"] = "Radio        = $25", ["Price"] = 25, ["ItemID"] = "radio"},
	{ ["name"] = "Watch        = $10", ["Price"] = 10, ["ItemID"] = "watch"},
    { ["name"] = "Binoculars        = $10", ["Price"] = 10, ["ItemID"] = "binoculars"},
    { ["name"] = "Camera      = $10", ["Price"] = 10, ["ItemID"] = "camera"},
    { ["name"] = "Large Pistol Ammo Box      = $5", ["Price"] = 5, ["ItemID"] = "ammunition_pistol_large"},
    { ["name"] = "Large Shotgun Ammo Box      = $200", ["Price"] = 200, ["ItemID"] = "ammunition_shotgun_large"},
    { ["name"] = "Large SMG Ammo Box      = $500", ["Price"] = 500, ["ItemID"] = "ammunition_smg_large"},
    { ["name"] = "Large Rifle Ammo Box      = $50", ["Price"] = 50, ["ItemID"] = "ammunition_rifle_large"},
    { ["name"] = "Taser Cartridge      = $50", ["Price"] = 50, ["ItemID"] = "cartridge"},
    { ["name"] = "Ankle Tracker      = $50", ["Price"] = 50, ["ItemID"] = "ankletracker"},
    { ["name"] = "Bolt Cutter      = $50", ["Price"] = 50, ["ItemID"] = "gruppe6wirecutter"},
    { ["name"] = "Blank ID      = $400", ["Price"] = 400, ["ItemID"] = "blankid"},
    { ["name"] = "UV Flashlight      = $400", ["Price"] = 400, ["ItemID"] = "uvlight"},
    { ["name"] = "Police Badge      = $400", ["Price"] = 400, ["ItemID"] = "badge"},
    { ["name"] = "Night Vision      = $5000", ["Price"] = 5000, ["ItemID"] = "nvg"},
}

Config.EmsItems = {
    { ["name"] = "Flashlight      = $400", ["Price"] = 400, ["ItemID"] = "WEAPON_FLASHLIGHT"},
    { ["name"] = "Stun Gun      = $200", ["Price"] = 200, ["ItemID"] = "WEAPON_STUNGUN"},
    { ["name"] = "Flare Gun      = $400", ["Price"] = 400, ["ItemID"] = "WEAPONN_FLAREGUN"},
    { ["name"] = "Parachute      = $50", ["Price"] = 50, ["ItemID"] = "GADGET_PARACHUTE"},
    { ["name"] = "Bandage      = $10", ["Price"] = 10, ["ItemID"] = "bandage"},
    { ["name"] = "Ifak      = $10", ["Price"] = 10, ["ItemID"] = "ifak"},
    { ["name"] = "Taser Cartridge      = $50", ["Price"] = 50, ["ItemID"] = "cartridge"},
    { ["name"] = "Scuba Gear      = $10", ["Price"] = 10, ["ItemID"] = "scuba"},
    { ["name"] = "Radio       = $25", ["Price"] = 25, ["ItemID"] = "radio"},
    { ["name"] = "Phone       = $25", ["Price"] = 25, ["ItemID"] = "phone"},
    { ["name"] = "Wheelchair       = $500", ["Price"] = 500, ["ItemID"] = "wheelchair"},
    { ["name"] = "Medical Bag       = $50", ["Price"] = 50, ["ItemID"] = "medbag"},
    
}

Config.BlackWeapons = {
    { ["name"] = "Knuckledusters      = $750", ["Price"] = 750, ["ItemID"] = "WEAPON_KNUCKLE"},
    { ["name"] = "Switchblade      = $1000", ["Price"] = 1000, ["ItemID"] = "WEAPON_SWITCHBLADE"},
    { ["name"] = "Heavy Pistol     = $8000", ["Price"] = 8000, ["ItemID"] = "WEAPON_HEAVYPISTOL"},
    { ["name"] = "Ceramic Pistol    = $35000", ["Price"] = 35000, ["ItemID"] = "WEAPON_CERAMICPISTOL"},
    { ["name"] = "AP Pistol     = $55000", ["Price"] = 55000, ["ItemID"] = "WEAPON_APPISTOL"},
    { ["name"] = "Double Barrel Shotgun      = $25000", ["Price"] = 25000, ["ItemID"] = "WEAPON_DBSHOTGUN"},
    { ["name"] = "Machine Pistol      = $48000", ["Price"] = 48000, ["ItemID"] = "WEAPON_MACHINEPISTOL"},
    { ["name"] = "Micro Smg      = $48000", ["Price"] = 48000, ["ItemID"] = "WEAPON_MICROSMG"},
    { ["name"] = "Mini Smg      = $48000", ["Price"] = 48000, ["ItemID"] = "WEAPON_MINISMG"},
    { ["name"] = "Combat PDW      = $60000", ["Price"] = 60000, ["ItemID"] = "WEAPON_COMBATPDW"},
    { ["name"] = "Assault Rifle      = $75000", ["Price"] = 75000, ["ItemID"] = "WEAPON_ASSAULTRIFLE"},
    { ["name"] = "Draco     = $48000", ["Price"] = 48000, ["ItemID"] = "WEAPON_COMPACTRIFLE"},
    { ["name"] = "Carbine Rifle      = $88000", ["Price"] = 88000, ["ItemID"] = "WEAPON_CARBINERIFLE"},
    { ["name"] = "Gusenberg    = $68000", ["Price"] = 68000, ["ItemID"] = "WEAPON_GUSENBERG"},
    { ["name"] = "Vice      = $500", ["Price"] = 500, ["ItemID"] = "drugvice"},
 
}