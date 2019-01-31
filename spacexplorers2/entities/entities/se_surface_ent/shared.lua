ENT.Type = "anim"
ENT.PrintName = "Surface"
ENT.Author = "The HellBox"
ENT.Spawnable = false

function ENT:SetupCollision(perlin_squad)
  print("Test2")
  -- Collect garbage to prevent crash
  collectgarbage( "collect" )
  local scale = 160
  local VERTICES = {}
  for x = 1, 10 do
    for y = 1, 10 do
      local x_m = x + self.from[1]
      local y_m = y + self.from[2]
      if !perlin_squad[x_m] then return end
      local h1 = perlin_squad[x_m][y_m] * scale
      local h2 = perlin_squad[x_m + 1][y_m] * scale
      local h3 = perlin_squad[x_m][y_m + 1] * scale
      local h4 = perlin_squad[x_m + 1][y_m + 1] * scale
      local x = x * scale
      local y = y * scale
      table.insert( VERTICES, { pos = ( Vector(x, y, h1) ) } );
      table.insert( VERTICES, { pos = ( Vector(x, y + scale, h3) ) } );
      table.insert( VERTICES, { pos = ( Vector(x + scale, y + scale, h4) ) } );

      table.insert( VERTICES, { pos = ( Vector(x, y, h1) ) } );
      table.insert( VERTICES, { pos = ( Vector(x + scale, y + scale, h4) ) } );
      table.insert( VERTICES, { pos = ( Vector(x + scale, y, h2) ) } );
    end
  end

  print("Setup physics...")
  self:SetModel("models/props_wasteland/rockgranite04c.mdl")
  self:PhysicsInit(SOLID_CUSTOM)
  self:PhysicsFromMesh( VERTICES )
  self:SetSolid(SOLID_VPHYSICS)
  self:SetMoveType(MOVETYPE_PUSH)
  self:EnableCustomCollisions( true )
  self:GetPhysicsObject():EnableMotion( false )
  self:GetPhysicsObject():SetMass(500)
  -- Create collision from generated verts
end
