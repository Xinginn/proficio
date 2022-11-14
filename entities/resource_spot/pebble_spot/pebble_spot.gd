extends ResourceSpot

func _ready():
  skill = "gathering"
  xp_gain = 4
  duration = 2.0
  stamina_loss_while_harvesting = 1.0
  remaining_harvests = 10
  # randomisation nombre recoltes
  var harvest_number_modifier = GameManager.rng.randi_range(-2,2)
  remaining_harvests += harvest_number_modifier
  
func harvest(harvester) -> void:
  var gain_text = ""
  #gain de ressources
  var stone_gain = clamp(GameManager.rng.randi_range(0,2), 0, 1)
  harvester.add_resource("stone", stone_gain)
  gain_text += "+%d %s" % [stone_gain, Dictionaries.resource_names["stone"] ]
  
  var ore_gain = clamp(GameManager.rng.randi_range(0,2), 0, 1)
  if ore_gain > 0:
    harvester.add_resource("ore", ore_gain)
    gain_text += "\n+%d %s" % [ore_gain, Dictionaries.resource_names["ore"] ]
    
  var cristal_gain = clamp(GameManager.rng.randi_range(-2,1), 0, 1) if (stone_gain + ore_gain > 0) else 1
  if cristal_gain > 0:
    harvester.add_resource("cristal", cristal_gain)
    gain_text += "\n+%d %s" % [cristal_gain, Dictionaries.resource_names["cristal"] ]
    
  harvester.display_pop_up(gain_text)
  # l'appel a xp_gain et la gestion de perte de remaing_harvest est gérée par la classe mère
  .harvest(harvester)
