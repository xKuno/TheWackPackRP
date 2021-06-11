local uiOpen = false
local callback = {}


function CloseUI()
    SetNuiFocus(false, false)
    uiOpen = false
    SendNUIMessage({
        action = 'closeui'
    })
end

function openNumpad(code,length,cb)
    callback = cb
    SetNuiFocus(true, true)
    uiOpen = true
    SendNUIMessage({
        action = 'openui',
        code = tostring(code),
        length = length
    })
end

RegisterNUICallback('SubmitCode', function(data)
    callback(data)
    CloseUI()
end)

RegisterNUICallback('CloseUI', function()
    CloseUI()
end)


AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    CloseUI()
end)
  
  