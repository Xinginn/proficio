extends Consumable

class_name CristalPowder

func _init(_crafter = null):
  label = "Poudre de cristaux"
  _name = "cristal_powder"
  weight = 0.1
  description = "Des cristaux réduits en poudre. Restaures graduellement 5 mana."

func use(actor):
  actor.mana += 2
  stack -= 1
