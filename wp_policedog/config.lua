-- TriggerEvent('esx_policedog:openMenu') to open menu

Config = {
    Command = false, -- set to false if you dont want to have a command
    Model = 351016938,
    TpDistance = 50.0,
    Sit = {
        dict = 'creatures@rottweiler@amb@world_dog_sitting@base',
        anim = 'base'
    },
    Drugs = {'drugcokebag', 'drugcokebrick', 'drugcoketray', 'drugcoketray', 'drugrawweed', 'drugweedbag', 'drugweedbrick', 'meat', 'fish'}, -- add all drugs here for the dog to detect
}

Strings = {
    ['not_police'] = 'You Are ~r~Not ~s~An Officer!',
    ['menu_title'] = 'K9',
    ['take_out_remove'] = 'Take Out / Remove K9',
    ['deleted_dog'] = 'Removed The Police Dog',
    ['spawned_dog'] = 'Created A Police Dog',
    ['sit_stand'] = 'Make Dog Sit / Stand',
    ['no_dog'] = "You Don't Have Any Dog!",
    ['dog_dead'] = 'Your Dog Is Dead :/',
    ['search_drugs'] = 'Search Closest Player For Drugs',
    ['no_drugs'] = 'No Drugs Found.', 
    ['drugs_found'] = 'Found Drugs',
    ['dog_too_far'] = 'The dog is too far away!',
    ['attack_closest'] = 'Attack Closest Player',
    ['get_in_out'] = 'Get In / Out Of Vehicle'
}