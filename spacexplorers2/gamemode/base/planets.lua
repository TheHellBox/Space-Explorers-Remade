
function se_spawn_terrain()
  se_terrain_ents = {}
  -- Generate terrain
  se_global_terrain = se_gen_terrain({0, 0}, se_game_state.terrain_seed)
  for x=0, 10 do
    for y=0, 10 do
      local terrain = ents.Create("se_surface_ent")
      terrain.from = {x * 10, y * 10}
      terrain:SetPos(Vector(x * 1600,y * 1600,512))
      terrain:Spawn()
      terrain:Activate()
      terrain:SetupCollision(se_global_terrain)
      table.insert(se_terrain_ents, terrain)
    end
  end
  se_send_event("rebuild_surface", {0})
end

function se_gen_planet_surface(seed)
  se_game_state.terrain_seed = seed
  se_global_terrain = se_gen_terrain({0, 0}, se_game_state.terrain_seed)
  local x = 0
  local y = 0
  for k, v in pairs(se_terrain_ents) do
    if y > 8 then
      x = x + 1
      y = 0
    end
    v:SetupCollision(se_global_terrain)
    y = y + 1
  end

  se_send_event("rebuild_surface", {seed})
end

-- Unused, made for test
function se_change_terrain(x, y, value)
  se_global_terrain[x][y] = value
  for k, v in pairs(se_terrain_ents) do
    print(k)
    PrintTable(v.from)
    if v.from[1] < x and v.from[1] < (x + 9) then
      if v.from[2] < y and v.from[2] < (y + 9) then
        v:SetupCollision(se_global_terrain)
        break
      end
    end
  end
  se_send_event("change_terrain", {x, y, value})
end

concommand.Add( "se_gen_surface", function() se_gen_planet_surface(math.random(0, 10000)) end )
