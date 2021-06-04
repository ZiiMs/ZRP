AddEventHandler("onResourceStart", function(resource)
	TriggerClientEvent("zrp-base:waitForExports", -1)
  
	if not ZRP.ExportsReady then return end

	Citizen.CreateThread(function()
		while true do 
			Citizen.Wait(100)
			if ZRP.ExportsReady then
				TriggerEvent("Proxy:Shared:RegisterReady")
				Citizen.Wait(50)
				TriggerEvent('Core:Shared:Ready')
				return
			else
			end
		end
	end)
end)