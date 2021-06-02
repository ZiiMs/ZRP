AddEventHandler("onClientResourceStart", function(resource) 
  if resource ~= GetCurrentResourceName() then return end
  print("Resource started notifications?")
end)

RegisterCommand("textBox", function(source, args)
  local Type = table.remove(args, 1);
  local Style = table.remove(args, 1);
  local Header = table.remove(args, 1);
  local Body = table.concat(args, " ");
  TriggerEvent("ziim:notify", Style, Type, "", Body);
end, false)


AddEventHandler("ziim:notify", function(style, type, header, body)
  SendNUIMessage({
    type = "Notify",
    payload = {type = type, text = body, style = style, header = header},
  })
end)