function RetrieveComponents()
  Logger = exports['zrp-base']:FetchComponent('Logger')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-base']:RequestDependencies('Base', {
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
  exports['zrp-base']:RegisterComponent("Players", Players)
end)

Players = {
  Testcb = function(self, cb)
    cb("Test string2")
  end,
  GetIdentifiers = function(self, player)
    local idents = {}
    for i,v in ipairs(GetPlayerIdentifiers(player)) do
      -- Logger:Trace("players", ("Identifiers: %s"):format(string.match(v, "(.-):")))
      local key = string.match(v, "(.-):")
      idents[key] = v
    end
    for i,v in pairs(idents) do
      -- print(i,v)
      Logger:Trace("players", ("Key:%s Ident: %s"):format(i,v))
    end
    return(idents)
  end
}