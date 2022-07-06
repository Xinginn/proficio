extends Sprite

class_name Building

onready var health_bar = $HealthBar
onready var health_bar_label = $HealthBar/Label

var health setget _set_health
var max_health
var building_owner = null
var building_data: BuildingData = null
var is_building: bool = false

signal building_destroyed(building)
signal building_constructed(building)

func _set_health(value):
  health = int(clamp(value, 0, max_health))
  health_bar.value = health
  health_bar_label.text = "%d / %d" % [health, max_health]
  if health == 0:
    emit_signal('building_destroyed', self)
    queue_free()

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
        display_buidling_window(true)

func _on_body_exited(body):
  if body == building_owner:
    is_building = false
    display_buidling_window(false) 
        
func _process(delta):
  if is_building:
    var health_gain = 50 * building_owner.construction * delta
    self.health += health_gain
    building_owner.gain_xp("construction", 50 * delta)
    if health >= max_health:
      emit_signal('building_constructed', self)
      is_building = false
      display_buidling_window(true)
