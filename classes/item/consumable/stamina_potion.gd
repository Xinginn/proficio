extends Consumable

class_name StaminaPotion

func _init():
  label = "Potion d'énergie"
  _name = "stamina_potion"
  weight = 0.1
  description = "Une potion au léger gout de pommes. Restaure graduellement 5 énergie"

func use(actor):
  actor.stamina += 5
  stack -= 1
