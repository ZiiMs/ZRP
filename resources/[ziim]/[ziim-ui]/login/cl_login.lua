local value = false;

local function RetrieveComponents()
  Logger = exports['zrp-core']:FetchComponent('Logger')
  Callbacks = exports['zrp-core']:FetchComponent('Callbacks')
end

RegisterCommand("login", function(source, args)
  loginScreen()
end, false)

local function loginScreen()
  SendNUIMessage({
    app = "login",
    method = "setShow",
    data = true,
  })
  SetNuiFocus(true, true);
  value = true
  Citizen.CreateThread(function()
    while value do
      Citizen.Wait(0)
      HideHudAndRadarThisFrame();
      DisableAllControlActions(0);
    end
  end)
    
end


local function Init()
  RegisterNUICallback('FetchData', function(data, cb)
    print("Before CB:!:!")
    local data = Callbacks:TriggerServerCallback("login:getData")
    print("Data?: ", data)
    if data then 
      TriggerEvent("zrp-base:InitSpawn")
      SendNUIMessage({
        app = "login",
        method = "FetchDataSuccess",
        data = false,
      })
      SetNuiFocus(false, false);
      value = false
      EnableAllControlActions(0)
      
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

RegisterNetEvent("zrp-base:spawnInitialized")
AddEventHandler("zrp-base:spawnInitialized", function()
  print("Init, Loading screen")
  loginScreen()
end)


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

