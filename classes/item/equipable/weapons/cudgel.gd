extends Equipable

class_name Cudgel

func _init(crafter = null):
  #valeurs immuables (nom, poids)
  label = "Gourdin"
  _name = "cudgel"
  weight = 0.8
  description = "Un baton court adapté au combat."
  slots = ["main_hand"]
  # calcul des valeur selon niveau de crafteur
  var base_atk = 4
  var bonus_atk = 0 
  
  # calcul des values de base + bonus du au skill de craft
  if crafter != null:
    bonus_atk = int(crafter.woodcarving * 0.2)
  
  # declaration des wear attribute: valeur inhérente à l'objet crafté, mastery l'augmentant 
  # et ratio de boost et gain d'xp en l'utilisant
  atk = WearAttribute.new(base_atk + bonus_atk, "masses", 0.1)

# override du getter
func _get_stats_text() -> String:
  return "Attaque %+d" % [atk.value]
