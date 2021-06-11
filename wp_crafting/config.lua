Config = {

BlipSprite = 237,
BlipColor = 26,
BlipText = 'Workbench',

UseLimitSystem = false, -- Enable if your esx uses limit system

CraftingStopWithDistance = false, -- Crafting will stop when not near workbench

ExperiancePerCraft = 5, -- The amount of experiance added per craft (100 Experiance is 1 level)

HideWhenCantCraft = false, -- Instead of lowering the opacity it hides the item that is not craftable due to low level or wrong job

Categories = {

['tool'] = {
	Label = 'TOOLS',
	Image = 'fixkit',
	Jobs = {}
},
['weapon'] = {
	Label = 'WEAPONRY',
	Image = 'WEAPON_APPISTOL',
	Jobs = {}
},
['crafting'] = {
	Label = 'RESOURCES',
	Image = 'aluminum',
	Jobs = {}
}


},

PermanentItems = { -- Items that dont get removed when crafting
	['WEAPON_WRENCH'] = true
},

Recipes = { -- Enter Item name and then the speed value! The higher the value the more torque

['fixkit'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'tool', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 75, -- 100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['aluminum'] = 2, -- item name and count, adding items that dont exist in database will crash the script
		['electronics'] = 1,
		['scrapmetal'] = 5
	}
}, 

['fixallkit'] = {
	Level = 2, -- From what level this item will be craftable
	Category = 'tool', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 50, -- 100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 50, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
		['aluminum'] = 5, -- item name and count, adding items that dont exist in database will crash the script
		['electronics'] = 3,
		['scrapmetal'] = 5
	}
}, 

['lockpick'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'tool', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 80, -- 100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	['scrapmetal'] = 1
	}
}, 

['advlockpick'] = {
	Level = 2, -- From what level this item will be craftable
	Category = 'tool', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 50, -- 100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 45, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	['recyclablematerial'] = 2,
	['scrapmetal'] = 3
	}
}, 

['nos'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'tool', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 45, -- 100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 65, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	['recyclablematerial'] = 25, -- item name and count, adding items that dont exist in database will crash the script
	['electronics'] = 15,
	['plastic'] = 1
	}
}, 

['armor'] = {
	Level = 10, -- From what level this item will be craftable
	Category = 'weapon', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 25, -- 100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 80, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	['scrapmetal'] = 5, -- item name and count, adding items that dont exist in database will crash the script
	['leather'] = 3
	}
}, 

['scrapmetal'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'crafting', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 2, -- The amount that will be crafted
	SuccessRate = 100, -- 100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	['silver'] = 5, -- item name and count, adding items that dont exist in database will crash the script
	['iron'] = 5
	}
},

['plastic'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'crafting', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 5, -- The amount that will be crafted
	SuccessRate = 100, -- 100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	['drugempybag'] = 10
	}
},

['recyclablematerial'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'crafting', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 2, -- The amount that will be crafted
	SuccessRate = 100, -- 100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	['coal'] = 5, -- item name and count, adding items that dont exist in database will crash the script
	['gold'] = 5
	}
},

['electronics'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'crafting', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 2, -- The amount that will be crafted
	SuccessRate = 100, -- 100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	['gold'] = 5
	}
},

['aluminum'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'crafting', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 2, -- The amount that will be crafted
	SuccessRate = 100, -- 100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	['silver'] = 5 -- item name and count, adding items that dont exist in database will crash the script
	}
},

['mag'] = {
	Level = 25, -- From what level this item will be craftable
	Category = 'weapon', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 50, -- 100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 60, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	['recyclablematerial'] = 5, -- item name and count, adding items that dont exist in database will crash the script
	['scrapmetal'] = 5,
	['aluminum'] = 5
	}
},

['WEAPON_MOLOTOV'] = {
	Level = 50, -- From what level this item will be craftable
	Category = 'weapon', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 25, -- 100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 60, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	['drinkbeer'] = 1, -- item name and count, adding items that dont exist in database will crash the script
	['leather'] = 3
	}
},

['ammunition_pistol_large'] = {
	Level = 0, -- From what level this item will be craftable
	Category = 'weapon', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 66, -- 100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 20, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	['coal'] = 4, -- item name and count, adding items that dont exist in database will crash the script
	['scrapmetal'] = 3
	}
}, 

['ammunition_smg_large'] = {
	Level = 5, -- From what level this item will be craftable
	Category = 'weapon', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 55, -- 100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 35, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	['coal'] = 5, -- item name and count, adding items that dont exist in database will crash the script
	['scrapmetal'] = 5
	}
},

['ammunition_rifle_large'] = {
	Level = 10, -- From what level this item will be craftable
	Category = 'weapon', -- The category item will be put in
	isGun = false, -- Specify if this is a gun so it will be added to the loadout
	Jobs = {}, -- What jobs can craft this item, leaving {} allows any job
	JobGrades = {}, -- What job grades can craft this item, leaving {} allows any grade
	Amount = 1, -- The amount that will be crafted
	SuccessRate = 45, -- 100% you will recieve the item
	requireBlueprint = false, -- Requires a blueprint whitch you need to add in the database yourself TEMPLATE: itemname_blueprint EXAMPLE: bandage_blueprint
	Time = 45, -- Time in seconds it takes to craft this item
	Ingredients = { -- Ingredients needed to craft this item
	['coal'] = 6, -- item name and count, adding items that dont exist in database will crash the script
	['scrapmetal'] = 4
	}
}

},

Workbenches = { -- Every workbench location, leave {} for jobs if you want everybody to access

{coords = vector3(-323.33, -129.62, 40.01), jobs = {}, blip = false, recipes = {}, radius = 3.0 },
{coords = vector3(-1147.31, -2002.20, 14.17), jobs = {}, blip = false, recipes = {}, radius = 3.0 },
{coords = vector3(1997.32, 3796.57, 33.18), jobs = {}, blip = false, recipes = {}, radius = 3.0 },
{coords = vector3(-79.6, 6414.95, 32.64), jobs = {}, blip = false, recipes = {}, radius = 3.0 },
{coords = vector3(-227.68, -1328.09, 31.88), jobs = {}, blip = false, recipes = {}, radius = 3.0 }

},
 

Text = {

    ['not_enough_ingredients'] = 'You dont have enough ingredients',
    ['you_cant_hold_item'] = 'You cant hold the item',
    ['item_crafted'] = 'Item crafted!',
    ['wrong_job'] = 'You cant open this workbench',
    ['workbench_hologram'] = '[~b~E~w~] Workbench',
    ['wrong_usage'] = 'Wrong usage of command',
    ['inv_limit_exceed'] = 'Inventory limit exceeded! Clean up before you lose more',
    ['crafting_failed'] = 'You failed to craft the item!'

}

}



function SendTextMessage(msg)

        exports['mythic_notify']:SendAlert('inform', msg)

end
