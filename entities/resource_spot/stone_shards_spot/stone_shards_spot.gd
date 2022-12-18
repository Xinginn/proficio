extends ResourceSpot

func _ready():
  skill = "mining"
  xp_gain = 4
  duration = 2.0
  stamina_loss_while_harvesting = 0.8
  remaining_harvests = 10
  # randomisation nombre recoltes
  var harvest_number_modifier = GameManager.rng.randi_range(-1,1)
  remaining_harvests += harvest_number_modifier
  
func harvest(harvester) -> void:
  var gain_text = ""
  #gain de ressources
  var stone_gain = clamp(GameManager.rng.randi_range(1, 3), 1, 2)
  harvester.add_resource("stone", stone_gain)
  gain_text += "+%d %s" % [stone_gain, Dictionaries.resource_names["stone"] ]
  # l'appel a xp_gain et la gestion de perte de remaing_harvest est gérée par la classe mère
  harvester.display_pop_up(gain_text)
  .harvest(harvester)
