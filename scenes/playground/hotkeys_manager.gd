extends Control

const cooldown_display_scene: PackedScene = preload('res://entities/cooldown_display/cooldown_display.tscn')
const available_tech_display_scene: PackedScene = preload('res://entities/available_tech_display/available_tech_display.tscn')

const CHILD_SIZE = 48
const SEPARATION = 3

onready var cooldowns_holder = $CooldownsHolder
onready var available_techs_holder = $AvailableTechsHolder

var displays = []
var drag_start_index = null

var armed_hotkey_index = null

signal hotkeys_switched(index_a, index_b)

func show_available_techs():
  for child in available_techs_holder.get_children():
    child.queue_free()
  for tech in GameManager.player_actor.available_techs:
    var new_display = available_tech_display_scene.instance()
    available_techs_holder.add_child(new_display)
    new_display.initialize(tech)
    new_display.connect("available_tech_display_pressed", self, "_on_available_tech_display_pressed")
  # ajout d'un display à tech_data = null pour le vidage de slot
  var cancel_display = available_tech_display_scene.instance()
  available_techs_holder.add_child(cancel_display)
  cancel_display.initialize(null)
  cancel_display.connect("available_tech_display_pressed", self, "_on_available_tech_display_pressed")
    
func hide_available_techs():
  for child in available_techs_holder.get_children():
    child.queue_free()

func _on_tech_list_changed(techs: Dictionary):
  # refresh si necessaire les available techs
  if available_techs_holder.get_child_count() > 0:
    show_available_techs()
  # refresh le display de techs selectionnées en hotkey
  for child in cooldowns_holder.get_children():
    child.queue_free()
  for i in techs.keys():
    var new_display = cooldown_display_scene.instance()
    cooldowns_holder.add_child(new_display)
    new_display.initialize(i)
    new_display.connect('hotkey_pressed', self, '_on_hotkey_pressed')
    
func _on_hotkey_pressed(hotkey_index):
  armed_hotkey_index = hotkey_index
  show_available_techs()
  
func _on_available_tech_display_pressed(tech_data):
  var player = GameManager.player_actor
  player.techs[armed_hotkey_index] = tech_data
  player.emit_signal('tech_list_changed', player.techs)
  hide_available_techs()

func _on_player_cooldowns_changed(cooldowns):
  displays = cooldowns_holder.get_children() # temp
  for key in cooldowns.size():
    displays[key].cooldown = cooldowns[key]

func ready():
  displays = cooldowns_holder.get_children()
  
func _unhandled_input(event):
  if event is InputEventMouseButton:
    if !event.pressed and event.button_index == BUTTON_LEFT :
      hide_available_techs()
  if event is InputEventKey:
    if !event.pressed and event.scancode == KEY_ESCAPE:
      hide_available_techs()
