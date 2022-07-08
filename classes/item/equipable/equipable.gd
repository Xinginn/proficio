extends Item

class_name Equipable

var atk: WearAttribute
var def: WearAttribute
var move_speed: WearAttribute
var construction: WearAttribute
var skinning: WearAttribute

var stats_text setget ,_get_stats_text

var slots: Array = []
var description_text: String =  "description par defaut"

func _get_stats_text() -> String:
  return "No stats"
