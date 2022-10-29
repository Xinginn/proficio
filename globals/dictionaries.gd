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
  "max_stamina_lvl",
  "max_mana_lvl",
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
  "apothecary",
  "cooking",
  "bartering",
  "pyromancy",
  "alchemy",
]

var masteries = [
  "tools",
  "knives",
  "swords",
  "masses",
  "clothes",
  "shoes",
  "light_armors",
  "heavy_armors",
]

var attribute_names = {
  #caracs
  "atk_lvl": "Attaque",
  "def_lvl": "Défense",
  "max_health_lvl": "Santé",
  "max_stamina_lvl": "Energie",
  "max_mana_lvl": "Mana",
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
  "apothecary": "Apothicaire",
  "cooking": "Cuisine",
  "bartering": "Marchandage",
  "pyromancy": "Pyromancie",
  "alchemy": "Alchimie",
  # masteries
  "tools": "Outils",
  "knives": "Dagues",
  "swords": "Epées",
  "masses": "Masses",
  "clothes": "Vêtements",
  "shoes": "Chaussures",
  "light_armors": "Armures Légères",
  "heavy_armors": "Armures Lourdes",
}
