function RetrieveComponents()
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
  exports['zrp-core']:RegisterComponent("Players", Players)
end)



Players = {
  Testcb = function(self, cb)
    print(self)
    cb("Test string2")
  end,
  GetIdentifiers = function(self, player)
    local idents = {}
    for i,v in ipairs(GetPlayerIdentifiers(player)) do
      -- Logger:Trace("players", ("Identifiers: %s"):format(string.match(v, "(.-):")))
      local key = string.match(v, "(.-):")
      idents[key] = v
    end
    return(idents)
  end, 
  GetIdent = function(self, player, id)
    local ident = nil
    for i,v in ipairs(GetPlayerIdentifiers(player)) do
      -- Logger:Trace("players", ("Identifiers: %s"):format(string.match(v, "(.-):")))
      local key = string.match(v, "(.-):")
      if(key == id) then
        ident = v
        break
      end
    end
    return(ident)
  end
}