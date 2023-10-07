--[[

TODO: 
- Måske lav alle targets i en seperat lua fil.

]]--
QBCore = exports['qb-core']:GetCoreObject()


local CurrentCops = 0


-- Bliver triggeret når spilleren har startet røveriet
-- Og tjekker så om spilleren er gået væk.
RegisterNetEvent('checkIfPlayerLeaves', function()
  Citizen.CreateThread(function ()
    while true do
      Citizen.Wait(500)
      local player = GetPlayerPed(-1)
      local playerCoords = GetEntityCoords(player)

      if GetDistanceBetweenCoords(Config.startLockpicCoordinates.x, Config.startLockpicCoordinates.y, Config.startLockpicCoordinates.z, playerCoords.x, playerCoords.y, playerCoords.z, true) > Config.CancelDistance then
        TriggerServerEvent("MissionStop")
        TriggerEvent("notify", Config.notifyTitle, Config.robberyCancled)    
        break
      end
    end
  end)
end)

-- Start/Lockpick target
exports["qb-target"]:AddBoxZone("beginLockpickingPJ", vector3(Config.startLockpicCoordinates.x, Config.startLockpicCoordinates.y, Config.startLockpicCoordinates.z), 1, 1, {
  name = "beginHackingPJ",
  heading = 32,
  debugPoly = false,
  minZ = Config.startLockpicCoordinates.z - 1,
  maxZ = Config.startLockpicCoordinates.z + 1,
}, {
  options = {
      {  
          event = "pede:beginLockpicking:Client",
          icon = Config.targetIcon, 
          label = Config.startTargetLabel,
      },
  },
  distance = 2.0
})

-- Hacking minigame
RegisterNetEvent("beginHackingMinigame")
AddEventHandler("beginHackingMinigame", function (name)  
  local hasHackingItem = QBCore.Functions.HasItem(Config.HackingItem)
  if hasHackingItem then
  local success = exports['howdy-hackminigame']:Begin(Config.HackingAmountColors, Config.HackingTime)

  if success == true then 
    TriggerServerEvent("beginSmashingGlass:Server")
    TriggerEvent("notifys", Config.notifyTitle, Config.hackingMinigameSuccess)
    exports['qb-target']:RemoveZone(name)
    end
  else
    TriggerEvent("notifys", Config.notifyTitle, Config.needHackingItem)
  end
end)

-- Hacking target
RegisterNetEvent("hackingTarget")
AddEventHandler("hackingTarget", function()
  HackSecurityTarget = exports["qb-target"]:AddBoxZone("beginHackingPJ", vector3(Config.disableSecurity.x, Config.disableSecurity.y, Config.disableSecurity.z), 1, 1, {
    name = "beginHackingPJ",
    heading = 32,
    debugPoly = false,
    minZ = Config.disableSecurity.z - 1,
    maxZ = Config.disableSecurity.z + 1,
}, {
    options = {
        {  
          action = function()
            TriggerEvent("beginHackingMinigame", "beginHackingPJ")
          end,
            icon = Config.targetIcon,
            label = Config.hackingTargetLabel,
        },
    },
    distance = 2.0
})
end)

RegisterNetEvent('police:SetCopCount', function(amount) -- Eventet kan findes i qb-policejob :)
  CurrentCops = amount
end)

-- Lockpick minigame
RegisterNetEvent("LockpickGame")
AddEventHandler("LockpickGame", function ()
  local hasLockpick = QBCore.Functions.HasItem(Config.LockPickItem)
  if Config.isPoliceRequired then
      if CurrentCops <= Config.MinimumPolice then
        TriggerEvent("notifys", Config.notifyTitle, Config.notEnoughPoliceLabel)
      else
      if hasLockpick then 
      local time = math.random(7,10) 
      local circles = math.random(2,4) 
      local success = exports['qb-lock']:StartLockPickCircle(circles, time, success)
        if success then 
          TriggerServerEvent("door", 0)
          TriggerServerEvent("MissionStart")
          TriggerEvent("notifys", Config.notifyTitle, Config.startingRobbery)
          exports['ps-dispatch']:VangelicoRobbery(31) -- Tbh så aner jeg ikke hvad 31 er det skulle være noget Camera ID men til hvad aner jeg ikke :)
            else if success == false then
                TriggerServerEvent("door", 1)
          end
        end
      else
        TriggerEvent("notifys", Config.notifyTitle, Config.needLockpick)
      end
    end

    else if Config.isPoliceRequired == false then
      if hasLockpick then
      local time = math.random(7,10) 
      local circles = math.random(2,4) 
      local success = exports['qb-lock']:StartLockPickCircle(circles, time, success)

        if success then 
          TriggerServerEvent("door", 0)
          TriggerServerEvent("MissionStart")
          TriggerEvent("notifys", Config.notifyTitle, Config.startingRobbery)
          exports['ps-dispatch']:VangelicoRobbery(31) -- Tbh så aner jeg ikke hvad 31 er det skulle være noget Camera ID men til hvad aner jeg ikke :)
            else if success == false then
                TriggerServerEvent("door", 1)
          end
        end
        else
          TriggerEvent("notifys", Config.notifyTitle, Config.needLockpick)
        end
      end 
    end
end)




-- Targets for at smadre glas og få items
RegisterNetEvent("beginSmash:Client")
AddEventHandler("beginSmash:Client", function ()
for k, v in pairs(Config.SmashGlass) do
    GlassTargets = exports["qb-target"]:AddBoxZone(v.name.."Pede", vector3(v.x, v.y, v.z), 1, 1, {
        name = v.name.."Pede",
        heading = 32,
        debugPoly = false,
        minZ = v.z - 1,
        maxZ = v.z + 1,
    }, {
        options = {
            {  
                action = function()
                  
                  TriggerEvent("targetUsed", v.x, v.y, v.z, v.name.."Pede")
                end,
                icon = Config.targetIcon, 
                label = Config.smashGlassTarget,
            },
        },
        distance = 2.0
    })
  end


RegisterNetEvent("targetUsed")
AddEventHandler("targetUsed", function (x, y, z, name)
    TriggerServerEvent("removeGlassTarget:Server", name)
    TriggerEvent("beginTask", x, y, z)
      Citizen.Wait(2100)
    TriggerServerEvent("giveItems")
end)

RegisterNetEvent("removeGlassTarget:Client")
AddEventHandler("removeGlassTarget:Client", function(name)
  exports['qb-target']:RemoveZone(name)
end)

-- Fjerner alle targets når spilleren går for langt væk
RegisterNetEvent("robberyCancled:DELETEGlassTargets")
AddEventHandler("robberyCancled:DELETEGlassTargets", function()
  for k, v in ipairs(Config.SmashGlass) do
    exports['qb-target']:RemoveZone(v.name.."Pede")
  end
end)

end)
-- Event som fjerner HackSecurityTarget
RegisterNetEvent("robberyCancled")
AddEventHandler("robberyCancled", function()
  exports['qb-target']:RemoveZone("beginHackingPJ")
end)

-- Gør så at røveriet er synced med serveren så hvis en starter det så kan resten af serveren også være med
RegisterNetEvent("pede:beginLockpicking:Client")
AddEventHandler("pede:beginLockpicking:Client", function ()
  TriggerServerEvent("pede:beginLockpicking:Server")
end)


-- Event til at få spilleren til at bruge emoten
RegisterNetEvent("beginTask")
AddEventHandler("beginTask", function(posX, posY, posZ)
  local playerPed = GetPlayerPed(-1)
      Citizen.Wait(550)
      if not HasAnimDictLoaded("missheist_jewel") then
        RequestAnimDict("missheist_jewel") 
      end
      while not HasAnimDictLoaded("missheist_jewel") do 
      Citizen.Wait(0)
      end
      PlaySoundFromCoord(-1, "Glass_Smash", posX, posY, posZ, "", 0, 0, 0)
      TaskPlayAnim(playerPed, 'missheist_jewel', 'smash_case', 8.0, 3.0, -1, 2, 0, 0, 0, 0)
      Citizen.Wait(6000)
      ClearPedTasksImmediately(playerPed)  
end)



-- Notifys
RegisterNetEvent("notifys")
AddEventHandler("notifys", function (message, title)
      lib.notify({
        id = 'Juvelroeveri',
        title = message, 
        description = title,
        position = 'top-right',
        style = {
            backgroundColor = '#141517',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
        },
        icon = Config.notifyIcon,
        iconColor = '#6F8FAF'
    })
end)


-- Debug commands
if Config.Debug == true then
RegisterCommand("opendoor", function(source, args, rawCommand)
  TriggerServerEvent("door", 0)
  TriggerEvent("beginSmash:Client")
end, false)

RegisterCommand("resetrobbery", function(source, args, rawCommand)
  TriggerServerEvent("door", 1)
  TriggerServerEvent("MissionStop")
end, false)
end










  

