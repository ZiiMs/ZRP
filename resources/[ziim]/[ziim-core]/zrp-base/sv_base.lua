AddEventHandler("onResourceStart", function(resource)
	TriggerClientEvent("zrp-base:waitForExports", -1)
  
	if not ZRP.ExportsReady then return end

	Citizen.CreateThread(function()
		while true do 
			Citizen.Wait(50)
			if ZRP.ExportsReady then
				Citizen.Wait(100);
				TriggerEvent("Proxy:Shared:RegisterReady")
				Citizen.Wait(500)
				TriggerEvent('Core:Shared:Ready')
				return
			else
			end
		end
	end)
end)