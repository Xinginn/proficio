extends Node

var crafts = []
var buildings = []

func _ready():
  # id, product, name, stamina, skill, xp, resources, ?needed_progress = 1000
  crafts.append(CraftData.new(0, LeatherJacket, "leather_jacket", 4, "leatherwork", 10, {"leather": 2}, 800))
  
  # id, label, max_health, resources, ?craft_ids = []
  buildings.append(BuildingData.new(0, "test", 500, 4, {"wood": 4}, [0]))
