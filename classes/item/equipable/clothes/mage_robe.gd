extends Equipable

class_name MageRobe

func _init(crafter = null):
  #valeurs immuables (nom, poids)
  label = "Robe de mage"
  _name = "mage_robe"
  weight = 2.0
  description = "Cette robe ample facilite la pratique de la magie."
  base_price = 20
  slots = ["body"]
  granted_techs = []
  # calcul des valeur selon niveau de crafteur
  var base_fire_magic = 2
  var bonus_fire_magic = 0
  var base_ice_magic = 2
  var bonus_ice_magic = 0
  var base_wild_magic = 2
  var bonus_wild_magic = 0
  var base_light_magic = 2
  var bonus_light_magic = 0
  var base_black_magic = 2
  var bonus_black_magic = 0
  var base_max_mana = 4
  var bonus_max_mana = 0
  
  # calcul des values de base + bonus du au skill de craft
  if crafter != null:
    bonus_fire_magic = int(crafter.get_total_attribute("weaving") * 0.2)
    bonus_ice_magic = int(crafter.get_total_attribute("weaving") * 0.2)
    bonus_wild_magic = int(crafter.get_total_attribute("weaving") * 0.2)
    bonus_light_magic = int(crafter.get_total_attribute("weaving") * 0.2)
    bonus_black_magic = int(crafter.get_total_attribute("weaving") * 0.2)
    bonus_max_mana = int(crafter.get_total_attribute("weaving") * 0.25)
  
  # declaration des wear attribute: valeur inhérente à l'objet crafté, mastery l'augmentant 
  # et ratio de boost et gain d'xp en l'utilisant
  fire_magic = WearAttribute.new(base_fire_magic + bonus_fire_magic, "mage_clothes", 0.05)
  ice_magic = WearAttribute.new(base_ice_magic + bonus_ice_magic, "mage_clothes", 0.05)
  wild_magic = WearAttribute.new(base_wild_magic + bonus_wild_magic, "mage_clothes", 0.05)
  light_magic = WearAttribute.new(base_light_magic + bonus_light_magic, "mage_clothes", 0.05)
  black_magic = WearAttribute.new(base_black_magic + bonus_black_magic, "mage_clothes", 0.05)
  max_mana = WearAttribute.new(base_max_mana + bonus_max_mana, "mage_clothes", 0.05)

# override du getter
func _get_stats_text() -> String:
  return "Mana %+d \nMagies %+d" % [max_mana.value, fire_magic.value] 

func _get_final_stats_text() -> String:
  var max_mana_value: int
  max_mana_value = max_mana.value * (1.0 + (GameManager.player_actor.get_total_attribute(max_mana.attribute_name) - 1) * max_mana.ratio)
  var magics_value: int
  magics_value = fire_magic.value * (1.0 + (GameManager.player_actor.get_total_attribute(fire_magic.attribute_name) - 1) * fire_magic.ratio)
  return "Mana %+d \nMagies %+d" % [max_mana_value, magics_value] 

