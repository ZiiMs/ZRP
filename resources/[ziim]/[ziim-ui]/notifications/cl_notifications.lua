function RetrieveComponents()
  Logger = exports['zrp-base']:FetchComponent('Logger')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-base']:RequestDependencies('Base', {
    'Logger'
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  -- print("TriggeringEvent?")
  exports['zrp-base']:RegisterComponent("Notifications", Notifications)
end)



RegisterCommand("testNotify", function(source, args)

  local Type = table.remove(args, 1);
  -- local Style = table.remove(args, 1);
  local Header = table.remove(args, 1);
  local duration = table.remove(args, 1);
  local Body = table.concat(args, " ");
  -- TriggerEvent("ziim:notify", Style, Type, "", Body);
  Notifications:Alert(Type, Header, Body, duration)
  -- for i,v in pairs(ZRP["Notifications"]) do print(i,v) end
end, false)

Notifications = {
  Notify = function(self, type, header, body, duration) 
    duration = duration or 5000
    SendNUIMessage({
      type = "Notify",
      payload = {type = type, text = body, style = 'notify', header = header, duration = duration},
    })
  end,
  Alert = function(self, type, header, body, duration) 
    duration = duration or 5000
    SendNUIMessage({
      type = "Notify",
      payload = {type = type, text = body, style = 'alert', header = header, duration = duration},
    })
  end
}


-- AddEventHandler("ziim:notify", function(style, type, header, body)
--   SendNUIMessage({
--     type = "Notify",
--     payload = {type = type, text = body, style = style, header = header},
--   })
-- end)