-- Gamemode was created by The HellBox (https://github.com/TheHellBox)

-- About comments in code, I'm not the best one in English, so they can contain a lot of grammar errors.
-- Feel free to contribute
-- Please, use -- instead // to make code readable not only as glua. Even if it looks ugly

-- The lib folder is used for stuff that not affect gameplay(raw functions, support functions)
-- The base folder is used for gameplay stuff, such as shops, npcs, your ship, etc
-- shared is used for configs, enums, settings and so on
include("net_reg.lua")

include("lib/events.lua")
include("lib/player.lua")
include("lib/perlin.lua")

include("shared/enums.lua")
include("shared/roles.lua")
include("shared/config.lua")

include("base/roles.lua")
include("base/game_state.lua")

include("base/modules/piloting.lua")
include("base/modules/lifesupport.lua")

include("base/ship/ship.lua")

-- We have to manualy make CSLua files in lib folder
AddCSLuaFile("lib/cl_events.lua")
AddCSLuaFile("lib/perlin.lua")

se_developer_mode = true

-- You can use this function to add all CSLua stuff, including subfolders. I use it for client/ folder
function se_addcslua_r(dir)
	print("SEDEBUG: Running se_addcslua_r on "..dir.."/*")
	local files, dirs = file.Find( dir.."/*", "LUA" )
	for k, v in pairs(files) do
		print("SEDEBUG: Adding "..dir.."/"..v.." to CSLua Files...")
		AddCSLuaFile(dir.."/"..v)
	end
	for k, v in pairs(dirs) do
		se_addcslua_r(dir.."/"..v)
	end
end
se_addcslua_r("spacexplorers2/gamemode/client")
se_addcslua_r("spacexplorers2/gamemode/shared")

function GM:PlayerSpawn( ply )
	-- We spawn player as spectator if he didn't choosed the role
	if !ply.se_role then
		GAMEMODE:PlayerSpawnAsSpectator( ply )
		ply:Spectate( OBS_MODE_FREEZECAM  )
		timer.Simple(3, function()
			-- We send this event to make client open the rolemenu thing
			se_send_event("open_role_menu", {}, ply)
		end)
	else
		ply:UnSpectate( )
		ply:SetupHands()
		ply:Give("weapon_crowbar")
		ply:SetModel(ply:GetRoleTable().model)
	end
end

function GM:PlayerInitialSpawn(ply)
	-- We use timer to give player some time for init
	timer.Simple(5, function()
		se_send_event("ship_update", {se_ship}, nil, true)
		se_send_event("game_state_update", {se_game_state}, ply)
	end)
end

function GM:InitPostEntity()
	se_spawn_pilot_chair()
	se_spawn_terrain()
end

local function se_allow_noclip( ply )
	return se_developer_mode
end

hook.Add( "PlayerNoClip", "DisableNoclip", se_allow_noclip )
