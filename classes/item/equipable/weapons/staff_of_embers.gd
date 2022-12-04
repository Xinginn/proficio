extends Equipable

class_name StaffOfEmbers

func _init(crafter = null):
  #valeurs immuables (nom, poids)
  label = "Sceptre de braises"
  _name = "staff_of_embers"
  weight = 0.8
  description = "Un baton de pyromancien novice."
  base_price = 20
  slots = ["main_hand"]
  granted_techs = [1]
  # calcul des valeur selon niveau de crafteur
  var base_atk = 1
  var bonus_atk = 0
  var base_fire_magic = 4
  var bonus_fire_magic = 0
  
  # calcul des values de base + bonus du au skill de craft
  if crafter != null:
    bonus_atk = int(crafter.get_total_attribute("woodcarving") * 0.1)
    bonus_fire_magic = int(crafter.get_total_attribute("woodcarving") * 0.15)
  
  # declaration des wear attribute: valeur inhérente à l'objet crafté, mastery l'augmentant 
  # et ratio de boost et gain d'xp en l'utilisant
  atk = WearAttribute.new(base_atk + bonus_atk, "focus", 0.1)
  fire_magic = WearAttribute.new(base_atk + bonus_atk, "focus", 0.1)

# override du getter
func _get_stats_text() -> String:
  return "Attaque %+d \nMagie flamboyante%+d" % [atk.value, fire_magic.value]

func _get_final_stats_text() -> String:
  var atk_value: int
  atk_value = atk.value * (1.0 + (GameManager.player_actor.get_total_attribute(atk.attribute_name) - 1) * atk.ratio)
  var fire_magic_value: int
  fire_magic_value = fire_magic.value * (1.0 + (GameManager.player_actor.get_total_attribute(fire_magic.attribute_name) - 1) * fire_magic.ratio)
  return "Attaque %+d \nMagie flamboyante%+d" % [atk_value, fire_magic_value]
