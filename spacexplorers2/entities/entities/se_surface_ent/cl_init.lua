
include("shared.lua")

function ENT:Initialize()
  if !se_terrain_ents then se_terrain_ents = {} end
  table.insert(se_terrain_ents, self)
end

function ENT:Draw()

end
