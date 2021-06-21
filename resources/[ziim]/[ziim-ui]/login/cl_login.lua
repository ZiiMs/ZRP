local value = false;

local function RetrieveComponents()
  Logger = exports['zrp-core']:FetchComponent('Logger')
  Callbacks = exports['zrp-core']:FetchComponent('Callbacks')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-core']:RequestDependencies('Base', {
    'Logger',
    'Callbacks',
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
  local data = Callbacks:TriggerServerCallback("login:FetchData")
  if data then 
    SendNUIMessage({
      app = "login",
      method = "FetchDataSuccess",
      data = false,
    })
    SetNuiFocus(true, true);
    value = false
  else
    SendNUIMessage({
      app = "login",
      method = "FetchDataError",
      data = "Error fetching data!",
    })
  end
  cb()
end)

