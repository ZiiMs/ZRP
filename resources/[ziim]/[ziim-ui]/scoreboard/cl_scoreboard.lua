function RetrieveComponents()
  Logger = exports['zrp-base']:FetchComponent('Logger')
  Callback = exports['zrp-base']:FetchComponent('Callback')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-base']:RequestDependencies('Base', {
    'Logger',
    'Callback'
  }, function(error)
    if #error > 0 then
      print("Errors", error[1])
      return
    end
    RetrieveComponents()
  end)
end)
local toggle = false;

Citizen.CreateThread(function () 
  while true do 
      Wait(0)
      if IsControlJustReleased(0, 303) then
          local tempPlayers = {}
          for i=1,255 do
            local license = ("license:7e5a718514a9dfd78920a66998a036b14b3a2a3%s"):format(i);
            local temp = { id = i, license = license};
            table.insert( tempPlayers, temp );
          end
          print("Get sb")
          local idents = Callback:TriggerServerCallback('sb:getData')
          for i,v in pairs(idents) do
            -- print(i,v)
            Logger:Trace("players", ("Key:%s Ident: %s"):format(i,v))
          end
      end
  end
end)


RegisterNUICallback('closeScoreboard', function(data, cb)
  toggle = false
  SetNuiFocus(toggle, toggle)
  cb(true)
end)

AddEventHandler("sb:fetch", function(data)
  toggle = not toggle
  SendNUIMessage({
    type = "scoreboardShow",
    payload = {show = toggle, players = tempPlayers},
  })
  SetNuiFocus(true, false)
end)
