extends Node

class_name CraftData

var id
var product
var product_name
var stamina
var skills
var xp
var resources
var needed_progress

var resources_text setget ,_get_resources_text

func _init(_id, _product, _name, _stamina, _skills, _xp, _resources, _needed_progress = 1000):
  id = _id
  product = _product
  product_name = _name
  stamina = _stamina
  skills = _skills
  xp = _xp
  resources = _resources
  needed_progress = _needed_progress

# TODO creer une classe-mère pour ne pas dupliquer ce code avec BuildingData ?
func _get_resources_text() -> String:
  var text = ""
  var i = 0
  for resource_name in resources.keys():
    text += "%s x%d" % [Dictionaries.resource_names[resource_name], resources[resource_name]]
    i += 1
    if i < resources.size():
      text += ", "
  return text
