se_star_material = Material("se_materials/star_texture.png", "smooth")
se_star_shine = Material("se_materials/star_shine.png", "smooth")
se_skybox = Material("se_materials/skybox.png")
se_tile = Material("se_materials/tiles/tile.png")
se_clouds = Material("se_materials/planets/clouds.png")

se_planet_materials = {}

local se_earth_tex = Material("se_materials/planets/earth.png", "smooth")

se_planet_materials[SE_PLANET_EARTHLIKE] = se_earth_tex
se_planet_materials[SE_PLANET_DUST] = Material("se_materials/planets/desertlike_planet.png", "smooth")
se_planet_materials[SE_PLANET_FROZEN] = se_earth_tex
se_planet_materials[SE_PLANET_GAS] = Material("se_materials/planets/gas_giant.png", "smooth")

se_planet_shadow= Material("se_materials/planets/shadow.png", "smooth")
