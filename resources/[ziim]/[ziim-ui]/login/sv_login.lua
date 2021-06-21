local function RetrieveComponents()
  Logger = exports['zrp-core']:FetchComponent('Logger')
  Database = exports['zrp-core']:FetchComponent('Database')
  Core = exports['zrp-core']:FetchComponent('Core')
  Callbacks = exports['zrp-core']:FetchComponent('Callbacks')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-core']:RequestDependencies('Base', {
    'Logger',
    'Database',
    'Core',
    'Callbacks',
  }, function(error)
    if #error > 0 then
      print("Errors", error[1])
      return
    end
    RetrieveComponents()
    print("Type: ", type(RegisterServerCallbacks))
    RegisterServerCallbacks()
    
  end)
end)

local function RegisterServerCallbacks()
  print("Registering")
  Callbacks:RegisterServerCallback("sb:getData", function(source)
    Core:LoadPlayer(source, function(data)
      if not data then 
        SendNUIMessage({
          app = "login",
          method = "FetchDataError",
          data = "Error fetching data!",
        })
      else
        SendNUIMessage({
          app = "login",
          method = "FetchDataSuccess",
          data = false,
        })
        SetNuiFocus(true, true);
        value = false
      end
    end)
  end)
end