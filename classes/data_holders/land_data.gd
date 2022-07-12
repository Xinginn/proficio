extends Node

class_name LandData

var id: int
var land_name: String
var max_spots: int
var resources_lottery: Array = []

func _init(_id: int, _name: String, _max_spots: int, _chances: Dictionary = {"herbs": 1, "pebble": 1} ):
    id = _id
    land_name = _name
    max_spots = _max_spots
    # génération de la lottery de spots
    for key in _chances.keys():
      for _i in range(_chances[key]):
        resources_lottery.append(key)
