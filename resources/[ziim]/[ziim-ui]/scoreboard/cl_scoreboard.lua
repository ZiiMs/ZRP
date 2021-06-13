function RetrieveComponents()
  Logger = exports['zrp-base']:FetchComponent('Logger')
  Callbacks = exports['zrp-base']:FetchComponent('Callbacks')
end


AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-base']:RequestDependencies('Base', {
    'Logger',
    'Callbacks'
  }, function(error)
    if #error > 0 then
      print("Errors", error[1])
      return
    end
    RetrieveComponents()
  end)
end)
local toggle = false;

Citizen.CreateThread(function () 
  while true do 
    Wait(0)
    if IsControlJustReleased(0, 303) then

        print("Get sb")
        local idents = Callbacks:TriggerServerCallback('sb:getData')
        -- for i=2,255 do
        --   local license = ("license:7e5a718514a9dfd78920a66998a036b14b3a2a3%s"):format(i);
        --   local temp = { id = i, license = license};
        --   table.insert( idents, temp );
        -- end
        toggle = not toggle
        SendNUIMessage({
          type = "scoreboardShow",
          payload = {show = toggle, players = idents},
        })
        SetNuiFocus(false, false)
        -- for i,v in pairs(idents) do
        --   -- print(i,v)
        --   Logger:Trace("players", ("Key234:%s Ident: %s"):format(i,v))
        -- end
    end
    if toggle then
      if IsControlJustReleased(0, 174) then
        SendNUIMessage({
          type = "scoreboardShow",
          payload = {move = "left"},
        })
      end
    elseif IsControlJustReleased(0, 175) then
        SendNUIMessage({
          type = "scoreboardShow",
          payload = {move = "left"},
        })
      end
    end
  end
end)

local function DrawText3D(position, text, r,g,b) 
  local onScreen,_x,_y=World3dToScreen2d(position.x,position.y,position.z+1)
  local dist = #(GetGameplayCamCoords()-position)

  local scale = (1/dist)*2
  local fov = (1/GetGameplayCamFov())*100
  local scale = scale*fov
 
  if onScreen then
      if not useCustomScale then
          SetTextScale(0.0*scale, 0.55*scale)
      else 
          SetTextScale(0.0*scale, customScale)
      end
      SetTextFont(0)
      SetTextProportional(1)
      SetTextColour(r, g, b, 255)
      SetTextDropshadow(0, 0, 0, 0, 255)
      SetTextEdge(2, 0, 0, 0, 150)
      SetTextDropShadow()
      SetTextOutline()
      SetTextEntry("STRING")
      SetTextCentre(1)
      AddTextComponentString(text)
      DrawText(_x,_y)
  end
end


RegisterNUICallback('closeScoreboard', function(data, cb)
  toggle = false
  SetNuiFocus(toggle, toggle)
  cb(true)
end)

AddEventHandler("sb:fetch", function(data)

end)
