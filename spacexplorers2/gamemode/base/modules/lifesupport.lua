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
end
