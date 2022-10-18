extends KinematicBody2D

class_name Actor

const alert_display_scene: PackedScene = preload('res://entities/alert_display/alert_display.tscn')

const MAX_BUILDINGS = 3
const HARVEST_GAIN_PER_SECOND = 50
const BASE_XP_NEED = 100
const XP_NEED_GROWTH = 1.2
const BASE_MAX_WEIGHT = 100.0
const MAX_MOVE_SPEED = 9999

const BASE_HEALTH_REGEN = 0.5
const BASE_STAMINA_REGEN = 0.2
const BASE_MANA_REGEN = 0.15

onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var health_bar: TextureProgress = $HealthBar
onready var texture_progress: TextureProgress = $TextureProgress
onready var attack_holder: Node2D = $AttackHolder
onready var pop_up_holder: Node2D = $PopUpHolder

var _name: String = "Noname"
var race: int = 0
var sprite_path: String = "test" setget _set_sprite_path

var team: int = 0
var is_dead: bool = false

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

var target_position = null
var velocity = null
var orientation: String = "down" setget _set_orientation

var harvest_progress: float = 0.0 setget _set_harvest_progress
var current_resource_spot = null

var gold: int = 0 setget _set_gold
var inventory: Inventory = Inventory.new()
var active_buildings: Array = []
var health_regain :float = 0.0
var stamina_regain :float = 0.0
var mana_regain :float = 0.0

var techs = []
var cooldowns = []

# --------- LEVELS AND XP ---------
var attributes: Dictionary = {}

signal actor_died
signal gold_changed(value)
signal weight_changed(total, maxi)
signal inventory_changed(inventory)
signal health_changed(current, maxi)
signal stamina_changed(current, maxi)
signal mana_changed(current, maxi)
signal experience_changed()
signal tech_list_changed(techs)
signal cooldowns_changed(cooldowns)

func _set_sprite_path(_name: String) -> void:
  sprite_path = _name
  animated_sprite.frames = load('res://tres/spriteframes/actors/%s.tres' % sprite_path)

func _set_health(value) -> void:
  var max_h = max_health + get_total_attribute("max_health_lvl")
  if value < 0.0:
    die()
  health = clamp(value, 0, max_h)
  # affichage de la mini barre de vie
  health_bar.value = health
  health_bar.max_value = max_h
  if health < max_h && not is_dead:
    health_bar.show()
  else:
    health_bar.hide()
  emit_signal('health_changed', health, max_h, health_regain)
  
func _set_stamina(value) -> void:
  var max_s = max_stamina + get_total_attribute("max_stamina_lvl")
  stamina = clamp(value, 0, max_s)
  emit_signal('stamina_changed', stamina, max_s, stamina_regain)

func _set_mana(value) -> void:
  var max_m = max_mana + get_total_attribute("max_mana_lvl")
  mana = clamp(value, 0, max_m)
  emit_signal('mana_changed', mana, max_m, mana_regain)

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

func die():
  is_dead = true
  emit_signal("actor_died")
  animated_sprite.self_modulate = Color(1.0, 1.0, 1.0, 0.4)
  health_bar.hide()
  texture_progress.hide()
  stop_harvesting()
  
func live():
  is_dead = false
  animated_sprite.self_modulate = Color(1.0, 1.0, 1.0, 1.0)

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

func get_data() -> Dictionary:
  var data = {
    "_name": _name,
    "race": race,
    "sprite_path": sprite_path,
    "max_health": max_health,
    "max_stamina": max_stamina,
    "max_mana": max_mana,
  }
  var attributes_data = {}
  for attribute_name in attributes.keys():
    attributes_data[attribute_name] = attributes[attribute_name].get_data()
  data["attributes"] = attributes_data
  return data
  
func load_data(data: Dictionary) -> void:
  _name = data["_name"]
  race = data["race"]
  # TODO appliquer modification stats de base selon race
  sprite_path = data["sprite_path"]
  animated_sprite.frames = load('res://tres/spriteframes/actors/%s.tres' % sprite_path)
  animated_sprite.animation = "walk_down"
  max_health = data["max_health"]
  max_stamina = data["max_stamina"]
  max_mana = data["max_mana"]
  gauges_at_max()
  for attribute_name in attributes.keys(): 
    attributes[attribute_name].load_data(data["attributes"][attribute_name])
  emit_signal('experience_changed')

func gauges_at_max():
  self.health += 9999
  self.stamina += 9999
  self.mana += 9999
  
func can_afford_skill(cost: Dictionary) -> bool:
  return(health > cost["health"] && stamina > cost["stamina"] && mana > cost["mana"])
    
func has_resources(needs: Dictionary) -> bool:
  for resource in needs:
    if inventory.resources[resource] < needs[resource]:
      return false
  return true

func add_resource(resource: String, number: int) -> void:
  inventory.resources[resource] += number
  compute_weight()
  emit_signal('inventory_changed', inventory)

func remove_resource(resource: String, number: int) -> void:
  inventory.resources[resource] -= number
  compute_weight()
  emit_signal('inventory_changed', inventory)

func add_item(item_to_add, quantity = 1):
  if item_to_add is Consumable:
    var existing_item = null
    for item in inventory.items:
      if item._name == item_to_add._name:
        existing_item = item
    if !!existing_item:
      existing_item.stack += quantity
      item_to_add.queue_free() # necessaire puisqu'on avait envoyé une instance qui ne sera pas ajoutée
    else:
      item_to_add.stack = quantity
      inventory.items.append(item_to_add)
  if item_to_add is Equipable:   
    inventory.items.append(item_to_add)
  compute_weight()
  emit_signal('inventory_changed', inventory)

# utilisée pour retirer un exemplaire d'un stack
func remove_item(index: int) -> void:
  var item: Consumable = inventory.items[index]
  inventory.items[index].stack -= 1
  emit_signal('inventory_changed', inventory)
  compute_weight()
  if item.stack == 0:
    if GameManager.player_actor == self:
      ItemTooltip.hide()
    destroy_item(index)

# utilisée pour se débarasser d'un equipable ou d'une stack
func destroy_item(slot):
  if slot is String:
    inventory.gear[slot].destroy()
    inventory.gear[slot] = null
  if slot is int:
    inventory.items[slot].destroy()
    inventory.items.remove(slot)
  compute_weight()
  emit_signal('inventory_changed', inventory)
      
func consume_item(index: int) -> void:
  var item: Consumable = inventory.items[index]
  item.use(self)
  remove_item(index)

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

func display_pop_up(text: String) -> void:
  var new_pop_up = alert_display_scene.instance()
  pop_up_holder.add_child(new_pop_up)
  new_pop_up.init(text)
  
func launch_tech(id: int, target_position) -> void:
  var attack_direction = Vector2(target_position - global_position).normalized()
  var data = techs[id]
  var tech_scene = load('res://entities/techs/%s.tscn' % data._name)
  var new_tech = tech_scene.instance()
  new_tech.tech_data = data
  get_tree().get_root().get_node('Playground/EffectsHolder').add_child(new_tech)
  if data is StrikeData:
    var tech_pos = global_position + attack_direction * data.strike_range
    new_tech.global_position = tech_pos
    var rota = global_position.direction_to(tech_pos).angle_to(Vector2(1,0)) * 180 / -PI
    new_tech.rotation_degrees = rota
    var main_hand = inventory.gear['main_hand']
    if !!main_hand:
      var mastery_name = inventory.gear['main_hand'].atk.attribute_name
      gain_xp(mastery_name, data.xp_gain)
    else: print('no weapon equipped')
    new_tech.launch(self)
    # TODO gain_xp
  if data is ProjectileData:
    new_tech.global_position = global_position
    new_tech.normalized_direction = attack_direction
    var rota = global_position.direction_to(global_position + attack_direction).angle_to(Vector2(1,0)) * 180 / -PI
    new_tech.rotation_degrees = rota
    new_tech.launch(self)
    gain_xp(data.skill, data.xp_gain)
  if data is SelfCenteredData:
    new_tech.global_position = global_position
    new_tech.launch(self)
    gain_xp(data.skill, data.xp_gain)
  if data is SpotTargetedData:
    new_tech.global_position = target_position
    new_tech.launch(self)
    gain_xp(data.skill, data.xp_gain)
    
  cooldowns[id] = data.cooldown
  emit_signal("cooldowns_changed", cooldowns)

# ------- fonctions de navigation et d'IA -------
func go_to_nearest_resource(resource_name: String):
  print("attempting to go to %s" % resource_name)
  var spots = get_tree().get_nodes_in_group(resource_name)
  if spots != []:
    move_to(get_closest_in_array(spots).global_position)
    
func get_closest_in_array(arr):
  var closest_dist = 9999999999 # distance_squared_to() a des résultats à 8 chiffres
  var closest_item = null
  for item in arr:
    var dist = global_position.distance_squared_to(item.global_position)
    if dist < closest_dist:
      closest_dist = dist
      closest_item = item
  return closest_item


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
  _on_ready()

# appelée par _ready pour être overloadable
func _on_ready() -> void:
  for attr in Dictionaries.caracs:
    var new_attribute = Attribute.new(attr, "caracs")
    attributes[attr] = new_attribute
  for attr in Dictionaries.skills:
    var new_attribute = Attribute.new(attr, "skills")
    attributes[attr] = new_attribute
  for attr in Dictionaries.masteries:
    var new_attribute = Attribute.new(attr, "masteries")
    attributes[attr] = new_attribute
  texture_progress.hide()
  techs = [Data.techs[0], Data.techs[1], Data.techs[2], Data.techs[3], Data.techs[4]]
  for tech in techs:
    cooldowns.append(0.0)
  yield(get_tree(), "idle_frame")
  emit_signal("tech_list_changed", techs)

func _physics_process(delta):


  if not is_dead:
    # Regens  
    var gain = clamp(delta, 0.0, health_regain)
    health_regain -= gain
    self.health += delta * BASE_HEALTH_REGEN + gain
    gain = clamp(delta, 0.0, stamina_regain)
    stamina_regain -= gain
    self.stamina += delta * BASE_STAMINA_REGEN + gain
    gain = clamp(delta, 0.0, mana_regain)
    mana_regain -= gain
    self.mana += delta * BASE_MANA_REGEN + gain
    
  if target_position != null:
    var final_move_speed = clamp(move_speed - weight_speed_malus, 0, MAX_MOVE_SPEED)
    velocity = global_position.direction_to(target_position) * final_move_speed
    if global_position.distance_to(target_position) > 5:
      velocity = move_and_slide(velocity)
    else:
      global_position = target_position
      stop_moving()
  if !!current_resource_spot && not is_dead:
    var level = get_total_attribute(current_resource_spot.skill)
    var harvest_gain = (1.0 + (level - 1) * 0.05) * HARVEST_GAIN_PER_SECOND * delta
    self.harvest_progress += harvest_gain
    self.stamina -= current_resource_spot.stamina_loss_while_harvesting * delta
    if stamina == 0.0:
      stop_harvesting()
      
  var cooldown_changed = false
  for key in techs.size():
    if cooldowns[key] > 0.0:
      cooldowns[key] = max(0.0, cooldowns[key] - delta)
      cooldown_changed = true
  if cooldown_changed:
    emit_signal("cooldowns_changed", cooldowns)
      
