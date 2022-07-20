extends Node

var resource_names: Dictionary = {
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

var resource_weights: Dictionary = {
  "cristal" : 0.1,
  "fiber": 0.1,
  "herb": 0.15,
  "leather": 0.2,
  "ore": 0.5,
  "skin": 0.3,
  "stone": 1.0,
  "wheat": 0.5,
  "wood": 1.0,
  "iron": 0.4
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
  "skinning": "Tannerie",
  "leatherwork": "Travail du Cuir",
  "weaponsmith": "Forge d'armes",
  "armorsmith": "Forge d'armures",
  "weaving": "Tissage",
  "woodcarving": "Travail du bois",
  "shoemaking": "Cordonnerie",
  "toolmaking": "Bricolage",
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
