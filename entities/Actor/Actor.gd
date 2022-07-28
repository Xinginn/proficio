extends KinematicBody2D

class_name Actor

const MAX_BUILDINGS = 3
const HARVEST_GAIN_PER_SECOND = 50
const BASE_XP_NEED = 100
const XP_NEED_GROWTH = 1.2
const BASE_MAX_WEIGHT = 100.0
const MAX_MOVE_SPEED = 9999

const BASE_HEALTH_REGEN = 0.1
const BASE_STAMINA_REGEN = 0.2
const BASE_MANA_REGEN = 0.15

onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var texture_progress: TextureProgress = $TextureProgress

var atk = 10
var def = 10
var health = 15 setget _set_health
var max_health = 15
var stamina = 15 setget _set_stamina
var max_stamina = 15
var mana = 15 setget _set_mana
var max_mana = 15
var move_speed: float = 200.0
# var move_speed: float = 500.0 #pour test
var max_weight: float = BASE_MAX_WEIGHT
var weight_speed_malus: float = 0.0

var total_xp
var target_position = null
var velocity = null
var orientation: String = "down" setget _set_orientation

var harvest_progress: float = 0.0 setget _set_harvest_progress
var current_resource_spot = null

var gold: int = 0 setget _set_gold
var inventory: Inventory = Inventory.new()
var active_buildings: Array = []
var is_player: bool = false

# --------- LEVELS AND XP ---------
var attributes: Dictionary = {
  # caracs
  "atk_lvl": Attribute.new("atk_lvl", "caracs"),
  "def_lvl": Attribute.new("def_lvl", "caracs"),
  "max_health_lvl": Attribute.new("max_health_lvl", "caracs"),
  "max_stamina_lvl": Attribute.new("max_stamina_lvl", "caracs"),
  "max_mana_lvl": Attribute.new("max_mana_lvl", "caracs"),
  "critical": Attribute.new("critical", "caracs"),
  #skills
  "construction": Attribute.new("construction", "skills"),
  "gathering": Attribute.new("gathering", "skills"),
  "lumberjack": Attribute.new("lumberjack", "skills"),
  "smelting": Attribute.new("smelting", "skills"),
  "skinning": Attribute.new("skinning", "skills"),
  "leatherwork": Attribute.new("leatherwork", "skills"),
  "weaponsmith": Attribute.new("weaponsmith", "skills"),
  "armorsmith": Attribute.new("armorsmith", "skills"),
  "weaving": Attribute.new("weaving", "skills"),
  "woodcarving": Attribute.new("woodcarving", "skills"),
  "shoemaking": Attribute.new("shoemaking", "skills"),
  "toolmaking": Attribute.new("toolmaking", "skills"),
  #masteries
  "tools": Attribute.new("tools", "masteries"),
  "knives": Attribute.new("knives", "masteries"),
  "swords": Attribute.new("swords", "masteries"),
  "masses": Attribute.new("masses", "masteries"),
  "clothes": Attribute.new("clothes", "masteries"),
  "shoes": Attribute.new("shoes", "masteries"),
  "light_armors": Attribute.new("light_armors", "masteries"),
  "heavy_armors": Attribute.new("heavy_armors", "masteries"),
 }

signal gold_changed(value)
signal weight_changed(total, maxi)
signal inventory_changed(inventory)
signal resources_changed(resources)
signal health_changed(current, maxi)
signal stamina_changed(current, maxi)
signal mana_changed(current, maxi)
signal experience_changed()

func _set_health(value) -> void:
  health = clamp(value, 0, max_health)
  emit_signal('health_changed', health, max_health)
  
func _set_stamina(value) -> void:
  stamina = clamp(value, 0, max_stamina)
  emit_signal('stamina_changed', stamina, max_stamina)

func _set_mana(value) -> void:
  mana = clamp(value, 0, max_mana)
  emit_signal('mana_changed', mana, max_mana)

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

func _set_orientation(value):
  orientation = value
  animated_sprite.play("walk_%s" % orientation)

# methode pour calculer le poids porté, le poids max, et le malus move_speed eventuel
# 1.0 de malus par %age de dépassement
func compute_weight() -> void:
  inventory.compute_total_weight()
  max_weight = BASE_MAX_WEIGHT + get_gear_bonus("max_weight")
  var overweight = inventory.total_weight - max_weight
  if overweight > 0.0:
    var overweight_ratio = overweight * 100.0 / max_weight
    weight_speed_malus = overweight_ratio * 2.0
  emit_signal('weight_changed', inventory.total_weight, max_weight)

func get_total_attribute(attribute_name: String) -> int:
  return(get_attribute_level(attribute_name) + get_gear_bonus(attribute_name))

func get_attribute_level(attribute_name: String) -> int:
  return attributes[attribute_name].level
  
func get_gear_bonus(attribute_name: String) -> int:
  var total: int = 0
  for slot in inventory.gear:
    var item: Equipable = inventory.gear[slot]
    if item != null:
      var wear_attribute: WearAttribute = item.get(attribute_name)
      if wear_attribute != null:
        var value = wear_attribute.value
        var mastery_bonus = wear_attribute.ratio * get(wear_attribute.attribute_name)
        total += int(value + mastery_bonus)
  return total

func has_resources(needs: Dictionary) -> bool:
  for resource in needs:
    if inventory.resources[resource] < needs[resource]:
      return false
  return true

func add_resource(resource: String, number: int) -> void:
  # TODO evaluer dépassement de poids
  inventory.resources[resource] += number
  compute_weight()
  emit_signal('resources_changed', inventory.resources)

func remove_resource(resource: String, number: int) -> void:
  inventory.resources[resource] -= number
  compute_weight()
  emit_signal('resources_changed', inventory.resources)

func add_item(item):
  inventory.items.append(item)
  compute_weight()
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
  compute_weight()
  emit_signal('inventory_changed', inventory)

func unequip(gear_slot):
  inventory.items.append(inventory.gear[gear_slot])
  inventory.gear[gear_slot] = null
  compute_weight()
  emit_signal('inventory_changed', inventory)

func move_to(coords: Vector2) -> void:
  animated_sprite.playing = true
  target_position = coords
  var dir = global_position.direction_to(target_position).angle_to(Vector2(0,1))
  # offsets de 0.01 pour regler les flickers sur les valeurs egales aux diagonales
  if dir < -3.0/4 * PI + 0.01 || dir >= 3.0/4 * PI -0.01:
    self.orientation = "up"
  elif dir > 1.0/4 * PI + 0.01:
    self.orientation = "right"
  elif dir > -1.0/4 * PI - 0.01:
    self.orientation = "down"
  else:
    self.orientation = "left"

func stop_moving() -> void:
  animated_sprite.playing = false
  animated_sprite.frame = 0
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
func gain_xp(main_attribute, xp_value): 
  # gain de base
  attributes[main_attribute].xp += xp_value
  # gain bonus selon equipement boostant la stat
  for item in inventory.gear.values():   
    if item == null:
      continue
    # on récupère la stat utilisée par l'equipement
    var boost_attribute = item.get(main_attribute)
    if boost_attribute == null:
      continue
    if boost_attribute.value == 0:
      continue
    # on calcule le gain d'xp a partir du ratio et la valeur de base d'xp
    attributes[boost_attribute.attribute_name].xp += xp_value * boost_attribute.ratio
  emit_signal('experience_changed')

func _ready() -> void:
  texture_progress.hide()

func _physics_process(delta):
  # Regens
  if health < 0.0:
    return
  self.health += delta * BASE_HEALTH_REGEN 
  self.stamina += delta * BASE_STAMINA_REGEN 
  self.mana += delta * BASE_MANA_REGEN
  
  if target_position != null:
    var final_move_speed = clamp(move_speed - weight_speed_malus, 0, MAX_MOVE_SPEED)
    velocity = global_position.direction_to(target_position) * final_move_speed
    if global_position.distance_to(target_position) > 5:
      velocity = move_and_slide(velocity)
    else:
      global_position = target_position
      stop_moving()
  if !!current_resource_spot:
    var level = get_total_attribute(current_resource_spot.skill)
    var harvest_gain = (1.0 + (level - 1) * 0.05) * HARVEST_GAIN_PER_SECOND * delta
    self.harvest_progress += harvest_gain
    self.stamina -= current_resource_spot.stamina_loss_while_harvesting * delta
    if stamina == 0.0:
      stop_harvesting()
