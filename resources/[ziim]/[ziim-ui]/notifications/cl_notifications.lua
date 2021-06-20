local function RetrieveComponents()
  Logger = exports['zrp-core']:FetchComponent('Logger')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-core']:RequestDependencies('Base', {
    'Logger'
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['zrp-core']:RegisterComponent("Notifications", Notifications)
end)



RegisterCommand("testNotify", function(source, args)

  local Type = table.remove(args, 1);
  -- local Style = table.remove(args, 1);
  local Header = table.remove(args, 1);
  local duration = table.remove(args, 1);
  local Body = table.concat(args, " ");
  Notifications:Alert(Type, Header, Body, duration)
end, false)

Notifications = {
  Notify = function(self, type, header, body, duration) 
    duration = duration or 7500
    SendNUIMessage({
      type = "Notify",
      payload = {type = type, text = body, style = 'notify', header = header, duration = duration},
    })
  end,
  Alert = function(self, type, header, body, duration) 
    duration = duration or 7500
    SendNUIMessage({
      type = "Notify",
      payload = {type = type, text = body, style = 'alert', header = header, duration = duration},
    })
  end,
  Testcb = function(self, info, cb)
    print(info)
    cb("Test string2")
  end,
  Testreturn = function(self)
    return("This is a test string?")
  end
}