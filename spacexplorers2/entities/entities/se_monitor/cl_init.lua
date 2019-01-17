
include("shared.lua")

function ENT:Initialize()
  self.lines = {}
  self:AddLine("Welcome to Star OS 0.1")
  self:AddLine("Memory test... 1024 kb free")
  self:AddLine("Searching for floppy devices... Not found")
  self:AddLine("Done!")
end

function ENT:Draw()
  self:DrawModel()
  local h, w = 640, 460

  local pos = self:LocalToWorld( Vector(2.3, 12.78, 24.7) )
  local ang = Angle(0, -180, 87) + self:GetAngles()
  cam.Start3D2D(pos, ang, 0.023)
    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawRect(0, 0, h, w);
    for k=1, math.Clamp(#(self.lines or {"Error"}), 0, 20) do
      draw.SimpleText((self.lines or {"Error"})[k], "se_terminal_font", 20, k * 20, Color(0, 200, 0, 200), 0, 0);
    end
    draw.SimpleText(self.user_input or "User$", "se_terminal_font", 20, (#(self.lines or {"Error"}) + 1) * 20, Color(0, 200, 0, 200), 0, 0)
  cam.End3D2D()
end

function ENT:AddLine(text)
  table.insert(self.lines, text)
end
