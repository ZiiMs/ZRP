local function RetrieveComponents()
  Logger = exports['zrp-core']:FetchComponent('Logger')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-core']:RequestDependencies('Base', {
    'Logger'
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	print("Working?")
  exports['zrp-core']:RegisterComponent("Player", Player)
end)

RegisterNetEvent('zrp-core:getPlayerVars')
AddEventHandler('zrp-core:getPlayerVars', function(var, val)

end)

Player = {
  LocalPlayer = LocalPlayer or {},
}

