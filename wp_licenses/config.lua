Config = {

Locations = { -- Every workbench location, leave {} for jobs if you want everybody to access

{coords = vector3(441.71, -979.70, 31.67), radius = 3.0 },
{coords = vector3(-551.4989, -195.32, 39.21), radius = 3.0 }

},
 

Text = {

    ['purchase_license'] = '[~b~E~w~] Purchase Weapon License'

}

}



function SendTextMessage(msg)

        exports['mythic_notify']:SendAlert('inform', msg)

end
