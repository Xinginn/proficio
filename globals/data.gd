extends Node

var items = []
var buildings = []

func _ready():
  items.append(ItemData.new("leather_jacket", 4, {"leather": 2}))
  
  buildings.append(BuildingData.new("test", 500, 4, {"wood": 4}, 1.0, ["leather_jacket"]))
