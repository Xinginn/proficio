extends Node

var resource_dictionary: Dictionary = {
  "cristal" : "Cristaux",
  "fiber": "Fibres",
  "herb": "Herbes",
  "leather": "Cuir",
  "ore": "Minerai",
  "skin": "Peaux",
  "stone": "Pierres",
  "wheat": "Blé",
  "wood": "Bois",
 }

var crafts = []
var buildings = []

func _ready():
  # id, product, name, stamina, skill, xp, resources, ?needed_progress = 1000
  crafts.append(CraftData.new(0, LeatherJacket, "leather_jacket", 4, "leatherwork", 10, {"leather": 3}, 1200))
  crafts.append(CraftData.new(1, HideArmor, "hide_armor", 4, "leatherwork", 8, {"skin": 3}, 1000))
  crafts.append(CraftData.new(2, HuntingKnife, "hunting_knife", 4, "toolmaking", 8, {"ore": 2, "wood": 1}, 1000))
  
  # id, label, max_health, resources, ?craft_ids = []
  buildings.append(BuildingData.new(0, "test", 500, 4, {"wood": 4}, [0,1,2]))
