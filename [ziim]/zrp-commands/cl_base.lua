
function RetrieveComponents()
  Notifications = exports['zrp-base']:FetchComponent('Notifications')
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