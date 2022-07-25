extends Node

class_name Attribute

const XP_NEEDS = {
  "caracs": 40,
  "skills": 10,
  "masteries": 20
}

const XP_NEED_GROWTHS = {
  "caracs": 1.1,
  "skills": 1.2,
  "masteries": 1.2
}

var attribute_name: String
var level: int
var xp: int setget _set_xp
var needed_xp: int
var type

func _set_xp(value):
  xp = value
  while(xp >= needed_xp):
    level += 1
    xp -= needed_xp
    compute_needed_xp()

func compute_needed_xp():
  needed_xp = XP_NEEDS[type] * pow(XP_NEED_GROWTHS[type], level -1)

func _init(_name: String, _type: String, _level: int = 1, _xp: int = 0):
  attribute_name = _name
  type = _type
  level = _level
  xp = _xp
  compute_needed_xp()
