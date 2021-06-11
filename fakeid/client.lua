ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local open = false

-- Open ID card
RegisterNetEvent('fakeid:open')
AddEventHandler('fakeid:open', function( data, type )
	open = true
	SendNUIMessage({
		action = "open",
		array  = data,
		type   = type
	})
end)

RegisterNetEvent('create:fake:id')
AddEventHandler('create:fake:id', function()

	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'fakeid_first_name', {
		title = "Enter First Name"
	},
	function(data, menu)
	local firstname = data.value
	menu.close()

		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'fakeid_last_name', {
			title = "Enter Last Name"
		},
		function(data2, menu2)
		local lastname = data2.value
		menu2.close()

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'fakeid_dob', {
				title = "Enter DOB"
			},
			function(data3, menu3)
			local dob = data3.value
			menu3.close()

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'fakeid_gender', {
					title = "Enter Gender (M or F)"
				},
				function(data4, menu4)
				local gender = string.lower(data4.value)
				menu4.close()

					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'fakeid_height', {
						title = "Enter Height (140 > 200)"
					},
					function(data5, menu5)
					local height = tonumber(data5.value)
					menu5.close()

					if firstname ~= nil and lastname ~= nil and dob ~= nil and gender == "m" and height ~= nil or firstname ~= nil and lastname ~= nil and dob ~= nil and gender == "f" and height ~= nil then
						TriggerServerEvent('create:fake:id:server', firstname, lastname, dob, gender, height)
					else
						TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 500, text = 'You did not fill in the details correctly.'})
						ESX.UI.Menu.CloseAll()
					end

					end, function(data, menu)
						menu.close()
					end)

				end, function(data2, menu2)
					menu2.close()
				end)

			end, function(data3, menu3)
				menu3.close()
			end)

		end, function(data4, menu4)
			menu4.close()
		end)

	end, function(data5, menu5)
		menu5.close()
	end)

end)

-- Key events
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then
			SendNUIMessage({
				action = "close"
			})
			open = false
		end
	end
end)
