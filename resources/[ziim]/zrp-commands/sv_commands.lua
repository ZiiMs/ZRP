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
  Database:insertOne({ collection="users", document = { username = username, password = "123" } }, function (success, result, insertedIds)
    if not success then
      print("[MongoDB][Example] Error in insertOne: "..tostring(result))
      return
    end
    print("[MongoDB][Example] User created. New ID: "..tostring(insertedIds[1]))
  end)
end, false)
