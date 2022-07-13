extends TextureButton

const RED_HUE: Color = Color("cd1e1e")

var building_data: BuildingData = null

signal building_button_pressed(data)
signal building_button_pright_pressed

func _initialize(data: BuildingData) -> void:
  building_data = data
  texture_normal = load("res://assets/buildings/%s.png" % data.label)
  if !GameManager.player_actor.has_resources(data.resources):
    self_modulate = RED_HUE

func _on_pressed() -> void:
  if GameManager.player_actor.has_resources(building_data.resources):
    emit_signal('building_button_pressed', building_data)


func _on_BuildingButton_gui_input(event):
  if event is InputEventMouseButton:
    if event.button_index == BUTTON_RIGHT and event.pressed:
      emit_signal("building_button_pright_pressed")
