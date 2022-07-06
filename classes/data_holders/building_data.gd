extends Node

class_name BuildingData

var label
var max_health
var stamina
var resources
var duration
var crafts

func _init(_label, _max_health, _stamina, _resources, _crafts = []):
  label = _label
  max_health = _max_health
  stamina = _stamina
  resources = _resources
  crafts = _crafts
