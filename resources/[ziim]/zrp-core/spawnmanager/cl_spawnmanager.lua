
function Initialize()
  Citizen.CreateThread(function()
    FreezeEntityPosition(PlayerPedId(), true)

    TransitionToBlurred(500)
    DoScreenFadeOut(500)

    ShutdownLoadingScreen()

    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)

    SetCamRot(cam, 0.0, 0.0, -45.0, 2)
    SetCamCoord(cam, -682.0, -1092.0, 226.0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)

    local ped = PlayerPedId()

    SetEntityCoordsNoOffset(ped, -682.0, -1092.0, 200.0, false, false, false, true)

    SetEntityVisible(ped, false)

    TriggerEvent("zrp-base:spawnInitialized")
    TriggerServerEvent("zrp-base:spawnInitialized")
    DoScreenFadeIn(500)

    while IsScreenFadingIn() do
        Citizen.Wait(0)
    end
  end)
end



AddEventHandler("zrp-base:InitSpawn", function() 

  RequestCollisionAtCoord(192.662, -941.161, 30.692)

  SetPedCoordsKeepVehicle(PlayerPedId(), 192.662, -941.161, 30.692)
  
  SetEntityVisible(PlayerPedId(), true)
  FreezeEntityPosition(PlayerPedId(), false)

  NetworkResurrectLocalPlayer(192.662, -941.161, 30.692, 180, true, true, false)

  ClearPedTasksImmediately(PlayerPedId())

  local startTime = GetGameTimer()
  while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
    if GetGameTimer - startTime > 6000 then break end
    Citizen.Wait(0)
  end
  
  TransitionFromBlurred(500)
  EnableAllControlActions(0)    
  DoScreenFadeIn(500)

  -- exports.spawnmanager:spawnPlayer();

  Citizen.CreateThread(function()
    Citizen.Wait(600)
    DestroyAllCams(true)
    RenderScriptCams(false, true, 1, true, true)
    FreezeEntityPosition(PlayerPedId(), false)
  end)
end)

AddEventHandler("zrp-base:playerSessionStarted", function() 
    Initialize();
end)