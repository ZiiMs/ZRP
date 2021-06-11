function RetrieveComponents()
  Logger = exports['zrp-base']:FetchComponent('Logger')
  Players = exports['zrp-base']:FetchComponent('Players')
  Callbacks = exports['zrp-base']:FetchComponent('Callbacks')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-base']:RequestDependencies('Base', {
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
      print("i")
      local id = Players:GetIdent(player, "license")
      table.insert( idents, {id = i, license = id})
    end
    print("Register")
    return idents
  end)
end






RegisterNetEvent("sb:fetch")
AddEventHandler("sb:fetch", function()
  local src = source
  local idents = Players:GetIdentifiers(src);
  for k,v in pairs(idents) do
    Logger:Trace("scoreboard", ("Identifiers %s"):format(v))
  end
  
  TriggerClientEvent("sb:fetch", idents)
end)