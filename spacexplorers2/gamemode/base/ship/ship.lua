include("power_managment.lua")

function se_init_ship()
  if !se_ship then
    se_ship = {
      -- Health
      max_health = se_ship_max_health,
      health = se_ship_max_health,
      -- Shields
      max_shields = se_ship_max_shields,
      shields = se_ship_max_shields,
      -- Oxygen
      max_oxygen = se_ship_max_oxygen,
      oxygen = se_ship_max_oxygen,
      -- Power
      max_power = 10,
      power_used = 0,
      -- Movement vectors.
      curret_vector = Vector(),
      future_vector = Vector(),
      -- Ship's rotation direction
      curret_rotation = Angle(),
      future_rotation = Angle(),
      -- Position and rotation
      position = Vector(),
      rotation = Angle()
    }
    se_ship_init_modules()
  end
end

-- Check if ship exists. If not, reinit it
function se_ship_exists()
  if !se_ship then se_init_ship() return false else return true end
end

function se_count_power_usage()
  if !se_ship_exists() then return end
  local usage = 0
  for k, v in pairs(se_ship.modules) do
    usage = usage + v.energy
  end
  return usage
end

function se_ship_init_modules()
  if !se_ship_exists() then return end
  se_ship.modules = {
    LifeSupport = {
      health = se_ship_max_module_health,
      energy_max = 3,
      energy = 3,
    },
    Piloting = {
      health = se_ship_max_module_health,
      energy_max = 4,
      energy = 4,
    },
    Weapons = {
      health = se_ship_max_module_health,
      energy_max = 5,
      energy = 3,
    },
  }
  se_ship.power_used = se_count_power_usage()
end

se_init_ship()

function se_add_power_to_module(ship_module_name, amount)
  if !se_ship_exists() then return end
  local ship_module = se_ship.modules[ship_module_name]
  if !ship_module then return end
  local power_to_add = math.Clamp(se_ship.max_power - se_ship.power_used, -999, amount)
  ship_module.energy = math.Clamp(ship_module.energy + power_to_add, 0, ship_module.energy_max)
  se_ship.power_used = se_count_power_usage()
  se_send_event("ship_module_update", {ship_module_name, se_ship.modules[ship_module_name]})
end

function se_get_oxygen()
  if !se_ship_exists() then return end
  return se_ship.oxygen
end

function se_get_max_oxygen()
  if !se_ship_exists() then return end
  return se_ship.max_oxygen
end

function se_get_module_health(ship_module_name)
  if !se_ship_exists() then return end
  local ship_module = se_ship.modules[ship_module_name]
  if !ship_module then return end
  return (ship_module.health or 0)
end

function se_get_module_energy(ship_module_name)
  if !se_ship_exists() then return end
  local ship_module = se_ship.modules[ship_module_name]
  if !ship_module then return end
  return (ship_module.energy or 0)
end

function se_get_module_max_energy(ship_module_name)
  if !se_ship_exists() then return end
  local ship_module = se_ship.modules[ship_module_name]
  if !ship_module then return end
  return (ship_module.energy_max or 0)
end

function se_get_module_efficiency(ship_module_name)
  if !se_ship_exists() then return end
  local ship_module = se_ship.modules[ship_module_name]
  if !ship_module then return end
  local health = se_get_module_health(ship_module_name)
  local max_health = 10
  local energy = se_get_module_energy(ship_module_name)
  local max_energy = se_get_module_max_energy(ship_module_name)
  return (health / max_health) * (energy / max_energy)
end

function se_add_module_health(ship_module_name, amount)
  if !se_ship_exists() then return end
  local ship_module = se_ship.modules[ship_module_name]
  if !ship_module then return end
  ship_module.health = math.Clamp(ship_module.health + amount, 0, se_ship_max_module_health)
end

-- Add health
function se_add_ship_health(amount)
  if !se_ship_exists() then return end
  se_ship.health = math.Clamp(se_ship.health + amount, 0, se_ship.max_health)
end
-- Add shields
function se_add_ship_shields(amount)
  if !se_ship_exists() then return end
  se_ship.shields = math.Clamp(se_ship.shields + amount, 0, se_ship.max_shields)
end
-- Add oxygen
function se_add_ship_oxygen(amount)
  if !se_ship_exists() then return end
  se_ship.oxygen = math.Clamp(se_ship.oxygen + amount, 0, se_ship.max_oxygen)
end

function se_ship_modules_update()
  se_lifesupport_update()
end

hook.Add("Think", "se_ship_think", function()
  local time = CurTime()
  se_update_ship_pos()
  if (se_next_modules_update or 0) < time then
    se_next_modules_update = (se_next_modules_update or 0) + se_ship_modules_update_time
    se_ship_modules_update()
  end
end)

hook.Add("Initialize", "se_ship_update_timer", function()
  -- I hope it will never give us an error
  timer.Create("se_ship_controls_timer", 0.1, 0, function()
    se_send_event("ship_pos_update", {{se_ship.position.x, se_ship.position.y, se_ship.position.z}, {se_ship.rotation.x, se_ship.rotation.y, se_ship.rotation.z}}, nil, true)
  end)
end)
