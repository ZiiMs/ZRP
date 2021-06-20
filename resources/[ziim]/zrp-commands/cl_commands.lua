
local function RetrieveComponents()
  Notifications = exports['zrp-core']:FetchComponent('Notifications')
  Textbox = exports['zrp-core']:FetchComponent('Textbox')
  Logger = exports['zrp-core']:FetchComponent('Logger')
end

AddEventHandler("Core:Shared:Ready", function()
  exports['zrp-core']:RequestDependencies('Base', {
    'Logger', 
    'Textbox',
    'Notifications'
  }, function(error)
    if #error > 0 then
      print('Error')
      return
    end
    RetrieveComponents()
  end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
  exports['zrp-core']:RegisterComponent("Commands", Commands)
end)


Commands = {
  -- Testcb = function(self, type, header, body, duration) 
  --   duration = duration or 7500
  --   SendNUIMessage({
  --     type = "Notify",
  --     payload = {type = type, text = body, style = 'notify', header = header, duration = duration},
  --   })
  -- end,
  -- Alert = function(self, type, header, body, duration) 
  --   duration = duration or 7500
  --   SendNUIMessage({
  --     type = "Notify",
  --     payload = {type = type, text = body, style = 'alert', header = header, duration = duration},
  --   })
  -- end
}

RegisterCommand("gotols", function(source, args)
  local self = PlayerPedId();
  SetPedCoordsKeepVehicle(self, 192.662, -941.161, 30.692)
  FreezeEntityPosition(self, true);
  Notifications:Alert("warn", "RequestsWork>?", "If you can read this, our object OOP style lua is working!!!")
  Notifications:Notify("info", "Is this Working", "I hope this works!!")
  Logger:Trace("commands", "Is this working?")
  Notifications:Testcb("Test string", function(data)
    print(data);
  end)
  
  Citizen.Wait(1500);
  FreezeEntityPosition(self, false);
end, false)

local toggle = false;

RegisterCommand('car', function(source, args)
  local info = Notifications:Testreturn()
  print(info);
  local cars = {"dinghy", "dinghy2", "dinghy3", "dinghy4", "jetmax", "marquis", "seashark", "seashark2", "seashark3", "speeder", "speeder2", "squalo", "submersible", "submersible2", "suntrap", "toro", "toro2", "tropic", "tropic2", "tug", "avisa", 
  "dinghy5", "kosatka", "longfin", "patrolboat", "benson", "biff", "cerberus", "cerberus2", "cerberus3", "hauler", "hauler2", "mule", "mule2", "mule3", "mule4", "packer", "phantom", "phantom2", "phantom3", "pounder", "pounder2", 
  "stockade", "stockade3", "terbyte", "asbo", "blista", "brioso", "club", "dilettante", "dilettante2", "kanjo", "issi2", "issi3", "issi4", "issi5", "issi6", "panto", "prairie", "rhapsody", "brioso2", "weevil", "cogcabrio", 
  "exemplar", "f620", "felon", "felon2", "jackal", "oracle", "oracle2", "sentinel", "sentinel2", "windsor", "windsor2", "zion", "zion2", "bmx", "cruiser", "fixter", "scorcher", "tribike", "tribike2", "tribike3", "ambulance", "fbi", 
  "fbi2", "firetruk", "lguard", "pbus", "police", "police2", "police3", "police4", "policeb", "polmav", "policeold1", "policeold2", "policet", "pranger", "predator", "riot", "riot2", "sheriff", "sheriff2", "akula", "annihilator", 
  "buzzard", "buzzard2", "cargobob", "cargobob2", "cargobob3", "cargobob4", "frogger", "frogger2", "havok", "hunter", "maverick", "savage", "seasparrow", "skylift", "supervolito", "supervolito2", "swift", "swift2", "valkyrie", 
  "valkyrie2", "volatus", "annihilator2", "seasparrow2", "seasparrow3", "bulldozer", "cutter", "dump", "flatbed", "guardian", "handler", "mixer", "mixer2", "rubble", "tiptruck", "tiptruck2", "apc", "barracks", "barracks2", 
  "barracks3", "barrage", "chernobog", "crusader", "halftrack", "khanjali", "minitank", "rhino", "scarab", "scarab2", "scarab3", "thruster", "trailersmall2", "vetir", "akuma", "avarus", "bagger", "bati", "bati2", "bf400", 
  "carbonrs", "chimera", "cliffhanger", "daemon", "daemon2", "defiler", "deathbike", "deathbike2", "deathbike3", "diablous", "diablous2", "double", "enduro", "esskey", "faggio", "faggio2", "faggio3", "fcr", "fcr2", "gargoyle", 
  "hakuchou", "hakuchou2", "hexer", "innovation", "lectro", "manchez", "nemesis", "nightblade", "oppressor", "oppressor2", "pcj", "ratbike", "ruffian", "rrocket", "sanchez", "sanchez2", "sanctus", "shotaro", "sovereign", "stryder", 
  "thrust", "vader", "vindicator", "vortex", "wolfsbane", "zombiea", "zombieb", "manchez2", "blade", "buccaneer", "buccaneer2", "chino", "chino2", "clique", "coquette3", "deviant", "dominator", "dominator2", "dominator3", 
  "dominator4", "dominator5", "dominator6", "dukes", "dukes2", "dukes3", "faction", "faction2", "faction3", "ellie", "gauntlet", "gauntlet2", "gauntlet3", "gauntlet4", "gauntlet5", "hermes", "hotknife", "hustler", "impaler", 
  "impaler2", "impaler3", "impaler4", "imperator", "imperator2", "imperator3", "lurcher", "moonbeam", "moonbeam2", "nightshade", "peyote2", "phoenix", "picador", "ratloader", "ratloader2", "ruiner", "ruiner2", "ruiner3", "sabregt", 
  "sabregt2", "slamvan", "slamvan2", "slamvan3", "slamvan4", "slamvan5", "slamvan6", "stalion", "stalion2", "tampa", "tampa3", "tulip", "vamos", "vigero", "virgo", "virgo2", "virgo3", "voodoo", "voodoo2", "yosemite", "yosemite2", 
  "yosemite3", "bfinjection", "bifta", "blazer", "blazer2", "blazer3", "blazer4", "blazer5", "bodhi2", "brawler", "bruiser", "bruiser2", "bruiser3", "brutus", "brutus2", "brutus3", "caracara", "caracara2", "dloader", "dubsta3", 
  "dune", "dune2", "dune3", "dune4", "dune5", "everon", "freecrawler", "hellion", "insurgent", "insurgent2", "insurgent3", "kalahari", "kamacho", "marshall", "mesa3", "monster", "monster3", "monster4", "monster5", "menacer", 
  "outlaw", "nightshark", "rancherxl", "rancherxl2", "rebel", "rebel2", "rcbandito", "riata", "sandking", "sandking2", "technical", "technical2", "technical3", "trophytruck", "trophytruck2", "vagrant", "zhaba", "verus", "winky", 
  "formula", "formula2", "openwheel1", "openwheel2", "alphaz1", "avenger", "avenger2", "besra", "blimp", "blimp2", "blimp3", "bombushka", "cargoplane", "cuban800", "dodo", "duster", "howard", "hydra", "jet", "lazer", "luxor", 
  "luxor2", "mammatus", "microlight", "miljet", "mogul", "molotok", "nimbus", "nokota", "pyro", "rogue", "seabreeze", "shamal", "starling", "strikeforce", "stunt", "titan", "tula", "velum", "velum2", "vestra", "volatol", "alkonost", 
  "baller", "baller2", "baller3", "baller4", "baller5", "baller6", "bjxl", "cavalcade", "cavalcade2", "contender", "dubsta", "dubsta2", "fq2", "granger", "gresley", "habanero", "huntley", "landstalker", "landstalker2", "mesa", 
  "mesa2", "novak", "patriot", "patriot2", "radi", "rebla", "rocoto", "seminole", "seminole2", "serrano", "toros", "xls", "xls2", "squaddie", "asea", "asea2", "asterope", "cog55", "cog552", "cognoscenti", "cognoscenti2", "emperor", 
  "emperor2", "emperor3", "fugitive", "glendale", "glendale2", "ingot", "intruder", "limo2", "premier", "primo", "primo2", "regina", "romero", "stafford", "stanier", "stratum", "stretch", "superd", "surge", "tailgater", "warrener", 
  "washington", "airbus", "brickade", "bus", "coach", "pbus2", "rallytruck", "rentalbus", "taxi", "tourbus", "trash", "trash2", "wastelander", "alpha", "banshee", "bestiagts", "blista2", "blista3", "buffalo", "buffalo2", "buffalo3", 
  "carbonizzare", "comet2", "comet3", "comet4", "comet5", "coquette", "coquette4", "drafter", "deveste", "elegy", "elegy2", "feltzer2", "flashgt", "furoregt", "fusilade", "futo", "gb200", "hotring", "komoda", "imorgon", "issi7", 
  "italigto", "jugular", "jester", "jester2", "jester3", "khamelion", "kuruma", "kuruma2", "locust", "lynx", "massacro", "massacro2", "neo", "neon", "ninef", "ninef2", "omnis", "paragon", "paragon2", "pariah", "penumbra", 
  "penumbra2", "raiden", "rapidgt", "rapidgt2", "raptor", "revolter", "ruston", "schafter2", "schafter3", "schafter4", "schafter5", "schafter6", "schlagen", "schwarzer", "sentinel3", "seven70", "specter", "specter2", "streiter", 
  "sugoi", "sultan", "sultan2", "surano", "tampa2", "tropos", "verlierer2", "vstr", "zr380", "zr3802", "zr3803", "italirsx", "veto", "veto2", "ardent", "btype", "btype2", "btype3", "casco", "cheetah2", "coquette2", "deluxo", 
  "dynasty", "fagaloa", "feltzer3", "gt500", "infernus2", "jb700", "jb7002", "mamba", "manana", "manana2", "michelli", "monroe", "nebula", "peyote", "peyote3", "pigalle", "rapidgt3", "retinue", "retinue2", "savestra", "stinger", 
  "stingergt", "stromberg", "swinger", "torero", "tornado", "tornado2", "tornado3", "tornado4", "tornado5", "tornado6", "turismo2", "viseris", "z190", "ztype", "zion3", "cheburek", "toreador", "adder", "autarch", "banshee2", 
  "bullet", "cheetah", "cyclone", "entity2", "entityxf", "emerus", "fmj", "furia", "gp1", "infernus", "italigtb", "italigtb2", "krieger", "le7b", "nero", "nero2", "osiris", "penetrator", "pfister811", "prototipo", "reaper", "s80", 
  "sc1", "scramjet", "sheava", "sultanrs", "t20", "taipan", "tempesta", "tezeract", "thrax", "tigon", "turismor", "tyrant", "tyrus", "vacca", "vagner", "vigilante", "visione", "voltic", "voltic2", "xa21", "zentorno", "zorrusso", 
  "armytanker", "armytrailer", "armytrailer2", "baletrailer", "boattrailer", "cablecar", "docktrailer", "freighttrailer", "graintrailer", "proptrailer", "raketrailer", "tr2", "tr3", "tr4", "trflat", "tvtrailer", "tanker", "tanker2", 
  "trailerlarge", "trailerlogs", "trailersmall", "trailers", "trailers2", "trailers3", "trailers4", "freight", "freightcar", "freightcont1", "freightcont2", "freightgrain", "metrotrain", "tankercar", "airtug", "caddy", "caddy2", 
  "caddy3", "docktug", "forklift", "mower", "ripley", "sadler", "sadler2", "scrap", "towtruck", "towtruck2", "tractor", "tractor2", "tractor3", "utillitruck", "utillitruck2", "utillitruck3", "slamtruck", "bison", "bison2", "bison3", 
  "bobcatxl", "boxville", "boxville2", "boxville3", "boxville4", "boxville5", "burrito", "burrito2", "burrito3", "burrito4", "burrito5", "camper", "gburrito", "gburrito2", "journey", "minivan", "minivan2", "paradise", "pony", 
  "pony2", "rumpo", "rumpo2", "rumpo3", "speedo", "speedo2", "speedo4", "surfer", "surfer2", "taco", "youga", "youga2", "youga3"}
  Textbox:TextBox("Spawn Car", "Enter a vehicle", "spawnCarBox", GetCurrentResourceName(), cars)
end, false)

RegisterNUICallback('spawnCarBox', function(data, cb)
  -- POST data gets parsed as JSON automatically
  print("Working?")
  local vehicleName = data.input
  if vehicleName == nil or vehicleName == '' then
    cb({ state = true, msg = "Error: Invalid submission."})
    return
  end
  print("Working23423?")
  if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
      cb({ state = true, msg = ("Error: Invalid vehicle %s."):format(vehicleName)})
      return
  end
  print("Worki2345345ng?")
  Textbox:Close();

  RequestModel(vehicleName)

  while not HasModelLoaded(vehicleName) do
      Wait(500) 
  end

  local playerPed = PlayerPedId()
  local pos = GetEntityCoords(playerPed)

  local vehicle = CreateVehicle(vehicleName, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)
  SetPedIntoVehicle(playerPed, vehicle, -1)
  SetEntityAsNoLongerNeeded(vehicle)
  SetModelAsNoLongerNeeded(vehicleName)

  Notifications:Alert("success", "Vehicle Spawned", ("Just spawned a %s"):format(vehicleName))
  cb({ state = false })
end)