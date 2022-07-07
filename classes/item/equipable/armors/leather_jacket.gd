extends Equipable

class_name LeatherJacket

func _init(crafter = null, allow_xp: bool = true):
  #valeurs immuables (nom, poids)
  label = "Veste de cuir"
  _name = "leather_jacket"
  weight = 4.0
  # calcul des valeur selon niveau de crafteur
  var base_def = 6
  var base_move_speed = 12
  var bonus_def = 0 
  var bonus_move_speed = 0
  
  #TODO sortir le px de cet endroit: plutot définir la stat et la quatité d'xp
  # du gain de px
  if crafter != null && allow_xp:
    bonus_def = int(crafter.leatherwork * 0.35)
    bonus_move_speed = int(crafter.leatherwork * 0.1)
    crafter.gain_xp("leatherwork", 4)
  
  def = WearAttribute.new(base_def + bonus_def, "light_armor", 0.1)
  move_speed = WearAttribute.new(base_move_speed + bonus_move_speed, "light_armor", 0.05)
