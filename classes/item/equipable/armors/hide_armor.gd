extends Equipable

class_name HideArmor

func _init(crafter = null):
  #valeurs immuables (nom, poids)
  label = "Armure de peaux"
  _name = "hide_armor"
  weight = 3.0
  description = "Une armure rudimentaire faite de peaux d'animaux."
  # calcul des valeur selon niveau de crafteur
  var base_def = 4
  var bonus_def = 0
  
  if crafter != null:
    bonus_def = int(crafter.leatherwork * 0.35)
  
  def = WearAttribute.new(base_def + bonus_def, "light_armors", 0.1)

# override du getter
func _get_stats_text() -> String:
  return "Défense %+d" % [def.value]
