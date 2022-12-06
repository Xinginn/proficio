extends Equipable

class_name Basket

func _init(crafter = null):
  #valeurs immuables (nom, poids)
  label = "Panier"
  _name = "basket"
  weight = 2.0
  description = "Un panier tressé pour transporter plus de ressources."
  base_price = 20
  slots = ["main_hand"]
  granted_techs = []
  # calcul des valeur selon niveau de crafteur
  var base_gathering = 3
  var bonus_gathering = 0
  var base_max_weight = 20
  var bonus_max_weight = 0

  # calcul des values de base + bonus du au skill de craft
  if crafter != null:
    bonus_gathering = int(crafter.get_total_attribute("toolmaking") * 0.2)
    bonus_max_weight = int(crafter.get_total_attribute("toolmaking") * 0.5)

  # declaration des wear attribute: valeur inhérente à l'objet crafté, mastery l'augmentant 
  # et ratio de boost et gain d'xp en l'utilisant
  gathering = WearAttribute.new(base_gathering + bonus_gathering, "tools", 0.2)
  max_weight = WearAttribute.new(base_max_weight + bonus_max_weight, "tools", 0.2)

# override du getter
func _get_stats_text() -> String:
  return "Ramassage %+d \nPoids %+d" % [gathering.value, max_weight.value]

func _get_final_stats_text() -> String:
  var gathering_value: int
  gathering_value = gathering.value * (1.0 + (GameManager.player_actor.get_total_attribute(gathering.attribute_name) - 1) * gathering.ratio)
  var max_weight_value: int
  max_weight_value = max_weight.value * (1.0 + (GameManager.player_actor.get_total_attribute(max_weight.attribute_name) - 1) * max_weight.ratio)
  return "Ramassage %+d \nPoids %+d" % [gathering_value, max_weight_value]
