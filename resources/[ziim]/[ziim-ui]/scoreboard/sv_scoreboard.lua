function RetrieveComponents()
  Logger = exports['zrp-core']:FetchComponent('Logger')
  Players = exports['zrp-core']:FetchComponent('Players')
  Callbacks = exports['zrp-core']:FetchComponent('Callbacks')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-core']:RequestDependencies('Base', {
    'Logger',
    'Players',
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

function RegisterServerCallbacks()
  print("Registering")
  Callbacks:RegisterServerCallback("sb:getData", function(source)
    local idents = {}
    for i, player in ipairs(GetPlayers()) do
      print("i", player)
      local id = Players:GetIdent(player, "license")
      table.insert( idents, {id = player, license = id})
    end
    print("Register")
    return idents
  end)
end



RegisterCommand('selftest', function(source, args)
  -- TODO: make a vehicle! fun!
  Players:Testcb(function(data)
    print(data)
  end)
end, false)