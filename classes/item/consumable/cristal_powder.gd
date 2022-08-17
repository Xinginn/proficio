extends Consumable

class_name CristalPowder

func _init(_crafter = null):
  label = "Poudre de cristaux"
  _name = "cristal_powder"
  weight = 0.1
  description = "Des cristaux réduits en poudre. Restaures graduellement 5 mana."
  base_price = 20

func use(actor):
  actor.mana_regain += 2
