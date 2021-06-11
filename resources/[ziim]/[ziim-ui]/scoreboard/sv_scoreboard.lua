function RetrieveComponents()
  Logger = exports['zrp-base']:FetchComponent('Logger')
  Players = exports['zrp-base']:FetchComponent('Players')
  Callback = exports['zrp-base']:FetchComponent('Callback')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-base']:RequestDependencies('Base', {
    'Logger',
    'Players',
    'Callback',
  }, function(error)
    if #error > 0 then
      print("Errors", error[1])
      return
    end
    RetrieveComponents()
    RegisterServerCallbacks()
  end)
end)

function RegisterServerCallbacks()
  print("Registering")
  Callback:RegisterServerCallback("sb:getData", function(source)
    local idents = Players:GetIdentifiers(source);
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