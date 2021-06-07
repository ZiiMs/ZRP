function RetrieveComponents()
  Logger = exports['zrp-base']:FetchComponent('Logger')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-base']:RequestDependencies('Base', {
    'Logger',
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
          local players = {}
          for i=1,255 do
            local license = ("license:7e5a718514a9dfd78920a66998a036b14b3a2a3%s"):format(i);
            local temp = { id = i, license = license};
            table.insert( players, temp );
          end
              toggle = not toggle
              SendNUIMessage({
                type = "scoreboardShow",
                payload = {show = toggle, players = players},
              })
              SetNuiFocus(true, false)
      end
  end
end)

RegisterNUICallback('closeScoreboard', function(data, cb)
  toggle = false
  SetNuiFocus(toggle, toggle)
  cb({ state = false })
end)

-- AddEventHandler("Proxy:Shared:RegisterReady", function()
--   -- print("TriggeringEvent?")
--   print("Registering")
--   exports['zrp-base']:RegisterComponent("Textbox", Textbox)
-- end)



-- RegisterCommand("testBox", function(source, args)
--   local title = table.remove(args, 1);
--   local placeholder = table.remove(args, 1);
--   local event = table.remove(args, 1);
--   Textbox:TextBox(title, placeholder, event)
--   -- for i,v in pairs(ZRP["Notifications"]) do print(i,v) end
-- end, false)

-- Textbox = {
--   toggle = false;
--   TextBox = function(self, title, placeholder, event, resource, autocomplete)
--     autocomplete = autocomplete or {}
--     self.toggle = not self.toggle
--     SendNUIMessage({
--       type = "Textbox",
--       payload = {show = self.toggle, title = title, placeholder = placeholder, event = event, resource = resource, autocomplete = autocomplete},
--     })
--     SetNuiFocus(self.toggle, self.toggle)
--     print("toggle:", self.toggle)
--     Logger:Trace("textbox", ("toggle: %s"):format(self.toggle))
--   end,
--   Close = function(self)
--     self.toggle = false
--     SetNuiFocus(self.toggle, self.toggle)
--     SendNUIMessage({
--       type = "Textbox",
--       payload = {show = self.toggle},
--     })
--   end
-- }

--303