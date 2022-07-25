extends Equipable

class_name LeatherJacket

func _init(crafter = null):
  #valeurs immuables (nom, poids)
  label = "Veste de cuir"
  _name = "leather_jacket"
  weight = 4.0
  description = "Une armure légère faite en cuir d'animaux."
  slots = ["body"]
  # calcul des valeur selon niveau de crafteur
  var base_def = 6
  var bonus_def = 0
  var base_move_speed = 12
  var bonus_move_speed = 0
  
  # calcul des values de base + bonus du au skill de craft
  if crafter != null:
    bonus_def = int(crafter.get_total_attribute("leatherwork") * 0.35)
    bonus_move_speed = int(crafter.get_total_attribute("leatherwork") * 0.1)
  
  # declaration des wear attribute: valeur inhérente à l'objet crafté, mastery l'augmentant 
  # et ratio de boost et gain d'xp en l'utilisant
  def = WearAttribute.new(base_def + bonus_def, "light_armors", 0.1)
  move_speed = WearAttribute.new(base_move_speed + bonus_move_speed, "light_armors", 0.05)

# override du getter
func _get_stats_text() -> String:
  return "Défense %+d \nVitesse %+d" % [def.value, move_speed.value]

func _get_final_stats_text() -> String:
  var def_value: int
  def_value = def.value * (1.0 + (GameManager.player_actor.get_total_attribute(def.attribute_name) - 1) * def.ratio)
  var move_speed_value: int
  move_speed_value = move_speed.value * (1.0 + (GameManager.player_actor.get_total_attribute(move_speed.attribute_name) - 1) * move_speed.ratio)
  return "Défense %+d\nVitesse %+d" % [def_value, move_speed_value]

