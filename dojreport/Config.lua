-- The key that opens to register a report.
key_report = 46

-- the npc coordinates
npc_coords = {
    vector3(-551.75,-191.23,38.22),
    -- vector3(440.1102, -983.692, 30.68959)
}

-- rotation of npc
npc_heading = {
    210.0,
    -- 0.0
}
-- Distance between player and npc to Show Notify
distance_to_show_notify_npc = 3.5
-- Model NPC
model_npc = 'a_f_m_bevhills_02'

-- Waiting time to perform a new registration. 
time_wait_new = 60*5 -- 5 minutes






-- The key that the police officer uses on the computer to view all police reports.
key_police = 46
-- the computer coordinates
computer_coords = {
    vector3(-568.74,-194.07,38.22)
}
-- Distance between player and computer to Show Notify
distance_to_show_notify_computer = 1.5

jobs = {
    "judge",
    "district",
    "mayor",
}

-- Change letters according to your preference
-- d = days
-- m = month
-- y = year
date_format = "%d/%m/%y"

WEBHOOK = {
    DISCORD_URL = "",
    DISCORD_TITLE = "New DOJ Report:",
    COLOR = 3066993,

    SIMBOL_IMG = 'https://i.imgur.com/d2mGURH.jpg',
    HEIGHT_SIMBOL = '10',
    WIDTH_SIMBOL = '10',

    -- Put Footer with a name you want and your server image.
    DISCORD_IMAGE       = "https://dunb17ur4ymx4.cloudfront.net/webstore/logos/2fbe8cb923d1f82c29f6b4ef71b9dbe1c917af7b.png",
    DISCORD_FOOTER      = "Legendary Team",
    DISCORD_FOOTER_IMG  = "https://dunb17ur4ymx4.cloudfront.net/webstore/logos/2fbe8cb923d1f82c29f6b4ef71b9dbe1c917af7b.png",
}

translate = {
    TR_NAME = "Name:",
    TR_PHONE = "Phone number:",
    TR_REPORT = "Report:",
    TR_ANONYMOUS = "Anonymous?",
    TR_TOREPORT = "Submit Report",
    TR_POLICEREPORT = "DOJ Report:",
    TR_REPORTS = "Reports:",
    TR_DESCRIPTION = "Description:",
    TR_BACK = "Back",

    TR_NOTIFY_REPORT = "Successful report!",
    TR_NEW_REPORT = "New registered DOJ report!",
    TR_PROXIMITY_NPC = "Press E to make a DOJ report.",
    TR_PROXIMITY_COMPUTER = "Press E to view all DOJ reports.",
    TR_WAIT = "You need to wait to make a new DOJ report."
}

