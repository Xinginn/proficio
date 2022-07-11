extends Equipable

class_name IronHelmet

func _init(crafter = null):
  #valeurs immuables (nom, poids)
  label = "Casque de fer"
  _name = "iron_helmet"
  weight = 1.5
  description = "Une pièce de metal protègeant le crâne."
  slots = ["head"]
  # calcul des valeur selon niveau de crafteur
  var base_def = 3
  var bonus_def = 0
  
  # calcul des values de base + bonus du au skill de craft
  if crafter != null:
    bonus_def = int(crafter.armorsmith * 0.2)
  
  # declaration des wear attribute: valeur inhérente à l'objet crafté, mastery l'augmentant 
  # et ratio de boost et gain d'xp en l'utilisant
  def = WearAttribute.new(base_def + bonus_def, "heavy_armors", 0.2)

# override du getter
func _get_stats_text() -> String:
  return "Défense %+d" % [def.value]
