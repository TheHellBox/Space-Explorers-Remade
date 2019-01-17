if !se_game_state then
  se_game_state = {
    State = SE_STATE_NONE,
    Ship_Type = SE_SHIP_EXPLORER,
    Game_Map = {}
  }
end

hook.Add("se_event_game_state_update", "se_update_game_state", function(game_state)
  se_game_state = game_state
end)
