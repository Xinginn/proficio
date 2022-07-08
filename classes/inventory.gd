extends Node

class_name Inventory

var total_weight: float

# equippés
var gear = {
  "main_hand": null,
  "secondary_hand": null,
  "body": null,
  "head": null,
  "feet": null,
  "ring": null
 }

# equipables et potions
var items = []

# ressources
var resources: Dictionary = {
  "cristal" : 0,
  "fiber": 0,
  "herb": 0,
  "leather": 0,
  "ore": 0,
  "skin": 0,
  "stone": 0,
  "wheat": 0,
  "wood": 0,
 }
