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
    bonus_atk = int(crafter.get_total_attribute("weaponsmith") * 0.1)
    bonus_def = int(crafter.get_total_attribute("weaponsmith") * 0.1)
  
  # declaration des wear attribute: valeur inhérente à l'objet crafté, mastery l'augmentant 
  # et ratio de boost et gain d'xp en l'utilisant
  atk = WearAttribute.new(base_atk + bonus_atk, "swords", 0.2)
  def = WearAttribute.new(base_def + bonus_def, "swords", 0.05)

# override du getter
func _get_stats_text() -> String:
  return "Attaque %+d \nDéfense %+d" % [atk.value, def.value]

func _get_final_stats_text() -> String:
  var atk_value: int
  atk_value = atk.value * (1.0 + (GameManager.player_actor.get_total_attribute(atk.attribute_name) - 1) * atk.ratio)
  var def_value: int
  def_value = def.value * (1.0 + (GameManager.player_actor.get_total_attribute(def.attribute_name) - 1) * def.ratio)
  return "Attaque %+d \nDéfense %+d" % [atk_value, def_value]
