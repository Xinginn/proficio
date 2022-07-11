extends Node

class_name Inventory

var total_weight: float

# equippés
var gear = {
  "main_hand": null,
  "off_hand": null,
  "body": null,
  "head": null,
  "feet": null,
  "right_ring": null,
  "left_ring": null,
 }

# equipables et potions
var items = []

# ressources
var resources: Dictionary = {
  "cristal" : 10,
  "fiber": 10,
  "herb": 10,
  "iron": 10,
  "leather": 10,
  "ore": 10,
  "skin": 10,
  "stone": 10,
  "wheat": 10,
  "wood": 10,
 }
