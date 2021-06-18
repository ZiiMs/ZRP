function RetrieveComponents()
  Logger = exports['zrp-core']:FetchComponent('Logger')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-core']:RequestDependencies('Base', {
    'Logger',
    'Database',
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

RegisterCommand('tret', function(source, args)
  -- TODO: make a vehicle! fun!
end, false)
