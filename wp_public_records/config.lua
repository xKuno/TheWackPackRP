Config = {

Locations = { -- Every workbench location, leave {} for jobs if you want everybody to access

{coords = vector3(-549.46, -194.12, 39.21), radius = 3.0 }

},
 

Text = {

    ['view_record'] = '[~b~E~w~] View Public Records'

}

}



function SendTextMessage(msg)

        exports['mythic_notify']:SendAlert('inform', msg)

end
