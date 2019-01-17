roles = {
  Captain = {
    model = "models/player/barney.mdl",
    color = Color(200, 40, 40),
    desc = "The captain of the ship. Almost every major decision falls into the Captain's hands.",
    id = SE_CAPTAIN
  },
  Engineer = {
    model = "models/player/eli.mdl",
    color = Color(225, 155, 80),
    desc = "Engineer is a man who makes ship work. With a good engineer in a team ship will be always stable and fully functional",
    id = SE_ENGINEER
  },
  Scientist = {
    model = "models/player/kleiner.mdl",
    color = Color(100, 100, 255),
    desc = "This man bla bla researchs, bla bla bla",
    id = SE_SCIENTIST
  },
  Pilot = {
    model = "models/player/kleiner.mdl",
    color = Color(190, 170, 30),
    desc = "Mr. Fuck",
    id = SE_PILOT
  },
  Shooter = {
    model = "models/player/kleiner.mdl",
    color = Color(55, 135, 100),
    desc = "Mr. Fuck",
    id = SE_WEAP_SPEC
  },
}

se_roles = {}
se_roles[SE_CAPTAIN] = roles.Captain
se_roles[SE_ENGINEER] = roles.Engineer
se_roles[SE_SCIENTIST] = roles.Scientist
se_roles[SE_PILOT] = roles.Pilot
se_roles[SE_WEAP_SPEC] = roles.Shooter
