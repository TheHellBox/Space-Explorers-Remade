local class_materials = {
  Engineer = Material("se_materials/roles/engineer.png", "smooth"),
  Captain = Material("se_materials/roles/captain.png", "smooth"),
  Scientist = Material("se_materials/roles/scientist.png", "smooth"),
  Pilot = Material("se_materials/roles/pilot.png", "smooth"),
  Shooter = Material("se_materials/roles/weapon_man.png", "smooth"),
}

local PANEL = {}

function PANEL:Init()
  self:SetText( "" )
  self:SetFont( "se_button_font" )
end

function PANEL:Paint( w, h )
  local height = h - 22
  draw.SimpleText(self.ClassText, "se_button_font", w / 2, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
  local color = self.color or Color(30, 30, 30)
  if self.Hovered then
    color = Color(color.r + 20, color.g + 20, color.b + 20)
  end
  draw.RoundedBox( 5, 0, h - height, w, height, color)
  if self.Icon then
    local size = height * 0.8
    surface.SetDrawColor( 255, 255, 255, 255 )
    surface.SetMaterial( class_materials[self.Icon] or class_materials.Captain	)
    surface.DrawTexturedRect( (w - size) / 2, (h - height) + (height - size) / 2, size, size )
  end
end

vgui.Register( "SERoleButton", PANEL, "DButton" )
