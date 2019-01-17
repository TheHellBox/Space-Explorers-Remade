-- Small functions for working with player, maybe that should be in base instead of lib

player_meta = FindMetaTable( "Player" )

-- Returns true if player is captain
function player_meta:IsCaptain()
  if self.se_role == SE_CAPTAIN then
    return true
  else
    return false
  end
end

-- Gets players role
function player_meta:GetRole()
  return self.se_role
end

-- Gets players role
function player_meta:GetRoleTable()
  return (se_roles[self.se_role] or se_roles[SE_ENGINEER])
end

-- Heals player(wtf, why there is nothing like that in gmod api)
function player_meta:Heal(amount)
  self:SetHealth(math.Clamp(self:Health() + amount, 0, self:GetMaxHealth()))
end
