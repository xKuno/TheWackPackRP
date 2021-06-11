Config = {}
Config = setmetatable(Config, {})


local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Config.CloseButton = Keys["BACKSPACE"]



-----------------------------------------------------------------
-- STEAM IDENTIFIERS -- STEAM IDENTIFIERS -- STEAM IDENTIFIERS --
-----------------------------------------------------------------
-- Bottom down is a identifer for a badge photo. Example;
-- ["steam:11000013c48d088"] = "donald.png" // ["steam:identifier"] 
--
Config.SteamIdentifiers = {
	["license:f5fd70460cb19e88ade477d2eee625b34b9f0547"] = "rangerlynx.png",
	["license:34af619486a8ff338fdbf12ea25466c66ea39b75"] = "rangerbrooks.png",
	["license:f4d6764318622bd6c4d129deb1c4ad3485bb6efb"] = "rangerwinters.png",
	["license:892bf7c09fdf311b551e7053320fbc972052b234"] = "rangermoul.png",
	["license:80c9a6541f280d5cb557ce0b04dca383028a15b4"] = "tprbartaldoe.png",
	["license:f7b7c585f53c11c6f0f56cbb00b2bd054b99bc77"] = "tprjonkrug.png",
	["license:6212dfabdc2c0d88f8f8257bc484b76b0e38427f"] = "tprlucaspower.png",
	["license:89353e8f1bf1600261c2cd8c277c17ef01e29e54"] = "ofcjaxstorm.png",
    ["license:5aefa189664caa82c2f37c284adc86e56c33e2c2"] = "justicepreach.png",
    ["license:aab11731b9bdc633ef39d372269e91cccb7047c3"] = "judgebackwood.png",
	["license:5c63f66213ccb2b3677b946d4faee2cbf20dec7a"] = "daadrakegraham.png",
	["license:086372195d651879c4479be266c48755cdc0f534"] = "damasonking.png",
	["license:585aa7a5131fae31a4aae9aebff5b84a45845748"] = "daharrygordon.png",
	["license:2536b232d88d6c4c2e8430b83bc0e388af618832"] = "adamirandawrights.png",
	["license:a0295bd013ef921f8d45a09419c75365e7f5ebc7"] = "judgebaken.png"
}

Config.BodCard = {
}

Config.Distance = 4.0 --How many meters to show to the people around when players use their badges