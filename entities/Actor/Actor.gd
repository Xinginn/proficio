extends KinematicBody2D

var move_speed: float = 100.0
var target_position = null
var velocity = null

var light_armor = 20
var light_armor_xp = 0

# TODO peut être une classe définie
var gear = {
  "body": null
 }

func move_to(coords: Vector2) -> void:
  print("received move to: ", coords)
  target_position = coords

func _physics_process(delta):
  if target_position != null:
    velocity = global_position.direction_to(target_position) * move_speed
    if global_position.distance_to(target_position) > 5:
      velocity = move_and_slide(velocity)
    else:
      global_position = target_position
      target_position = null

func gain_xp(attr, xp_value):
  # TODO temporaire, il faudrait gérer pour tous les equipements
  var armor = gear['body']
  # on récupère la stat utilisée par l'equipement
  var wear_attr = armor.get(attr)
  # on calcule le gain d'xp
  var xp_gain = xp_value * wear_attr.ratio
  var total_xp = get(wear_attr.attribute_name + "_xp") + xp_gain
  # on applique le gain d'xp
  set(wear_attr.attribute_name + "_xp", total_xp)
  print(get(wear_attr.attribute_name + "_xp"))
  
