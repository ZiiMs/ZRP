function RetrieveComponents()
  Logger = exports['zrp-core']:FetchComponent('Logger')
  Database = exports['zrp-core']:FetchComponent('Database')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-core']:RequestDependencies('Base', {
    'Logger',
    'Database',
  }, function(error)
    if #error > 0 then
      print("Errors", error[1])
      return
    end
    RetrieveComponents()
    -- print("Type: ", type(RegisterServerCallbacks))
    -- RegisterServerCallbacks()
  
  end)
end)

RegisterCommand('tret', function(source, args)
  -- TODO: make a vehicle! fun!
  Database:count({collection="Players"}, function(success, result)
    if not success then
      print("[MongoDB][Example] Error in count: "..tostring(result))
      return
    end
    print("[MongoDB][Example] Current users count: "..tostring(result))
  end)

  local params = {
    collection = "Players",
    query = {},
    limit = 5,
    options = {
        -- Include username and exclude _id field
        projection = {username = 1, _id = 0}
    }
  }
  Database:find(params, function (success, result)
    if not success then
        return
    end
  
    print("\n** 5 users")
    for i, document in ipairs(result) do
        for k, v in pairs(document) do
            print("* "..tostring(k).." = \""..tostring(v).."\"")
        end
    end
  end)
end, false)

RegisterCommand('tet', function(source, args)
  -- TODO: make a vehicle! fun!
  Database:insert({ collection="Players", documents = {{ username = "Test", password = "123" }, { username = "Tes2t", password = "123243" } }}, function (success, result)
    if not success then
      print("[MongoDB][Example] Error in insertOne: "..tostring(result))
      return
    end
    print("[MongoDB][Example] Inserted "..tostring(result).." new users")
  end)
end, false)




