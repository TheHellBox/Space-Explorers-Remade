
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

function se_gen_planet( size_mod, parent_pos )
  local size_mod = size_mod or 1
  local parent_pos = parent_pos or Vector()
  local position = Vector(math.random(5000, 10000), math.random(-15000, 15000))
  if parent_pos != Vector() then
    position = parent_pos + Vector(math.random(-4000, 4000), math.random(-4000, 4000))
  end
  return {
    position = position,
    rotation = 0,
    body_type = BODY_TYPE_PLANET,
    color = Color(math.random(50, 255), math.random(50, 255), math.random(50, 255)),
    planet_type = math.random(SE_PLANET_EARTHLIKE, SE_PLANET_GAS),
    size = math.random(500, 1500) * size_mod
  }
end

-- Earse old game map and creates new one
function se_generate_random_map()
  se_game_state.Game_Map = {}
  -- We can have up to 2 stars
  for k=1,math.random(1, 2) do
    table.insert(se_game_state.Game_Map, se_gen_star())
  end
  local original_planet = se_gen_planet()
  table.insert(se_game_state.Game_Map, original_planet)
  for k=1,math.random(1, 2) do
    table.insert(se_game_state.Game_Map, se_gen_planet(0.2, original_planet.position))
  end
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

concommand.Add( "se_gen_map", se_generate_random_map )
