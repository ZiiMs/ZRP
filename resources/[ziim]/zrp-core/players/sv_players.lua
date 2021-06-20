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

local function setupUser(user)
  function user.getVar(self, var)
    return Player.Users[user.source][var]
  end
  function user.setVar(self, var, data)
    Player.Users[user.source][var] = data
  end
  function user.setRank(self, rank)
    print(Player.Users)
    Player.Users[user.source].rank = rank
    self:sendVar("rank", rank)
  end
  function user.getRank(self)
    return Player.Users[user.source].rank
  end
  function user.sendVar(self, var, data)
    self:setVar(var, data)
    TriggerClientEvent("zrp-core:getPlayerVars", Player.Users[user.source]:getVar("source"), var, data)
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
      -- Logger:Trace("Player", ("Identifiers: %s"):format(string.match(v, "(.-):")))
      local key = string.match(v, "(.-):")
      idents[key] = v
    end
    return(idents)
  end, 
  GetIdent = function(self, player, id)
    local ident = nil
    for i,v in ipairs(GetPlayerIdentifiers(player)) do
      -- Logger:Trace("Player", ("Identifiers: %s"):format(string.match(v, "(.-):")))
      local key = string.match(v, "(.-):")
      if(key == id) then
        ident = v
        break
      end
    end
    return(ident)
  end,
  GetUser = function(self, id)
    return Player.Users[id] or false
  end,
  IsAdmin = function(self, id)
    return (Player.Users[id].rank == "admin")
  end,
  GetUsers = function(self)
    local tmp = {}

    for k,v in pairs(Player.Users) do
      tmp[#tmp+1] = k
    end
    
    return tmp
  end,
  CreatePlayer = function(self, src, new)
    if new then Player.Users[src] = nil end
    if Player.Users[src] then return Player.Users[src] end

    local user = {}

    user.source = src
    user.name = GetPlayerName(src)
    user.steamid = Player:GetIdent(src, "steam")
    user.license = Player:GetIdent(src, "license")

    user.ip = GetPlayerEndpoint(src)
    user.rank = "user"

    user.characters = {}
    user.character = {}

    user.charactersLoaded = false
    user.characterLoaded = false

    Player.Users = {}
    Player.Users[src] = {}
    

    print("Users?: ", #Player.Users)

    

    local goodUser = setupUser(user)

    Player .Users[src] = goodUser
    return goodUser
  end,
}