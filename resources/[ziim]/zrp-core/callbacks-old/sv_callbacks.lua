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

RegisterServerEvent("__scb")
AddEventHandler("__scb", function(eventName, id, data)
  print("ZiiMBo is amazing!?!?")
	local src = source
  print("Name", eventName)
  print("Id", id)
	local requestName = eventName .. tostring(id)
  
	if (cbs[eventName] ~= nil) then
		-- execute callback function and return its result
		local result = { cbs[eventName](src, table.unpack(data)) }
		TriggerClientEvent("__cb:server", src, requestName, result)
	else
		-- callback does not exist
    Logger:Error("callbacks", ("ServerCallback \\%s\\ does not exist"):format(eventName))
		TriggerClientEvent("__scb:error", src, requestName, eventName)
	end
end)

RegisterServerEvent("__cb:client")
AddEventHandler("__cb:client", function(eventName, data)
	if (cbResp[eventName] ~= nil) then
		-- receive data
		cbResp[eventName] = data
	end
end)

RegisterServerEvent("__ccb:error")
AddEventHandler("__ccb:error", function(eventName, name)
	if (cbResp[eventName] ~= nil) then
		cbResp[eventName] = "ERROR"
		
		Logger:Error("callbacks", ("ClientCallback \\%s\\ does not exist"):format(eventName))
	end
end)

Callbacks = {
  TriggerClientCallback = function(self, src, eventName, ...)
    local time = 5000
    local requestId = currReqId

    currReqId = currReqId + 1
    if (currReqId >= 65536) then
      currReqId = 0
    end

    local event = eventName .. tostring(requestId)

    cbResp[event] = true

    TriggerClientEvent("__ccb", src, eventName, requestId, { ... })

    local ticket = GetGameTimer()

    while (cbResp[event] == true) do
      Citizen.Wait(0)

      if(GetGameTimer() > ticket + time) then
        Logger:Error("callbacks", ("ClientCallBack \\%s\\ timed out after %s ms"):format(eventName, tostring(time)))

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
  TriggerClientCallbackTimeout = function(self, src, eventName, Timeout, ...)
    Timeout = Timeout or 5000
    local requestId = currReqId

    currReqId = currReqId + 1
    if (currReqId >= 65536) then
      currReqId = 0
    end

    local event = eventName .. tostring(requestId)

    cbResp[event] = true

    TriggerClientEvent("__ccb", src, eventName, requestId, { ... })

    local ticket = GetGameTimer()

    while (cbResp[event] == true) do
      Citizen.Wait(0)

      if(GetGameTimer() > ticket + Timeout) then
        Logger:Error("callbacks", ("ClientCallBack \\%s\\ timed out after %s ms"):format(eventName, tostring(Timeout)))

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
  RegisterServerCallback = function(self, eventName, fc)
    print("Event: ", eventName)
    print("Func: ", fc)
    cbs[eventName] = fc
  end,
}
