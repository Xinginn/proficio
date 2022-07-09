extends Equipable

class_name WalkingShoes

func _init(crafter = null):
  #valeurs immuables (nom, poids)
  label = "Chaussures de marche"
  _name = "walking_shoes"
  weight = 0.6
  description = "Des chaussures confortables à porter."
  # calcul des valeur selon niveau de crafteur

  var base_move_speed = 10
  var bonus_move_speed = 0
  var base_max_stamina = 8
  var bonus_max_stamina = 0
  
  # calcul des values de base + bonus du au skill de craft
  if crafter != null:
    bonus_move_speed = int(crafter.shoemaking * 0.5)
    bonus_max_stamina = int(crafter.shoemaking * 0.2)
  
  # declaration des wear attribute: valeur inhérente à l'objet crafté, mastery l'augmentant 
  # et ratio de boost et gain d'xp en l'utilisant
  move_speed = WearAttribute.new(base_move_speed + bonus_move_speed, "shoes", 0.05)
  max_stamina = WearAttribute.new(base_max_stamina + bonus_max_stamina, "shoes", 0.1)

# override du getter
func _get_stats_text() -> String:
  return "Vitesse: %+d \nEndurance %+d" % [move_speed.value, max_stamina.value]
