extends KinematicBody2D

class_name Actor

const MAX_BUILDINGS = 3
const HARVEST_GAIN_PER_SECOND = 50
const BASE_XP_NEED = 100
const XP_NEED_GROWTH = 1.2

onready var texture_progress: TextureProgress = $TextureProgress

var move_speed: float = 200.0
# var move_speed: float = 500.0 #pour test

var target_position = null
var velocity = null

var harvest_progress: float = 0.0 setget _set_harvest_progress
var current_resource_spot = null

var gold: int = 0 setget _set_gold
var inventory: Inventory = Inventory.new()
var active_buildings: Array = []

# stats
var atk = 1
var atk_xp = 0
var def = 1
var def_xp = 0
var max_health = 10
var max_health_xp = 0
var max_stamina = 10
var max_stamina_xp = 0
var max_mana = 10
var max_mana_xp = 0
var critical = 1
var critical_xp = 0
# skills
var construction = 1
var construction_xp = 0
var gathering = 1
var gathering_xp = 0
var lumberjack = 1
var lumberjack_xp = 0
var smelting = 1
var smelting_xp = 0
var skinning = 1
var skinning_xp = 0
var leatherwork = 1
var leatherwork_xp = 0
var weaponsmith = 1
var weaponsmith_xp = 0
var armorsmith = 1
var armorsmith_xp = 0
var weaving = 1
var weaving_xp = 0
var woodcarving = 1
var woodcarving_xp = 0
var shoemaking = 1
var shoemaking_xp = 0
var toolmaking = 1
var toolmaking_xp = 0
# masteries
var tools = 1
var tools_xp = 0
var knives = 1
var knives_xp = 0
var swords = 1
var swords_xp = 0
var masses = 1
var masses_xp = 0
var clothes = 1
var clothes_xp = 0
var shoes = 1
var shoes_xp = 0
var light_armors = 1
var light_armors_xp = 0
var heavy_armors = 1
var heavy_armors_xp = 0

signal gold_changed(value)
signal inventory_changed(inventory)
signal resources_changed(resources)

func _set_gold(value: int) -> void:
  gold = value
  emit_signal("gold_changed", value)

func _set_harvest_progress(value: float) -> void:
  if !current_resource_spot:
    harvest_progress = 0.0
  else:
    harvest_progress = clamp(value, 0.0, current_resource_spot.duration)
    if harvest_progress == current_resource_spot.duration:
      current_resource_spot.harvest(self)
      harvest_progress = 0.0
    texture_progress.value = int(harvest_progress)

func has_resources(needs: Dictionary) -> bool:
  for resource in needs:
    if inventory.resources[resource] < needs[resource]:
      return false
  return true

func add_resource(resource: String, number: int) -> void:
  # TODO evaluer dépassement de poids
  inventory.resources[resource] += number
  emit_signal('resources_changed', inventory.resources)

func remove_resource(resource: String, number: int) -> void:
  inventory.resources[resource] -= number 
  emit_signal('resources_changed', inventory.resources)

func add_item(item):
  inventory.items.append(item)
  emit_signal('inventory_changed', inventory)

func swap_inventory_items(slot_a, slot_b):
  var temp = inventory.items[slot_a]
  inventory.items[slot_a] = inventory.items[slot_b]
  inventory.items[slot_b] = temp
  emit_signal('inventory_changed', inventory)

func swap_gear_and_inventory_item(gear_slot, item_slot):
  # cas où la gear est vide
  if inventory.gear[gear_slot] == null:
    inventory.gear[gear_slot] = inventory.items[item_slot]
    inventory.items.remove(item_slot)
  else:
    var temp = inventory.items[item_slot]
    inventory.items[item_slot] = inventory.gear[gear_slot]
    inventory.gear[gear_slot] = temp
  emit_signal('inventory_changed', inventory)

func unequip(gear_slot):
  inventory.items.append(inventory.gear[gear_slot])
  inventory.gear[gear_slot] = null
  emit_signal('inventory_changed', inventory)

func move_to(coords: Vector2) -> void:
  target_position = coords

func stop_moving() -> void:
  target_position = null
  velocity = Vector2(0,0)

func start_harvesting(spot):
  current_resource_spot = spot
  texture_progress.max_value = spot.duration
  texture_progress.show()
  
func stop_harvesting() -> void:
  self.harvest_progress = 0.0
  current_resource_spot = null
  texture_progress.hide()

# ------- gestion XP -------
# cette methode fait gagner de l'xp à la stat envoyée en argument,
# puis augmente d'une fraction les compétences des équipements qui ameillorent aussi cette stat
# ex: gain d'xp de def -> porte une armure légere qui augmente la def -> gain d'xp d'armure legere
func gain_xp(attr, xp_value):
#  print("+ %d xp for %s" % [xp_value, attr])
  # gain de base
  var new_xp = get(attr + "_xp") + xp_value
  set(attr + "_xp", new_xp)
  check_for_lvl_up(attr)
#  print("new_xp de " + attr + ": " + str(get(attr + "_xp")))
  # gain bonus selon equipement boostant la stat
  for item in inventory.gear.values():   
    if item == null:
      continue
    # on récupère la stat utilisée par l'equipement
    var attribute = item.get(attr)
    if attribute == null:
      continue
    if attribute.value == 0:
      continue
    # on calcule le gain d'xp
#    print("trouvé %s boostant la %s" % [item.label, attr])
    var xp_gain = xp_value * attribute.ratio
    var total_xp = get(attribute.attribute_name + "_xp") + xp_gain
    # on applique le gain d'xp
    set(attribute.attribute_name + "_xp", total_xp)
#    print("new_xp de " + attribute.attribute_name + ": " + str(get(attribute.attribute_name + "_xp")))

func check_for_lvl_up(attribute_name: String):
  
  var attribute_level = get(attribute_name)
  var current_xp = get(attribute_name + "_xp")
  var needed_xp = int(BASE_XP_NEED * pow(XP_NEED_GROWTH, attribute_level - 1))
  if current_xp > needed_xp:
    set(attribute_name, attribute_level + 1)
    set(attribute_name + "_xp", current_xp - needed_xp)
    print('%s level up!' % attribute_name)

func _ready() -> void:
  texture_progress.hide()

func _physics_process(delta):
  if target_position != null:
    velocity = global_position.direction_to(target_position) * move_speed
    if global_position.distance_to(target_position) > 5:
      velocity = move_and_slide(velocity)
    else:
      global_position = target_position
      target_position = null
  if !!current_resource_spot:
    var harvest_gain = get(current_resource_spot.skill) * HARVEST_GAIN_PER_SECOND * delta
    self.harvest_progress += harvest_gain
