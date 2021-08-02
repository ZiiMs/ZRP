local function RetrieveComponents()
  Logger = exports['zrp-core']:FetchComponent('Logger')
  Core = exports['zrp-core']:FetchComponent('Core')
  Callbacks = exports['zrp-core']:FetchComponent('Callbacks')
end

local function RegisterServerCallbacks()
  print("RegisteringCallbacks!!")
  Callbacks:RegisterServerCallback("login:getData", function(source)
    local src = source
    local user = nil
    print("BeforeLOAD??")
    user = Core:LoadPlayer(src, function(data)
      print("Working?: ", data)
      user = data
    end)
    while (user == nil) do
      Wait(500)
      print("User is nil")
    end
    print("User: ", user)
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
    Wait(100)
    RegisterServerCallbacks()
  end)
end)