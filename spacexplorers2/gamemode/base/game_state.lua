if !se_game_state then
  se_game_state = {
    State = SE_STATE_NONE,
    Ship_Type = SE_SHIP_EXPLORER,
    Game_Map = {}
  }
end

include("map.lua")
