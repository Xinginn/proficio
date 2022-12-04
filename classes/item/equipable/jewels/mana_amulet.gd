extends Equipable

class_name ManaAmulet

func _init(crafter = null):
  #valeurs immuables (nom, poids)
  label = "Amulette de mana"
  _name = "mana_amulet"
  weight = 0.5
  description = "Un bijou amplifiant la circulation du mana autour du porteur."
  base_price = 50
  slots = ["amulet"]
  granted_techs = []
  # calcul des valeur selon niveau de crafteur
  var base_max_mana = 3
  var bonus_max_mana = 0
  var base_mana_regen = 0.5
  var bonus_mana_regen = 0

  # calcul des values de base + bonus du au skill de craft
  if crafter != null:
    bonus_max_mana = int(crafter.get_total_attribute("enchanting") * 0.1)
    bonus_mana_regen = stepify((crafter.get_total_attribute("enchanting") * 0.025), 0.1)
  
  # declaration des wear attribute: valeur inhérente à l'objet crafté, mastery l'augmentant 
  # et ratio de boost et gain d'xp en l'utilisant
  max_mana = WearAttribute.new(base_max_mana + bonus_max_mana, "jewels", 0.1)
  mana_regen = WearAttribute.new(base_mana_regen + bonus_mana_regen, "jewels", 0.05)



# override du getter
func _get_stats_text() -> String:
  return "Mana %+d \nRegen. mana %.1f" % [max_mana.value, mana_regen.value] 

func _get_final_stats_text() -> String:
  var max_mana_value: int
  max_mana_value = max_mana.value * (1.0 + (GameManager.player_actor.get_total_attribute(max_mana.attribute_name) - 1) * max_mana.ratio)
  var mana_regen_value: float
  mana_regen_value = mana_regen.value * (1.0 + (GameManager.player_actor.get_attribute_level(mana_regen.attribute_name) - 1) * mana_regen.ratio)
  return "Mana %+d \nRegen. mana %.1f" % [max_mana_value, mana_regen_value] 

