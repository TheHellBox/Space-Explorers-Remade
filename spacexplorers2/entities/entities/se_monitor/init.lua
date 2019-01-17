AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
  self:SetModel("models/dobr/StarPc.mdl")
  self:SetSolid(SOLID_VPHYSICS)
  self:SetUseType(SIMPLE_USE)
end
