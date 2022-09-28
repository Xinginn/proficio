extends Node

var lands = []
var refines = []
var crafts = []
var buildings = []
var techs = []
var races = []
var npc_models = {}

func _ready():
  lands.append(LandData.new(0, "center", 3, {"herbs": 3, "pebble": 2, "wood": 2, "tree": 1}))
  lands.append(LandData.new(1, "crown", 3, {"herbs": 3, "pebble": 2, "wood": 2, "tree": 1}))
  lands.append(LandData.new(2, "plain", 8, {"herbs": 4, "pebble": 2, "wood": 2, "tree": 3}))
  lands.append(LandData.new(3, "forest", 6, {"herbs": 2, "pebble": 1, "wood": 3, "tree": 5}))
  
  # id, _name, inputs, outputs, time, skill, xp_gain
  refines.append(RefineData.new(0, "Fondre du fer", {"ore": 3}, {"iron": 1}, 2.0, "smelting", 3))
  refines.append(RefineData.new(1, "Rafiner des pierres", {"stone": 5}, {"cristal": 1}, 3.0, "alchemy", 3))
  
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
  
  crafts.append(CraftData.new(10, Bandages, "bandages", 4, "apothecary", 4, {"fiber": 4, "herb": 1}, 600))
  crafts.append(CraftData.new(11, Bread, "bread", 4, "cooking", 4, {"wheat": 4}, 600))
  crafts.append(CraftData.new(12, StaminaPotion, "stamina_potion", 4, "apothecary", 4, {"herb": 2, "cristal": 1}, 800))
  crafts.append(CraftData.new(13, CristalPowder, "cristal_powder", 4, "apothecary", 6, {"cristal": 4,}, 1000))
  
  # id, label, max_health, resources, ?craft_ids = [], ?refine_ids = [], ?stackables = [], ?equipables = []
  buildings.append(BuildingData.new(0, "workshop", "Atelier", 500, 4, {"wood": 5}, [2, 3, 5, 8, 9], [], ["herb"], []))
  buildings.append(BuildingData.new(1, "hunting_lodge", "Loge de chasseur", 500, 4, {"wood": 24}, [0, 1, 2], [], []))
  buildings.append(BuildingData.new(2, "armory", "Armurerie", 500, 4, {"wood": 4, "stone": 3}, [0, 1, 6], [], [], []))
  buildings.append(BuildingData.new(3, "foundry", "Fonderie", 500, 4, {"stone": 8}, [], [0,1], [], []))
  buildings.append(BuildingData.new(4, "store", "Boutique", 500, 4, {"wood": 6, "stone": 4}, [4, 7], [], [], []))
  buildings.append(BuildingData.new(4, "apothecary_shop", "Boutique d'Apothicaire", 500, 4, {"wood": 6, "stone": 4}, [10, 12, 13], [], [], []))
  
  # building de test  TODO retirer en prod
  buildings.append(BuildingData.new(99, "building_01", "Test", 500, 4, {}, [0,1,2,3,4,5,6,7,8,9,10,11,12,13], ["ore", "wood", "stamina_potion"], [], []))
  
  # id, _name, type, skill ('weapon' pour déduire de l'arme equipée, _xp_gain, _cost ( _range ou area)
  techs.append(StrikeData.new(0, "weapon_strike", "strike", "weapon", 4, {"stamina": 1}, 1.0, 60))
  # _id, _name, _type, _skill, _xp_gain, _cost, _cooldown, _velocity, _lifespan
  techs.append(ProjectileData.new(1, "default_projectile", "projectile", "pyromancy", 1, {"mana": 1}, 0.5, 200, 20))
    # _id, _name, _type, _skill, _xp_gain, _cost, _cooldown, _area_multiplier
  techs.append(SelfCenteredData.new(2, "default_self_centered", "self_centered", "pyromancy", 1, {"mana": 1}, 1.0, 1.0))
  techs.append(SpotTargetedData.new(3, "default_spot_targeted", "spot_targeted", "pyromancy", 1, {"mana": 1}, 1.0, 1.0))
  
  
  races.append({"id": 0, "name": "human", "label": "Humain", "description": "Description humain", "stats_text": "Santé: 15\nEnergie: 15\nMana: 15"})
  races.append({"id": 1, "name": "dwarf", "label": "Nain", "description": "Description nain", "stats_text": "Santé: 18\nEnergie: 18\nMana: 9"})
  races.append({"id": 2, "name": "elf", "label": "Elfe", "description": "Description elfe", "stats_text": "Santé: 12\nEnergie: 15\nMana: 18"})

  npc_models["chicken"] = {
    "max_health": 20,
    "max_stamina": 8,
    "max_mana": 6,
    "move_speed": 250,
    "attributes": { "gathering": 5 },
   }
  
