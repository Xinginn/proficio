extends ResourceSpot

func _ready():
  skill = "gathering"
  xp_gain = 5
  stamina_loss_while_harvesting = 2.0
  duration = 200
  remaining_harvests = 4
  # randomisation nombre recoltes
  var harvest_number_modifier = GameManager.rng.randi_range(-1,1)
  remaining_harvests += harvest_number_modifier
  
func harvest(harvester) -> void:
  #gain de ressources
  var wood_gain = GameManager.rng.randi_range(1,3)
  harvester.add_resource("wood", wood_gain)
  # l'appel a xp_gain et la gestion de perte de remaing_harvest est gérée par la classe mère
  .harvest(harvester)
