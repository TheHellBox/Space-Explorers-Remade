function se_captain_exists()
  for k, v in pairs(player.GetAll()) do
    if v.se_role == SE_CAPTAIN then
      return true
    end
  end
  return false
end

net.Receive("se_choose_role", function(len, ply)
  local role = net.ReadInt(4)
  -- If captain role is taken, then we force player to choose role again
  if role == SE_CAPTAIN and se_captain_exists() then
    ply:Spawn()
    return
  end
  -- If everything is ok, then we respawn player with new role
  ply.se_role = role
  ply:Spawn()
end)
