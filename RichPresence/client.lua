Citizen.CreateThread(function()
	while true do
        --This is the Application ID (Replace this with you own)
		SetDiscordAppId(823199736291000320)

        --Here you will have to put the image name for the "large" icon.
		SetDiscordRichPresenceAsset('wp_circle')
        
        --(11-11-2018) New Natives:

        --Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('https://discord.me/twprp, PUBLIC!')

        --Buttons
        SetDiscordRichPresenceAction(0, "Website", "https://www.thewackpackrp.com")
        SetDiscordRichPresenceAction(1, "Connect", "fivem://connect/74.91.125.117:30120")

        --It updates every one minute just in case.
		Citizen.Wait(60000)
	end
end)