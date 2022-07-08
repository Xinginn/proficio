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
  "leather": 0,
  "stone": 0,
  "wood": 0,
 }
