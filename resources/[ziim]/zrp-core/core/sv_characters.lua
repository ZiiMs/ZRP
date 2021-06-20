function RetrieveComponents()
  Logger = exports['zrp-core']:FetchComponent('Logger')
  Database = exports['zrp-core']:FetchComponent('Database')
  Players = exports['zrp-core']:FetchComponent('Players')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-core']:RequestDependencies('Base', {
    'Logger',
    'Database',
    'Player',
  }, function(error)
    if #error > 0 then
      return
    end
    RetrieveComponents()
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	print("Working?")
  exports['zrp-core']:RegisterComponent("Core", Core)
end)

Core = {
  LoadPlayer = function(self, src, cb)
    local user = Players:CreatePlayer(src, false)

    if not user then 
      user = Players:CreatePlayer(src, false)
      if not user then print("Error cant create character") return end
    end

    Database:findOne({ collection="Players", query = { steamid = Players:GetIdent(src, "steamid") } }, function (success, result)
      if not success then
          print("[MongoDB][Example] Error in findOne: "..tostring(result))
          return
      end
      if result then
        print("[MongoDB][Example] User is already created " .. tostring(result._id))
        user:setRank(result.rank)

        callback(result)
      else
        
      end
    end)

  end,
}