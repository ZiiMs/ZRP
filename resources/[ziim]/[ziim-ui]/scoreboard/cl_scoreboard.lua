function RetrieveComponents()
  Logger = exports['zrp-core']:FetchComponent('Logger')
  Callbacks = exports['zrp-core']:FetchComponent('Callbacks')
  Utils = exports['zrp-core']:FetchComponent('Utils')
end

local toggle = false;

local distances = {}

local function Init()
  Citizen.CreateThread(function () 
    while true do 
      Wait(0)
      if IsControlJustReleased(0, Utils.Keys["U"]) then

          print("Get sb")
          local idents = Callbacks:TriggerServerCallback('sb:getData')
          -- for i=2,255 do
          --   local license = ("license:7e5a718514a9dfd78920a66998a036b14b3a2a3%s"):format(i);
          --   local temp = { id = i, license = license};
          --   table.insert( idents, temp );
          -- end
          toggle = not toggle
          SendNUIMessage({
            type = "scoreboardShow",
            payload = {show = toggle, players = idents},
          })
          SetNuiFocus(false, false)
          -- for i,v in pairs(idents) do
          --   -- print(i,v)
          --   Logger:Trace("players", ("Key234:%s Ident: %s"):format(i,v))
          -- end
      end
      if toggle then
        if IsControlJustReleased(0, Utils.Keys["ESC"]) then
          print("ESC?")
          toggle = false
          SendNUIMessage({
            type = "scoreboardShow",
            payload = {show = toggle},
          })
        end
        if IsControlJustReleased(0, Utils.Keys["LEFT"]) then
          print("Left?")
          SendNUIMessage({
            type = "scoreboardUpdate",
            payload = {move = "left"},
          })
        elseif IsControlJustReleased(0, Utils.Keys["RIGHT"]) then
          print("Right?")
          SendNUIMessage({
            type = "scoreboardUpdate",
            payload = {move = "right"},
          })
        end
      end
    end
  end)

  Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
      Citizen.Wait(0)
      if toggle then

        local playerped = PlayerPedId()
        local HeadBone = 0x796e
        local playerCoords = GetPedBoneCoords(playerped, HeadBone)

        for _, id in ipairs(GetActivePlayers()) do
          local targetPed = GetPlayerPed(id)
          if targetPed == playerped then
            Utils:DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z+0.5, GetPlayerServerId(id), 152,251,152)
          else
            
            if distances[id] then
              if distances[id] < 5 then
                local targetPedCords = GetPedBoneCoords(targetPed, HeadBone)
                local isDucking = IsPedDucking(targetPed)
                local cansee = HasEntityClearLosToEntity(playerped, targetPed, 17 )
                local isReadyToShoot = IsPedWeaponReadyToShoot(targetPed)
                local isStealth = GetPedStealthMovement(targetPed)
                local isDriveBy = IsPedDoingDriveby(targetPed)
                local isInCover = IsPedInCover(targetPed,true)

                if isStealth == nil then
                  isStealth = 0
                end

                if isDucking or isStealth == 1 or isDriveBy or isInCover then
                    cansee = false
                end
                  -- Logger:Trace("scoreboard", ("Coords: %s,%s,%s"):format(tostring(targetPedCords.x),tostring(targetPedCords.y),tostring(targetPedCords.z)))
                if cansee then
                  Utils:DrawText3D(targetPedCords.x, targetPedCords.y, targetPedCords.z+0.5, GetPlayerServerId(id), 255,255,255)
                end
              end
            end
          end
        end
      end
    end
  end)

  Citizen.CreateThread(function()
    while true do
      local playerPed = PlayerPedId()
      local playerCoords = GetEntityCoords(playerPed)
      
      for _, id in ipairs(GetActivePlayers()) do
          local targetPed = GetPlayerPed(id)
          local distance = #(playerCoords-GetEntityCoords(targetPed))
          distances[id] = distance
      end
      Citizen.Wait(1000)
    end
  end)
end

AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-core']:RequestDependencies('Base', {
    'Logger',
    'Callbacks',
    'Utils',
  }, function(error)
    if #error > 0 then
      print("Errors", error[1])
      return
    end
    RetrieveComponents()
    Init()
  end)
end)


RegisterNUICallback('closeScoreboard', function(data, cb)
  toggle = false
  SetNuiFocus(toggle, toggle)
  cb(true)
end)
