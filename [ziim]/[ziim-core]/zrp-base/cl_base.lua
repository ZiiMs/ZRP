RegisterNetEvent("zrp-base:waitForExports")
AddEventHandler("zrp-base:waitForExports", function()
    print("WiatForExports", ZRP.ExportsReady);
    if not ZRP.ExportsReady then return end

    while true do
        Citizen.Wait(50)
        if exports and exports["zrp-base"] then
            print("ClientRegister")
            TriggerEvent("Proxy:Shared:RegisterReady")
            return
        end
    end
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
    exports['zrp-base']:RegisterComponent("Logger", Logger)
  end)
  

Logger = {
    Error = function(self, msg, mod) 
      if not tostring(msg) then return end
      if not tostring(mod) then mod = "No Module" end
      
      local pMsg = string.format("[^1ERROR^7] [^4%s^7] %s", mod, msg)
      if not pMsg then return end
  
      print(pMsg)
    end
  }