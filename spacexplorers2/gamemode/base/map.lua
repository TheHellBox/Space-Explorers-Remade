
hook.Add("Initialize", "se_spacemap_init", function()
  -- Do map generation on init
  se_generate_random_map()
end)

function se_gen_star()
  return {
    position = Vector(15000, math.random(-15000, 15000)),
    rotation = 0,
    body_type = BODY_TYPE_STAR,
    color = Color(math.random(50, 255), math.random(50, 255), math.random(50, 255)),
    size = math.random(500, 1500)
  }
end

function se_gen_planet()
  return {
    position = Vector(10000, math.random(-15000, 15000)),
    rotation = 0,
    body_type = BODY_TYPE_PLANET,
    color = Color(math.random(50, 255), math.random(50, 255), math.random(50, 255)),
    planet_type = math.random(SE_PLANET_EARTHLIKE, SE_PLANET_GAS),
    size = math.random(500, 1500)
  }
end

-- Earse old game map and creates new one
function se_generate_random_map()
  se_game_state.Game_Map = {}
  table.insert(se_game_state.Game_Map, se_gen_star())
  table.insert(se_game_state.Game_Map, se_gen_planet())
  for k=0, 50 do
    local asteroid = {
      position = Vector(math.random(-15000, 15000), math.random(-15000, 15000)),
      rotation = 0,
      body_type = BODY_TYPE_ASTEROID,
      asteroid_size = math.random(SE_ASTEROID_SMALL, SE_ASTEROID_BIG)
    }
    -- If asteroid is outside of the ship, spawn it
    if !asteroid.position:WithinAABox( Vector(-1000, -500, -500), Vector(1000, 500, 500) ) then
      table.insert(se_game_state.Game_Map, asteroid)
    else
      print("SEDEBUG: Removing stuck asteroid....")
    end
  end
  se_send_event("game_state_update", {se_game_state})
end
