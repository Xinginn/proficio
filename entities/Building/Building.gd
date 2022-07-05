extends TextureRect

var health = 500
var max_health = 500
var building_owner = null
var building_type = null


func init(_owner, type, position) -> void:
  building_owner = _owner
  building_type = type
  rect_global_position = position
  print(building_owner, building_type, rect_global_position)
