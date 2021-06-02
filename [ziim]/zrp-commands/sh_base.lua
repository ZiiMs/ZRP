


function ConsoleLog(msg, mod)
  if not tostring(msg) then return end
  if not tostring(mod) then mod = "No Module" end
  
  local pMsg = string.format("[NPX LOG - %s] %s", mod, msg)
  if not pMsg then return end

  print(pMsg)
end

RegisterNetEvent("np-base:consoleLog")
AddEventHandler("np-base:consoleLog", function(msg, mod)
  ConsoleLog(msg, mod)
end)