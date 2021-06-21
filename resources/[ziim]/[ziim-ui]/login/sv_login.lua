local function RetrieveComponents()
  Logger = exports['zrp-core']:FetchComponent('Logger')
  Database = exports['zrp-core']:FetchComponent('Database')
  Core = exports['zrp-core']:FetchComponent('Core')
  Callbacks = exports['zrp-core']:FetchComponent('Callbacks')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-core']:RequestDependencies('Base', {
    'Logger',
    'Database',
    'Core',
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

local function RegisterServerCallbacks()
  print("Registering")
  Callbacks:RegisterServerCallback("sb:getData", function(source)
    local idents = {}
    for i, player in ipairs(GetPlayers()) do
      print("i", player)
      local id = Player:GetIdent(player, "license")
      table.insert( idents, {id = player, license = id})
    end
    print("Register")
    return idents
  end)
end