extends Node

var lands = []
var refines = []
var crafts = []
var buildings = []
var techs = []
var races = []
var npc_models = {}
var contributions = {}

func _ready():
  lands.append(LandData.new(0, "center", 3, {"herbs": 3, "pebble": 2, "twig": 2, "tree": 1}))
  lands.append(LandData.new(1, "crown", 3, {"herbs": 3, "pebble": 2, "twig": 2, "tree": 1}))
  lands.append(LandData.new(2, "plain", 8, {"herbs": 4, "pebble": 2, "twig": 2, "tree": 3}))
#  lands.append(LandData.new(2, "plain", 8, {"cristal_shards": 4, "ore_shards": 2, "stone_shards": 3}))
  lands.append(LandData.new(3, "forest", 6, {"herbs": 2, "pebble": 1, "twig": 3, "tree": 5}))
  
  # id, _name, inputs, outputs, time, skill, xp_gain
  refines.append(RefineData.new(0, "Cultiver des céréales", {"grain": 3}, {"grain": 9}, 4.0, "botanic", 3))
  refines.append(RefineData.new(1, "Cultiver des herbes", {"grain": 3}, {"herb": 2}, 3.0, "botanic", 2))
  refines.append(RefineData.new(2, "Fondre du fer", {"ore": 3}, {"iron": 1}, 3.0, "smelting", 3))
  refines.append(RefineData.new(3, "Tisser des fibres", {"herb": 4}, {"fabric": 1}, 2.5, "weaving", 3))
  refines.append(RefineData.new(4, "Tanner du cuir", {"skin": 4}, {"leather": 1}, 2.5, "leatherwork", 3))
  refines.append(RefineData.new(5, "Raffiner du quartz", {"stone": 6}, {"cristal": 1}, 3.0, "alchemy", 3))
  refines.append(RefineData.new(6, "Scier des planches", {"wood": 3}, {"plank": 1}, 2.5, "lumberjack", 2))
  refines.append(RefineData.new(7, "Tailler des pierres ", {"stone": 3}, {"brick": 1}, 2.5, "mining", 2))
  refines.append(RefineData.new(8, "Préparer des parchemins ", {"skin": 3}, {"parchment": 1}, 4.0, "leatherwork", 2))
  
  # id, product, name, stamina, [skills], xp, {resources}, ?needed_progress = 1.0
  crafts.append(CraftData.new(0, HideArmor, "hide_armor", 4, ["leatherwork"], 8, {"skin": 3}, 1.0))  
  crafts.append(CraftData.new(1, LeatherJacket, "leather_jacket", 4, ["leatherwork"], 10, {"leather": 3}, 1.2))
  crafts.append(CraftData.new(2, HuntingKnife, "hunting_knife", 4, ["toolmaking", "weaponsmith"], 8, {"ore": 2, "wood": 1}, 0.8))
  crafts.append(CraftData.new(3, Gladius, "gladius", 4, ["weaponsmith"], 10, {"ore": 2, "iron": 3}, 1.2))
  crafts.append(CraftData.new(4, Tunic, "tunic", 4, ["weaving"], 6, {"herb": 6}, 1.2))
  crafts.append(CraftData.new(5, Cudgel, "cudgel", 4, ["woodcarving"], 6, {"wood": 4}, 1.0))
  crafts.append(CraftData.new(6, IronHelmet, "iron_helmet", 4, ["armorsmith"], 6, {"iron": 3}, 1.0))
  crafts.append(CraftData.new(7, WalkingShoes, "walking_shoes", 4, ["shoemaking"], 6, {"leather": 2, "skin": 1}, 1.0))
  crafts.append(CraftData.new(8, LumberingAxe, "lumbering_axe", 4, ["toolmaking", "weaponsmith"], 8, {"ore": 4, "wood": 2}, 1.5))
  crafts.append(CraftData.new(9, Dirk, "dirk", 4, ["weaponsmith"], 4, {"ore": 3}, 1.0))
  crafts.append(CraftData.new(10, Bandages, "bandages", 4, ["alchemy"], 4, {"herb": 4}, 0.8))
  crafts.append(CraftData.new(11, Bread, "bread", 4, ["cooking"], 4, {"grain": 4}, 0.8))
  crafts.append(CraftData.new(12, StaminaPotion, "stamina_potion", 4, ["alchemy"], 4, {"herb": 2, "cristal": 1}, 1.0))
  crafts.append(CraftData.new(13, CristalPowder, "cristal_powder", 4, ["alchemy"], 6, {"cristal": 4,}, 1.0))
  crafts.append(CraftData.new(14, Chainmail, "chain_mail", 4, ["armorsmith"], 4, {"iron" : 6, "ore": 4}, 2.0))
  crafts.append(CraftData.new(15, StuddedArmor, "studded_armor", 4, ["leatherwork"], 4, {"leather" : 3, "ore": 4}, 1.8))
  crafts.append(CraftData.new(16, AssassinSuit, "assassin_suit", 4, ["leatherwork"], 4, {"leather" : 6, "iron": 2}, 2.0))
  crafts.append(CraftData.new(17, NightGarb, "night_garb", 4, ["leatherwork", "enchanting"], 4, {"leather" : 2, "fabric": 4, "cristal": 4}, 2.0))
  crafts.append(CraftData.new(18, LeatherSkullcap, "leather_skullcap", 4, ["leatherwork"], 4, {"skin": 2, "leather" : 2}, 1.5))
  crafts.append(CraftData.new(19, ShortBow, "short_bow", 4, ["woodcarving"], 4, {"wood": 4}, 2.0))
  crafts.append(CraftData.new(20, MageRobe, "mage_robe", 4, ["weaving", "enchanting"], 4, {"fabric": 4, "cristal": 1}, 2.0))
  crafts.append(CraftData.new(21, StaffOfEmbers, "staff_of_embers", 4, ["enchanting", "fire_magic"], 4, {"wood": 4, "cristal": 2}, 2.0))
  crafts.append(CraftData.new(22, ManaAmulet, "mana_amulet", 4, ["enchanting"], 4, {"iron": 3, "cristal": 3}, 2.5))
  crafts.append(CraftData.new(23, Basket, "basket", 4, ["toolmaking"], 4, {"wood": 2, "fabric": 2}, 1.5))
  crafts.append(CraftData.new(24, HealingPotion, "healing_potion", 4, ["alchemy"], 4, {"herb": 6, "ore": 2}, 1.5))
  crafts.append(CraftData.new(25, ScrollSummonChicken, "scroll_summon_chicken", 4, ["wild_magic"], 4, {"parchment": 3, "skin": 1}, 1.5))
  
  # id, _name, label, max_health, stamina, resources, ?craft_ids = [], ?refine_ids = [], ?stackables = [], ?equipables = []
  buildings.append(BuildingData.new(0, "castle", "Castle", 1000, 0, {}, [], [], ["brick","cristal","fabric","grain","herb","iron","leather","ore","parchment","plank","skin","stone","wood"], []))
  buildings.append(BuildingData.new(1, "field", "Champ", 150, 4, {"stone": 4, "wood": 2}, [], [0,1], ["grain", "herb"], []))
  buildings.append(BuildingData.new(2, "foundry", "Fonderie", 300, 4, {"stone": 8, "wood": 2}, [], [2], ["ore", "iron"], []))
  buildings.append(BuildingData.new(3, "tailor_shop", "Atelier de tailleur", 300, 4, {"wood": 8}, [4], [3], ["herb", "fabric"], []))
  buildings.append(BuildingData.new(4, "hunting_lodge", "Loge de chasseur", 150, 4, {"wood": 6}, [0,1,2,19], [4], ["skin", "leather"], []))
  buildings.append(BuildingData.new(5, "kitchen", "Cuisine", 200, 4, {"stone": 4, "wood": 4}, [11], [], ["grain"], []))
  buildings.append(BuildingData.new(6, "store", "Boutique", 200, 4, {"wood": 6, "stone": 4}, [1,3,5,7,23], [], [], []))
  buildings.append(BuildingData.new(7, "laboratory", "Laboratoire", 200, 4, {"wood": 4, "stone": 4}, [24,12,13], [5], [], []))
  buildings.append(BuildingData.new(8, "forge", "Forge", 300, 4, {"wood": 4, "stone": 6}, [3,9,6,14], [], [], []))
  buildings.append(BuildingData.new(9, "scout_workshop", "Atelier d'éclaireur", 200, 4, {"wood": 6}, [9,19,1,15,18], [], [], []))
  buildings.append(BuildingData.new(10, "enchanter_tower", "Tour d'enchanteur", 300, 4, {"stone": 8,"wood": 2}, [21,20,22,25], [], [], []))
  buildings.append(BuildingData.new(11, "sawmill", "Scierie", 300, 4, {"wood": 8}, [8], [6], ["wood", "plank"], []))
  buildings.append(BuildingData.new(12, "stonecutter", "Briquetterie", 300, 4, {"stone": 6, "wood": 4}, [], [7], ["stone", "brick"], []))
  buildings.append(BuildingData.new(13, "parcheminery", "Parcheminerie", 300, 4, {"plank": 6, "stone": 4}, [], [8], ["skin", "parchment"], []))
  buildings.append(BuildingData.new(14, "thieves_guild", "Guilde de voleurs", 400, 4, {"plank": 8, "brick": 4}, [9,15,16,17], [], [], []))
  
  
  # building de test  TODO retirer en prod
  var all_crafts = []
  for i in range(crafts.size()):
    all_crafts.append(i)
  buildings.append(BuildingData.new(99, "building_01", "Test", 500, 4, {}, all_crafts, [], ["ore", "wood", "stamina_potion"], []))

  # id, _name, type, skill ('weapon' pour déduire de l'arme equipée, _xp_gain, _cost ( _range ou area)
  techs.append(StrikeData.new(0, "weapon_strike", "strike", "swords", 4, {"stamina": 1}, 1.0, 60))
  # _id, _name, _type, _skill, _xp_gain, _cost, _cooldown, _velocity, _lifespan
  techs.append(ProjectileData.new(1, "default_projectile", "projectile", "fire_magic", 1, {"mana": 1}, 0.5, 200, 1.0))
    # _id, _name, _type, _skill, _xp_gain, _cost, _cooldown, _area_multiplier
  techs.append(SelfCenteredData.new(2, "default_self_centered", "self_centered", "fire_magic", 1, {"mana": 1}, 1.0, 1.0))
  techs.append(SpotTargetedData.new(3, "default_spot_targeted", "spot_targeted", "fire_magic", 1, {"mana": 1}, 1.0, 1.0))
  techs.append(SpotTargetedData.new(4, "summon_chicken", "spot_targeted", "wild_magic", 1, {"mana": 1}, 0.5, 1.0))
  techs.append(ProjectileData.new(5, "sinus_projectile", "projectile ", "fire_magic", 1, {"mana": 1}, 0.5, 200, 1.0))
  techs.append(SelfCenteredData.new(6, "growing_radius_area", "self_centered ", "fire_magic", 1, {"mana": 1}, 1.0, 1.0))
  techs.append(StrikeData.new(7, "dagger_strike", "strike", "daggers", 0, {"stamina": 0.5}, 0.3, 40))
  techs.append(StrikeData.new(8, "axe_strike", "strike", "axes", 0, {"stamina": 0.5}, 0.3, 60))
  techs.append(ProjectileData.new(9, "bow_projectile", "projectile", "bows", 0, {"stamina": 1}, 0.5, 300, 1.0))
  techs.append(StrikeData.new(10, "sword_strike", "strike", "swords", 0, {"stamina": 1}, 1.0, 60))
  techs.append(StrikeData.new(11, "staff_strike", "strike", "focus", 0, {"stamina": 1}, 0.8, 40))
  techs.append(StrikeData.new(12, "unarmed_strike", "strike", "focus", 0, {"stamina": 0.5}, 0.5, 40))

  
  races.append({"id": 0, "name": "human", "label": "Humain", "description": "Description humain", "stats_text": "Santé: 15\nEnergie: 15\nMana: 15"})
  races.append({"id": 1, "name": "dwarf", "label": "Nain", "description": "Description nain", "stats_text": "Santé: 18\nEnergie: 18\nMana: 9"})
  races.append({"id": 2, "name": "elf", "label": "Elfe", "description": "Description elfe", "stats_text": "Santé: 12\nEnergie: 15\nMana: 18"})

  npc_models["chicken"] = {
    "max_health": 20,
    "max_stamina": 8,
    "max_mana": 6,
    "move_speed": 250,
    "attributes": { "botanic": 5 },
   }
  
  contributions = {
    "repair": {"cost": {"stone": 4}, "needed_progress": 2.0},
    "upgrade": {"cost": {"stone": 4}, "needed_progress": 4.0}
   }
