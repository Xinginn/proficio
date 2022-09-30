extends ResourceSpot

func _ready():
  skill = "gathering"
  xp_gain = 3
  duration = 120
  stamina_loss_while_harvesting = 1.0
  remaining_harvests = 6
  # randomisation nombre recoltes
  var harvest_number_modifier = GameManager.rng.randi_range(-1,1)
  remaining_harvests += harvest_number_modifier
  
func harvest(harvester) -> void:
  var gain_text = ""
  #gain de ressources
  var fiber_gain = GameManager.rng.randi_range(1,3)
  harvester.add_resource("fiber", fiber_gain)
  gain_text += "+%d %s" % [fiber_gain, Dictionaries.resource_names["fiber"] ]
  var grain_gain = clamp(GameManager.rng.randi_range(-2,2), 0, 2)
  if grain_gain > 0:
    harvester.add_resource("grain", grain_gain)
    gain_text += "\n+%d %s" % [grain_gain, Dictionaries.resource_names["grain"] ]
  var herb_gain = clamp(GameManager.rng.randi_range(-2,1), 0, 1)
  if herb_gain > 0:
    harvester.add_resource("herb", herb_gain)
    gain_text += "\n+%d %s" % [herb_gain, Dictionaries.resource_names["herb"] ]
  harvester.display_pop_up(gain_text)
  # l'appel a xp_gain et la gestion de perte de remaing_harvest est gérée par la classe mère
  .harvest(harvester)
