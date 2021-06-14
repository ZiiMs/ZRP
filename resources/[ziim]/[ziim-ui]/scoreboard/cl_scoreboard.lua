function RetrieveComponents()
  Logger = exports['zrp-core']:FetchComponent('Logger')
  Callbacks = exports['zrp-core']:FetchComponent('Callbacks')
  Utils = exports['zrp-core']:FetchComponent('Utils')
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
local toggle = false;

local distances = {}

local function Init()
  Citizen.CreateThread(function () 
    while true do 
      Wait(0)
      print(Utils.Keys["ESC"])
      if IsControlJustReleased(0, 303) then

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
        if IsControlJustReleased(0, 174) then
          print("Left?")
          SendNUIMessage({
            type = "scoreboardUpdate",
            payload = {move = "left"},
          })
        elseif IsControlJustReleased(0, 175) then
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
        for _, id in ipairs(GetActivePlayers()) do
          local targetPed = GetPlayerPed(id)
            if distances[id] then
                if distances[id] < 5 then
                    local targetPedCords = GetEntityCoords(targetPed)
                    -- Logger:Trace("scoreboard", ("Coords: %s,%s,%s"):format(tostring(targetPedCords.x),tostring(targetPedCords.y),tostring(targetPedCords.z)))
                    if NetworkIsPlayerTalking(id) then
                        
                        Utils:DrawText3D(targetPedCords.x, targetPedCords.y, targetPedCords.z, GetPlayerServerId(id), 247,124,24)
                        DrawMarker(27, targetPedCords.x, targetPedCords.y, targetPedCords.z-0.97, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 173, 216, 230, 100, 0, 0, 0, 0)
                    else
                        Utils:DrawText3D(targetPedCords.x, targetPedCords.y, targetPedCords.z, GetPlayerServerId(id), 255,255,255)
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


RegisterNUICallback('closeScoreboard', function(data, cb)
  toggle = false
  SetNuiFocus(toggle, toggle)
  cb(true)
end)

AddEventHandler("sb:fetch", function(data)

end)
