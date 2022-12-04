extends Equipable

class_name Tunic

func _init(crafter = null):
  #valeurs immuables (nom, poids)
  label = "Tunique"
  _name = "tunic"
  weight = 2.0
  description = "Un vêtement léger, idéal pour travailler."
  base_price = 20
  slots = ["body"]
  granted_techs = []
  # calcul des valeur selon niveau de crafteur
  var base_max_stamina = 4
  var bonus_max_stamina = 0
  
  # calcul des values de base + bonus du au skill de craft
  if crafter != null:
    bonus_max_stamina = int(crafter.get_total_attribute("weaving") * 0.2)
  
  # declaration des wear attribute: valeur inhérente à l'objet crafté, mastery l'augmentant 
  # et ratio de boost et gain d'xp en l'utilisant
  max_stamina = WearAttribute.new(base_max_stamina + bonus_max_stamina, "clothes", 0.05)

# override du getter
func _get_stats_text() -> String:
  return "Endurance %+d" % [max_stamina.value]

func _get_final_stats_text() -> String:
  var max_stamina_value: int
  max_stamina_value = max_stamina.value * (1.0 + (GameManager.player_actor.get_total_attribute(max_stamina.attribute_name) - 1) * max_stamina.ratio)
  return "Endurance %+d" % [max_stamina_value]

