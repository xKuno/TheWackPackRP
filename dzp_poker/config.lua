Config = {}

-- Shared object event. Change it if you using qbus
Config.TrigEv = 'esx:getSharedObject'

-- To avoid people from dying of hunger or thirst at the table after every game their status can be reset
Config.RestoreStatus = true
Config.SetStatusEvent = 'esx_status:set'

-- Webhook for poker logs
--Config.DiscordWebhook = 'https://discord.com/api/webhooks/843686864032628757/wZ1jsWFA5vEkwOrdDppPTeeSCDqJ0825lbCCBrf2EB44p2BjjRaLS4Ktx78Se5tzUAi_'

Config.NewESX = true

-- Poker blip settings
Config.BlipCoords = vector3(928.77, 54.87, 81.1)
Config.BlipDisplay = 4
Config.BlipSprite = 267
Config.BlipColor = 49
Config.BlipScale = 0.8


-- Amount that automatically gets placed on blind call
Config.BigBlindAmount = 100

-- Amount of money player has to have in cash to sit at poker table
Config.AmountToStartPlaying = 1000

-- Time for player to make decision (in seconds)
Config.MoveTimer = 30 -- seconds

-- Disables automatic camera moving (cinematic camera) while at the table
Config.DisableCinematicCamera = true

-- Marker to sit at the poker table
Config.MarkerCoords = vector3(1142.88, 269.71, -52.84)

-- Hash keys for table and chair objects
Config.ChairHash = GetHashKey('apa_mp_h_stn_chairarm_12')
Config.TableHash = GetHashKey('ch_prop_casino_blackjack_01a')

-- Table position
Config.Table = {x = 1147.63, y =265.15, z = -52.84}
-- Config.Table = {x = 1608.24, y = 3607.0, z = 34.16}

-- Set chairs position depending on table by using offsets
Config.SetChairsByOffset = true

-- Chairs positions
Config.ChairsData = {
    {x = -1147.58, y = 266.49, z = -51.36, h = 1.0, xOffset = 0.0, yOffset = 1.3},
    {x = 1146.47, y = 265.66, z = -51.36, h = 300.69, xOffset = 1.3, yOffset = 0.6},
    {x = 1146.41, y = 264.58, z = -51.36, h = 244.01, xOffset = 1.15, yOffset = -0.60},
    {x = 1147.64, y = 263.9, z = -51.36, h = 180.3, xOffset = -0.0, yOffset = -1.3},
    {x = 1148.8, y = 264.66, z = -51.36, h = 110.86, xOffset = -1.3, yOffset = -0.6},
    {x = 1148.96, y = 265.8, z = -51.36, h = 55.68, xOffset = -1.2, yOffset = 0.6}
}

Config.Framework = 'esx' -- esx/qbus

-- Strings:
-- Language to use
Config.Language = 'en'
-- Translations
Config.Strings = {
    ['en'] = {
        ['blip_name'] = 'Poker Table',
        ['poker_title'] = 'Poker',
        ['pot_title'] = 'Pot: {1}{0}', -- {0:amount}{1:currency}
        ['player_turn_title'] = '{0}\'s Turn', -- {0:player's name}
        ['player_list_title'] = 'Player',
        ['winning_announcement'] = '{0} Won', -- {0:player's name}
        ['winning_status'] = 'Won',
        ['currency'] = '$',
        ['no_space'] = 'All seats are taken at the table',
        ['leave_table'] = 'You left Poker table',
        ['join_table'] = '~INPUT_CONTEXT~ - sit at the Poker table',
        ['not_enough_money'] = 'You must have at least 1000 chips if you want to start playing poker',
        ['wrong_amount'] = 'Invalid bet amount',
        ['too_low_bet'] = 'Bet is to small. Current bet - %d',
        ['player_status_title'] = 'Player {0}: ', -- {0:table slot}
        ['player_list_fold'] = 'Folded',
        ['default_player_status'] = ' Not at the table',
        ['check-button_title'] = 'Check',
        ['call-button_title'] = 'Call {1}{0}', -- {0:amount}{1:currency}
        ['bet-button_title'] = 'Bet',
        ['fold-button_title'] = 'Fold',
        ['exit-button_title'] = 'Exit',
    },
    ['lt'] = {
        ['blip_name'] = 'Pokerio stalas',
        ['poker_title'] = 'Pokeris',
        ['pot_title'] = 'Bendras Prizas: {0}{1}', -- {0:amount}{1:currency}
        ['player_turn_title'] = 'Žaidėjo {0} eilė', -- {0:player's name}
        ['player_list_title'] = 'Žaidėjas',
        ['winning_announcement'] = '{0} Laimėjo', -- {0:player's name}
        ['winning_status'] = 'Laimėjo',
        ['currency'] = '€',
        ['no_space'] = 'Nera laisvu vietu prie stalo',
        ['leave_table'] = 'Palikote stala',
        ['join_table'] = '~INPUT_CONTEXT~ - sesti prie pokerio stalo',
        ['not_enough_money'] = 'Norint atsisesti prie pokerio stalo reikia tureti bent %d€',
        ['wrong_amount'] = 'Netinkamai ivesta statymo suma',
        ['too_low_bet'] = 'Statymas per mazas, dabartinis statymas - %d',
        ['player_status_title'] = 'Žaidėjas {0}: ', -- {0:table slot}
        ['player_list_fold'] = 'Nusimetė Kortas',
        ['default_player_status'] = 'Ne prie stalo',
        ['check-button_title'] = 'Praleisti',
        ['call-button_title'] = 'Atsakyti {0}{1}', -- {0:amount}{1:currency}
        ['bet-button_title'] = 'Statyti',
        ['fold-button_title'] = 'Nusimesti',
        ['exit-button_title'] = 'Išeiti',
    }
}

-- Functions
-- Note: script author does not take any responsibility for issues caused by functions below

Config.GetPlayerMoney = function(playerId)
    if type(playerId) == 'number' then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer then
            return xPlayer.getInventoryItem('gambledoritochips').count
        end
    else
        -- If player id is string (debug player)
        return 10000
    end
    return 0
end

Config.AddPlayerMoney = function(playerId, moneyAmount)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer then
        local name = xPlayer.getName(source)
        exports.wp_logs:discord('**'..name..'** Won '..moneyAmount..' chips at the poker table', source, 0, '9651934', 'casino')
        xPlayer.addInventoryItem('gambledoritochips', moneyAmount)
    end
end

Config.RemovePlayerMoney = function(playerId, amount)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer then
        local name = xPlayer.getName(source)
        exports.wp_logs:discord('**'..name..'** Bet '..amount..' chips at the poker table', source, 0, '9651934', 'casino')
        xPlayer.removeInventoryItem('gambledoritochips', amount)
    end
end

Config.GetPlayerName = function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer then
        return xPlayer.getName()
    end
    return playerId
end
