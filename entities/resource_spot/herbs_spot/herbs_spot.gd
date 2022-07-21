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
  #gain de ressources
  var fiber_gain = GameManager.rng.randi_range(1,3)
  harvester.add_resource("fiber", fiber_gain)
  var wheat_gain = clamp(GameManager.rng.randi_range(-2,2), 0, 2)
  if wheat_gain > 0:
    harvester.add_resource("wheat", wheat_gain)
  var herb_gain = clamp(GameManager.rng.randi_range(-2,1), 0, 1)
  if herb_gain > 0:
    harvester.add_resource("herb", herb_gain)
  # l'appel a xp_gain et la gestion de perte de remaing_harvest est gérée par la classe mère
  .harvest(harvester)
