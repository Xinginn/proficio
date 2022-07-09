extends Equipable

class_name LumberingAxe

func _init(crafter = null):
  #valeurs immuables (nom, poids)
  label = "Hache de bûcheron"
  _name = "lumbering_axe"
  weight = 2.0
  description = "Un outil idéal pour couper du bois. Peut également servir d'arme."
  # calcul des valeur selon niveau de crafteur
  var base_lumberjack = 3
  var bonus_lumberjack = 0
  var base_atk = 5
  var bonus_atk = 0
  
  # calcul des values de base + bonus du au skill de craft
  if crafter != null:
    bonus_lumberjack = int(crafter.toolmaking * 0.2)
    bonus_atk = int(crafter.toolmaking * 0.1)
  
  # attributions des wear attribute de l'objet crafté, et déclaration des mastery les augmentant 
  # et ratio de boost et gain d'xp en l'utilisant
  lumberjack = WearAttribute.new(base_lumberjack + bonus_lumberjack, "tools", 0.1)
  atk = WearAttribute.new(base_atk + bonus_atk, "tools", 0.1)

# override du getter
func _get_stats_text() -> String:
  return "Bûcheron %+d \nAttaque %+d" % [lumberjack.value, atk.value]
