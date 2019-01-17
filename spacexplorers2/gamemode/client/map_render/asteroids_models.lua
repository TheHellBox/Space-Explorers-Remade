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
