local chance = 0
local skillGap = 20
local isDead = false

function openGui(sentLength,taskID,namesent,chancesent,skillGapSent)
    guiEnabled = true
    SetNuiFocus(guiEnabled,false)
    SendNUIMessage({runProgress = true, Length = sentLength, Task = taskID, name = namesent, chance = chancesent, skillGap = skillGapSent})
end
function updateGui(sentLength,taskID,namesent,chancesent,skillGapSent)
    SendNUIMessage({runUpdate = true, Length = sentLength, Task = taskID, name = namesent, chance = chancesent, skillGap = skillGapSent})
end
local activeTasks = 0
function closeGuiFail()
    guiEnabled = false
    SetNuiFocus(guiEnabled,false)
    SendNUIMessage({closeFail = true})
end
function closeGui()
    guiEnabled = false
    SetNuiFocus(guiEnabled,false)
    SendNUIMessage({closeProgress = true})
end

function closeNormalGui()
    guiEnabled = false
    SetNuiFocus(guiEnabled,false)
end
  
RegisterNUICallback('taskCancel', function(data, cb)
  closeGui()
  activeTasks = 2
  FactorFunction(false)
end)

RegisterNUICallback('taskEnd', function(data, cb)
    closeNormalGui()
    if (tonumber(data.taskResult) < (chance + 20) and tonumber(data.taskResult) > (chance))  then
        activeTasks = 3
        factor = 1.0
    else
        FactorFunction(false)
        activeTasks = 2
    end
end)

local factor = 1.0
local taskInProcess = false
local calm = true

function FactorFunction(pos)
    if not pos then
        factor = factor - 0.1
        if factor < 0.1 then
            factor = 0.1
        end
        if factor == 0.5 and calm then
            calm = false
        end
        TriggerEvent("factor:restore")        
    else
        if factor > 1.0 or factor == 0.9 then
            if not calm then
                calm = true
            end            
            factor = 1.0
            return
        end
        factor = factor + 0.1
    end    
end

RegisterNetEvent('factor:restore')
AddEventHandler('factor:restore', function()
    Wait(15000)
    FactorFunction(true)
end)

function taskBar(difficulty,skillGapSent)
    Wait(100)
    skillGap = skillGapSent
    if skillGap < 5 then
        skillGap = 5
    end
    local name = "E"
    local playerPed = PlayerPedId()
    if taskInProcess then
        return 100
    end
    FactorFunction(false)
    chance = math.random(15,90)

    local length = math.ceil(difficulty * factor)

    taskInProcess = true
    local taskIdentifier = "taskid" .. math.random(1000000)
    openGui(length,taskIdentifier,name,chance,skillGap)
    activeTasks = 1

    local maxcount = GetGameTimer() + length
    local curTime

    while activeTasks == 1 do
        Citizen.Wait(1)
        curTime = GetGameTimer()
        if curTime > maxcount then
            activeTasks = 2
        end
        local updater = 100 - (((maxcount - curTime) / length) * 100)
        updater = math.min(100, updater)
        updateGui(updater,taskIdentifier,name,chance,skillGap)
    end

    if activeTasks == 2 then
        closeGui()
        taskInProcess = false
        return 0
    else
        closeGui()
        taskInProcess = false
        return 100
    end 
   
end

RegisterNetEvent('repairbar')
AddEventHandler('repairbar', function()
    local finished = taskBar(5000,math.random(5,15))
    if finished ~= 100 then
        TriggerEvent('reload-repair:fail', true)
    else
        local finished2 = taskBar(5000,math.random(5,15))
        if finished2 ~= 100 then
            TriggerEvent('reload-repair:fail', true)
        else
            local finished3 = taskBar(5000,math.random(5,15))
            if finished3 ~= 100 then
                TriggerEvent('reload-repair:fail', true)
            else
                TriggerEvent('reload-repair:complete', true)
            end
        end
    end
end)

AddEventHandler('menu:isDead', function()
    isDead = true
end)
  
AddEventHandler('menu:notIsDead', function()
    isDead = false
end)

RegisterNetEvent('cuffbar')
AddEventHandler('cuffbar', function()
    if not isDead then
        local finished = taskBar(1000,math.random(5,15))
        if finished ~= 100 then
            TriggerEvent('reload-cuff:fail', true)
        else
            TriggerEvent('reload-cuff:complete', true)
        end
    elseif isDead then
        TriggerEvent('reload-cuff:fail', true)
    end
end)

RegisterNetEvent('cuffbar2')
AddEventHandler('cuffbar2', function()
    if not isDead then
        local finished = taskBar(1000,math.random(5,15))
        if finished ~= 100 then
            TriggerEvent('reload-cuff:fail', true)
        else
            local finished2 = taskBar(750,math.random(5,15))
            if finished ~= 100 then
                TriggerEvent('reload-cuff:fail', true)
            else
                TriggerEvent('reload-cuff:complete', true)
            end
        end
    elseif isDead then
        TriggerEvent('reload-cuff:fail', true)
    end
end)