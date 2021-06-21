local value = false;

local function RetrieveComponents()
  Logger = exports['zrp-core']:FetchComponent('Logger')
  Database = exports['zrp-core']:FetchComponent('Database')
  Player = exports['zrp-core']:FetchComponent('Player')
  Core = exports['zrp-core']:FetchComponent('Core')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-core']:RequestDependencies('Base', {
    'Logger',
    'Database',
    'Player',
    'Core',
  }, function(error)
    if #error > 0 then
      print("Errors", error[1])
      return
    end
    RetrieveComponents()
    -- print("Type: ", type(RegisterServerCallbacks))
    -- RegisterServerCallbacks()
  
  end)
end)

RegisterCommand("login", function(source, args)
  SendNUIMessage({
    app = "login",
    method = "setShow",
    data = not value,
  })
  SetNuiFocus(true, true);
  value = not value
end, false)

RegisterNUICallback('FetchData', function(data, cb)
  Core:LoadPlayer(src, function(data)
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
  cb()
end)

