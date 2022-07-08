extends Equipable

class_name HuntingKnife

func _init(crafter = null):
  #valeurs immuables (nom, poids)
  label = "Couteau de chasse"
  _name = "hunting_knife"
  weight = 0.5
  description = "Un couteau utilitaire."
  # calcul des valeur selon niveau de crafteur
  var base_atk = 4
  var base_skinning = 2
  var bonus_atk = 0 
  var bonus_skinning = 0
  
  if crafter != null:
    bonus_atk = int(crafter.toolmaking * 0.1)
    bonus_skinning = int(crafter.leatherwork * 0.2)
  
  atk = WearAttribute.new(base_atk + bonus_atk, "tools", 0.1)
  skinning = WearAttribute.new(base_skinning + bonus_skinning, "tools", 0.1)

# override du getter
func _get_stats_text() -> String:
  return "Attaque %+d \nDépeçage %+d" % [atk.value, skinning.value]
