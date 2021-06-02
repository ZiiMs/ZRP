ZRP = ZRP or {}

ZRP.ExportsReady = false

exports('RequestDependencies', function(resource, dependencies, cb)
  local count = 1;
  for _,depends in pairs(dependencies) do  
    for resources,_ in pairs(ZRP) do 
      print(depends, resources)
      if depends == resources then 
        count = count + 1;
      end
    end
  end
  if count ~= #dependencies then 
    cb(count-#dependencies);
  else
    cb();
  end
  
end)


exports('RegisterComponent', function(resource, Component)
  ZRP[resource] = Component;
  print("Registering Component: ", resource);
end)

exports('FetchComponent', function(resource) 
  for i,v in pairs(ZRP) do print(i,v ) end
  return ZRP[resource];
end)

function ZRP.WaitForExports(self)
  Citizen.CreateThread(function()
      while true do
        Citizen.Wait(50)
          if exports and exports["zrp-base"] then
              TriggerEvent("Proxy:Shared:RegisterReady")
              ZRP.ExportsReady = true
              Citizen.Wait(50)
              TriggerEvent('Core:Shared:Ready')
              return
          end
      end
      print("CoreReady!??")
      
  end)
end

ZRP.WaitForExports();