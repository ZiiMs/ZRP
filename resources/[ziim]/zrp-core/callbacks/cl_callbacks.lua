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


RegisterNetEvent('__cb:client')
AddEventHandler('__cb:client', function(eventName, ...)
	local p = promise.new()

	TriggerEvent(('__ccb:%s'):format(eventName), function(...)
		p:resolve({...})
	end, ...)

	local result = Citizen.Await(p)
	TriggerServerEvent(('__cb:server:%s'):format(eventName), table.unpack(result))
end)

Callbacks = {
  TriggerServerCallback = function(self, eventName, ...)
    assert(type(eventName) == 'string', 'Invalid Lua type at argument #1, expected string, got '..type(eventName))
    local p = promise.new()
		local ticket = GetGameTimer()
    Logger:Trace("callbacks", "Is this working?")

    RegisterNetEvent(('__cb:client:%s:%s'):format(eventName, ticket))
		local e = AddEventHandler(('__cb:client:%s:%s'):format(eventName, ticket), function(...)
			p:resolve({...})
		end)
    Logger:Trace("callbacks", "Get here?")

    TriggerServerEvent('__cb:server', eventName, ticket, ...)

    Logger:Trace("callbacks", ("TERtewwer: "))
    for k,v in pairs(p) do
      print(k,v)
    end
    local result = Citizen.Await(p)
    Logger:Trace("callbacks", "Await!?!?")
		RemoveEventHandler(e)
		return table.unpack(result)

  end,
  RegisterClientCallback = function(self, eventName, fc)
    assert(type(eventName) == 'string', 'Invalid Lua type at argument #1, expected string, got '..type(eventName))
		assert(type(fc) == 'function', 'Invalid Lua type at argument #2, expected function, got '..type(fn))
		AddEventHandler(('__ccb:%s'):format(eventName), function(cb, ...)
			cb(fc(...))
		end)
  end
}


AddEventHandler("Proxy:Shared:RegisterReady", function()
	print("Working?")
  exports['zrp-core']:RegisterComponent("Callbacks", Callbacks)
end)