extends Consumable

class_name StaminaPotion

func _init(_crafter = null):
  label = "Potion d'énergie"
  _name = "stamina_potion"
  weight = 0.1
  description = "Une potion au léger gout de pommes. Restaure 5 énergie"
  base_price = 15

func use(actor):
  actor.stamina += 5
