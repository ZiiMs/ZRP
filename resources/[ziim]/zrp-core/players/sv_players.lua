-- Player = Players or {}
-- Players.Users = Players.Users or {}

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
  exports['zrp-core']:RegisterComponent("Player", Players)
end)

local function setupUser(user)
  function user.setRank(self, rank)
    print(Players.Users)
    Players.Users[user.source].rank = rank
  end
  function user.getRank(self)
    return Players.Users[user.source].rank
  end

  return user
end



Player = {
  Users = Users or {},
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
    return Players.Users[id] or false
  end,
  IsAdmin = function(self, id)
    return (Players.Users[id].rank == "admin")
  end,
  GetUsers = function(self)
    local tmp = {}

    for k,v in pairs(Players.Users) do
      tmp[#tmp+1] = k
    end
    
    return tmp
  end,
  CreatePlayer = function(self, src, new)
    if new then Players.Users[src] = nil end
    if Players.Users[src] then return Players.Users[src] end

    local user = {}

    user.source = src
    user.name = GetPlayerName(src)
    user.steamid = Players:GetIdent(src, "steam")
    user.license = Players:GetIdent(src, "license")

    user.ip = GetPlayerEndpoint(src)
    user.rank = "user"

    user.characters = {}
    user.character = {}

    user.charactersLoaded = false
    user.characterLoaded = false

    Players.Users = {}
    Players.Users[src] = {}
    

    print("Users?: ", #Players.Users)

    

    local goodUser = setupUser(user)

    Players .Users[src] = goodUser
    return goodUser
  end,
}