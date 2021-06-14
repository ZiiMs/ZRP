local cbs = {}
local cbResp = {}
local currReqId = 0

function RetrieveComponents()
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
    local requestId = currReqId

    currReqId = currReqId + 1
    if (currReqId >= 65536) then
      currReqId = 0
    end

    local event = eventName .. tostring(requestId)

    cbResp[event] = true
    print("Name21", eventName)
    TriggerServerEvent("__scb", eventName, requestId, { ... })

    local ticket = GetGameTimer()

    while (cbResp[event] == true) do
      Citizen.Wait(0)

      if(GetGameTimer() > ticket + 5000) then
        Logger:Error("callbacks", ("ServerCallback  \\%s\\ timed out after %s ms"):format(eventName, tostring(5000)))

        cbResp[event] = "ERROR"
      end
    end

    if(cbResp[event] == "ERROR") then
      return nil
    end

    local data = cbResp[event]
    cbResp[event] = nil
    return table.unpack(data)
  end,
  RegisterClientCallback = function(self, eventName, fc)
    cbs[eventName] = fc
  end
}

RegisterNetEvent("__ccb")
AddEventHandler("__ccb", function(evetName, id, data)
	local requestName = eventName .. tostring(id)

	if (cbs[evetName] ~= nil) then
		-- execute callback function and return its result
		local result = { cbs[evetName](src, table.unpack(data)) }
		
		TriggerServerEvent("__cb:client", requestName, result)
	else
		-- callback does not exist
    Logger:Error("callbacks", ("ClientCallback  \\%s\\ does not exist"):format(eventName))
		
		TriggerServerEvent("__ccb:error", requestName, evetName)
	end
end)

RegisterNetEvent("__cb:server")
AddEventHandler("__cb:server", function(eventName, data)
  print("working1")
	if (cbResp[eventName] ~= nil) then
		-- receive data
    print("working2")
		cbResp[eventName] = data
    print("working3")
	end
end)

RegisterNetEvent("__scb:error")
AddEventHandler("__scb:error", function(eventName, name)
	if (cbResp[eventName] ~= nil) then
		cbResp[eventName] = "ERROR"
		
		Logger:Error("callbacks", ("ServerCallback  \\%s\\ does not exist"):format(eventName))
	end
end)


AddEventHandler("Proxy:Shared:RegisterReady", function()
	print("Working?")
  exports['zrp-base']:RegisterComponent("Callbacks", Callbacks)
end)