extends Equipable

class_name Gladius

func _init(crafter = null):
  #valeurs immuables (nom, poids)
  label = "Glaive"
  _name = "gladius"
  weight = 1.2
  description = "Une épée de conception ancienne, courte et large."
  slots = ["main_hand"]
  # calcul des valeur selon niveau de crafteur
  var base_atk = 4
  var bonus_atk = 0
  var base_def = 2 
  var bonus_def = 0
  
  # calcul des values de base + bonus du au skill de craft
  if crafter != null:
    bonus_atk = int(crafter.weaponsmith * 0.1)
    bonus_def = int(crafter.weaponsmith * 0.1)
  
  # declaration des wear attribute: valeur inhérente à l'objet crafté, mastery l'augmentant 
  # et ratio de boost et gain d'xp en l'utilisant
  atk = WearAttribute.new(base_atk + bonus_atk, "swords", 0.2)
  def = WearAttribute.new(base_def + bonus_def, "swords", 0.05)

# override du getter
func _get_stats_text() -> String:
  return "Attaque %+d \nDéfense %+d" % [atk.value, def.value]
