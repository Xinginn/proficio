extends Equipable

class_name ShortBow

func _init(crafter = null):
  #valeurs immuables (nom, poids)
  label = "Arc Court"
  _name = "short_bow"
  weight = 0.8
  description = "un arc de petite taille, facile à bander. Adapté aux débutants."
  base_price = 25
  slots = ["main_hand"]
  granted_techs = []
  # calcul des valeur selon niveau de crafteur
  var base_atk = 5
  var bonus_atk = 0 
  
  # calcul des values de base + bonus du au skill de craft
  if crafter != null:
    bonus_atk = int(crafter.get_total_attribute("woodcarving") * 0.2)
  
  # declaration des wear attribute: valeur inhérente à l'objet crafté, mastery l'augmentant 
  # et ratio de boost et gain d'xp en l'utilisant
  atk = WearAttribute.new(base_atk + bonus_atk, "bows", 0.1)

# override du getter
func _get_stats_text() -> String:
  return "Attaque %+d" % [atk.value]

func _get_final_stats_text() -> String:
  var atk_value: int
  atk_value = atk.value * (1.0 + (GameManager.player_actor.get_total_attribute(atk.attribute_name) - 1) * atk.ratio)
  return "Attaque %+d" % [atk_value]
