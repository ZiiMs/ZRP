local value = true;

RegisterCommand("login", function(source, args)
  SendNUIMessage({
    app = "login",
    method = "setShow",
    data = not value,
  })
  SetNuiFocus(true, true);
  value = not value
end, false)

RegisterNUICallback('FetchData', function(data, cb)
  Core:LoadPlayer(src, function(data)
    if not data then 
      SendNUIMessage({
        app = "login",
        method = "FetchDataError",
        data = "Error fetching data!",
      })
    else
      SendNUIMessage({
        app = "login",
        method = "FetchDataSuccess",
        data = false,
      })
    end
  end)
  SendNUIMessage({
    app = "login",
    method = "setShow",
    data = not value,
  })
  cb()
end)

