hook.Add("se_event_power_add", "se_event_power_add", function(module_name)
  se_add_power_to_module(module_name, 1)
  se_send_event("ship_value_update", {"power_used", se_ship.power_used}, nil, true)
end)

hook.Add("se_event_power_reduce", "se_event_power_reduce", function(module_name)
  se_add_power_to_module(module_name, -1)
  se_send_event("ship_value_update", {"power_used", se_ship.power_used}, nil, true)
end)
