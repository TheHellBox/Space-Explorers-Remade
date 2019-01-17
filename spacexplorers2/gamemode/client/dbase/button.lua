local PANEL = {}

function PANEL:Init()
  self:SetTextColor( Color(255, 255, 255) )
  self:SetText( "Error" )
  self:SetFont( "se_button_font" )
end

function PANEL:Paint( w, h )
  local color = self.color or Color(30, 30, 30)
  if self.Hovered then
    color = Color(color.r + 20, color.g + 20, color.b + 20)
  end
  draw.RoundedBox( 5, 0, 0, w, h, color)
end

vgui.Register( "SEButton", PANEL, "DButton" )
