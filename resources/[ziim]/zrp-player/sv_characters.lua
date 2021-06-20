-- function RetrieveComponents()
--   Logger = exports['zrp-core']:FetchComponent('Logger')
--   Database = exports['zrp-core']:FetchComponent('Database')
--   Players = exports['zrp-core']:FetchComponent('Players')
--   -- Core = exports['zrp-core']:FetchComponent('Core')
-- end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-core']:RequestDependencies('Base', {
    'Logger',
    'Database',
    'Players',
    -- 'Core',
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

-- AddEventHandler("Proxy:Shared:RegisterReady", function()
--   print("Tewtwqerwer")
--   exports['zrp-core']:RegisterComponent("Core", Core)
-- end)

-- Core = {
--   LoadPlayer = function(self, src, cb)
--     local user = Players:CreatePlayer(src, false)

--     if not user then 
--       user = Players:CreatePlayer(src, false)
--       if not user then print("Error cant create character") return end
--     end
--     Logger:Trace("characters", Database)

--     Database:findOne({ collection="Players", query = { steamid = Players:GetIdent(src, "steamid") } }, function (success, result)
--       if not success then
--           print("[MongoDB][Example] Error in findOne: "..tostring(result))
--           return
--       end
--       if result then
--         print("[MongoDB][Example] User is already created " .. tostring(result._id))
--         user:setRank(result.rank)

--         callback(result)
--       else
--         Database:insertOne({ collection="Players", document = { 
--           name = user.name, 
--           rank = user.rank ,
--           steamid = user.steamid,
--           license = user.license,
--           ip = user.ip,
--         }}, function (success, result, insertedIds)
--           if not success then
--             print("[MongoDB][Example] Error in insertOne: "..tostring(result))
--             return
--           end
--           print("[MongoDB][Example] User created. New ID: "..tostring(insertedIds[1]))
--         end)
--         callback(result)
--       end
--     end)
--   end,
-- }