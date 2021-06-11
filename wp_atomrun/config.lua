Config = {}

-- Oxy runs.
Config.StartPawnPayment = 1000 -- How much you pay at the start to start the run

Config.RunAmount = math.random(10,12) -- How many drop offs the player does before it automatixally stops.

Config.Payment = 1500 -- How much you get paid when RN Jesus doesnt give you oxy, divided by 2 for when it does.
Config.PaymentRoll = 5000

Config.Item = "cashstack" -- The item you receive from the oxy run. Should be oxy right??
Config.CashStackChance = 1000 -- Percentage chance of getting oxy on the run. Multiplied by 100. 10% = 100, 20% = 200, 50% = 500, etc. Default 55%.
Config.CashAmmount = 1 -- How much oxy you get when RN Jesus gives you oxy. Default: 1.
Config.AtomAmount = 1


Config.BigRewarditemChance = 2000 -- Percentage of getting rare item on oxy run. Multiplied by 100. 0.1% = 1, 1% = 10, 20% = 200, 50% = 500, etc. Default 0.1%.
Config.BigRewarditem = "bagofdope" -- Put a rare item here which will have 0.1% chance of being given on the run.