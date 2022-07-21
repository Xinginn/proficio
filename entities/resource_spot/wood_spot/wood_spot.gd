extends ResourceSpot

func _ready():
  skill = "gathering"
  xp_gain = 2
  duration = 80
  stamina_loss_while_harvesting = 0.7
  remaining_harvests = 6
  # randomisation nombre recoltes
  var harvest_number_modifier = GameManager.rng.randi_range(-1,1)
  remaining_harvests += harvest_number_modifier
  
func harvest(harvester) -> void:
  #gain de ressources
  var wood_gain = GameManager.rng.randi_range(1, 2)
  harvester.add_resource("wood", wood_gain)
  # l'appel a xp_gain et la gestion de perte de remaing_harvest est gérée par la classe mère
  .harvest(harvester)
