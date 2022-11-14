extends Building
class_name Castle

const TIME_FOR_BASE_RESOURCES_GAIN = 5.0
const TIME_FOR_COMMON_RESOURCES_GAIN = 10.0
const TIME_FOR_RARE_RESOURCES_GAIN = 20.0

var base_resources_ticks: float = 0.0 setget _set_base_resources_ticks
var common_resources_ticks: float = 0.0 setget _set_common_resources_ticks
var rare_resources_ticks: float = 0.0 setget _set_rare_resources_ticks

var base_resources = ["grain", "herb", "stone", "wood" ]
var common_resources = ["fabric", "skin", "ore", "parchment"]
var rare_resources = ["plank", "brick", "cristal", "iron", "leather",]

signal castle_destroyed


func _set_health(value) -> void:
  ._set_health(value)
  if health <= 0.0:
    print('should handle team elimination')
    emit_signal('castle_destroyed')

func _set_base_resources_ticks(value) -> void:
  base_resources_ticks = value
  if base_resources_ticks > TIME_FOR_BASE_RESOURCES_GAIN:
    base_resources_ticks -= TIME_FOR_BASE_RESOURCES_GAIN
    for resource_name in base_resources:
      stackable_storage[resource_name] += 1
    emit_signal('stackable_storage_changed', stackable_storage)
    
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

func _ready() -> void:
  building_data = Data.buildings[0]
  max_health = building_data.max_health
  self.health = max_health
  for _name in building_data.storable_stackables:
    stackable_storage[_name] = 0

func _process(delta):
  self.base_resources_ticks += delta
  self.common_resources_ticks += delta
  self.rare_resources_ticks += delta
  
