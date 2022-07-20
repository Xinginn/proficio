extends Node

var lands = []
var crafts = []
var buildings = []

func _ready():
  lands.append(LandData.new(0, "center", 3, {"herbs": 4, "pebble": 2}))
  lands.append(LandData.new(1, "crown", 3, {"herbs": 4, "pebble": 2}))
  lands.append(LandData.new(2, "plain", 3, {"herbs": 4, "pebble": 2}))
  lands.append(LandData.new(3, "forest", 3, {"herbs": 4, "pebble": 2}))
  
  # id, product, name, stamina, skill, xp, resources, ?needed_progress = 1000
  crafts.append(CraftData.new(0, HideArmor, "hide_armor", 4, "leatherwork", 8, {"skin": 3}, 1000))  
  crafts.append(CraftData.new(1, LeatherJacket, "leather_jacket", 4, "leatherwork", 10, {"leather": 3}, 1200))
  crafts.append(CraftData.new(2, HuntingKnife, "hunting_knife", 4, "toolmaking", 8, {"ore": 2, "wood": 1}, 1000))
  crafts.append(CraftData.new(3, Gladius, "gladius", 4, "weaponsmith", 10, {"ore": 2, "iron": 3}, 1200))
  crafts.append(CraftData.new(4, Tunic, "tunic", 4, "weaving", 6, {"fiber": 6}, 900))
  crafts.append(CraftData.new(5, Cudgel, "cudgel", 4, "woodcarving", 6, {"wood": 4}, 800))
  crafts.append(CraftData.new(6, IronHelmet, "iron_helmet", 4, "armorsmith", 6, {"iron": 3}, 1000))
  crafts.append(CraftData.new(7, WalkingShoes, "walking_shoes", 4, "shoemaking", 6, {"leather": 2, "skin": 1}, 900))
  crafts.append(CraftData.new(8, LumberingAxe, "lumbering_axe", 4, "toolmaking", 8, {"ore": 4, "wood": 2}, 1200))
  crafts.append(CraftData.new(9, Dirk, "dirk", 4, "weaponsmith", 4, {"ore": 3}, 800))
  
  # id, label, max_health, resources, ?craft_ids = []
  buildings.append(BuildingData.new(0, "workshop", "Atelier", 500, 4, {"wood": 5}, [2, 3, 5, 8, 9]))
  buildings.append(BuildingData.new(1, "hunting_lodge", "Loge de chasseur", 500, 4, {"wood": 24}, [0, 1, 2]))
  buildings.append(BuildingData.new(2, "armory", "Armurerie", 500, 4, {"wood": 4, "stone": 3}, [0, 1, 6]))
  buildings.append(BuildingData.new(3, "foundry", "Fonderie", 500, 4, {"stone": 8}, []))
  buildings.append(BuildingData.new(4, "store", "Boutique", 500, 4, {"wood": 6, "stone": 4}, [4, 7]))
  
  # building de test  TODO retirer en prod
  buildings.append(BuildingData.new(99, "building_01", "Test", 500, 4, {}, [0,1,2,3,4,5,6,7,8,9]))
