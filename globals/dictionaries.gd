extends Node

var resource_names: Dictionary = {
  "brick": "Briques", 
  "cristal": "Cristaux",
  "fabric": "Tissu",
  "grain": "Graines",
  "herb": "Herbes",
  "iron": "Fer",
  "leather": "Cuir",
  "ore": "Minerai",
  "parchment": "Parchemin",
  "plank": "Planches",
  "skin": "Peaux",
  "stone": "Pierres",
  "wood": "Bois",
 }

var resource_weights: Dictionary = {
  "brick" : 1.0,
  "cristal" : 0.1,
  "fabric": 0.15,
  "grain": 0.5,
  "herb": 0.15,
  "iron": 0.4,
  "leather": 0.2,
  "ore": 0.5,
  "parchment": 0.1,
  "plank": 1.0,
  "skin": 0.3,
  "stone": 1.0,
  "wood": 1.0,
 }

var resource_prices: Dictionary = {
  "brick": 8,
  "cristal" : 5,
  "fabric": 10,
  "grain": 2,
  "herb": 3,
  "iron": 15,
  "leather": 12,
  "ore": 4,
  "parchment": 10,
  "plank": 8,
  "skin": 3,
  "stone": 2,
  "wood": 2,

  "stamina_potion": 15,
 }

var caracs = [
  #caracs
  "atk_lvl",
  "def_lvl",
  "max_health_lvl",
  "health_regen",
  "max_stamina_lvl",
  "stamina_regen",
  "max_mana_lvl",
  "mana_regen",
  "critical",
 ]

var skills = [
  "construction",
  "gathering",
  "lumberjack",
  "smelting",
  "skinning",
  "leatherwork",
  "weaponsmith",
  "armorsmith",
  "weaving",
  "woodcarving",
  "shoemaking",
  "toolmaking",
  "cooking",
  "bartering",
  "fire_magic",
  "ice_magic",
  "wild_magic",
  "light_magic",
  "black_magic",
  "alchemy",
  "enchanting"
]

var masteries = [
  "tools",
  "daggers",
  "swords",
  "masses",
  "axes",
  "bows",
  "focus",
  "clothes",
  "shoes",
  "light_armors",
  "heavy_armors",
  "mage_clothes",
  "jewels"
]

var attribute_names = {
  #caracs
  "atk_lvl": "Attaque",
  "def_lvl": "Défense",
  "max_health_lvl": "Santé",
  "health_regen": "Regen. santé",
  "max_stamina_lvl": "Energie",
  "stamina_regen": "Regen. energie",
  "max_mana_lvl": "Mana",
  "mana_regen": "Regen. mana",
  "critical": "Coups critiques",
  #skills
  "construction": "Construction",
  "gathering": "Ramassage",
  "lumberjack": "Bucheron",
  "smelting": "Fonderie",
  "skinning": "Dépeçage",
  "leatherwork": "Travail du Cuir",
  "weaponsmith": "Forge d'armes",
  "armorsmith": "Forge d'armures",
  "weaving": "Tissage",
  "woodcarving": "Travail du bois",
  "shoemaking": "Cordonnerie",
  "toolmaking": "Bricolage",
  "cooking": "Cuisine",
  "bartering": "Marchandage",
  "fire_magic": "Magie flamboyante",
  "ice_magic": "Magie glaciale",
  "wild_magic": "Magie druidique",
  "light_magic": "Magie lumineuse",
  "black_magic": "Magie noire",
  "alchemy": "Alchimie",
  "enchanting": "Enchantement",
  # masteries
  "tools": "Outils",
  "daggers": "Dagues",
  "swords": "Epées",
  "masses": "Masses",
  "axes": "Hache",
  "bows": "Arcs",
  "focus": "Catalyseurs",
  "clothes": "Vêtements",
  "mage_clothes": "Tenues de mage",
  "shoes": "Chaussures",
  "light_armors": "Armures Légères",
  "heavy_armors": "Armures Lourdes",
  "jewels": "Bijoux"
}
