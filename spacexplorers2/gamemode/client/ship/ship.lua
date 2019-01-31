include("draw.lua")
include("power_managment.lua")

function se_count_power_usage()
  if !se_ship_exists() then return end
  local usage = 0
  for k, v in pairs(se_ship.modules) do
    usage = usage + v.energy
  end
  return usage
end

-- This hook used to smooth ship movement using Lerp
hook.Add("Think", "se_ship_smooth_update", function()
  if !se_ship then return end
  se_ship.position = LerpVector(0.035, se_ship.position, se_ship.future_vector)
  se_ship.rotation = LerpAngle(0.035, se_ship.rotation, se_ship.future_rotation)
end)

-- Update ship pos. ~every 0.1 sec
hook.Add("se_event_ship_pos_update", "se_update_ship_pos", function(position, rotation)
  if !se_ship then return end
  local position = Vector(position[1], position[2], position[3])
  local rotation = Angle(rotation[1], rotation[2], rotation[3])

  se_ship.future_vector = position
  se_ship.future_rotation = rotation

  se_move_x = math.floor( se_ship.position[1] / 1024 )
  se_move_y = math.floor( se_ship.position[2] / 1024 )
  --se_gen_perlin_squrere({-se_move_x, -se_move_y}, 31)
end)

-- Update the whole ship.
hook.Add("se_event_ship_update", "se_update_ship", function(ship)
  se_ship = ship
end)

hook.Add("se_event_ship_module_update", "se_update_ship", function(module_name, module_data)
  if !se_ship then return end
  se_ship.modules[module_name] = module_data
end)

hook.Add("se_event_ship_value_update", "se_update_ship_value", function(value_name, data)
  if !se_ship then return end
  se_ship[value_name] = data
end)
