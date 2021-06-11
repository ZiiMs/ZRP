AddEventHandler("Proxy:Shared:RegisterReady", function()
	print("Working?")
  exports['zrp-base']:RegisterComponent("Callback", Callback)
end)


RegisterNetEvent('__cb:server')
AddEventHandler('__cb:server', function(eventName, ticket, ...)
  local src = source
	local p = promise.new()

	TriggerEvent(('__scb:%s'):format(eventName), function(...)
		p:resolve({...})
	end, s, ...)

	local result = Citizen.Await(p)
	TriggerServerEvent(('__cb:client:%s:%s'):format(eventName, ticket), s, table.unpack(result))
end)

Callback = {
  TriggerClientCallback = function(self, src, eventName, ...)
		assert(type(src) == 'number', 'Invalid Lua type at argument #1, expected number, got '..type(src))
		assert(type(eventName) == 'string', 'Invalid Lua type at argument #2, expected string, got '..type(eventName))

    local p = promise.new()

    RegisterNetEvent(("__cb:server:%s"):format(eventName))
    local event = AddEventHandler(("__cb:server:%s"):format(eventName), function(...)
      local s = source
      if src == s then
        p:resolve({...})
      end
    end)

    TriggerServerEvent("__cb:client", src, eventName, ...)

    local result = Citizen.Await(p)
    RemoveEventHandler(event)
    return table.unpack(result);
  end,
  RegisterServerCallback = function(self, eventName, func)
		assert(type(eventName) == 'string', 'Invalid Lua type at argument #1, expected string, got '..type(eventName))
		assert(type(func) == 'function', 'Invalid Lua type at argument #2, expected function, got '..type(func))

    AddEventHandler(("__scb:%s"):format(eventName), function(cb, s, ...)
      local result = {func(s, ...)}
      cb(table.unpack(result))
    end)
  end
}