dopeplant = {}

dopeplant.Version = '1.0.12'

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)
Citizen.CreateThread(function(...)
  while not ESX do
    Citizen.Wait(0)
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)
  end
end)

dopeplant.Objects = {
  [1] = "bkr_prop_weed_01_small_01c",
  [2] = "bkr_prop_weed_01_small_01b",
  [3] = "bkr_prop_weed_01_small_01a",
  [4] = "bkr_prop_weed_med_01a",
  [5] = "bkr_prop_weed_med_01b",
  [6] = "bkr_prop_weed_lrg_01a",
  [7] = "bkr_prop_weed_lrg_01b",
}

dopeplant.WeedPerBag    = 2
dopeplant.ActionTimer   = 10
dopeplant.InteractDist  = 1.5
dopeplant.DrawDist      = 2.5
dopeplant.SpawnDist     = 50.0
dopeplant.PoliceJob     = "police"

dopeplant.NeedNutrientsAt   = 10.0
dopeplant.QualityDegradeAt  = 10.0

dopeplant.GrowthModifier    = 8.00 -- rate of gain every StatUpdateTimer
dopeplant.QualityModifier   = 8.00 -- rate of quality gain
dopeplant.WaterModifier     = dopeplant.GrowthModifier*2.00 -- rate of drain
dopeplant.FertModifier      = dopeplant.GrowthModifier*2.00 -- rate of drain

dopeplant.SaveSqlTimer      = 2.0 -- minute(s)
dopeplant.StatUpdateTimer   = 900.0 -- seconds