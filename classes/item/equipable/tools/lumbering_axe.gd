extends Equipable

class_name LumberingAxe

func _init(crafter = null):
  #valeurs immuables (nom, poids)
  label = "Hache de bûcheron"
  _name = "lumbering_axe"
  weight = 2.0
  description = "Un outil idéal pour couper du bois. Peut également servir d'arme."
  base_price = 40
  slots = ["main_hand"]
  granted_techs = [8]
  # calcul des valeur selon niveau de crafteur
  var base_lumberjack = 3
  var bonus_lumberjack = 0
  var base_atk = 5
  var bonus_atk = 0
  
  # calcul des values de base + bonus du au skill de craft
  if crafter != null:
    bonus_lumberjack = int(crafter.get_total_attribute("toolmaking") * 0.25)
    bonus_atk = int(crafter.get_total_attribute("toolmaking") * 0.2)
  
  # attributions des wear attribute de l'objet crafté, et déclaration des mastery les augmentant 
  # et ratio de boost et gain d'xp en l'utilisant
  lumberjack = WearAttribute.new(base_lumberjack + bonus_lumberjack, "tools", 0.1)
  atk = WearAttribute.new(base_atk + bonus_atk, "tools", 0.1)

# override du getter
func _get_stats_text() -> String:
  return "Bûcheron %+d \nAttaque %+d" % [lumberjack.value, atk.value]

func _get_final_stats_text() -> String:
  var atk_value: int
  atk_value = atk.value * (1.0 + (GameManager.player_actor.get_total_attribute(atk.attribute_name) - 1) * atk.ratio)
  var lumberjack_value: int
  lumberjack_value = lumberjack.value * (1.0 + (GameManager.player_actor.get_total_attribute(lumberjack.attribute_name) - 1) * lumberjack.ratio)
  return "Bûcheron %+d \nAttaque %+d" % [lumberjack_value, atk_value]
