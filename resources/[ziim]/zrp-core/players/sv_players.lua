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
  exports['zrp-core']:RegisterComponent("Players", Players)
end)



Players = {
  Users = {},
  Testcb = function(self, cb)
    for i,v in pairs(self) do
      print(i,v)
    end
    -- print(self)
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
  end,
  GetUser = function(self, id)
    return self.Users[id] or self.Users[id]
  end,
  GetUsers = function(self)
    local tmp = {}

    for k,v in pairs(self.Users) do
      tmp[#tmp+1] = k
    end
    
    return tmp
  end,
  CreatePlayer = function(self, src, new)
    if new then self.Users[src] = nil end
    if self.Users[src] then return self.Users[src] end

    local user = {}

    user.source = src
    user.name = GetPlayerName(src)
    user.steamid = self:GetIdent(src, "steam")
    user.license = self:GetIdent(src, "license")

    user.ip = GetPlayerEndpoint(src)
    user.rank = "user"

    user.characters = {}
    user.character = {}

    user.charactersLoaded = false
    user.characterLoaded = false

    self.Users = {}
    self.Users[src] = {}

    print("Users?: ", self.Users[src])

    

    local goodUser = setupUser(user)

    self.Users[src] = goodUser
    return goodUser
  end,
}

local function setupUser(user)
  function user.setRank(self, rank)
    print(Players.Users[user.source])
    Players.Users[user.source].rank = rank
  end
  function user.getRank(self)
    return Players.Users[user.source].rank
  end

  return user
end