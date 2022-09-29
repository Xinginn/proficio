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
  "grain": 10,
  "wood": 10,
 }

func compute_total_weight() -> void:
  var total: float = 0.0
  # objets equipés
  for slot in gear:
    if gear[slot] != null:
      total += gear[slot].weight
  # objets dans le sac
  for item in items:
    var item_weight = item.weight
    if "stack" in item:
      item_weight *= item.stack
    total += item_weight
  # ressources
  for res in resources:
    total += resources[res] * Dictionaries.resource_weights[res]
  total_weight = total

func get_item_names() -> Array:
  var names = []
  for item in items:
    names.append(item._name)
  return names
