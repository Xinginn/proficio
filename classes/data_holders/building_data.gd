extends Node

class_name BuildingData

var id
var label
var max_health
var stamina
var resources
var craft_ids

func _init(_id, _label, _max_health, _stamina, _resources, _craft_ids = []):
  id = _id
  label = _label
  max_health = _max_health
  stamina = _stamina
  resources = _resources
  craft_ids = _craft_ids
