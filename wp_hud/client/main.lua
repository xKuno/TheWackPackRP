local hunger = 0
local thirst = 0
local stress = 0
local voiceRadius = 50
local istalking = false

local voiceToggled = false
local UIHidden = false
local UIRadar = false

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/hidehud', 'Toggle the hud and map off.')
    TriggerEvent('chat:addSuggestion', '/showhud', 'Toggle the hud and map on.')
end)

--Cricle Radar
Citizen.CreateThread(
    function()
        RequestStreamedTextureDict("circlemap", false)
        while not HasStreamedTextureDictLoaded("circlemap") do
            Wait(100)
        end

        AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

        SetMinimapClipType(1)
        SetMinimapComponentPosition("minimap", "L", "B", 0.025, -0.03, 0.153, Config.MapZoom)
        SetMinimapComponentPosition("minimap_mask", "L", "B", 0.135, 0.12, 0.093, 0.164)
        SetMinimapComponentPosition("minimap_blur", "L", "B", 0.012, 0.022, 0.256, 0.337)

        local minimap = RequestScaleformMovie("minimap")

        SetRadarBigmapEnabled(true, false)
        Citizen.Wait(100)
        SetRadarBigmapEnabled(false, false)

        Citizen.Wait(1000)

        SendNUIMessage(
            {
                type = "Init",
                healthIcon = Config.HealthIcon,
                armorIcon = Config.ArmorIcon,
                foodIcon = Config.FoodIcon,
                thirstIcon = Config.ThirstIcon,
                fourthIcon = Config.FourthIcon,
                showvoice = Config.DisplayVoice
            }
        )

        while true do
            Wait(0)
            BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
            ScaleformMovieMethodAddParamInt(3)
            EndScaleformMovieMethod()

            if Config.DisplayVoice then
              local netTalk = NetworkIsPlayerTalking(PlayerId()) or talking
                
                if netTalk  ~= voiceToggled then
              
                SendNUIMessage(
                    {
                        type = "toggleTalking",
                        talking = netTalk
                    }
                )
                voiceToggled = netTalk
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(Config.StatusUpdateInterval)

            GetStatus(
                function(result)
                    hunger = result[1]
                    thirst = result[2]
                end
            )
        end
    end
)

Citizen.CreateThread(
    function()
        while true do

            Citizen.Wait(Config.VitalsUpdateInterval)
            
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped)
            local health = GetEntityHealth(ped) - 100
            local armor = GetPedArmour(ped)
            local pauseMenu = IsPauseMenuActive()

            SendNUIMessage(
                {
                    type = "changeStatus",
                    health = health,
                    armor = armor,
                    food = hunger,
                    thirst = thirst,
                    voice = voiceRadius
                }
            )

           if pauseMenu and not UIHidden then
                 SendNUIMessage(
                        {
                            type = "hideUI"
                        }
                    )
                 UIHidden = true
            elseif UIHidden and not pauseMenu then
                 SendNUIMessage(
                        {
                            type = "showUI"
                        }
                    )
                UIHidden = false
            end

            RegisterCommand('hidehud',function()
                DisplayRadar(false)
                SendNUIMessage(
                    {
                        type = "closeMapUI"
                    }
                )
                SendNUIMessage({
                    type = "hideUI"
                })
                UIRadar = true
            end)
            
            RegisterCommand('showhud',function()
                if vehicle ~= 0 then
                    DisplayRadar(true)
                    SendNUIMessage(
                        {
                            type = "openMapUI"
                        }
                    )
                end
                SendNUIMessage({
                    type = "showUI"
                })
                UIRadar = false
            end)

            
        end
    end
)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1000)
		local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped)
		if vehicle ~= 0 and not UIRadar or exports.gcphone:IsPhoneOpen() and not UIRadar then 
			DisplayRadar(true)
            SendNUIMessage(
                {
                    type = "openMapUI"
                }
            )
		else
			SendNUIMessage(
                {
                    type = "closeMapUI"
                }
            )
			DisplayRadar(false)
		end 
    end
end)

--EXPORTS

exports(
    "setTalking",
    function(talking)
        istalking = talking
    end
)

exports(
    "setVoiceRange",
    function(percent)
        voiceRadius = percent
    end
)
