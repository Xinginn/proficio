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
    bonus_def = int(crafter.leatherwork * 0.35)
    bonus_move_speed = int(crafter.leatherwork * 0.1)
  
  # declaration des wear attribute: valeur inhérente à l'objet crafté, mastery l'augmentant 
  # et ratio de boost et gain d'xp en l'utilisant
  def = WearAttribute.new(base_def + bonus_def, "light_armors", 0.1)
  move_speed = WearAttribute.new(base_move_speed + bonus_move_speed, "light_armors", 0.05)

# override du getter
func _get_stats_text() -> String:
  return "Défense %+d \nVitesse %+d" % [def.value, move_speed.value]
