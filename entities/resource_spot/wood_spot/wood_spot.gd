extends ResourceSpot

func _ready():
  skill = "gathering"
  xp_gain = 5
  duration = 1000
  remaining_harvests = 10
  
func harvest(harvester) -> void:
  #gain de ressources
  var resource_gain = GameManager.rng.randi_range(1,3)
  harvester.add_resource("wood", resource_gain)
  # l'appel a xp_gain et la gestion de perte de remaing_harvest est gérée par la classe mère
  .harvest(harvester)

