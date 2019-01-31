print("SEDEBUG: Loading models...")

se_asteroid_models = {}

se_asteroids_model_small = ClientsideModel("models/props_wasteland/rockgranite01c.mdl")
se_asteroids_model_small:SetPos(Vector(-14638,11969,-1102))
se_asteroids_model_small:SetNoDraw(true)

se_asteroids_model_medium = ClientsideModel("models/props_wasteland/rockcliff01g.mdl")
se_asteroids_model_medium:SetPos(Vector(-14638,11969,-1102))
se_asteroids_model_medium:SetNoDraw(true)

se_asteroids_model_big = ClientsideModel("models/props_wasteland/rockcliff06i.mdl")
se_asteroids_model_big:SetPos(Vector(-14638,11969,-1102))
se_asteroids_model_big:SetNoDraw(true)

se_asteroid_models[SE_ASTEROID_SMALL] = se_asteroids_model_small
se_asteroid_models[SE_ASTEROID_MEDIUM] = se_asteroids_model_medium
se_asteroid_models[SE_ASTEROID_BIG] = se_asteroids_model_big



se_rocks = {}

se_rock_1 = ClientsideModel("models/props_debris/concrete_chunk05g.mdl")
se_rock_1:SetPos(Vector(0,0,0))
se_rock_1:SetNoDraw(true)

se_rock_2 = ClientsideModel("models/props_debris/concrete_chunk04a.mdl")
se_rock_2:SetPos(Vector(0,0,0))
se_rock_2:SetNoDraw(true)

se_rock_3 = ClientsideModel("models/props_debris/concrete_chunk03a.mdl")
se_rock_3:SetPos(Vector(0,0,0))
se_rock_3:SetNoDraw(true)

se_rock_4 = ClientsideModel("models/props_debris/concrete_chunk09a.mdl")
se_rock_4:SetPos(Vector(0,0,0))
se_rock_4:SetNoDraw(true)

se_rocks[1] = se_rock_1
se_rocks[2] = se_rock_2
se_rocks[3] = se_rock_3
se_rocks[4] = se_rock_4

print("SEDEBUG: Loading models complete")
