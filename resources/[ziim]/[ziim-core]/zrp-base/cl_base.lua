function Init(self)
    Citizen.CreateThread(function()
        while true do
            if NetworkIsSessionStarted() then
                TriggerEvent('zrp-base:playerSessionStarted')
                TriggerServerEvent('zrp-base:playerSessionStarted')
            end
        end
    end)
end

RegisterNetEvent("zrp-base:waitForExports")
AddEventHandler("zrp-base:waitForExports", function()
    print("WiatForExports", ZRP.ExportsReady);
    if not ZRP.ExportsReady then return end

    while true do
        Citizen.Wait(50)
        if exports and exports["zrp-base"] then
            print("ClientRegister")
            Citizen.Wait(100);
            TriggerEvent("Proxy:Shared:RegisterReady")
            Citizen.Wait(500)
            TriggerEvent('Core:Shared:Ready')
            return
        end
    end
end)

