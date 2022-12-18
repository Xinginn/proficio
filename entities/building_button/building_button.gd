extends TextureButton

const WHITE_HUE: Color = Color("ffffff")
const RED_HUE: Color = Color("cd1e1e")

var building_data: BuildingData = null

signal building_button_pressed(data)
signal building_button_right_pressed

func check_for_availability():
  if !GameManager.player_actor.has_resources(building_data.resources):
    self_modulate = RED_HUE
  else:
    self_modulate = WHITE_HUE  

func _initialize(data: BuildingData) -> void:
  building_data = data
  texture_normal = load("res://assets/buildings/%s.png" % data._name)
  check_for_availability()

func _on_mouse_entered():
  BuildingTooltip.display(building_data)

func _on_mouse_exited():
  BuildingTooltip.hide()

func _on_pressed() -> void:
  if GameManager.player_actor.has_resources(building_data.resources):
    emit_signal('building_button_pressed', building_data)

func _on_player_inventory_changed(_inventory: Inventory) -> void:
  check_for_availability()

func _on_BuildingButton_gui_input(event):
  if event is InputEventMouseButton:
    if event.button_index == BUTTON_RIGHT and event.pressed:
      emit_signal("building_button_right_pressed")
