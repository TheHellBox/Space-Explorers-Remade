include("planets.lua")

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
    size = math.random(100, 500)
  }
end

function se_gen_planet( )
  local position = Vector(math.random(5000, 10000), math.random(-15000, 15000))
  return {
    position = position,
    rotation = 0,
    body_type = BODY_TYPE_PLANET,
    color = Color(math.random(50, 255), math.random(50, 255), math.random(50, 255)),
    planet_type = math.random(SE_PLANET_EARTHLIKE, SE_PLANET_GAS),
    is_moon = false,
    size = math.random(500, 1500)
  }
end

function se_gen_moon( parent )
  local parent_pos = parent.position or Vector()
  local position = Vector(math.random(-4000, 4000), math.random(-4000, 4000))
  return {
    position = parent_pos,
    orbit = math.random(parent.size + 500, parent.size + 3000),
    start_angle = math.random(0, 360),
    rotation = 0,
    body_type = BODY_TYPE_PLANET,
    color = Color(math.random(50, 255), math.random(50, 255), math.random(50, 255)),
    planet_type = math.random(SE_PLANET_EARTHLIKE, SE_PLANET_FROZEN),
    is_moon = true,
    size = math.random(50, 100)
  }
end

function se_clean_planets()
  local to_remove = {}
  for k, v in pairs(se_game_state.Game_Map) do
    if v.body_type == BODY_TYPE_PLANET then table.insert(to_remove, v) end
  end
  for k, v in pairs(to_remove) do
    table.RemoveByValue(se_game_state.Game_Map, v)
  end
end

function se_get_planets_count()
  local count = 0
  for k, v in pairs(se_game_state.Game_Map) do
    if v.body_type == BODY_TYPE_PLANET then
      count = count + 1
    end
  end
  return count
end

function se_place_planets()
  se_clean_planets()

  local original_planet = se_gen_planet()
  table.insert(se_game_state.Game_Map, original_planet)

  for k=1,math.random(1, 2) do
    table.insert(se_game_state.Game_Map, se_gen_moon(original_planet))
  end
  se_send_event("game_state_update", {se_game_state})
end

function se_gen_asteroids()
  for k=0, 10 do
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
end

-- Clean old game map and creates new one
function se_generate_random_map()
  se_game_state.Game_Map = {}

  table.insert(se_game_state.Game_Map, se_gen_star())
  se_place_planets()
  se_gen_asteroids()
  se_send_event("game_state_update", {se_game_state})
end

concommand.Add( "se_gen_map", se_generate_random_map )
concommand.Add( "se_gen_planets", se_place_planets )
