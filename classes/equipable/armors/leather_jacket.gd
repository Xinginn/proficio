extends Equipable

class_name LeatherJacket

func _init(crafter = null):
  # calcul des valeur selon niveau de crafteur
  var base_def = 6
  var base_move_speed = 12
  var bonus_def = 0 
  var bonus_move_speed = 0
  
  if crafter != null:
    bonus_def = int(crafter.leather_work * 0.35)
    bonus_move_speed = int(crafter.leather_work * 0.1)
    crafter.gain_xp("leather_work", 4)
  
  def = WearAttribute.new(base_def + bonus_def, "light_armor", 0.1)
  move_speed = WearAttribute.new(base_move_speed + bonus_move_speed, "light_armor", 0.05)
  
  print("créé! def: %s, move_speed:%s" % [def.base_value, move_speed.base_value])
