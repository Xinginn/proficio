extends ResourceSpot

func _ready():
  skill = "skinning"
  xp_gain = 4
  duration = 1.5
  stamina_loss_while_harvesting = 0.8
  remaining_harvests = 4
  # randomisation nombre recoltes
  var harvest_number_modifier = GameManager.rng.randi_range(-0,1)
  remaining_harvests += harvest_number_modifier
  
func harvest(harvester) -> void:
  var gain_text = ""
  #gain de ressources
  var skin_gain = GameManager.rng.randi_range(2, 4)
  harvester.add_resource("skin", skin_gain)
  gain_text += "+%d %s" % [skin_gain, Dictionaries.resource_names["skin"] ]
  # l'appel a xp_gain et la gestion de perte de remaing_harvest est gérée par la classe mère
  harvester.display_pop_up(gain_text)
  .harvest(harvester)
