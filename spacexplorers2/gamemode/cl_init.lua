include("shared/enums.lua")
include("shared/roles.lua")
include("lib/cl_events.lua")
include("client/role_menu.lua")
include("client/dbase.lua")
include("client/game_state/game_state.lua")
include("client/map_render/map.lua")
include("client/ship/ship.lua")
include("client/terminals/terminal.lua")

-- NOTE: Move all fonts init to special file instead of here.

-- This font is used for terminals
surface.CreateFont("se_terminal_font", {
	size = 22,
	antialias = false,
	font = "Roboto Bold"
} );
-- This font is used by most of the buttons
surface.CreateFont("se_button_font", {
	size = 22,
	antialias = true,
	font = "Roboto Bold"
} );
-- This font is used by most of the game text
surface.CreateFont("se_text_font", {
	size = 22,
	antialias = true,
	font = "Roboto Bold"
} );
