local function RetrieveComponents()
  Logger = exports['zrp-core']:FetchComponent('Logger')
  Core = exports['zrp-core']:FetchComponent('Core')
  Callbacks = exports['zrp-core']:FetchComponent('Callbacks')
end

local function RegisterServerCallbacks()
  print("RegisteringCallbacks!!")
  Callbacks:RegisterServerCallback("login:FetchData", function(source)
    local src = source
    local user = nil
    Core:LoadPlayer(src, function(data)
      print("Working?: ", data)
      user = data
    end)
    return user
  end)
end

AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-core']:RequestDependencies('Base', {
    'Logger',
    'Core',
    'Callbacks',
  }, function(error)
    if #error > 0 then
      print("Errors", error[1])
      return
    end
    RetrieveComponents()
    RegisterServerCallbacks()
  end)
end)