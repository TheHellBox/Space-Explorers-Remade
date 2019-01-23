se_dialogues = {
  {
    name = ""
    text = "Отдавайте ваше добро или вас самим несдобровать. За проезд платим по 10 кредитов",
    fn_enabled = false,
    options = {
      {
        name = "Отдать 10 кредитов",
        text = "Молодцы, теперь валите отсюда, и держите рот на замке",
        fn_enabled = false,
        inventory_ch = {
          "credits" = -10
        }
      },
      {
        name = "Не отдавать ничего",
        text = "Вам крышка, поняли? К-Р-Ы-Ш-К-А",
        fn_enabled = false,
        enemy_attack = true,
        enemy_level_min = 1,
        enemy_level_max = 5,
      },
    }
  }
}
