if !se_ship then
  se_ship = {
    health = 10,
    shield = 10,
    curret_vector = Vector(),
    future_vector = Vector(),
    curret_rotation = Angle(),
    future_rotation = Angle(),
    position = Vector(),
    rotation = Angle()
  }
end

hook.Add("Think", "se_ship_think", function()
  se_ship.curret_vector = LerpVector(0.01, se_ship.curret_vector, se_ship.future_vector)
  se_ship.curret_rotation = LerpAngle(0.01, se_ship.curret_rotation, se_ship.future_rotation)
  local mat = Matrix()
  mat:SetAngles(se_ship.rotation)
  mat:Invert()
  local forward = mat:GetForward()
  se_ship.position:Add(se_ship.curret_vector[1] * forward)
  se_ship.rotation:Add(se_ship.curret_rotation)
  for k, v in pairs(se_game_state.Game_Map) do
    collision = util.IntersectRayWithOBB( -v.position, Vector(10), se_ship.position, -se_ship.rotation, Vector(-1000, -500, -500), Vector(1000, 500, 500) )
    if collision and (se_col_cooldown or 0) < CurTime() and se_pilot_chair then
      se_pilot_chair:EmitSound( "vehicles/airboat/pontoon_impact_hard1.wav", 140, 50 + math.abs(se_ship.curret_vector:Length() * 20), 1, CHAN_AUTO )
      se_ship.curret_vector = -se_ship.curret_vector
      se_ship.curret_rotation = -se_ship.curret_rotation
      se_col_cooldown = CurTime() + 0.1
    end
  end
end)

hook.Add("Initialize", "se_ship_update_timer", function()
  timer.Create("se_ship_controls_timer", 0.1, 0, function()
    se_send_event("ship_pos_update", {{se_ship.position.x, se_ship.position.y, se_ship.position.z}, {se_ship.rotation.x, se_ship.rotation.y, se_ship.rotation.z}})
  end)
end)

/*hook.Add("Initialize", "se_ship_update_timer", function()
  timer.Create("se_ship_controls_timer", 0.1, 0, function()
    net.Start("se_update_ship_pos", true)
    net.WriteInt(se_ship.position[1], 64)
    net.WriteInt(se_ship.position[1], 64)
    net.WriteInt(se_ship.position[1], 64)

    net.WriteInt(se_ship.rotation[1], 64)
    net.WriteInt(se_ship.rotation[1], 64)
    net.WriteInt(se_ship.rotation[1], 64)
    net.Broadcast()
  end)
end)*/
