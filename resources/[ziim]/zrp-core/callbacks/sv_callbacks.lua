local cbs = {}
local cbResp = {}
local currReqId = 0


local function RetrieveComponents()
  Logger = exports['zrp-core']:FetchComponent('Logger')
end

AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-core']:RequestDependencies('Base', {
    'Logger', 
  }, function(error)
    if #error > 0 then
      print('Error')
      return
    end
    RetrieveComponents()
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	print("Working?")
  exports['zrp-core']:RegisterComponent("Callbacks", Callbacks)
end)

RegisterServerEvent("__cb:server")
AddEventHandler("__cb:server", function(eventName, ticket, ...)
	local s = source
	local p = promise.new();
  
  TriggerEvent(('__scb:%s'):format(eventName), function(...) 
    p:resolve({...})
  end, s, ...)

  local result = Citizen.Await(p)
  TriggerClientEvent(("__cb:client:%s:%s"):format(eventName, ticket), s, table.unpack(result))
end)

Callbacks = {
  TriggerClientCallback = function(self, src, eventName, ...)
    assert(type(src) == 'number', 'Invalid Lua type at argument #1, expected number, got '..type(src))
		assert(type(eventName) == 'string', 'Invalid Lua type at argument #2, expected string, got '..type(eventName))

    local p = promise.new()

    RegisterNetEvent(('__cb:server:'):format(eventName))
    local e = AddEventHandler(('__cb:server:'):format(eventName), function(...)
      local s = source
      if src == s then
        p:resolve({...})
      end
    end)

    TriggerClientEvent('__cb:client', src, eventName, ...)

    local result = Citizen.Await(p)
    RemoveEventHandler(e)
    return table.unpack(result)
  end,
  RegisterServerCallback = function(self, eventName, fc)
    print("Event: ", eventName)
    print("Func: ", fc)
    assert(type(eventName) == 'string', 'Invalid Lua type at argument #1, expected string, got '..type(eventName))
		-- assert(type(fc) == 'function', 'Invalid Lua type at argument #2, expected function, got '..type(fc))
    
		AddEventHandler(('__scb:%s'):format(eventName), function(cb, s, ...)
			local result = {fc(s, ...)}
			cb(table.unpack(result))
		end)
  end,
}
