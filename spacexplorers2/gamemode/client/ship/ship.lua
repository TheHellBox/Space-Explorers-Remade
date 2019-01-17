se_ship = {
  health = 10,
  shield = 10,
  position = Vector(),
  rotation = Angle(),
  future_position = Vector(),
  future_rotation = Angle(),
}

-- This hook used to smooth ship movement using Lerp
hook.Add("Think", "se_ship_smooth_update", function()
  se_ship.position = LerpVector(0.035, se_ship.position, se_ship.future_position)
  se_ship.rotation = LerpAngle(0.035, se_ship.rotation, se_ship.future_rotation)
end)

-- Update ship pos. ~every 0.1 sec
hook.Add("se_event_ship_pos_update", "se_update_ship_pos", function(position, rotation)
  local position = Vector(position[1], position[2], position[3])
  local rotation = Angle(rotation[1], rotation[2], rotation[3])
  print(position)
  se_ship.future_position = position
  se_ship.future_rotation = rotation
end)


/*net.Receive("se_update_ship_pos", function()
  local pos_x = net.ReadInt(64)
  local pos_y = net.ReadInt(64)
  local pos_z = net.ReadInt(64)

  local ang_x = net.ReadInt(64)
  local ang_y = net.ReadInt(64)
  local ang_z = net.ReadInt(64)

  local position = Vector(pos_x, pos_y, pos_z)
  local rotation = Angle(ang_x, pos_y, pos_z)
end)
*/
