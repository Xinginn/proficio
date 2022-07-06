extends Node

class_name ItemData

var label
var stamina
var resources
var duration

func _init(_label, _stamina, _resources, _duration = 1.0):
  label = _label
  stamina = _stamina
  resources = _resources
  duration = _duration
