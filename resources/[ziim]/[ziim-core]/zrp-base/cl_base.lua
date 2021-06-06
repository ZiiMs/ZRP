RegisterNetEvent("zrp-base:waitForExports")
AddEventHandler("zrp-base:waitForExports", function()
    print("WiatForExports", ZRP.ExportsReady);
    if not ZRP.ExportsReady then return end

    while true do
        Citizen.Wait(50)
        if exports and exports["zrp-base"] then
            print("ClientRegister")
            Citizen.Wait(100);
            TriggerEvent("Proxy:Shared:RegisterReady")
            Citizen.Wait(500)
            TriggerEvent('Core:Shared:Ready')
            return
        end
    end
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
    exports['zrp-base']:RegisterComponent("Logger", Logger)
  end)
  

Logger = {
    Error = function(self, mod, msg) 
      if not tostring(msg) then return end
      if not tostring(mod) then mod = "No Module" end
      
      local pMsg = "[^1ERROR^7]"
      local msg2 = ("[^4%s^7] %s"):format(mod, msg)
      if not pMsg then return end
  
      print(pMsg, msg2)
    end,
    Trace = function(self, mod, msg) 
      if not tostring(msg) then return end
      if not tostring(mod) then mod = "No Module" end
      
      local pMsg = "^7[TRACE]"
      local msg2 =  ("[^4%s^7] %s"):format(mod, msg)
      if not pMsg then return end
  
      print(pMsg, msg2)
    end,
    Warn = function(self, mod, msg) 
      if not tostring(msg) then return end
      if not tostring(mod) then mod = "No Module" end
      
      local pMsg = "[^3TRACE^7]"  
      local msg2 =  ("[^4%s^7] %s"):format(mod, msg)
      if not pMsg then return end
  
      print(pMsg, msg2)
    end,

  }