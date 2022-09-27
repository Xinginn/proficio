extends Sprite
class_name Building

#const HEALTH_GAIN_SPEED = 100
#const CRAFT_GAIN_SPEED = 100
const HEALTH_GAIN_SPEED = 1000 # valeur boostée pour simplicité de test
const CRAFT_GAIN_SPEED = 1000
const REFINE_GAIN_SPEED = 1
const MAX_QUEUE_SIZE = 8
const STAMINA_LOSS_WHILE_BUILDING = 2.0
const STAMINA_LOSS_WHILE_CRAFTING = 2.0

onready var occupied_space = $OccupiedSpaceArea
onready var health_bar = $HealthBar
onready var health_bar_label = $HealthBar/Label

var health setget _set_health
var max_health
var building_owner = null
var building_data: BuildingData = null
var is_building: bool = false
var is_crafting: bool = false setget _set_is_crafting
var is_refining: bool = false
var is_spawning: bool = false
var craft_progress: float = 0.0 setget _set_craft_progress
var craft_queue: Array = []
var refine_progress: float = 0.0 setget _set_refine_progress
var is_refine_looping: bool = true
var current_refine_data: RefineData = null setget _set_current_refine_data
var frames_since_no_overlap: int = 0

var gold_storage: int = 0 setget _set_gold_storage
var stackable_storage = {}
var equipable_storage = []

signal building_destroyed(building)
signal building_constructed(building)
signal craft_progress_changed(value)
signal craft_queue_changed(queue)
signal refine_progress_changed(value)
signal current_refine_changed(value)
signal player_entered_building(building)
signal player_entered_owned_building(data)
signal player_exited_building

signal occupied_space_overlapped(building)
signal ended_spawning(building)
signal stackable_storage_changed(storage)
signal gold_storage_changed(gold)

func _set_is_crafting(value: bool) -> void:
  is_crafting = value

func _set_health(value) -> void:
  health = int(clamp(value, 0, max_health))
  health_bar.value = health
  health_bar_label.text = "%d / %d" % [health, max_health]
  if health == 0:
    emit_signal('building_destroyed', self)
    queue_free()
  if health == max_health:
    # TODO gerer valeur de px gagné
    building_owner.gain_xp("construction", 10)
    emit_signal('building_constructed', self)
    is_building = false
    if building_owner == GameManager.player_actor:
      emit_signal("player_entered_owned_building", self)

func _set_craft_progress(value) -> void:
  craft_progress = value
  emit_signal('craft_progress_changed', craft_progress)
  if craft_queue.size() > 0:
    if craft_progress >= craft_queue[0].needed_progress:
      building_owner.add_item(craft_queue[0].product.new(building_owner))
      # gain de pex
      building_owner.gain_xp(craft_queue[0].skill, craft_queue[0].xp)
      # changement d'item
      craft_queue.pop_front()
      emit_signal('craft_queue_changed', craft_queue)
      if craft_queue.size() == 0:
        is_crafting = false
      craft_progress = 0
      
func _set_current_refine_data(data) -> void:
  current_refine_data = data
  self.refine_progress = 0.0
  is_refining = !!data
  emit_signal("current_refine_changed", data)      
      
func _set_refine_progress(value) -> void:
  refine_progress = value
  if !current_refine_data:
    return
  elif refine_progress >= current_refine_data.time:
    building_owner.gain_xp(current_refine_data.skill_name, current_refine_data.xp_gain)
    for input_name in current_refine_data.inputs.keys():
      building_owner.remove_resource(input_name, current_refine_data.inputs[input_name])
    for output_name in current_refine_data.outputs.keys():
      building_owner.add_resource(output_name, current_refine_data.outputs[output_name])
    if is_refine_looping:
      refine_progress -= current_refine_data.time
    else:
      refine_progress = 0.0
      is_refining = false
      self.current_refine_data = null
  emit_signal('refine_progress_changed', refine_progress)
  
func _set_gold_storage(value) -> void:
  gold_storage = value
  emit_signal("gold_storage_changed", gold_storage)

func _initialize(_owner, data, pos) -> void:
  building_owner = _owner
  building_data = data
  self.gold_storage = 0
  texture = load("res://assets/buildings/%s.png" % data._name)
  global_position = pos
  var level = building_owner.get_total_attribute("construction")
  max_health = int(building_data.max_health * (1.0 + (level - 1) * 0.05 ))
  health_bar.max_value = max_health
  self.health = 1
  for item_name in building_data.storable_stackables:
    stackable_storage[item_name] = 0
  # TODO gerer storage possible d'equipable
  # TODO set position et largeur health_bar

func display_buidling_window(_visible: bool):
  print("should toggle building display ", _visible)

func _on_body_entered(body):
  if body is Actor:
    body.stop_moving()
    if body == GameManager.player_actor:
      emit_signal('player_entered_building', self)
    if body == building_owner:
      if health < max_health:
        is_building = true
      elif body == GameManager.player_actor:
        emit_signal("player_entered_owned_building", self)
        emit_signal('craft_queue_changed', craft_queue)
        is_crafting = true
    
func _on_body_exited(body):
  if body == building_owner:
    is_building = false
    is_crafting = false
    is_refining = false
    emit_signal('craft_queue_changed', [])
  if body is Player:
    emit_signal('player_exited_building')

# signaux: recipe_button -> craft panel -> ici
func _on_recipe_requested(craft_data) -> void:
  var cost = craft_data.resources
  if building_owner.has_resources(cost):
    for res in cost.keys():
      building_owner.remove_resource(res, cost[res])
    var queue_size = craft_queue.size()
    if queue_size < MAX_QUEUE_SIZE:
      craft_queue.append(craft_data)
      emit_signal('craft_queue_changed', craft_queue)
    if queue_size == 0:
      self.is_crafting = true
  else:
    pass
 
func _on_refine_requested(refine_data) -> void:
  # TODO ajouter verifs de couts
  self.current_refine_data = refine_data
  self.refine_progress = 0.0
  
func _on_refine_loop_toggled(value: bool) -> void:
  is_refine_looping = value
  
func _on_cancel_requested(index) -> void:
  var refund = craft_queue[index].resources
  for res in refund.keys():
    building_owner.add_resource(res, refund[res])
  craft_queue.remove(index)
  emit_signal('craft_queue_changed', craft_queue)
  if craft_queue.size() == 0:
    self.craft_progress = 0
    
func _on_stackable_storage_requested(item_name) -> void:
  if item_name in building_owner.inventory.resources.keys():
    building_owner.remove_resource(item_name, 1)
  else:
    var item_names = GameManager.player_actor.inventory.get_item_names()
    var index = item_names.find(item_name)
    building_owner.remove_item(index)
  stackable_storage[item_name] += 1
  emit_signal("stackable_storage_changed", stackable_storage)
  
func _on_stackable_withdrawal_requested(item_name) -> void:
  if item_name in building_owner.inventory.resources.keys():
    building_owner.add_resource(item_name, 1)
  else:
    var new_item = load('res://classes/item/consumable/%s.gd' % item_name).new()
    building_owner.add_item(new_item)
  stackable_storage[item_name] -= 1
  emit_signal("stackable_storage_changed", stackable_storage)
  
func _on_stackable_buy_requested(item_name, customer) -> void:
  var base_price = 0
  if item_name in customer.inventory.resources.keys():
    base_price = Dictionaries.resource_prices[item_name]
    customer.add_resource(item_name, 1)
  else:
    var new_item = load('res://classes/item/consumable/%s.gd' % item_name).new()
    base_price = new_item.base_price
    customer.add_item(new_item)
  stackable_storage[item_name] -= 1
  emit_signal("stackable_storage_changed", stackable_storage)
  # gestion niveau de trade dans le prix
  self.gold_storage += base_price
  customer.gold -= int(round(base_price / (0.99 + 0.01 * customer.get_total_attribute("bartering"))))
  customer.gain_xp("bartering", base_price)

func _process(delta):
  if is_building:
    var level = building_owner.get_total_attribute("construction")
    var health_gain = HEALTH_GAIN_SPEED * (1.0 + (level - 1) * 0.05) * delta
    self.health += health_gain
    building_owner.stamina -= delta * STAMINA_LOSS_WHILE_BUILDING
    if building_owner.stamina == 0.0:
      is_building = false
  elif is_crafting:
    if craft_queue.size() == 0:
      self.is_crafting = false
      return
    var level = building_owner.get_total_attribute(craft_queue[0].skill)
    var craft_gain = CRAFT_GAIN_SPEED * (1.0 + (level - 1) * 0.05) * delta
    self.craft_progress += craft_gain 
    building_owner.stamina -= delta * STAMINA_LOSS_WHILE_CRAFTING
    if building_owner.stamina == 0.0:
      is_crafting = false
  elif is_refining:
    var level = building_owner.get_total_attribute(current_refine_data.skill_name)
    var refine_gain = REFINE_GAIN_SPEED * (1.0 + (level - 1) * 0.05) * delta
    self.refine_progress += delta
  else:
    pass

# necessaire pour la gestion des overlap au spawn
# la methode get_overlapping_areas ne donne des résultats cohérents qu'après
# qu'une frame physique ait été calculée
func _physics_process(_delta):
  if !is_spawning:
    pass
  else:
    if occupied_space.get_overlapping_areas():
      emit_signal('occupied_space_overlapped', self)
    else:
      frames_since_no_overlap += 1
      if frames_since_no_overlap >= 3:
        emit_signal('ended_spawning', self)
