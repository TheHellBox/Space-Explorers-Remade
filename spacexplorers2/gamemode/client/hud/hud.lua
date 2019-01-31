hook.Add("HUDPaint", "se_draw_hud", function()
  if !se_ship then return end
  surface.SetDrawColor( 0, 0, 255, 1.5 * (100 - se_ship.oxygen) )
  surface.DrawRect( 0, 0, ScrW(), ScrH() )
end)
