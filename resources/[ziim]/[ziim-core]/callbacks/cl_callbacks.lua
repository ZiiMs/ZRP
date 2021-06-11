AddEventHandler("Proxy:Shared:RegisterReady", function()
	print("Working?")
  exports['zrp-base']:RegisterComponent("Callback", Callback)
end)


RegisterNetEvent('__cb:client')
AddEventHandler('__cb:client', function(eventName, ...)
	local p = promise.new()

	TriggerEvent(('__ccb:%s'):format(eventName), function(...)
		p:resolve({...})
	end, ...)

	local result = Citizen.Await(p)
	TriggerServerEvent(('__cb:server:%s'):format(eventName), table.unpack(result))
end)

Callback = {
  TriggerServerCallback = function(self, eventName, ...)
    assert(type(eventName) == 'string', 'Invalid Lua type at argument #1, expected string, got '..type(eventName))
    print("Working??1")
    local p = promise.new()
    local ticket = GetGameTimer()
    print("Working??2")
    RegisterNetEvent(("__cb:client:%s:%s"):format(eventName, ticket))
    local event = AddEventHandler(("__cb:client:%s:%s"):format(eventName, ticket), function(...)
      p:resolve({...})
      print(...)
    end)

    print("Working??3")
    TriggerServerEvent("__cb:server", eventName, ticket, ...)
    print("Working??4", Citizen.Await(p)  )
    local result = Citizen.Await(p)
    
    RemoveEventHandler(event)
    print("Working??5")
    return table.unpack(result);
  end,
  RegisterClientCallback = function(self, eventName, func)
		assert(type(eventName) == 'string', 'Invalid Lua type at argument #1, expected string, got '..type(eventName))
		assert(type(func) == 'function', 'Invalid Lua type at argument #2, expected function, got '..type(func))

    AddEventHandler(("__ccb:%s"):format(eventName), function(cb, ...)
      cb(fn(...))
    end)
  end
}