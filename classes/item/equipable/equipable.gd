extends Item

class_name Equipable

var attributes = [
  "atk", "def", "max_health", "max_stamina", "max_mana", "critical", "move_speed", "construction",
  "gathering", "lumberjack", "smelting", "skinning", "leatherwork", "weaponsmith", "armorsmith", "weaving",
  "woodcarving", "shoemaking", "toolmaking"
]

var atk: WearAttribute
var def: WearAttribute
var max_health: WearAttribute
var max_stamina: WearAttribute
var max_mana: WearAttribute
var critical: WearAttribute
var move_speed: WearAttribute
#skills
var construction: WearAttribute
var gathering: WearAttribute
var lumberjack: WearAttribute
var smelting: WearAttribute
var skinning: WearAttribute
var leatherwork: WearAttribute
var weaponsmith: WearAttribute
var armorsmith: WearAttribute
var weaving: WearAttribute
var woodcarving: WearAttribute
var shoemaking: WearAttribute
var toolmaking: WearAttribute
# probablement pas de masteries en wearAttribute, parce qu'on pourrait avoir un bénéfice cyclique à la skyrim

var stats_text setget ,_get_stats_text

var slots: Array = []

func _get_stats_text() -> String:
  return "No stats"

# retrait des WeatAttributes de la mémoire 
func destroy():
  for attr in attributes:
    if !!get(attr): get(attr).queue_free()
  .destroy()
