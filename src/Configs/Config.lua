Config = {}

Config.WebhookURL = "https://discord.com/api/webhooks/1162017300522729614/K_iXJyAJkJjRQdQKShA9x6ZBSuDRMnrXMx2wWodgaNSDn1FAN-0VnICyp5aJOScLm3fK"

Config.CancelDistance = 50 -- Hvor langt væk at spilleren skal gå før at røveriet bliver afsluttet

Config.LockPickItem = "lockpick"

Config.HackingItem = "trojan_usb"
Config.HackingTime = 5000
Config.HackingAmountColors = 2

Config.isPoliceRequired = false -- Er politi required? Ikke testet igennem endu
Config.MinimumPolice = 1 -- Hvor mange betjente der skal være inde for at starte røveriet

Config.OXDoorName = "JuvelButik" -- standard: "JuvelButik"

Config.RewardItems = {
    "diamond_ring",
    "rolex",
    "goldbar"
}

Config.ItemsAmount = 2 -- Hvor mange forskellige items skal der gives til spilleren.a
Config.RandomItemMin = 2 -- Minimum af hvor mange items man kan få
Config.RandomItemMax = 6 -- Maximum af hvor mange items man kan

Config.SmashGlass = { 
[1] = {
    name = "FirstGLASSSMASH", -- Skal hedde noget unikt!
    x = -622.9241, y = -233.2133, z = 38.057
},
[2] = {
    name = "SecondGLASSSMASH",
    x = -624.6163, y = -231.0933, z = 38.057 -- { -624.6163, -231.0933, 38.057 }
},
[3] = {
    name = "ThirdGLASSSMASH",
    x = -620.2109, y = -233.431, z = 38.0571 -- { -620.2109, -233.431, 38.0571 }
}

--[[
# Example

[4] = { -- ID det skal sættes til noget unikt!
    name = "Name", -- Navn skal være unikt.
    x = -620.2109, y = -233.431, z = 38.0571 -- Koordinater til glasset
}
  ]]--

}

Config.startLockpicCoordinates = {x = -629.2777, y = -230.7365, z = 38.057} -- Coords til target til at starte lockpicking af døren.
Config.disableSecurity = { x = -631.2907, y = -230.1635, z = 38.0571 } -- Coords til target til at hacke systemet.

Config.Debug = true -- # true = debug oommands | false = ingen debug commands #

Config.ProgressbarText = "Looting"

-- Sprog:Targets --
Config.targetIcon = "fa-regular fa-gem"

Config.startTargetLabel = "Start Røveri!"
Config.hackingTargetLabel = "Begynd hacking!"

Config.smashGlassTarget = "Ødelæg lortet!"

Config.robberyCancled = "Røveri afsluttet!"

-- Sprog:Notifikationer --
Config.notifyTitle = "Juvelrøveri"
Config.notifyIcon = "gem"

Config.hackingMinigameSuccess = "Sådan! Gå ud og røv hele lortet!"
Config.startingRobbery = "Starter røveri"

Config.notEnoughPoliceLabel = "Ikke nok politi på arbejde!"

Config.needLockpick = "Du skal bruge en lockpick!"

Config.needHackingItem = "Du skal bruge en " .. Config.HackingItem .. " for at kunne hacke dette!"





