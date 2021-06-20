fx_version 'cerulean'
game 'gta5'

author 'ZiiM'
version '1.0.0'


-- Base
client_script 'base/cl_base.lua'
shared_script 'base/sh_base.lua'
server_script 'base/sv_base.lua'


--Callbacks
client_script 'callbacks/cl_callbacks.lua'
server_script 'callbacks/sv_callbacks.lua'

--Player
client_script 'players/cl_players.lua'
server_script 'players/sv_players.lua'

--Utils
shared_script 'utils/sh_utils.lua'
client_script 'utils/cl_utils.lua'

--Gameplay
client_script 'gameplay/cl_gameplay.lua'

--Density
client_script 'density/cl_density.lua'
server_script 'density/sv_density.lua'
