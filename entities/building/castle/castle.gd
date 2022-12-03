extends Building
class_name Castle

const TIME_FOR_BASE_RESOURCES_GAIN = 5.0
const TIME_FOR_COMMON_RESOURCES_GAIN = 10.0
const TIME_FOR_RARE_RESOURCES_GAIN = 20.0
const BASE_HEALTH_REGEN = 0.0
const BASE_UPGRADE_GAIN = 0.0
const TIME_FOR_INSTANT_RESURRECTION_GAIN = 5.0

var base_resources_ticks: float = 0.0 setget _set_base_resources_ticks
var common_resources_ticks: float = 0.0 setget _set_common_resources_ticks
var rare_resources_ticks: float = 0.0 setget _set_rare_resources_ticks

var base_resources = ["grain", "herb", "stone", "wood" ]
var common_resources = ["fabric", "skin", "ore", "parchment"]
var rare_resources = ["plank", "brick", "cristal", "iron", "leather",]

var upgrade = 0.0 setget _set_upgrade
var max_upgrade = 50.0
var upgrade_level = 1
var health_regain = 20.0
var upgrade_regain = 0.0
var instant_resurrection_stock: int = 0 setget _set_instant_resurrection_stock
var instant_resurrection_ticks: float = 0.0 setget _set_instant_resurrection_ticks

var team = 0

signal health_changed(current, maxi, regain)
signal upgrade_changed(current, maxi, regain)
signal upgrade_level_gained(castle)
signal instant_resurrection_stock_changed(value)
signal instant_resurrection_ticks_changed(value)
signal castle_destroyed(castle)

func _set_health(value) -> void:
  health = clamp(value, 0, max_health)
  health_bar.value = health
  health_bar.max_value = max_health
  health_bar_label.text = "%d / %d" % [health, max_health]
  emit_signal('health_changed', health, max_health, health_regain)
  if health <= 0.0:
    emit_signal('castle_destroyed', self)
    emit_signal('building_destroyed', self)
    queue_free()
    
func _set_upgrade(value) -> void:
  upgrade = clamp(value, 0, max_upgrade)
  if upgrade == max_upgrade:
    pass #TODO gerer upgrade de level
  emit_signal('upgrade_changed', upgrade, max_upgrade, upgrade_regain)
  
func _set_instant_resurrection_stock(value) -> void:
  instant_resurrection_stock = clamp(value, 0, 99)
  emit_signal("instant_resurrection_stock_changed", instant_resurrection_stock)
  
func _set_instant_resurrection_ticks(value) -> void:
  instant_resurrection_ticks = value
  if instant_resurrection_ticks >= TIME_FOR_INSTANT_RESURRECTION_GAIN:
    instant_resurrection_ticks -= TIME_FOR_INSTANT_RESURRECTION_GAIN
    self.instant_resurrection_stock += 1
  emit_signal("instant_resurrection_ticks_changed", instant_resurrection_ticks)

func _set_base_resources_ticks(value) -> void:
  base_resources_ticks = value
  if base_resources_ticks > TIME_FOR_BASE_RESOURCES_GAIN:
    base_resources_ticks -= TIME_FOR_BASE_RESOURCES_GAIN
    for resource_name in base_resources:
      stackable_storage[resource_name] += 1
    emit_signal('stackable_storage_changed', stackable_storage)
    self.gold_storage += 1
    
func _set_common_resources_ticks(value) -> void:
  common_resources_ticks = value
  if common_resources_ticks > TIME_FOR_COMMON_RESOURCES_GAIN:
    common_resources_ticks -= TIME_FOR_COMMON_RESOURCES_GAIN
    for resource_name in common_resources:
      stackable_storage[resource_name] += 1
    emit_signal('stackable_storage_changed', stackable_storage)
 
func _set_rare_resources_ticks(value) -> void:
  rare_resources_ticks = value
  if rare_resources_ticks > TIME_FOR_RARE_RESOURCES_GAIN:
    rare_resources_ticks -= TIME_FOR_RARE_RESOURCES_GAIN
    for resource_name in rare_resources:
      stackable_storage[resource_name] += 1
    emit_signal('stackable_storage_changed', stackable_storage)

func require_instant_resurrection(actor):
  if instant_resurrection_stock > 0 && actor.is_dead:
    self.instant_resurrection_stock -= 1
    actor.live()

    
func _on_actor_finished_contribution(_name, actor):
  actor.end_contribution()
  match _name:
    "repair":
      health_regain += 5;
    "upgrade":
      upgrade_regain += 5

func _ready() -> void:
  connect('castle_destroyed', GameManager, '_on_castle_destroyed')
  building_data = Data.buildings[0]
  max_health = building_data.max_health
  self.health = max_health - 200.0
  for _name in building_data.storable_stackables:
    stackable_storage[_name] = 0

func _process(delta):
  self.base_resources_ticks += delta
  self.common_resources_ticks += delta
  self.rare_resources_ticks += delta
  
  var gain = clamp(delta, 0.0, health_regain)
  health_regain -= gain
  self.health += delta * BASE_HEALTH_REGEN + gain
  
  gain = clamp(delta, 0.0, upgrade_regain)
  upgrade_regain -= gain
  self.upgrade += delta * BASE_UPGRADE_GAIN + gain
  
  self.instant_resurrection_ticks += delta  #TODO reduire vitesse de gain selon stock ?
  
