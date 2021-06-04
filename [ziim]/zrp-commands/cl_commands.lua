
function RetrieveComponents()
  Notifications = exports['zrp-base']:FetchComponent('Notifications')
  Textbox = exports['zrp-base']:FetchComponent('Textbox')
  Logger = exports['zrp-base']:FetchComponent('Logger')
  print('Retrieving', Notifications)
end

AddEventHandler("Core:Shared:Ready", function()
  print("core shared")
  exports['zrp-base']:RequestDependencies('Base', {
    'Logger', 
    'Notifications'
  }, function(error)
    if error == 0 then
      print('Error')
      return
    end
    RetrieveComponents()
  end)
end)

RegisterCommand("gotols", function(source, args)
  local self = PlayerPedId();
  SetPedCoordsKeepVehicle(self, 192.662, -941.161, 30.692)
  FreezeEntityPosition(self, true);
  Notifications:Alert("success", "RequestsWork>?", "If you can read this, our object OOP style lua is working!!!")
  Notifications:Notify("info", "Is this Working", "I hope this works!!")
  Logger:Error("test", "Is this working?")
  Citizen.Wait(1500);
  FreezeEntityPosition(self, false);
end, false)

local toggle = false;

RegisterCommand('car', function(source, args)
  Textbox:TextBox("Spawn Car", "Enter a vehicle", "spawnCarBox", GetCurrentResourceName())
end, false)

RegisterNUICallback('spawnCarBox', function(data, cb)
  -- POST data gets parsed as JSON automatically
  print("Working?")
  local vehicleName = data.input
  if vehicleName == nil or vehicleName == '' then
    cb({ state = true, msg = "Error: Invalid submission."})
    return
  end
  print("Working23423?")
  if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
      cb({ state = true, msg = "Error: Invalid vehicle " .. vehicleName})
      return
  end
  print("Worki2345345ng?")
  Textbox:Close();

  RequestModel(vehicleName)

  while not HasModelLoaded(vehicleName) do
      Wait(500) 
  end

  local playerPed = PlayerPedId()
  local pos = GetEntityCoords(playerPed)

  local vehicle = CreateVehicle(vehicleName, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)
  SetPedIntoVehicle(playerPed, vehicle, -1)
  SetEntityAsNoLongerNeeded(vehicle)
  SetModelAsNoLongerNeeded(vehicleName)

  Notifications:Alert("success", "Vehicle Spawned", ("Just spawned a %s"):format(vehicleName))
  cb({ state = false })
end)