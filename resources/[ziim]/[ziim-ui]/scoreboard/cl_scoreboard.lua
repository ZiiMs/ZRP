function RetrieveComponents()
  Logger = exports['zrp-base']:FetchComponent('Logger')
  Callbacks = exports['zrp-base']:FetchComponent('Callbacks')
  Utils = exports['zrp-base']:FetchComponent('Utils')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-base']:RequestDependencies('Base', {
    'Logger',
    'Callbacks',
    'Utils',
  }, function(error)
    if #error > 0 then
      print("Errors", error[1])
      return
    end
    RetrieveComponents()
  end)
end)
local toggle = false;

local distances = {}

Citizen.CreateThread(function () 
  while true do 
    Wait(0)
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
  Citizen.Wait(500)
  while true do
    for _, id in ipairs(GetActivePlayers()) do
      local targetPed = GetPlayerPed(id)
      if targetPed ~= PlayerPedId() then
          if distances[id] then
              if distances[id] < 5 then
                  local targetPedCords = GetEntityCoords(targetPed)
                  if NetworkIsPlayerTalking(id) then
                      DrawText3D(targetPedCords, GetPlayerServerId(id), 247,124,24)
                      DrawMarker(27, targetPedCords.x, targetPedCords.y, targetPedCords.z-0.97, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 173, 216, 230, 100, 0, 0, 0, 0)
                  else
                      DrawText3D(targetPedCords, GetPlayerServerId(id), 255,255,255)
                  end
              end
          end
      end
    end
    Citizen.Wait(0)
  end
end)

Citizen.CreateThread(function()
  while true do
      local playerPed = PlayerPedId()
      local playerCoords = GetEntityCoords(playerPed)
      
      for _, id in ipairs(GetActivePlayers()) do
          local targetPed = GetPlayerPed(id)
          if targetPed ~= playerPed then
              local distance = #(playerCoords-GetEntityCoords(targetPed))
              distances[id] = distance
          end
      end
      Wait(1000)
  end
end)


RegisterNUICallback('closeScoreboard', function(data, cb)
  toggle = false
  SetNuiFocus(toggle, toggle)
  cb(true)
end)

AddEventHandler("sb:fetch", function(data)

end)
