function RetrieveComponents()
  print("Fetching textbox")
  Logger = exports['zrp-base']:FetchComponent('Logger')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-base']:RequestDependencies('Base', {
    'Logger'
  }, function(error)
    if error == 0 then
      print("Errors", error)
      return
    end
    print("No Error: Retrieving");
    RetrieveComponents()
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  -- print("TriggeringEvent?")
  print("Registering")
  exports['zrp-base']:RegisterComponent("Textbox", Textbox)
end)



RegisterCommand("testBox", function(source, args)
  local title = table.remove(args, 1);
  local placeholder = table.concat(args, " ");
  Textbox:TextBox(title, placeholder)
  -- for i,v in pairs(ZRP["Notifications"]) do print(i,v) end
end, false)

Textbox = {
  toggle = false;
  TextBox = function(self, title, placeholder) 
    self.toggle = not self.toggle
    SendNUIMessage({
      type = "Textbox",
      payload = {show = self.toggle, title = title, placeholder = placeholder},
    })
    SetNuiFocus(self.toggle, self.toggle)
    print("toggle:", self.toggle)
    Logger:Trace("textbox", ("toggle: %s"):format(self.toggle))
  end
}

RegisterNUICallback('closeBox', function(data, cb)
  -- POST data gets parsed as JSON automatically
  -- print(data.input);
  Textbox.toggle = false
  SetNuiFocus(Textbox.toggle, Textbox.toggle)
  -- SetNuiFocus('false', 'false');
  -- and so does callback response data
  cb({ state = false })
end)

RegisterNUICallback('submitBox', function(data, cb)
  -- POST data gets parsed as JSON automatically
  print(data.input)
  if data.input == nil then
    cb({ state = true, msg = "Invalid submission."})
    return
  end
  if data.input ~= "Alex" then 
    cb({ state = true, msg = "Error: Does not equal 'Alex'"})
    return
  end
  print(data.input)
  Textbox.toggle = false
  SetNuiFocus(Textbox.toggle, Textbox.toggle)
  -- SetNuiFocus('false', 'false');
  -- and so does callback response data
  cb({ state = false })
end)


-- AddEventHandler("ziim:notify", function(style, type, header, body)
--   SendNUIMessage({
--     type = "Notify",
--     payload = {type = type, text = body, style = style, header = header},
--   })
-- end)