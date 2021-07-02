local value = false;

local function RetrieveComponents()
  Logger = exports['zrp-core']:FetchComponent('Logger')
  Callbacks = exports['zrp-core']:FetchComponent('Callbacks')
end

RegisterCommand("login", function(source, args)
  SendNUIMessage({
    app = "login",
    method = "setShow",
    data = not value,
  })
  SetNuiFocus(true, true);
  value = not value
end, false)


local function Init()
  RegisterNUICallback('FetchData', function(data, cb)
    print("Before CB:!:!")
    local data = Callbacks:TriggerServerCallbackTimeout("login:getData", 25000)
    print("Data?: ", data)
    if data then 
      SendNUIMessage({
        app = "login",
        method = "FetchDataSuccess",
        data = false,
      })
      SetNuiFocus(false, false);
      value = false
    else
      SendNUIMessage({
        app = "login",
        method = "FetchDataError",
        data = "Error fetching data!",
      })
    end
    cb(true)
  end)
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
    Init()
    -- print("Type: ", type(RegisterServerCallbacks))
    -- RegisterServerCallbacks()
  
  end)
end)

