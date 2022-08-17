extends Consumable

class_name Bread

func _init(_crafter = null):
  label = "Pain"
  _name = "bread"
  weight = 0.1
  description = "Un plat simple mais qui tient au ventre. Restaure graduellement 2 énergie."
  base_price = 8

func use(actor):
  actor.stamina_regain += 2
