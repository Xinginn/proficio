extends Consumable

class_name HealingPotion

func _init(_crafter = null):
  label = "Potion de Soins"
  _name = "healing_potion"
  weight = 0.2
  description = "Une décoction curative boisée. Restaure 5 points de santé."
  base_price = 15

func use(actor):
  actor.health += 5
