extends Node

class_name BuildingData

var id
var _name
var label
var max_health
var stamina
var resources
var craft_ids

var resources_text setget ,_get_resources_text

func _init(_id, _building_name, _label, _max_health, _stamina, _resources, _craft_ids = []):
  id = _id
  _name = _building_name
  label = _label
  max_health = _max_health
  stamina = _stamina
  resources = _resources
  craft_ids = _craft_ids

# TODO creer une classe-mère pour ne pas dupliquer ce code avec CraftData ?
func _get_resources_text() -> String:
  var text = ""
  var i = 0
  for resource_name in resources.keys():
    text += "%s x%d" % [Dictionaries.resource_names[resource_name], resources[resource_name]]
    i += 1
    if i < resources.size():
      text += ", "
  return text
