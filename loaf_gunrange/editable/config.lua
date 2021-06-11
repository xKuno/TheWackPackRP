--[[
    FYI: 
        * vector3 is in the format: x, y, z so vector3(x, y, z)
        * vector4 is in the format: x, y, z, heading so vector3(x, y, z, heading)

--]]

Config = {
    
    ['WeaponMenu'] = {
        ['Enabled'] = false, -- true = people can choose a weapon from a menu, false = people will have to use guns they already own
        ['Weapons'] = {
            {label = 'Combat pistol', weapon = 'WEAPON_COMBATPISTOL'},
            {label = 'Pistol', weapon = 'WEAPON_PISTOL'},

            {label = 'Carbine rifle', weapon = 'WEAPON_CARBINERIFLE'},
            {label = 'Special carbine', weapon = 'WEAPON_SPECIALCARBINE'},
            {label = 'Bullpup rifle', weapon = 'WEAPON_BULLPUPRIFLE'},

            {label = 'Pump shotgun', weapon = 'WEAPON_PUMPSHOTGUN'},
        }
    },

    ['Colours'] = {
        [15] = '~g~', -- 15 points = green
        [30] = '~b~', -- 30 points = blue
        [45] = '~o~', -- 45 points = orange
        [60] = '~r~' -- 60 points = red
    },

    ['Targets'] = {
        {
            obj = 'prop_target_comp_metal',
            type = 'sphere',
            offsets = {
                vec4(0.0, 0.0, 0.0, 0.075), -- vec4(x, y, z, radius) 
                vec4(0.0, 0.0, 0.0, 0.15), -- vec4(x, y, z, radius) 
                vec4(0.0, 0.0, 0.0, 0.2), -- vec4(x, y, z, radius) 
                vec4(0.0, 0.0, 0.0, 0.275), -- vec4(x, y, z, radius) 
            },
        },

        {
            obj = 'prop_range_target_01',
            type = 'box',
            offsets = {
                {
                    vector3(-0.07, 0.0, -1.125),
                    vector3(0.05, 0.0, -1.275)
                },
                {
                    vector3(-0.12, 0.0, -1.05),
                    vector3(0.1, 0.0, -1.35)
                },
                {
                    vector3(-0.195, 0.0, -0.95),
                    vector3(0.18, 0.0, -1.45)
                },
                {
                    vector3(-0.24, 0.0, -0.9),
                    vector3(0.24, 0.0, -1.5)
                },
            },
        },
    },

    ['GunRanges'] = {

        {
            ['Blip'] = {

                ['Enabled'] = false,
                ['Position'] = vector3(20.0, -1110.0, 331.0),
                ['Sprite'] = 110, -- https://docs.fivem.net/docs/game-references/blips/
                ['Colour'] = 0, -- https://docs.fivem.net/docs/game-references/blips/

            },

            ['Jobs'] = {

                ['Locked'] = false, -- set this to false to enable each job to use the gunrange, true to only allow jobs in the list
                ['Allowed'] = {
                    'police',
                    -- you can add more jobs here
                },

            },

            ['Locations'] = {
                {
                    coords = vector4(8.4, -1095.4, 29.83, 340.0),
                    targets = {
                        -- back
                        vector4(17.833110809326, -1069.2279052734, 29.845045089722, 346.61422729492),
                        vector4(18.753175735474, -1069.5173339844, 29.845045089722, 352.90832519531),
                        vector4(19.787599563599, -1069.8073730469, 29.845045089722, 340.5569152832),
                        vector4(20.571090698242, -1070.3674316406, 29.845043182373, 340.66400146484),
                        vector4(21.519241333008, -1070.6644287109, 29.845041275024, 342.11538696289),
                        vector4(22.578151702881, -1070.8939208984, 29.845043182373, 339.15270996094),
                        vector4(23.446544647217, -1071.3160400391, 29.845041275024, 342.26953125),
                        vector4(24.484746932983, -1071.5866699219, 29.845043182373, 337.44937133789),
                        vector4(25.338006973267, -1071.9141845703, 29.845043182373, 338.35397338867),
                        vector4(26.314413070679, -1072.2576904297, 29.84504699707, 344.73358154297),
                        vector4(27.244832992554, -1072.6872558594, 29.84504699707, 339.01348876953),
                        vector4(28.145648956299, -1072.9904785156, 29.84504699707, 348.95074462891),

                        -- middle, left 5
                        vector4(14.026497840881, -1079.6353759766, 29.844930648804, 355.61682128906),
                        vector4(15.017477989197, -1080.0590820313, 29.845043182373, 339.15228271484),
                        vector4(15.796446800232, -1080.3723144531, 29.845043182373, 338.74487304688),
                        vector4(16.896068572998, -1080.59765625, 29.845043182373, 343.53485107422),
                        vector4(17.777332305908, -1080.9938964844, 29.845043182373, 337.64837646484),

                        -- closest, left 2
                        vector4(10.94709777832, -1088.2475585938, 29.845039367676, 341.14218139648),
                        vector4(11.863671302795, -1088.5599365234, 29.845043182373, 351.7829284668),
                    },
                },
                {
                    coords = vector4(9.4, -1095.77, 29.83, 340.0),
                    targets = {
                        -- back
                        vector4(17.833110809326, -1069.2279052734, 29.845045089722, 346.61422729492),
                        vector4(18.753175735474, -1069.5173339844, 29.845045089722, 352.90832519531),
                        vector4(19.787599563599, -1069.8073730469, 29.845045089722, 340.5569152832),
                        vector4(20.571090698242, -1070.3674316406, 29.845043182373, 340.66400146484),
                        vector4(21.519241333008, -1070.6644287109, 29.845041275024, 342.11538696289),
                        vector4(22.578151702881, -1070.8939208984, 29.845043182373, 339.15270996094),
                        vector4(23.446544647217, -1071.3160400391, 29.845041275024, 342.26953125),
                        vector4(24.484746932983, -1071.5866699219, 29.845043182373, 337.44937133789),
                        vector4(25.338006973267, -1071.9141845703, 29.845043182373, 338.35397338867),
                        vector4(26.314413070679, -1072.2576904297, 29.84504699707, 344.73358154297),
                        vector4(27.244832992554, -1072.6872558594, 29.84504699707, 339.01348876953),
                        vector4(28.145648956299, -1072.9904785156, 29.84504699707, 348.95074462891),

                        -- middle, left 5
                        vector4(14.026497840881, -1079.6353759766, 29.844930648804, 355.61682128906),
                        vector4(15.017477989197, -1080.0590820313, 29.845043182373, 339.15228271484),
                        vector4(15.796446800232, -1080.3723144531, 29.845043182373, 338.74487304688),
                        vector4(16.896068572998, -1080.59765625, 29.845043182373, 343.53485107422),
                        vector4(17.777332305908, -1080.9938964844, 29.845043182373, 337.64837646484),

                        vector4(10.902272224426, -1088.1223144531, 29.845043182373, 336.16244506836),
                        vector4(11.733567237854, -1088.5358886719, 29.845043182373, 340.02487182617),
                        vector4(12.743752479553, -1088.9425048828, 29.845043182373, 339.27005004883),
                    },
                },
                {
                    coords = vector4(10.30, -1096.13, 29.83, 340.0),
                    targets = {
                        vector4(17.833110809326, -1069.2279052734, 29.845045089722, 346.61422729492),
                        vector4(18.753175735474, -1069.5173339844, 29.845045089722, 352.90832519531),
                        vector4(19.787599563599, -1069.8073730469, 29.845045089722, 340.5569152832),
                        vector4(20.571090698242, -1070.3674316406, 29.845043182373, 340.66400146484),
                        vector4(21.519241333008, -1070.6644287109, 29.845041275024, 342.11538696289),
                        vector4(22.578151702881, -1070.8939208984, 29.845043182373, 339.15270996094),
                        vector4(23.446544647217, -1071.3160400391, 29.845041275024, 342.26953125),
                        vector4(24.484746932983, -1071.5866699219, 29.845043182373, 337.44937133789),
                        vector4(25.338006973267, -1071.9141845703, 29.845043182373, 338.35397338867),
                        vector4(26.314413070679, -1072.2576904297, 29.84504699707, 344.73358154297),
                        vector4(27.244832992554, -1072.6872558594, 29.84504699707, 339.01348876953),
                        vector4(28.145648956299, -1072.9904785156, 29.84504699707, 348.95074462891),

                        -- middle, left 5
                        vector4(14.026497840881, -1079.6353759766, 29.844930648804, 355.61682128906),
                        vector4(15.017477989197, -1080.0590820313, 29.845043182373, 339.15228271484),
                        vector4(15.796446800232, -1080.3723144531, 29.845043182373, 338.74487304688),
                        vector4(16.896068572998, -1080.59765625, 29.845043182373, 343.53485107422),
                        vector4(17.777332305908, -1080.9938964844, 29.845043182373, 337.64837646484),

                        vector4(11.872257232666, -1088.4638671875, 29.845045089722, 345.95550537109),
                        vector4(12.775745391846, -1088.892578125, 29.845045089722, 340.75149536133),
                        vector4(13.725363731384, -1089.2492675781, 29.845041275024, 342.00256347656),
                    },
                },
                {
                    coords = vector4(11.22, -1096.51, 29.83, 340.0),
                    targets = {
                        vector4(17.833110809326, -1069.2279052734, 29.845045089722, 346.61422729492),
                        vector4(18.753175735474, -1069.5173339844, 29.845045089722, 352.90832519531),
                        vector4(19.787599563599, -1069.8073730469, 29.845045089722, 340.5569152832),
                        vector4(20.571090698242, -1070.3674316406, 29.845043182373, 340.66400146484),
                        vector4(21.519241333008, -1070.6644287109, 29.845041275024, 342.11538696289),
                        vector4(22.578151702881, -1070.8939208984, 29.845043182373, 339.15270996094),
                        vector4(23.446544647217, -1071.3160400391, 29.845041275024, 342.26953125),
                        vector4(24.484746932983, -1071.5866699219, 29.845043182373, 337.44937133789),
                        vector4(25.338006973267, -1071.9141845703, 29.845043182373, 338.35397338867),
                        vector4(26.314413070679, -1072.2576904297, 29.84504699707, 344.73358154297),
                        vector4(27.244832992554, -1072.6872558594, 29.84504699707, 339.01348876953),
                        vector4(28.145648956299, -1072.9904785156, 29.84504699707, 348.95074462891),

                        -- middle, left 5
                        vector4(14.026497840881, -1079.6353759766, 29.844930648804, 355.61682128906),
                        vector4(15.017477989197, -1080.0590820313, 29.845043182373, 339.15228271484),
                        vector4(15.796446800232, -1080.3723144531, 29.845043182373, 338.74487304688),
                        vector4(16.896068572998, -1080.59765625, 29.845043182373, 343.53485107422),
                        vector4(17.777332305908, -1080.9938964844, 29.845043182373, 337.64837646484),

                        vector4(12.761939048767, -1088.8338623047, 29.845043182373, 339.56488037109),
                        vector4(13.711015701294, -1089.2613525391, 29.845043182373, 339.09664916992),
                        vector4(14.623076438904, -1089.5882568359, 29.84504699707, 341.83786010742),
                    },
                },

                {
                    coords = vector4(15.92, -1098.18, 29.83, 340.0),
                    targets = {
                        -- back
                        vector4(17.833110809326, -1069.2279052734, 29.845045089722, 346.61422729492),
                        vector4(18.753175735474, -1069.5173339844, 29.845045089722, 352.90832519531),
                        vector4(19.787599563599, -1069.8073730469, 29.845045089722, 340.5569152832),
                        vector4(20.571090698242, -1070.3674316406, 29.845043182373, 340.66400146484),
                        vector4(21.519241333008, -1070.6644287109, 29.845041275024, 342.11538696289),
                        vector4(22.578151702881, -1070.8939208984, 29.845043182373, 339.15270996094),
                        vector4(23.446544647217, -1071.3160400391, 29.845041275024, 342.26953125),
                        vector4(24.484746932983, -1071.5866699219, 29.845043182373, 337.44937133789),
                        vector4(25.338006973267, -1071.9141845703, 29.845043182373, 338.35397338867),
                        vector4(26.314413070679, -1072.2576904297, 29.84504699707, 344.73358154297),
                        vector4(27.244832992554, -1072.6872558594, 29.84504699707, 339.01348876953),
                        vector4(28.145648956299, -1072.9904785156, 29.84504699707, 348.95074462891),

                        -- middle, right 5
                        vector4(24.342741012573, -1083.4012451172, 29.845043182373, 338.36810302734),
                        vector4(23.480047225952, -1083.0375976563, 29.845043182373, 340.99417114258),
                        vector4(22.452545166016, -1082.6335449219, 29.845043182373, 343.57943725586),
                        vector4(21.476737976074, -1082.2786865234, 29.845043182373, 341.7014465332),
                        vector4(20.569896697998, -1081.9552001953, 29.845043182373, 333.84149169922),

                        vector4(21.345504760742, -1091.9670410156, 29.845026016235, 350.42639160156),
                        vector4(20.292112350464, -1091.5532226563, 29.84504699707, 341.25573730469),
                    },
                },
                {
                    coords = vector4(16.84, -1098.52, 29.83, 340.0),
                    targets = {
                        -- back
                        vector4(17.833110809326, -1069.2279052734, 29.845045089722, 346.61422729492),
                        vector4(18.753175735474, -1069.5173339844, 29.845045089722, 352.90832519531),
                        vector4(19.787599563599, -1069.8073730469, 29.845045089722, 340.5569152832),
                        vector4(20.571090698242, -1070.3674316406, 29.845043182373, 340.66400146484),
                        vector4(21.519241333008, -1070.6644287109, 29.845041275024, 342.11538696289),
                        vector4(22.578151702881, -1070.8939208984, 29.845043182373, 339.15270996094),
                        vector4(23.446544647217, -1071.3160400391, 29.845041275024, 342.26953125),
                        vector4(24.484746932983, -1071.5866699219, 29.845043182373, 337.44937133789),
                        vector4(25.338006973267, -1071.9141845703, 29.845043182373, 338.35397338867),
                        vector4(26.314413070679, -1072.2576904297, 29.84504699707, 344.73358154297),
                        vector4(27.244832992554, -1072.6872558594, 29.84504699707, 339.01348876953),
                        vector4(28.145648956299, -1072.9904785156, 29.84504699707, 348.95074462891),

                        -- middle, right 5
                        vector4(24.342741012573, -1083.4012451172, 29.845043182373, 338.36810302734),
                        vector4(23.480047225952, -1083.0375976563, 29.845043182373, 340.99417114258),
                        vector4(22.452545166016, -1082.6335449219, 29.845043182373, 343.57943725586),
                        vector4(21.476737976074, -1082.2786865234, 29.845043182373, 341.7014465332),
                        vector4(20.569896697998, -1081.9552001953, 29.845043182373, 333.84149169922),

                        vector4(21.245838165283, -1091.9975585938, 29.845006942749, 344.31448364258),
                        vector4(20.25438117981, -1091.5966796875, 29.845043182373, 8.2787837982178),
                        vector4(19.274480819702, -1091.2562255859, 29.84504699707, 341.36267089844),
                    },
                },
                {
                    coords = vector4(17.77, -1098.87, 29.83, 340.0),
                    targets = {
                        -- back
                        vector4(17.833110809326, -1069.2279052734, 29.845045089722, 346.61422729492),
                        vector4(18.753175735474, -1069.5173339844, 29.845045089722, 352.90832519531),
                        vector4(19.787599563599, -1069.8073730469, 29.845045089722, 340.5569152832),
                        vector4(20.571090698242, -1070.3674316406, 29.845043182373, 340.66400146484),
                        vector4(21.519241333008, -1070.6644287109, 29.845041275024, 342.11538696289),
                        vector4(22.578151702881, -1070.8939208984, 29.845043182373, 339.15270996094),
                        vector4(23.446544647217, -1071.3160400391, 29.845041275024, 342.26953125),
                        vector4(24.484746932983, -1071.5866699219, 29.845043182373, 337.44937133789),
                        vector4(25.338006973267, -1071.9141845703, 29.845043182373, 338.35397338867),
                        vector4(26.314413070679, -1072.2576904297, 29.84504699707, 344.73358154297),
                        vector4(27.244832992554, -1072.6872558594, 29.84504699707, 339.01348876953),
                        vector4(28.145648956299, -1072.9904785156, 29.84504699707, 348.95074462891),

                        -- middle, right 5
                        vector4(24.342741012573, -1083.4012451172, 29.845043182373, 338.36810302734),
                        vector4(23.480047225952, -1083.0375976563, 29.845043182373, 340.99417114258),
                        vector4(22.452545166016, -1082.6335449219, 29.845043182373, 343.57943725586),
                        vector4(21.476737976074, -1082.2786865234, 29.845043182373, 341.7014465332),
                        vector4(20.569896697998, -1081.9552001953, 29.845043182373, 333.84149169922),

                        vector4(20.333332061768, -1091.6783447266, 29.84504699707, 346.91403198242),
                        vector4(19.333694458008, -1091.1876220703, 29.84504699707, 338.43225097656),
                        vector4(18.368322372437, -1090.9411621094, 29.84504699707, 340.24020385742),
                    },
                },
                {
                    coords = vector4(18.80, -1099.25, 29.83, 340.0),
                    targets = {
                        -- back
                        vector4(17.833110809326, -1069.2279052734, 29.845045089722, 346.61422729492),
                        vector4(18.753175735474, -1069.5173339844, 29.845045089722, 352.90832519531),
                        vector4(19.787599563599, -1069.8073730469, 29.845045089722, 340.5569152832),
                        vector4(20.571090698242, -1070.3674316406, 29.845043182373, 340.66400146484),
                        vector4(21.519241333008, -1070.6644287109, 29.845041275024, 342.11538696289),
                        vector4(22.578151702881, -1070.8939208984, 29.845043182373, 339.15270996094),
                        vector4(23.446544647217, -1071.3160400391, 29.845041275024, 342.26953125),
                        vector4(24.484746932983, -1071.5866699219, 29.845043182373, 337.44937133789),
                        vector4(25.338006973267, -1071.9141845703, 29.845043182373, 338.35397338867),
                        vector4(26.314413070679, -1072.2576904297, 29.84504699707, 344.73358154297),
                        vector4(27.244832992554, -1072.6872558594, 29.84504699707, 339.01348876953),
                        vector4(28.145648956299, -1072.9904785156, 29.84504699707, 348.95074462891),

                        -- middle, right 5
                        vector4(24.342741012573, -1083.4012451172, 29.845043182373, 338.36810302734),
                        vector4(23.480047225952, -1083.0375976563, 29.845043182373, 340.99417114258),
                        vector4(22.452545166016, -1082.6335449219, 29.845043182373, 343.57943725586),
                        vector4(21.476737976074, -1082.2786865234, 29.845043182373, 341.7014465332),
                        vector4(20.569896697998, -1081.9552001953, 29.845043182373, 333.84149169922),

                        vector4(19.319839477539, -1091.2590332031, 29.84504699707, 338.30944824219),
                        vector4(18.40124130249, -1090.8514404297, 29.84504699707, 10.210451126099),
                        vector4(17.460048675537, -1090.4315185547, 29.84504699707, 44.60510635376),
                    },
                },
            },
        }

    }
    
}

Strings = {
    ['Blip'] = 'Gun range',
    ['Use'] = '~INPUT_CONTEXT~ Use gun range',
    ['Using'] = 'You can\'t use this gun range.',
    ['No_Gun'] = 'You have to equip a gun to use.',
    ['Using_Info'] = 'Points: %s\nHits: %s/%s\nShots: %s',
    ['Weapon_Menu'] = 'Please select a weapon.'
}