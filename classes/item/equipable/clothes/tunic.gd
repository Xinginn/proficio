extends Equipable

class_name Tunic

func _init(crafter = null):
  #valeurs immuables (nom, poids)
  label = "Tunique"
  _name = "tunic"
  weight = 2.0
  description = "Un vêtement léger, idéal pour travailler."
  slots = ["body"]
  # calcul des valeur selon niveau de crafteur
  var base_max_stamina = 4
  var bonus_max_stamina = 0
  
  # calcul des values de base + bonus du au skill de craft
  if crafter != null:
    bonus_max_stamina = int(crafter.weaving * 0.2)
  
  # declaration des wear attribute: valeur inhérente à l'objet crafté, mastery l'augmentant 
  # et ratio de boost et gain d'xp en l'utilisant
  max_stamina = WearAttribute.new(base_max_stamina + bonus_max_stamina, "clothes", 0.05)

# override du getter
func _get_stats_text() -> String:
  return "Endurance %+d" % [max_stamina.value]
