RegisterNetEvent('__zrp:peds:rogue')
AddEventHandler('__zrp:peds:rogue', function(toDelete)
  if toDelete == nil then return end

  TriggerClientEvent("__zrp:peds:delete",-1, toDelete)
end)