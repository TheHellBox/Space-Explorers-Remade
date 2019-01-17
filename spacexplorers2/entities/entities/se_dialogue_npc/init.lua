AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
  self:SetModel("models/alyx.mdl")
  self:SetSolid(SOLID_BBOX)
  self:SetHullType( HULL_HUMAN )
  self:SetHullSizeNormal( )
  self:SetNPCState( NPC_STATE_SCRIPT )
  self:CapabilitiesAdd( CAP_ANIMATEDFACE and CAP_TURN_HEAD)
  self:DropToFloor()
  self:SetUseType(SIMPLE_USE)
  self:SetMaterial("models/wireframe")
  self:SetMaxYawSpeed( 90 )
end

function ENT:Think()
  self:NextThink(CurTime())
  return true
end
