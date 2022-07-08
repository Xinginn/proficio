extends KinematicBody2D

class_name Actor

var move_speed: float = 100.0
var target_position = null
var velocity = null

# stats
var def = 1
var def_xp = 0
# skills
var leatherwork = 10
var leatherwork_xp = 0
# masteries
var construction = 20
var construction_xp = 0
var light_armor = 20
var light_armor_xp = 0

var gear = {
  "main_hand": null,
  "secondary_hand": null,
  "body": null,
  "head": null,
  "feet": null,
  "ring": null
 }

var inventory: Array = []

func move_to(coords: Vector2) -> void:
  target_position = coords

func stop_moving() -> void:
  target_position = null

func _physics_process(delta):
  if target_position != null:
    velocity = global_position.direction_to(target_position) * move_speed
    if global_position.distance_to(target_position) > 5:
      velocity = move_and_slide(velocity)
    else:
      global_position = target_position
      target_position = null

# cette methode fait gagner de l'xp à la stat envoyée en argument,
# puis augmente d'une fraction les compétences des équipements qui ameillorent aussi cette stat
# ex: gain d'xp de def -> porte une armure légere qui augmente la def -> gain d'xp d'armure legere
func gain_xp(attr, xp_value):
  if attr != "construction":
    print("xp gain for " + attr)
  # gain de base
  var new_xp = get(attr + "_xp") + xp_value
  set(attr + "_xp", new_xp)
#  print("new_xp de " + attr + ": " + str(get(attr + "_xp")))
  # gain bonus selon equipement boostant la stat
  for item in gear.values():   
    if item == null:
      continue
    # on récupère la stat utilisée par l'equipement
    var attribute = item.get(attr)
    if attribute == null:
      continue
    if attribute.value == 0:
      continue
    # on calcule le gain d'xp
#    print("trouvé %s boostant la %s" % [item.label, attr])
    var xp_gain = xp_value * attribute.ratio
    var total_xp = get(attribute.attribute_name + "_xp") + xp_gain
    # on applique le gain d'xp
    set(attribute.attribute_name + "_xp", total_xp)
#    print("new_xp de " + attribute.attribute_name + ": " + str(get(attribute.attribute_name + "_xp")))
