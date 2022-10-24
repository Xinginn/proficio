extends HBoxContainer

const cooldown_display_scene: PackedScene = preload('res://entities/cooldown_display/cooldown_display.tscn')

onready var label = get_node('../Label')

var displays = []
var dragged_index = null setget _set_label

signal hotkeys_switched(index_a, index_b)

func _set_label(value):
  dragged_index = value
  label.text = str(value) if !!value else 'null'


func _on_hotkey_entered(index):
  self.dragged_index = index
  
func _on_hotkey_exited(index):
  self.dragged_index = null

func _on_tech_list_changed(techs):
  for child in get_children():
    child.queue_free()
  for i in range(techs.size()):
    var new_display = cooldown_display_scene.instance()
    new_display.index = i
    add_child(new_display)
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
      if !event.pressed:
        print("released")
        #emit_signal("hotkeys_switched", dragged_index, index)
      else:
        print('pressed')
      


func ready():
  displays = get_children()
