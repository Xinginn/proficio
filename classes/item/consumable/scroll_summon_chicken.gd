extends Consumable

class_name Bandages

func _init(_crafter = null):
  label = "Parchemin d'Invocation de Poulet"
  _name = "scroll_summon_chicken"
  weight = 0.1
  description = "Renferme les incantations necessaires pour invoquer un terrible gallinacé."
  base_price = 150

func use(actor):
  actor.health_regain += 5
