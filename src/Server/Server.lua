QBCore = exports['qb-core']:GetCoreObject()

local missionIsStared = false

local MaxCount = #(Config.SmashGlass)
local Count = 0


CurrentCops = 0

RegisterNetEvent('police:SetCopCount', function(amount) -- Eventet kan findes i qb-policejob :)
    CurrentCops = amount
  end)

  function Log(msg)
    local embeds = {
          {
              --["color"] = "8663711",
              ["title"] = "Pede-Vangelico",
              ["description"] = msg,
              --["footer"] = {
                --["text"] = "errorlog",
            --},
          }
    }
    PerformHttpRequest(Config.WebhookURL, function(err, text, headers) end, 'POST', json.encode({username = 'pede-vangelico', embeds = embeds}), { ['Content-Type'] = 'application/json' })
  end
  

  -- Taget fra qb scripts
  local function banforExploiting(identifier)
    MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)',
        {
            GetPlayerName(identifier),
            QBCore.Functions.GetIdentifier(identifier, 'license'),
            QBCore.Functions.GetIdentifier(identifier, 'discord'),
            QBCore.Functions.GetIdentifier(identifier, 'ip'),
            'Banned for: Exploiting',
            20000000000000,
            'pede-vangelico'
        })
    Log( "Player banned: " ..
    GetPlayerName(identifier) .. QBCore.Functions.GetIdentifier(identifier, 'license') .. QBCore.Functions.GetIdentifier(identifier, 'discord')
    )
    DropPlayer(identifier, 'Banned for: Exploiting')
end

-- Gør bare så at når scriptet er restartet så lukker døren igen
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    TriggerEvent("door", 1)
    print("Resource started: lavet af Ledpede1")
  end)


-- 1 er lukket og 0 er åbnet
-- Event som åbner eller lukker døren
RegisterNetEvent("door")
AddEventHandler("door", function(openorlock)
local doorName = exports.ox_doorlock:getDoorFromName('JuvelButik')
TriggerEvent('ox_doorlock:setState', doorName.id, openorlock)
end)

-- Event som tjekker om der allerede er et røveri startet inden man lockpicker
RegisterNetEvent("pede:beginLockpicking:Server")
AddEventHandler("pede:beginLockpicking:Server", function ()
    if missionIsStared == false then
        TriggerClientEvent("LockpickGame", source)
            else if missionIsStared == true then
                TriggerClientEvent("notify", source, "Juvelrøveri", "Allerede startet")     
            end
        end
    end)

-- Starter røveriet
RegisterNetEvent("MissionStart")
AddEventHandler("MissionStart", function ()
    missionIsStared = true
    TriggerClientEvent("hackingTarget", -1)
    TriggerClientEvent("checkIfPlayerLeaves", source) -- Tjekker om ham som startede røveriet er for langt væk
end)

-- Stopper røveriet
RegisterNetEvent("MissionStop")
AddEventHandler("MissionStop", function ()
    missionIsStared = false
    TriggerEvent("door", 1)
    TriggerClientEvent("robberyCancled", -1)
    TriggerClientEvent("robberyCancled:DELETEGlassTargets", -1)
    Count = 0
end)

-- Event som gør det muligt for hele serveren at smadre glasset og få items.
RegisterNetEvent("beginSmashingGlass:Server")
AddEventHandler("beginSmashingGlass:Server", function()
    TriggerClientEvent("beginSmash:Client", -1)
end)

-- Vælger random item ud fra configgen
function RandomizedItem()
    return Config.RewardItems[math.random(#Config.RewardItems)]
end

-- Giv items når man smadre glasset
RegisterNetEvent("giveItems")
AddEventHandler("giveItems", function ()
Count = Count+1

if Count < MaxCount then
if Config.isPoliceRequired == true then
    if CurrentCops >= Config.MinimumPolice then
        return
    end 
else
    local Player = QBCore.Functions.GetPlayer(source)
    local identifier = source
    Log( "Player got item: " ..
    GetPlayerName(identifier) .. QBCore.Functions.GetIdentifier(identifier, 'license') .. QBCore.Functions.GetIdentifier(identifier, 'discord')
)
    for i=1,Config.ItemsAmount do -- Gør så at man i configgen kan vælge hvor mange forskellige items skal gives til spilleren
        Player.Functions.AddItem(RandomizedItem(), math.random(Config.RandomItemMin,Config.RandomItemMax))
                end
            end
        else
            banforExploiting(source)
            Count = 0
        end
    end)

RegisterNetEvent("removeGlassTarget:Server")
AddEventHandler("removeGlassTarget:Server", function (name)
    TriggerClientEvent("removeGlassTarget:Client", -1, name) -- -1 for hele serveren
end)