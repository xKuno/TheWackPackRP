Config = {}
Config.Maximumboundary = 2000.0

Config.AuthorizedJobShare = {
    ['police'] = true
}

Config.RestrictUsage = false -- Set to true. if you want only certain jobs to use the tracker.
Config.AuthorizedJobsToUseTracker = {'police'}

Config.TargetBlipInformations = {
    Sprite = 459,
    Color = 2,
    Scale = 1.4,
    Display = 2
}

Config.RemoveItemsUponUsage = {Tracker = true, BoltCutter = false}
Config.ItemNames = {TrackerName = 'ankletracker', BoltCutter = 'gruppe6wirecutter'}

Config.Animations = {
    TrackerSetupAnimation = {
        anim = 'base',
        animDict = 'amb@medic@standing@tendtodead@base'
    },
    BoltCuttingAnimation = {
        anim = 'base',
        animDict = 'amb@medic@standing@tendtodead@base'
    }
}
Config.InstallTimes = {
    Tracker = 5, -- How Many seconds will take to install the tracker
    BoltCutter = 7 -- how many seconds will take to deattach the tracker
}

Config.RemoveUponRemoval = true -- inform the Player if the target tracker has been removed.

Config.EnableCustomBraceletOnSkin = true -- Set to true if you are using Ankle Bracelet Streaming file.

Config.InformIfTargetLeavedServer = false -- Inform the Player if the target that has tracker bracelet left the server.

Config.ESXEvent = 'esx:getSharedObject'

