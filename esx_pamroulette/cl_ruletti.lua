ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local persex = 951.8
local persey = 76.91
local persez = 114.64
local arvonta = false
local arvontavalmis = false
local tulos = 0
local sattumaluku = 0
local fakelaskuri = 0


Citizen.CreateThread(function()

	while true do
		Citizen.Wait(5)
		local coords = GetEntityCoords(PlayerPedId())
		if(GetDistanceBetweenCoords(coords, persex, persey, persez, true) < 10) then
			if(GetDistanceBetweenCoords(coords, persex, persey, persez, true) < 3) then
				if not lahella then
					TriggerServerEvent('esx_ruletti:lahella')
					lahella = true
				end
				if not arvonta then
					if not liitytty then
						ESX.ShowHelpNotification('Enter your bet in chips for Roulette. ~INPUT_CONTEXT~ ')
					else
						ESX.ShowHelpNotification('You have entered the round, you can add additional bets using ~INPUT_CONTEXT~')
					end
				end
					if IsControlJustPressed(0, 38) then
						maxLength = 5
						AddTextEntry('FMMC_KEY_TIP8', "Bet")
						DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", maxLength)
						ESX.ShowNotification("Enter your bet.")
						blockinput = true

						while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
							Citizen.Wait( 0 )
						end

						local osallistumismaksu = GetOnscreenKeyboardResult()

						osallistumismaksu = tonumber(osallistumismaksu)
						Citizen.Wait(150)

						blockinput = false

						if osallistumismaksu ~= nil and osallistumismaksu > 0 then
							maxLength = 2
							AddTextEntry('FMMC_KEY_TIP8', "Make your selection")
							DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", maxLength)
							ESX.ShowNotification("Choose your color. R, B, G or Number 0-36")
							blockinput = true

							while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
								Citizen.Wait( 0 )
							end

							local vari = GetOnscreenKeyboardResult()

							Citizen.Wait(150)
							blockinput = false
							if vari == 'R' or vari == 'B' or vari == 'G' then
								TriggerServerEvent('esx_ruletti:osallistuminen', osallistumismaksu, vari)
								liitytty = true
							else
								vari = tonumber(vari)
								if vari ~= nil and vari >= 0 and vari < 37 then
									TriggerServerEvent('esx_ruletti:osallistuminen', osallistumismaksu, vari)
									liitytty = true
								else
									ESX.ShowNotification('Invalid Colour or Number')
								end
							end
						else
							ESX.ShowNotification('Please specify a valid bet')
						end
					end
					if arvonta then
						if fakelaskuri > 16 then
							sattumaluku = math.random(0,36)
							fakelaskuri = 0
							if not arvontavalmis then
								PlaySound(-1, "CANCEL", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
							end
						end
						if arvontavalmis then
							sattumaluku = tulos
						end
						fakelaskuri = fakelaskuri + 1
						if sattumaluku == 0 then
							text = 'Roulette: ~g~'..sattumaluku
						elseif sattumaluku > 18 then
							text = 'Roulette: ~m~'..sattumaluku
						else
							text = 'Roulette: ~r~'..sattumaluku
						end
					else
						text = 'Roulette: ~g~Place your bet.'
					end
					DrawText3Ds(persex, persey, persez, text)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

RegisterNetEvent('esx:ruletti:tulos')
AddEventHandler('esx:ruletti:tulos', function(servuntulos)
	tulos = servuntulos
	arvonta = true
	Citizen.Wait(10000)
	arvontavalmis = true
	Citizen.Wait(5000)
	liitytty = false
	arvonta = false
	arvontavalmis = false
	lahella = false
end)

RegisterNetEvent('esx:ruletti:epaonnistui')
AddEventHandler('esx:ruletti:epaonnistui', function()
	liitytty = false
end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.5, 0.5)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
	SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 250
    DrawRect(_x,_y+0.018, 0.015+ factor, 0.03, 41, 11, 41, 68)
end