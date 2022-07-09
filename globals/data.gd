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
  "iron": "Fer"
 }

var crafts = []
var buildings = []

func _ready():
  # id, product, name, stamina, skill, xp, resources, ?needed_progress = 1000
  crafts.append(CraftData.new(0, LeatherJacket, "leather_jacket", 4, "leatherwork", 10, {"leather": 3}, 1200))
  crafts.append(CraftData.new(1, HideArmor, "hide_armor", 4, "leatherwork", 8, {"skin": 3}, 1000))
  crafts.append(CraftData.new(2, HuntingKnife, "hunting_knife", 4, "toolmaking", 8, {"ore": 2, "wood": 1}, 1000))
  crafts.append(CraftData.new(3, Gladius, "gladius", 4, "weaponsmith", 10, {"ore": 2, "iron": 3}, 1200))
  crafts.append(CraftData.new(4, Tunic, "tunic", 4, "weaving", 6, {"fiber": 6}, 900))
  crafts.append(CraftData.new(5, Cudgel, "cudgel", 4, "woodcarving", 6, {"wood": 4}, 800))
  crafts.append(CraftData.new(6, IronHelmet, "iron_helmet", 4, "armorsmith", 6, {"iron": 3}, 1000))
  crafts.append(CraftData.new(7, WalkingShoes, "walking_shoes", 4, "shoemaking", 6, {"leather": 2, "skin": 1}, 900))
  crafts.append(CraftData.new(8, LumberingAxe, "lumbering_axe", 4, "toolmaking", 8, {"ore": 4, "wood": 2}, 1200))
  crafts.append(CraftData.new(9, Dirk, "dirk", 4, "weaponsmith", 4, {"ore": 3}, 800))
  
  # id, label, max_health, resources, ?craft_ids = []
  buildings.append(BuildingData.new(0, "test", 500, 4, {"wood": 4}, [0,1,2,3,4,5,6,7,8,9]))
