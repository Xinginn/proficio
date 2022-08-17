extends Consumable

class_name Bandages

func _init(_crafter = null):
  label = "Bandages"
  _name = "bandages"
  weight = 0.1
  description = "Des fibres végétales tissées. Restaure graduellement 5 santé."
  base_price = 15

func use(actor):
  actor.health_regain += 5
