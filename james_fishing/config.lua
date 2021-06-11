Config = {}

Config.Debug = false -- only in dev mode.

Config.MarkerData = {
    ["type"] = 6,
    ["size"] = vector3(2.0, 2.0, 2.0),
    ["color"] = vector3(0, 255, 150)
}

Config.FishingRestaurant = {
    ["name"] = "La Spada Fish Restaurant",
    ["blip"] = {
        ["sprite"] = 410,
        ["color"] = 3
    },
    ["ped"] = {
        ["model"] = 0xED0CE4C6,
        ["position"] = vector3(-1038.4545898438, -1397.0551757813, 5.553192615509),
        ["heading"] = 75.0
    }
}

Config.FishingItems = {
    ["rod"] = {
        ["name"] = "fishingrod",
        ["label"] = "Fishing Rod"
    },
    ["bait"] = {
        ["name"] = "bait",
        ["label"] = "Bait"
    },
    ["baitLuxary"] = {
        ["name"] = "baitturtle",
        ["label"] = "Luxary Bait"
    },
    ["fish"] = {
        ["name"] = "fish",
        ["label"] = "Fish",
    },
}

Config.SellableItems = {
    [1] = {name = 'fish', price = 250},
    [2] = {name = 'turtle', price = 600},
    [3] = {name = 'fishDolphin', price = 750},
    [4] = {name = 'fishShark', price = 800},
    [5] = {name = 'fishWhale', price = 800},
    [6] = {name = 'fishBass', price = 125},
    [7] = {name = 'fishBluefish', price = 250},
    [8] = {name = 'fishCod', price = 200},
    [9] = {name = 'fishFlounder', price = 300},
    [10] = {name = 'fishMackerel', price = 350},
}

Config.Command = "fish"