extends Equipable

class_name HuntingKnife

func _init(crafter = null):
  #valeurs immuables (nom, poids)
  label = "Couteau de chasse"
  _name = "hunting_knife"
  weight = 0.5
  description = "Un couteau utilitaire qui facilite le dépeçage."
  slots = ["main_hand"]
  # calcul des valeur selon niveau de crafteur
  var base_atk = 4
  var bonus_atk = 0
  var base_skinning = 2
  var bonus_skinning = 0
  
  # calcul des values de base + bonus du au skill de craft
  if crafter != null:
    bonus_atk = int(crafter.toolmaking * 0.1)
    bonus_skinning = int(crafter.toolmaking * 0.2)
  
  # declaration des wear attribute: valeur inhérente à l'objet crafté, mastery l'augmentant 
  # et ratio de boost et gain d'xp en l'utilisant
  atk = WearAttribute.new(base_atk + bonus_atk, "tools", 0.1)
  skinning = WearAttribute.new(base_skinning + bonus_skinning, "tools", 0.1)

# override du getter
func _get_stats_text() -> String:
  return "Attaque %+d \nDépeçage %+d" % [atk.value, skinning.value]
  
func _get_final_stats_text() -> String:
  var atk_value: int
  atk_value = atk.value * (1.0 + (GameManager.player_actor.get(atk.attribute_name) - 1) * atk.ratio)
  var skinning_value: int
  skinning_value = skinning.value * (1.0 + (GameManager.player_actor.get(skinning.attribute_name) - 1) * skinning.ratio)
  return "Attaque %+d \nDépeçage %+d" % [atk_value, skinning_value]
