hook.Add("se_button_press_powerbtn_add", "se_button_press_powerbtn_add", function(module_name)
  se_send_event("power_add", {module_name})
end)

hook.Add("se_button_press_powerbtn_reduce", "se_button_press_powerbtn_add", function(module_name)
  se_send_event("power_reduce", {module_name})
end)
