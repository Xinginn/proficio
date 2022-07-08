extends Node

class_name CraftData

var id
var product
var product_name
var stamina
var skill
var xp
var resources
var needed_progress

func _init(_id, _product, _name, _stamina, _skill, _xp, _resources, _needed_progress = 1000):
  id = _id
  product = _product
  product_name = _name
  stamina = _stamina
  skill = _skill
  xp = _xp
  resources = _resources
  needed_progress = _needed_progress
