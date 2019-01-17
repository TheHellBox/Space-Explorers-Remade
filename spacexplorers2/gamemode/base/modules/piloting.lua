if !se_pilot_chair then
  se_pilot_chair = nil
end
se_ship_controls_buttons = {}
-- Ship controls.
se_ship_controls_buttons[KEY_W] = {
  vector = Vector(-15, 0, 0)
}
se_ship_controls_buttons[KEY_S] = {
  vector = Vector(15, 0, 0)
}
se_ship_controls_buttons[KEY_Z] = {
  vector = Vector(0, 15, 0)
}
se_ship_controls_buttons[KEY_X] = {
  vector = Vector(0, -15, 0)
}
se_ship_controls_buttons[KEY_A] = {
  rotation = Angle(0, -0.5, 0)
}
se_ship_controls_buttons[KEY_D] = {
  rotation = Angle(0, 0.5, 0)
}

sound.Add( {
	name = "enzo_engine_idle",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = { 95, 110 },
	sound = "ambience/mechwhine.wav"
} )

function se_spawn_pilot_chair()
  -- Remove previous seat
  if IsValid(se_pilot_chair) then
    se_pilot_chair:Remove()
  end
  -- Create seat
  local seat = ents.Create( "prop_vehicle_prisoner_pod" )
  seat:SetModel( "models/nova/jeep_seat.mdl" )
  seat:SetKeyValue( "vehiclescript", "scripts/vehicles/prisoner_pod.txt" )
  seat:SetKeyValue( "limitview", "0" )
  seat:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
  local physobj = seat:GetPhysicsObject()
  if(IsValid(physobj))then
    physobj:EnableCollisions( false )
  end
  seat:SetPos(Vector(-13795, 14977, 44))
  seat:SetAngles(Angle(0, -90, 0))
  seat:Spawn()
  seat:Activate()
  seat:PhysicsDestroy()
  -- Attach seat to global
  se_pilot_chair = seat
end

-- Spawn player near chair, to spawning in the roof
hook.Add("PlayerLeaveVehicle", "se_leave_pilot_seat", function(ply, vehicle)
  if vehicle == se_pilot_chair then
	   ply:SetPos(Vector(-13921,14977,5))
  end
end)

-- React to players input
hook.Add("PlayerButtonDown", "se_pilot_controls", function(ply, button)
  -- If player piloting
  if ply:GetVehicle() != se_pilot_chair then return end
  se_pilot_chair:StopSound( "enzo_engine_idle" )
  -- If we have such control button
  if !se_ship_controls_buttons[button] then return end
  -- Emit engine sound. NOTE: Change this one
  se_pilot_chair:EmitSound( "enzo_engine_idle", 75, 100, 1, CHAN_AUTO )
  local action = se_ship_controls_buttons[button]
  -- We copy action and write it into ship vector/rot
  if action.vector then se_ship.future_vector = Vector(action.vector.x, action.vector.y, action.vector.z) end
  if action.rotation then se_ship.future_rotation = Angle(action.rotation.x, action.rotation.y, action.rotation.z) end
end)

-- React to players input
hook.Add("PlayerButtonUp", "se_pilot_controls_up", function(ply, button)
  -- If player piloting
  if ply:GetVehicle() != se_pilot_chair then return end
  -- If we have such control button
  if !se_ship_controls_buttons[button] then return end
  -- Stop engine sound
  se_pilot_chair:StopSound( "enzo_engine_idle" )
  local action = se_ship_controls_buttons[button]
  -- Stop ship movement
  for k=1,3 do
    -- If button was about changing position
    if action.vector then
      se_ship.future_vector[k] = 0
    end
    -- If button was about changing rotation
    if action.rotation then
      se_ship.future_rotation[k] = 0
    end
  end
end)
