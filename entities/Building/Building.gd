extends TextureRect

var health = 500
var max_health = 500
var building_owner = null
var building_data: BuildingData = null

func init(_owner, data, position) -> void:
  building_owner = _owner
  building_data = data
  rect_global_position = position
  print(data.crafts)
