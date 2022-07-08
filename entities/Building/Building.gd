extends Sprite
class_name Building

const HEALTH_GAIN_PER_SECOND = 50
const CRAFT_GAIN_PER_SECOND = 50
const MAX_QUEUE_SIZE = 8

onready var health_bar = $HealthBar
onready var health_bar_label = $HealthBar/Label

var health setget _set_health
var max_health
var building_owner = null
var building_data: BuildingData = null
var is_building: bool = false
var is_crafting: bool = false
var craft_progress: float = 0.0 setget _set_craft_progress
var craft_queue: Array = []

signal building_destroyed(building)
signal building_constructed(building)
signal craft_progress_changed(value)
signal player_entered_owned_building(data)
signal player_exited_owned_building(data)
signal craft_queue_changed(queue)

func _set_health(value) -> void:
  health = int(clamp(value, 0, max_health))
  health_bar.value = health
  health_bar_label.text = "%d / %d" % [health, max_health]
  if health == 0:
    emit_signal('building_destroyed', self)
    queue_free()
  if health == max_health:
    emit_signal('building_constructed', self)
    is_building = false
    emit_signal("player_entered_owned_building", building_data)

func _set_craft_progress(value) -> void:
  craft_progress = value
  emit_signal('craft_progress_changed', craft_progress)
  if craft_queue.size() > 0:
    if craft_progress >= craft_queue[0].needed_progress:
      building_owner.inventory.append(craft_queue[0].product.new(building_owner))
      # gain de pex
      building_owner.gain_xp("leatherwork", 4)
      # changement d'item
      craft_queue.pop_front()
      emit_signal('craft_queue_changed', craft_queue)
      if craft_queue.size() == 0:
        is_crafting = false
      craft_progress = 0

func init(_owner, data, pos) -> void:
  building_owner = _owner
  building_data = data
  global_position = pos
  max_health = building_data.max_health + 5 * _owner.construction
  health_bar.max_value = max_health
  self.health = 1
  # TODO set position et largeur health_bar

func display_buidling_window(_visible: bool):
  print("should toggle building display ", _visible)

func _on_body_entered(body):
  if body is Actor:
    body.stop_moving()
    if body == building_owner:
      if health < max_health:
        is_building = true
      elif body == GameManager.player_actor:
        emit_signal("player_entered_owned_building", building_data)

func _on_body_exited(body):
  if body == building_owner:
    is_building = false
    emit_signal('player_exited_owned_building', building_data)
        
func _process(delta):
  if is_building:
    var health_gain = HEALTH_GAIN_PER_SECOND * building_owner.construction * delta
    self.health += health_gain
    building_owner.gain_xp("construction", HEALTH_GAIN_PER_SECOND * delta)
  elif is_crafting:
    if craft_queue.size() == 0:
      is_crafting = false
      return
    var skill_level = building_owner.get(craft_queue[0].skill)
    var craft_gain = CRAFT_GAIN_PER_SECOND * skill_level * delta
    self.craft_progress += craft_gain 
  else:
    pass

# signaux: recipe_button -> craft panel -> ici
func _on_recipe_requested(craft_data) -> void:
  var queue_size = craft_queue.size()
  if queue_size < MAX_QUEUE_SIZE:
    craft_queue.append(craft_data)
    emit_signal('craft_queue_changed', craft_queue)
  if queue_size == 0:
    is_crafting = true

func _on_cancel_requested(index) -> void:
  craft_queue.remove(index)
  emit_signal('craft_queue_changed', craft_queue)
