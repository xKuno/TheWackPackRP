TD = {}

TD.Doors = {
	{
		textCoords = vector3(434.7444, -981.8956, 30.8153),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = false,
		pickable = true,
		distance = 2.5,
		sound = false,
		doors = {
			{
				objName = 'gabz_mrpd_reception_entrancedoor',
			objYaw = 270.0,
			objCoords = vector3(434.7444, -980.7556, 30.8153)
		},

			{
				objName = 'gabz_mrpd_reception_entrancedoor',
				objYaw = 90.0,
				objCoords = vector3(434.7444, -983.0781, 30.8153)
			}
		}
	},
	-- Side Entrance Door 1
	{
		textCoords = vector3(457.00, -972.28, 30.7),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 2.5,
		sound = false,
		doors = {
			{
				objName = 'gabz_mrpd_reception_entrancedoor',
			objYaw = 360.0,
			objCoords = vector3(455.8862, -972.2543, 30.81531)
		},

			{
				objName = 'gabz_mrpd_reception_entrancedoor',
				objYaw = 180.0,
				objCoords = vector3(458.2087, -972.2543, 30.81531)
			}
		}
	},
	-- Side Entrance Door 2
	{
		textCoords = vector3(441.8, -998.73, 30.7),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 2.5,
		sound = false,
		doors = {
			{
				objName = 'gabz_mrpd_reception_entrancedoor',
			objYaw = 360.0,
			objCoords = vector3(440.7392, -998.7462, 30.8153)
		},

			{
				objName = 'gabz_mrpd_reception_entrancedoor',
				objYaw = 180.0,
				objCoords = vector3(443.0618,-998.7462,30.8153)
			}
		}
	},
	-- Parking Garage Single Door 1
	{
		objName = 'gabz_mrpd_room13_parkingdoor',
		objYaw = 90.0,
		objCoords  = vector3(464.1566, -997.5093, 26.3707),
		textCoords = vector3(464.1566, -997.5093, 26.3707),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		sound = false,
	},
	-- Parking Garage Single Door 2
	{
		objName = 'gabz_mrpd_room13_parkingdoor',
		objYaw = 270.0,
		objCoords  = vector3(464.1591, -974.6656, 26.3707),
		textCoords = vector3(464.1591, -974.6656, 26.3707),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		sound = false,
	},
	-- Garage Door 1
	{
		objName = 'gabz_mrpd_garage_door',
		objYaw = 0.0,
		objCoords  = vector3(452.3005, -1000.772, 26.69661),
		textCoords = vector3(452.3005, -1000.772, 26.69661),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 10.0,
		sound = true,
	},
	-- Garage Door 2
	{
		objName = 'gabz_mrpd_garage_door',
		objYaw = 0.0,
		objCoords  = vector3(431.4119, -1000.772, 26.69661),
		textCoords = vector3(431.4119, -1000.772, 26.69661),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 10.0,
		sound = true,
	},
	-- Back Double Doors
	{
		textCoords = vector3(468.67, -1014.43, 26.48),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		sound = false,
		doors = {
			{
				objName = 'gabz_mrpd_door_03',
				objYaw = 180.0,
				objCoords  = vector3(469.7743, -1014.406, 26.48382)
			},
	
			{
				objName = 'gabz_mrpd_door_03',
				objYaw = 0.0,
				objCoords  = vector3(467.3686, -1014.406, 26.483829)
			}
		}
	},
	-- -- Back Gate
	-- {
	-- 	objName = 'hei_prop_station_gate',
	-- 	objYaw = 90.0,
	-- 	objCoords  = vector3(488.8948, -1017.212, 27.14935),
	-- 	textCoords = vector3(488.8948, -1017.212, 27.14935),
	-- 	authorizedJobs = { 'police', 'offpolice' },
	-- 	locking = false,
	-- 	locked = true,
	-- 	pickable = true,
	-- 	distance = 10.0,
	-- },
	-- Captain's Office
	{
		objName = 'gabz_mrpd_door_05',
		objYaw = 270.0,
		objCoords  = vector3(458.65430, -990.64980, 30.82319),
		textCoords = vector3(458.65430, -990.64980, 30.82319),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 1.5,
		sound = false,
	},
	-- Front Side Entrance Door 1
	{
		objName = 'gabz_mrpd_door_04',
		objYaw = 360.0,
		objCoords = vector3(440.5201, -977.6011, 30.80),
		textCoords = vector3(440.5201, -977.6011, 30.80),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		sound = false,
	},
	-- Front Side Entrance Door 2
	{
		objName = 'gabz_mrpd_door_05',
		objYaw = 180.0,
		objCoords = vector3(440.5201, -986.2335, 30.80),
		textCoords = vector3(440.5201, -986.2335, 30.80),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		sound = false,
	},
	-- Interigation Room 1
	{
		objName = 'gabz_mrpd_door_04',
		objYaw = 270.0,
		objCoords = vector3(482.6701, -987.5792, 26.40548),
		textCoords = vector3(482.6701, -987.5792, 26.4),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.25,
		sound = false,
	},
	-- Interigation Room 2
	{
		objName = 'gabz_mrpd_door_04',
		objYaw = 270.0,
		objCoords = vector3(482.6703, -995.7285, 26.40548),
		textCoords = vector3(482.6703, -995.7285, 26.4),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.25,
		sound = false,
	},
	-- Cell 1
	{
		objName = 'gabz_mrpd_cells_door',
		objYaw = 0.0,
		objCoords = vector3(477.9126, -1012.189, 26.5),
		textCoords = vector3(477.9126, -1012.189, 26.4),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.25,
		sound = false,
	},
	-- Cell 2
	{
		objName = 'gabz_mrpd_cells_door',
		objYaw = 0.0,
		objCoords = vector3(480.9128, -1012.189, 26.5),
		textCoords = vector3(480.9128, -1012.189, 26.4),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.25,
		sound = false,
	},
	-- Cell 3
	{
		objName = 'gabz_mrpd_cells_door',
		objYaw = 0.0,
		objCoords = vector3(483.9127, -1012.189, 26.5),
		textCoords = vector3(483.9127, -1012.189, 26.4),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.25,
		sound = false,
	},
	-- Cell 4
	{
		objName = 'gabz_mrpd_cells_door',
		objYaw = 0.0,
		objCoords = vector3(486.9131, -1012.189, 26.5),
		textCoords = vector3(486.9131, -1012.189, 26.4),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.25,
		sound = false,
	},
	-- Cell 5
	{
		objName = 'gabz_mrpd_cells_door',
		objYaw = 180.0,
		objCoords = vector3(484.1764, -1007.734, 26.48),
		textCoords = vector3(484.1764, -1007.734, 26.48),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.25,
		sound = false,
	},
	-- Cell 6
	{
		objName = 'gabz_mrpd_cells_door',
		objYaw = 180.0,
		objCoords = vector3(481.0084, -1004.118, 26.5),
		textCoords = vector3(481.0084, -1004.118, 26.4),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.25,
		sound = false,
	},
	-- Cell Entrance Door
	{
		objName = 'gabz_mrpd_cells_door',
		objYaw = 270.0,
		objCoords = vector3(476.6157, -1008.875, 26.48005),
		textCoords = vector3(476.6157, -1008.875, 26.48005),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.25,
		sound = false,
	},
	-- Rooftop
	{
		objName = 'gabz_mrpd_door_03',
		objYaw = 90.0,
		objCoords  = vector3(464.3086, -984.5484, 43.77124),
		textCoords = vector3(464.3086, -984.5484, 43.77124),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		sound = false,
	},
	-- Bollards 1
	{
		objName = 'gabz_mrpd_bollards1',
		objYaw = 270.0,
		objCoords  = vector3(410.02580, -1024.22800, 29.21824),
		textCoords = vector3(410.02580, -1020.22800, 29.21824),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 5.0,
		sound = true,
	},
	-- Bollards 2
	{
		objName = 'gabz_mrpd_bollards2',
		objYaw = 270.0,
		objCoords  = vector3(410.0258, -1024.22, 29.2202),
		textCoords = vector3(410.0258, -1028.22, 29.2202),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 5.0,
		sound = true,
	},

    -- Paleto PD

    --Holding Cell

    {
		objName = 'v_ilev_ph_cellgate1',
		objYaw = 46.0,
		objCoords  = vector3(-444.36820, 6012.22, 28.13),
		textCoords = vector3(-444.36820, 6012.22, 28.13),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		sound = false,
		size = 2
	},

	--Evidence Door

	{
		textCoords = vector3(-435.51, 6008.64, 28.13),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		sound = false,
		doors = {
			{
				objName = 'v_ilev_ph_gendoor002',
				objYaw = 225.0,
				objCoords  = vector3(-436.51, 6007.84, 28.13)
			},

			{
				objName = 'v_ilev_ph_gendoor002',
				objYaw = 45.0,
				objCoords  = vector3(-434.67, 6009.68, 28.13)
			}
		}
	},

	--Single Door To Stairs

	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = 135.0,
		objCoords  = vector3(-447.76, 6005.19, 31.87),
		textCoords = vector3(-447.76, 6005.19, 31.87),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		sound = false,
		size = 2
	},

	--Double Door

	{
		textCoords = vector3(-441.85, 6008.20, 31.87),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		sound = false,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = 314.84,
				objCoords  = vector3(-442.65, 6009.30, 31.87)
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = 135.0,
				objCoords  = vector3(-440.81, 6007.46, 31.87)
			}
		}
	},

    -- Sandy PD

    --Front Door

    {
        objName = 'v_ilev_shrfdoor',
        objYaw = 210.0,
        objCoords  = vector3(1854.60, 3683.25, 34.60),
        textCoords = vector3(1855.70, 3683.93, 34.59),
        authorizedJobs = { 'police', 'offpolice' },
        locking = false,
        locked = true,
        pickable = false,
		distance = 2.5,
		sound = false,
        size = 2
    },

    --Holding Cell 1

    {
        objName = 'v_ilev_ph_cellgate',
        objYaw = 300.0,
        objCoords  = vector3(1862.80, 3688.45, 30.40),
        textCoords = vector3(1862.80, 3688.45, 30.40),
        authorizedJobs = { 'police', 'offpolice' },
        locking = false,
        locked = true,
        pickable = false,
        distance = 1.5,
		sound = false,
        size = 2
    },

    --Holding Cell 2

    {
        objName = 'v_ilev_ph_cellgate',
        objYaw = 300.0,
        objCoords  = vector3(1860.90, 3691.65, 30.40),
        textCoords = vector3(1860.90, 3691.65, 30.40),
        authorizedJobs = { 'police', 'offpolice' },
        locking = false,
        locked = true,
        pickable = false,
        distance = 1.5,
		sound = false,
        size = 2
    },

    --Holding Cell 3

    {
        objName = 'v_ilev_ph_cellgate',
        objYaw = 300.0,
        objCoords  = vector3(1859.0, 3694.95, 30.40),
        textCoords = vector3(1859.0, 3694.95, 30.40),
        authorizedJobs = { 'police', 'offpolice' },
        locking = false,
        locked = true,
        pickable = false,
        distance = 1.5,
		sound = false,
        size = 2
    },

	-- Park Ranger

	-- Holding Cell

	{
		objName = 'prop_pr_gate_door',
		objYaw = 0.0,
		objCoords  = vector3(381.25780, 795.55510, 187.826640),
		textCoords = vector3(381.25780, 795.55510, 187.826640),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		sound = false,
		size = 2
	},

	-- Hallway Bar Door

	{
		objName = 'prop_pr_gate_door',
		objYaw = 90.0,
		objCoords  = vector3(383.41730, 797.51140, 187.826640),
		textCoords = vector3(383.41730, 797.51140, 187.826640),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		sound = false,
		size = 2
	},

	-- Entrance 1

	{
		objName = 'prop_pr_door2',
		objYaw = 0.027,
		objCoords  = vector3(387.60950, 792.839040, 187.82640),
		textCoords = vector3(387.60950, 792.839040, 187.82640),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		sound = false,
		size = 2
	},

	-- Entrance 2

	{
		objName = 'prop_pr_door2',
		objYaw = 90.0,
		objCoords  = vector3(388.56500, 799.48120, 187.82640),
		textCoords = vector3(388.56500, 799.48120, 187.82640),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		sound = false,
		size = 2
	},

	-- Captain's Office

	{
		objName = 'prop_pr_door2',
		objYaw = 270.026,
		objCoords  = vector3(384.70810, 795.30950, 190.64070),
		textCoords = vector3(384.70810, 795.30950, 190.64070),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		sound = false,
		size = 2
	},

	-- 2nd Floor Double Doors

	{
		textCoords = vector3(379.06, 792.8, 190.44),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		sound = false,
		doors = {
			{
				objName = 'prop_pr_door',
				objYaw = 359.924,
				objCoords  = vector3(380.21750, 792.93070, 190.64310)
			},

			{
				objName = 'prop_pr_door',
				objYaw = 180.109,
				objCoords  = vector3(378.01860, 792.93070, 190.64310)
			}
		}
	},

	-- Bolingbroke Penitentiary

	-- Entrance (Two Big Gates)

	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1844.9, 2604.8, 44.6),
		textCoords = vector3(1844.9, 2608.5, 48.0),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		sound = true,
		distance = 10,
		size = 2
	},

	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1818.5, 2604.8, 44.6),
		textCoords = vector3(1818.5, 2608.4, 48.0),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		sound = true,
		distance = 10,
		size = 2
	},

	{
		objName = 'prop_gate_prison_01',
		objCoords = vector3(1799.237, 2616.303, 44.6),
		textCoords = vector3(1795.941, 2616.969, 48.0),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		sound = true,
		distance = 10,
		size = 2
	},

	-- Door To Prisoner Visitor

	{
		objName = 'sanhje_Prison_recep_door02',
		objYaw = 0.0,
		objCoords = vector3(1837.74, 2592.16, 46.03),
		textCoords = vector3(1837.74, 2592.16, 46.03),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		sound = false,
		distance = 2.5,
		size = 2
	},

	{
		objName = 'sanhje_Prison_recep_door02',
		objYaw = 90.0,
		objCoords = vector3(1831.34, 2594.992, 46.03791),
		textCoords = vector3(1831.34, 2594.992, 46.03791),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		sound = false,
		distance = 2.5,
		size = 2
	},

	{
		objName = 'prop_pris_door_03',
		objYaw = 269.980,
		objCoords = vector3(1819.073, 2594.873, 46.08695),
		textCoords = vector3(1819.073, 2594.873, 46.08695),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		sound = false,
		distance = 2.5,
		size = 2
	},

	-- Exit From Cell Block

	{
		objName = 'sanhje_Prison_block_door',
		objYaw = 210.025,
		objCoords = vector3(1758.64, 2492.66, 45.90),
		textCoords = vector3(1758.64, 2492.66, 45.90),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		sound = false,
		distance = 2.5,
		size = 2
	},

	{
		objName = 'prop_pris_door_03',
		objYaw = 209.874,
		objCoords = vector3(1754.79, 2501.58, 45.82),
		textCoords = vector3(1754.79, 2501.58, 45.82),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		sound = false,
		distance = 2.5,
		size = 2
	},

	-- Cafeteria

	{
		objName = 'prop_pris_door_03',
		objYaw = 90.0,
		objCoords = vector3(1791.596, 2551.462, 45.75320),
		textCoords = vector3(1791.596, 2551.462, 45.75320),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		sound = false,
		distance = 2.5,
		size = 2
	},

	{
		objName = 'prop_pris_door_03',
		objYaw = 269.834,
		objCoords = vector3(1776.196, 2552.563, 45.74741),
		textCoords = vector3(1776.196, 2552.563, 45.74741),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		sound = false,
		distance = 2.5,
		size = 2
	},

	-- Infirmaray

	{
		objName = 'prop_pris_door_03',
		objYaw = 0.015,
		objCoords = vector3(1765.118, 2566.524, 45.80285),
		textCoords = vector3(1765.118, 2566.524, 45.80285),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		sound = false,
		distance = 2.5,
		size = 2
	},

	{
		textCoords = vector3(1765.206, 2589.564, 45.75309),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		sound = false,
		doors = {
			{
				objName = 'sanhje_Prison_infirmary_door1',
				objYaw = 180.185,
				objCoords  = vector3(1764.026, 2589.564, 45.75309)
			},

			{
				objName = 'sanhje_Prison_infirmary_door1',
				objYaw = 359.931,
				objCoords  = vector3(1766.32, 2589.564, 45.75309)
			}
		}
	},

	-- Vespucci PD

	-- Cells

	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = vector3(-1088.38, -841.8, 13.52),
		textCoords = vector3(-1088.38, -841.8, 13.52),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		sound = false,
		size = 2
	},

	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = vector3(-1084.78, -838.93, 13.52),
		textCoords = vector3(-1084.78, -838.93, 13.52),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		sound = false,
		size = 2
	},

	{
		objName = 'v_ilev_ph_cellgate',
		objCoords = vector3(-1091.17, -844.08, 13.52),
		textCoords = vector3(-1091.17, -844.08, 13.52),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		sound = false,
		size = 2
	},

	-- City Hall

	-- Cells

	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = vector3(-515.95, -202.04, 34.25),
		textCoords = vector3(-515.95, -202.04, 34.25),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		sound = false,
		size = 2
	},

	{
		objName = 'v_ilev_ph_cellgate',
		objCoords  = vector3(-513.84, -205.66, 34.25),
		textCoords = vector3(-513.84, -205.66, 34.25),
		authorizedJobs = { 'police', 'offpolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		sound = false,
		size = 2
	},

}