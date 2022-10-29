extends ResourceSpot

func _ready():
  skill = "gathering"
  xp_gain = 2
  duration = 2.0
  stamina_loss_while_harvesting = 0.7
  remaining_harvests = 10
  # randomisation nombre recoltes
  var harvest_number_modifier = GameManager.rng.randi_range(-2,2)
  remaining_harvests += harvest_number_modifier
  
func harvest(harvester) -> void:
  var gain_text = ""
  #gain de ressources
  var wood_gain = GameManager.rng.randi_range(1, 2)
  harvester.add_resource("wood", wood_gain)
  gain_text += "+%d %s" % [wood_gain, Dictionaries.resource_names["wood"] ]
  # l'appel a xp_gain et la gestion de perte de remaing_harvest est gérée par la classe mère
  harvester.display_pop_up(gain_text)
  .harvest(harvester)
