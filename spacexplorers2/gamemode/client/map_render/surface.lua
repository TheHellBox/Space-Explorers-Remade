
function se_gen_rocks()
  local offset = Vector(0, 0, 512)
  se_surface_rocks = {}
  for k=0, 1000 do
    local x = math.random(1, 100)
    local y = math.random(1, 100)
    local rock = {
      position = Vector(x * 160, y * 160, se_terrian_get_h(x, y)) + offset,
      model = math.random(1, 4)
    }
    table.insert(se_surface_rocks, rock)
  end
end

function se_blend_color_v(a, b, t)
    return math.sqrt((1 - t) * a^2 + t * b^2)
end

function se_blend_colors(a, b, t)
  local result = Color(0, 0, 0)
  result.r = se_blend_color_v(a.r, b.r, t)
  result.g = se_blend_color_v(a.g, b.g, t)
  result.b = se_blend_color_v(a.b, b.b, t)
  return result
end

function se_draw_surface()
  render.OverrideDepthEnable( true, true )
  local scale = 160;
  render.SetMaterial( se_tiles[3] )
  for k, v in pairs(se_terrain_models or {}) do
    mat = Matrix()
    mat:Translate( Vector(v.offset[1], v.offset[2], 512) )
    mat:Scale( Vector( 1, 1, 1 ) * scale )
    cam.PushModelMatrix ( mat )
      v.mesh:Draw()
    cam.PopModelMatrix()
  end
  for k, v in pairs(se_surface_rocks or {}) do
    if v.position:Distance(LocalPlayer():GetPos()) < 2000 then
      rmat = Matrix()
      rmat:Translate( v.position )
      rmat:Scale( Vector( 1, 1, 1 ) * 5 )
      -- Push matrix to the model
      se_rocks[v.model]:EnableMatrix( "RenderMultiply", rmat )
      -- Draw model
      se_rocks[v.model]:DrawModel()
    end
  end
  render.OverrideDepthEnable( false, false )
end

function se_build_terrain_mesh(perlin_squad, x_offset, y_offset)
  -- Calculate colors for dark and light verts
  local dark_color = Color(150, 150, 150)
  local regular_color = Vector(255, 255, 255)
  dark_color = se_blend_colors(dark_color, se_star_color or Color(255, 255, 255), 0.2)
  regular_color = se_blend_colors(regular_color, se_star_color or Color(255, 255, 255), 0.2)

  local model = Mesh();
  -- Gen terrain
  local perlin_squad = perlin_squad or se_gen_terrain({0, 0}, se_game_state.terrain_seed)
  local mesh = {}
  for x=1, 10 do
    for y=1, 10 do
      -- Add offsets
      local x_m = x + x_offset
      local y_m = y + y_offset
      -- Check if value exists
      if !perlin_squad[x] then return end

      -- Get vert heights
      local h1 = perlin_squad[x_m][y_m]
      local h2 = perlin_squad[x_m + 1][y_m]
      local h3 = perlin_squad[x_m][y_m + 1]
      local h4 = perlin_squad[x_m + 1][y_m + 1]

      -- Calculate normals
      local normal_1 = se_calc_normal(Vector(0, 0, h1), Vector(0, 1, h3), Vector(1, 1, h4))
      local normal_2 = se_calc_normal(Vector(0, 0, h1), Vector(1, 1, h4), Vector(1, 0, h2))

      -- Calculate color from normal and light direction
      local n1_l = normal_1:Dot(Vector(1,0.4,0.0))
      local n2_l = normal_2:Dot(Vector(1,0.1,0.0))
      local n1c = se_blend_colors(dark_color, regular_color, n1_l)
      local n2c = se_blend_colors(dark_color, regular_color, n2_l)

      -- Insert verts
      table.insert(mesh, {
        pos = Vector(x, y, h1),
        normal = normal_1,
        color = n1c,
        u = 0,
        v = 0
      })
      table.insert(mesh, {
        pos = Vector(x, y + 1, h3),
        normal = normal_1,
        color = n1c,
        u = 0,
        v = 1
      })
      table.insert(mesh, {
        pos = Vector(x + 1, y + 1, h4),
        normal = normal_1,
        color = n1c,
        u = 1,
        v = 1
      })
      -- Trinagle 2
      table.insert(mesh, {
        pos = Vector(x, y, h1),
        normal = normal_2,
        color = n2c,
        u = 0,
        v = 0
      })
      table.insert(mesh, {
        pos = Vector(x + 1, y + 1, h4),
        normal = normal_2,
        color = n2c,
        u = 1,
        v = 1
      })
      table.insert(mesh, {
        pos = Vector(x + 1, y, h2),
        normal = normal_2,
        color = n2c,
        u = 1,
        v = 0
      })
    end
  end
  -- Build new one
  model:BuildFromTriangles(mesh);
  table.insert(se_terrain_models, {
    mesh = model,
    offset = {x_offset * 160, y_offset * 160}
  })
end

function se_apply_terrain_changes()
  if !se_global_terrain or !se_terrain_ent then return end
  for k, v in pairs(terrain_changes) do
    local x = v.x
    local y = v.y
    local value = v.v
    se_global_terrain[x][y] = value
    se_terrain_ent:BuildMesh(se_global_terrain)
  end
end

-- Unused, made for test
function se_remove_terrain_chunk(x, y)
  for k, v in pairs(se_terrain_models) do
    local tx, ty = v.offset[1] / 1600, v.offset[2] / 1600
    if tx == x and ty == y then
      table.remove(se_terrain_models, k)
    end
  end
end

-- Unused, made for test
function se_change_terrain(x, y, value)
  if !se_global_terrain or !se_terrain_ents then return end
  se_global_terrain[x][y] = value
  for k, v in pairs(se_terrain_ents) do
    if v.from[1] > x and v.from[1] < (x + 10) then
      if v.from[2] > y and v.from[2] < (y + 10) then
        se_remove_terrain_chunk((v.from[1] - 10) / 10, (v.from[2] - 10) / 10)
        v:SetupCollision(se_global_terrain)
        se_build_terrain_mesh(se_global_terrain, v.from[1] - 10, v.from[2] - 10)
        break
      end
    end
  end
end

hook.Add("se_event_change_terrain", "se_event_change_terrain", function(x, y, value)
  se_change_terrain(x, y, value)
end)

hook.Add("se_event_rebuild_surface", "se_event_rebuild_surface", function(seed)
  se_terrain_models = {}
  se_game_state.terrain_seed = seed
  se_global_terrain = se_gen_terrain({0, 0}, se_game_state.terrain_seed)
  local x = 0
  local y = 0
  for k=1, 95 do
    print(x, y)
    if y > 9 then
      x = x + 1
      y = 0
    end
    se_build_terrain_mesh(se_global_terrain, x * 10, y * 10)
    y = y + 1
  end

  local x = 0
  local y = 0
  for k, v in pairs(se_terrain_ents or {}) do
    if y > 9 then
      x = x + 1
      y = 0
    end
    print(x, y)
    v.from = {x * 10, y * 10}
    v:SetupCollision(se_global_terrain)
    y = y + 1
  end
end)
