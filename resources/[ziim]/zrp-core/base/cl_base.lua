function Init(self)
    Citizen.CreateThread(function()
        while true do
            Wait(0)
            if NetworkIsSessionStarted() then
                TriggerEvent('zrp-base:playerSessionStarted')
                TriggerServerEvent('zrp-base:playerSessionStarted')
                break
            end
        end
    end)
end
Init()


RegisterNetEvent("zrp-base:waitForExports")
AddEventHandler("zrp-base:waitForExports", function()
    print("WiatForExports", ZRP.ExportsReady);
    if not ZRP.ExportsReady then return end

    while true do
        Citizen.Wait(50)
        if exports and exports["zrp-core"] then
            print("ClientRegister")
            Citizen.Wait(100);
            TriggerEvent("Proxy:Shared:RegisterReady")
            Citizen.Wait(500)
            TriggerEvent('Core:Shared:Ready')
            return
        end
    end
end)

