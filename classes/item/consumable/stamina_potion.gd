extends Consumable

class_name StaminaPotion

func _init(_crafter = null):
  label = "Potion d'énergie"
  _name = "stamina_potion"
  weight = 0.1
  description = "Une potion au léger gout de pommes. Restaure graduellement 5 énergie"

func use(actor):
  actor.stamina_regain += 5
  stack -= 1
