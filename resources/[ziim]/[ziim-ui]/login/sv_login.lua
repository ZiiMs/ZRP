local function RetrieveComponents()
  Logger = exports['zrp-core']:FetchComponent('Logger')
  Database = exports['zrp-core']:FetchComponent('Database')
  Core = exports['zrp-core']:FetchComponent('Core')
  Callbacks = exports['zrp-core']:FetchComponent('Callbacks')
end

local function RegisterServerCallbacks()
  print("Registering")
  Callbacks:RegisterServerCallback("login:FetchData", function(source)
    Core:LoadPlayer(source, function(data)
      print("Working?: ", data)
      return data;
    end)
  end)
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