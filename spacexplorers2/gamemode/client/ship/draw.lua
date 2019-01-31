local function se_get_power_frame()
  if !se_power_status_frame then
    se_power_status_frame = se_construct_frame(600, 600, Vector(-14520,14920,-20), Angle(0, 90, 90), 0.2)
    local iter = 0
    for k, v in pairs(se_ship.modules) do

      local button_reduce = se_construct_button({520, 90 + iter * 40}, 30, 30)
      button_reduce.text = "-"
      button_reduce.hook_name = "powerbtn_reduce"
      button_reduce.args = {k}
      se_frame_add_button(se_power_status_frame, button_reduce, k.."-")

      local button_add = se_construct_button({560, 90 + iter * 40}, 30, 30)
      button_add.text = "+"
      button_add.hook_name = "powerbtn_add"
      button_add.args = {k}
      se_frame_add_button(se_power_status_frame, button_add, k.."+")

      iter = iter + 1
    end
  end
  return se_power_status_frame
end

function se_draw_ship_power_info()
  local frame = se_get_power_frame()
  se_update_frame(frame)
  local position = Vector(-14520,14920,-20)
  local angle = Angle(0, 90, 90)
  cam.Start3D2D( position, angle, 0.2 )
    surface.SetDrawColor( 20, 20, 20, 255 )
    surface.DrawRect( 0, 0, 600, 600 )
    draw.SimpleText( "Power usage:", "se_text_font", 10, 0, Color( 255, 255, 255, 255 ))

    draw.RoundedBox( 2, 10, 30, 500, 30, Color(0, 0, 60) )
    draw.RoundedBox( 2, 10, 30, 50 * se_ship.power_used, 30, Color(0, 0, 100) )
    draw.SimpleText( "Ship energy: "..se_ship.power_used.."/"..se_ship.max_power, "se_text_font", 15, 35, Color( 255, 255, 255, 255 ))

    draw.SimpleText( "Modules energy:", "se_text_font", 10, 70, Color( 255, 255, 255, 255 ))

    local iter = 0
    for k, v in pairs(se_ship.modules) do
      draw.RoundedBox( 2, 10, 90 + iter * 40, 500, 30, Color(0, 0, 60) )
      draw.RoundedBox( 2, 10, 90 + iter * 40, 500 * (v.energy / v.energy_max), 30, Color(0, 0, 100) )
      draw.SimpleText( k..": "..v.energy.."/"..v.energy_max, "se_text_font", 15, 95 + iter * 40, Color( 255, 255, 255, 255 ))
      iter = iter + 1
    end
    se_draw_frame(frame)
  cam.End3D2D()
end

hook.Add( "PostDrawOpaqueRenderables", "se_draw_ship_power_info", function()
  if !se_ship then return end
  se_draw_ship_power_info()
end)
