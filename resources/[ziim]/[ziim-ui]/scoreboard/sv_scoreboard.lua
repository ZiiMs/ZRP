local function RetrieveComponents()
  Logger = exports['zrp-core']:FetchComponent('Logger')
  Player = exports['zrp-core']:FetchComponent('Player')
  Callbacks = exports['zrp-core']:FetchComponent('Callbacks')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-core']:RequestDependencies('Base', {
    'Logger',
    'Player',
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
      local id = Player:GetIdent(player, "license")
      table.insert( idents, {id = player, license = id})
    end
    print("Return Idents")
    return idents
  end)
end



RegisterCommand('selftest', function(source, args)
  -- TODO: make a vehicle! fun!
  Player:Testcb(function(data)
    print(data)
  end)
end, false)