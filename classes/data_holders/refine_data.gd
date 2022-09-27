extends Node

class_name RefineData

var id: int
var _name: String
var inputs: Dictionary
var outputs: Dictionary
var time: float
var skill_name: String
var xp_gain: int

func _init(_id: int, _refine_name: String, _inputs: Dictionary, _outputs: Dictionary, _time: float, _skill_name: String, _xp_gain: int):
  id = _id
  _name = _refine_name
  inputs = _inputs
  outputs = _outputs
  time = _time
  skill_name = _skill_name
  xp_gain = _xp_gain
