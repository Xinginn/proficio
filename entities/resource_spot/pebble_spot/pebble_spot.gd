extends ResourceSpot

func _ready():
  skill = "gathering"
  xp_gain = 4
  duration = 130
  stamina_loss_while_harvesting = 1.0
  remaining_harvests = 4
  # randomisation nombre recoltes
  var harvest_number_modifier = GameManager.rng.randi_range(-1,1)
  remaining_harvests += harvest_number_modifier
  
func harvest(harvester) -> void:
  #gain de ressources
  var stone_gain = GameManager.rng.randi_range(1,3)
  harvester.add_resource("stone", stone_gain)
  var ore_gain = clamp(GameManager.rng.randi_range(-2,2), 0, 2)
  if ore_gain > 0:
    harvester.add_resource("ore", ore_gain)
  var cristal_gain = clamp(GameManager.rng.randi_range(-2,1), 0, 1)
  if cristal_gain > 0:
    harvester.add_resource("cristal", cristal_gain)
  # l'appel a xp_gain et la gestion de perte de remaing_harvest est gérée par la classe mère
  .harvest(harvester)
