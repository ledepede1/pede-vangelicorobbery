QBCore = exports['qb-core']:GetCoreObject()

local missionIsStared = false

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
    local Player = QBCore.Functions.GetPlayer(source)
    for i=1,Config.ItemsAmount do -- Gør så at man i configgen kan vælge hvor mange forskellige items skal gives til spilleren
        Player.Functions.AddItem(RandomizedItem(), math.random(Config.RandomItemMin,Config.RandomItemMax))
    end
end)

RegisterNetEvent("removeGlassTarget:Server")
AddEventHandler("removeGlassTarget:Server", function (name)
    TriggerClientEvent("removeGlassTarget:Client", -1, name) -- -1 for hele serveren
end)






