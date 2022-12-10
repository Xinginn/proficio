extends Consumable

class_name ScrollSummonChicken

func _init(_crafter = null):
  label = "Parchemin d'Invocation de Poulet"
  _name = "scroll_summon_chicken"
  weight = 0.1
  description = "Contient les incantations necessaires pour invoquer un terrible gallinacé."
  base_price = 150

func use(actor):
  actor.launch_spot_targeted(Data.techs[4], actor.global_position + Vector2(36,0), true)
