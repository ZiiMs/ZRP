function RetrieveComponents()
  Logger = exports['zrp-base']:FetchComponent('Logger')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-base']:RequestDependencies('Base', {
    'Logger'
  }, function(error)
    if error > 0 then
      return
    end
    RetrieveComponents()
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  -- print("TriggeringEvent?")
  exports['zrp-base']:RegisterComponent("Textbox", Textbox)
end)



RegisterCommand("testBox", function(source, args)
  Textbox:TextBox(type, header, body)
  -- for i,v in pairs(ZRP["Notifications"]) do print(i,v) end
end, false)

Textbox = {
  toggle = false;
  TextBox = function(self, type, header, body) 
    self.toggle = not self.toggle
    SendNUIMessage({
      type = "Textbox",
      payload = {show = self.toggle},
    })
    SetNuiFocus(self.toggle, self.toggle)
    print("toggle:", self.toggle)
    -- Logger:Error("textbox", "toggle: %s"):format(self.toggle)
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