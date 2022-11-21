extends HBoxContainer

const cooldown_display_scene: PackedScene = preload('res://entities/cooldown_display/cooldown_display.tscn')
const CHILD_SIZE = 48
const SEPARATION = 3

var displays = []
var drag_start_index = null

signal hotkeys_switched(index_a, index_b)

func _on_tech_list_changed(techs: Dictionary):
  for child in get_children():
    child.queue_free()
  for i in techs.keys():
    var new_display = cooldown_display_scene.instance()
    add_child(new_display)
    new_display.initialize(i)
    new_display.connect('hotkey_entered', self, '_on_hotkey_entered')
    new_display.connect('hotkey_exited', self, '_on_hotkey_exited')

func _on_player_cooldowns_changed(cooldowns):
  displays = get_children() # temp
  for key in cooldowns.size():
    displays[key].cooldown = cooldowns[key]

# gestion swap buttons
func _on_gui_input(event):
  if event is InputEventMouseButton:
    if event.button_index == BUTTON_LEFT:
      var hovered_index = int( (get_global_mouse_position() - rect_global_position).x / (CHILD_SIZE + SEPARATION) )
      if event.pressed:
        drag_start_index = hovered_index
      else:
        emit_signal("hotkeys_switched", drag_start_index, hovered_index)
        drag_start_index = null

func ready():
  displays = get_children()
