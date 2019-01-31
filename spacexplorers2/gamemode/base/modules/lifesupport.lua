function se_lifesupport_update()
  if !se_ship_exists() then return end
  local efficiency = se_get_module_efficiency("LifeSupport")
  se_add_ship_oxygen(-2)
  se_add_ship_oxygen(4 * efficiency)
  if se_get_oxygen() < 50 then
    for k, v in pairs(player.GetAll()) do
      v:TakeDamage(1 * (se_get_max_oxygen() / (se_get_oxygen() + 20)))
    end
  end
  se_send_event("ship_module_update", {"LifeSupport", se_ship.modules.LifeSupport})
  se_send_event("ship_value_update", {"oxygen", se_ship.oxygen})
end
