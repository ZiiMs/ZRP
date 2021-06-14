ZRP = ZRP or {}

ZRP.ExportsReady = false

exports('RequestDependencies', function(resource, dependencies, cb)
  local errors = {}
  for _,depends in pairs(dependencies) do  
    local count = 1;
    for resources,_ in pairs(ZRP) do 
      if depends == resources then
        count = count + 1;
      end
    end
    if count == 1 then 
      table.insert(errors, depends)
    end
  end
    cb(errors);
end)

exports('RegisterComponent', function(resource, Component)
  ZRP[resource] = Component;
  print("Registering Component: ", resource);
  -- for i,v in pairs(ZRP) do print(i) end
end)

exports('FetchComponent', function(resource) 
  
  -- print("Fetch: ", resource);
  return ZRP[resource];
end)

RegisterNetEvent("Proxy:Shared:RegisterReady")
RegisterNetEvent("Core:Shared:Ready")
function ZRP.WaitForExports(self)
  Citizen.CreateThread(function()
      while true do
        Citizen.Wait(50)
          if exports and exports["zrp-core"] then
              print("Triggering Event!")
              TriggerEvent("Proxy:Shared:RegisterReady")
              ZRP.ExportsReady = true
              Citizen.Wait(500)
              TriggerEvent('Core:Shared:Ready')
              return
          end
      end
      print("CoreReady!??")
      
  end)
end

ZRP.WaitForExports();

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['zrp-core']:RegisterComponent("Logger", Logger)
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