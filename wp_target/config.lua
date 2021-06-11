Config = {

    Locations = {
    
    {coords = vector3(1116.8, 217.2, -49.44 + 1), radius = 1.0 }
    
    },

    LocationsPDMPlate = {
    
    {coords = vector3(-29.71, -1107.87, 26.42 + 1), radius = 1.0 }
    
    },
     
    
    Text = {
    
        ['call_clerk'] = '[~b~E~w~] Call Clerk',
        ['call_seller'] = '[~b~E~w~] Call Seller'
    
    }
    
    }

Config.ESX = true


-- Return an object in the format
-- {
--     name = job name
-- }

Config.NonEsxJob = function()
    local PlayerJob = {}

    return PlayerJob
end