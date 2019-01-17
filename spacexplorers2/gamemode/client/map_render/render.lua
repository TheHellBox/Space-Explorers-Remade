function se_draw_skybox()
  -- To make skybox faces visible
  render.CullMode( 1 )
  -- Drawing skybox as sphere with texture
  render.SetMaterial(se_skybox)
  -- We use EyePos instead LocalPlayer():GetPos() because when player trying to seat and jump at the same time the players position changing while camera position is not
  -- And yes, we can use it, as we are in the rendering function
  local model = Matrix()
  model:Translate( EyePos())
  model:Rotate( se_ship.rotation )

  cam.PushModelMatrix(model)
    render.DrawSphere( Vector(), 3000, 30, 30, color )
  cam.PopModelMatrix()

  render.CullMode( 0 )
end

-- Function to calculate model matrix for objects. If view is not difined, then we use null matrix instead
function se_get_model_matrix(pos, rot, view)
  local pos = pos or Vector()
  local rot = rot or Angle()
  local view = view or Matrix()

  local model = Matrix()
  model:Translate(pos)
  model:SetAngles(rot)
  return view * model
end

function se_draw_asteroid(asteroid, view)
  -- Change asteroid color to star's one
  se_star_color = se_star_color or Color(0, 0, 0)
  render.SetColorModulation( se_star_color.r / 50, se_star_color.g / 50, se_star_color.b / 50 )

  -- Asteroid position
  local position = (asteroid.position or Vector())
  local view = view
  -- Make model matrix for asteroid
  local model = Matrix()
  model:Translate(position)
  -- If asteroid is not rotation, then we have to change his direction
  if !asteroid.rot_dir then
    asteroid.rot_dir = Vector(math.Rand(-3, 3), math.Rand(-3, 3), math.Rand(-3, 3))
  end
  -- I named it rd to make code a bit shorted
  local rd = asteroid.rot_dir
  -- Set asteroid angles
  model:SetAngles(Angle(RealTime() * rd[1], RealTime() * rd[2], RealTime() * rd[3]))
  -- Push matrix to the model
  se_asteroid_models[asteroid.asteroid_size]:EnableMatrix( "RenderMultiply", view * model )
  -- Draw model
  se_asteroid_models[asteroid.asteroid_size]:DrawModel()
end

function se_draw_star(sun_size, position, color)
  -- Make sure that values are valid. We don't want lua errors, aren't we?
  local sun_size = sun_size or 1000
  local position = (position or Vector())
  local color = color or Color( 255, 100, 15, 255 )

  -- View matrix specific for star
  local view = Matrix()
  view:Translate( EyePos())
  view:Rotate( se_ship.rotation )

  -- Calculate view models for star
  local inside_layer_model = se_get_model_matrix(position, Angle(0, (CurTime() * 2) % 360), view)
  local outside_layer_model = se_get_model_matrix(position, Angle(0, (CurTime()* 1) % 360), view)

  local angle = Angle()

  local shine_model = se_get_model_matrix(position, angle, view)
  -- Render 'Shine' effect around star
  render.SetMaterial(se_star_shine)
  cam.PushModelMatrix(shine_model)
    render.DrawQuadEasy( Vector(), Vector(-1), sun_size * 8, sun_size * 8, Color( color.r, color.g, color.b, 20), 0 )
  cam.PopModelMatrix()

  -- I use 2 spheres for star drawing, 1 from inside and 1 from outside.
  -- The first one have alpha 255 and rotates faster, the outside layer is transparent and rotates slower

  -- Set material. We use same material for both layers
  render.SetMaterial(se_star_material)
  -- Draw star inside
  cam.PushModelMatrix(inside_layer_model)
    render.DrawSphere( Vector(), sun_size, 30, 30, color )
  cam.PopModelMatrix()
  -- Draw star outside
  cam.PushModelMatrix(outside_layer_model)
    render.DrawSphere( Vector(), sun_size * 1.02, 30, 30, Color( color.r, color.g + 50, color.b - 10, 50) )
  cam.PopModelMatrix()
end

function se_draw_planet(planet_size, position, color, planet_type)
  -- Make sure that values are valid. We don't want lua errors, aren't we?
  local planet_size = planet_size or 1000
  local position = (position or Vector())
  local color = color or Color( 255, 100, 15, 255 )

  -- View matrix specific for star
  local view = Matrix()
  view:Translate( EyePos())
  view:Rotate( se_ship.rotation )

  local vec = ( position - se_star_position )
  vec:Normalize()
  // convert the vector to an angle
  local angle = vec:Angle()

  -- Calculate view model (For shadow)
  local shadow_model = se_get_model_matrix(position, angle, view)
  local planet_model = se_get_model_matrix(position, Angle(0, (CurTime() * 1) % 360), view)

  -- Set material.
  render.SetMaterial(se_planet_materials[planet_type])
  -- Draw Planet
  cam.PushModelMatrix(planet_model)
    render.DrawSphere( Vector(), planet_size, 30, 30, color )
  cam.PopModelMatrix()
  -- Set shadow material
  render.SetMaterial(se_planet_shadow)
  cam.PushModelMatrix(shadow_model)
    render.DrawSphere( Vector(), planet_size * 1.01, 30, 30, Color(255, 255, 255, 255) )
  cam.PopModelMatrix()
end

hook.Add("PostDrawOpaqueRenderables", "se_render_map", function()
  if !se_ship then return end
  local player_on_ship = LocalPlayer():GetPos():WithinAABox( Vector(-15799,14366,518), Vector(-13116,15641,-547) )
  if !player_on_ship then return end
  local view = Matrix()
  view:Translate(Vector(-14422,14973,4) - Vector(-14638,11969,-1102))
  view:Rotate(se_ship.rotation)
  view:Translate(se_ship.position)
  -- First we draw skybox
  se_draw_skybox()
  -- After skybox, we draw objects
  for k, v in pairs(se_game_state.Game_Map) do
    -- For evety body type we use different render functions
    if v.body_type == BODY_TYPE_STAR then
      se_draw_star(v.size, v.position, v.color or Color(0, 0, 0) )
      se_star_color = v.color
      se_star_position = v.position
    elseif v.body_type == BODY_TYPE_ASTEROID then
      se_draw_asteroid(v, view)
    elseif v.body_type == BODY_TYPE_PLANET then
      se_draw_planet(v.size, v.position, v.color, v.planet_type)
    end
  end
end)
