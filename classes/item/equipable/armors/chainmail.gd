extends Equipable

class_name Chainmail

func _init(crafter = null):
  #valeurs immuables (nom, poids)
  label = "Cote de mailles"
  _name = "chainmail"
  weight = 3.0
  description = "Une protection de corps composées d'anneaux de fer enchevetrés."
  base_price = 60
  slots = ["body"]
  # calcul des valeur selon niveau de crafteur
  var base_def = 8
  var bonus_def = 0
  
  # calcul des values de base + bonus du au skill de craft
  if crafter != null:
    bonus_def = int(crafter.get_total_attribute("armorsmith") * 0.35)
  
  # declaration des wear attribute: valeur inhérente à l'objet crafté, mastery l'augmentant 
  # et ratio de boost et gain d'xp en l'utilisant
  def = WearAttribute.new(base_def + bonus_def, "heavy_armors", 0.1)

# override du getter
func _get_stats_text() -> String:
  return "Défense %+d" % [def.value]
  
func _get_final_stats_text() -> String:
  var def_value: int
  def_value = def.value * (1.0 + (GameManager.player_actor.get_total_attribute(def.attribute_name) - 1) * def.ratio)
  return "Défense %+d" % [def_value]
