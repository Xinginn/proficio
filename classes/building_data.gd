extends Node

class_name BuildingData

var label
var max_hp
var stamina
var resources
var duration
var crafts

func _init(_label, _max_hp, _stamina, _resources, _duration = 1.0, _crafts = []):
  label = _label
  max_hp = _max_hp
  stamina = _stamina
  resources = _resources
  duration = _duration
  crafts = _crafts
