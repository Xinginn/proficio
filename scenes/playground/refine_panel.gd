extends Panel

const refine_button_scene: PackedScene = preload('res://entities/refine_recipe_button/refine_recipe_button.tscn')

onready var recipe_container: VBoxContainer = $RefineRecipeContainer
onready var progress_bar: TextureProgress = $CurrentRefine/TextureProgress
onready var loop_button: TextureButton = $LoopButton

signal refine_requested(data)
signal refine_loop_toggled(value)

func _initialize(building):
  progress_bar.value = 0.0
  for child in recipe_container.get_children():
    child.disconnect("refine_button_pressed", self, "_on_refine_button_pressed")
    child.queue_free()
  for _data in building.building_data.refine_ids:
    var new_refine_button = refine_button_scene.instance()
    recipe_container.add_child(new_refine_button)
    new_refine_button._initialize(Data.refines[_data])
    new_refine_button.connect("refine_button_pressed", self, "_on_refine_button_pressed")
  loop_button.pressed = building.is_refine_looping
#  check_for_affordable_items(GameManager.player_actor.gold)

# --- emit to building ---
func _on_refine_button_pressed(data) -> void:
  emit_signal('refine_requested', data)

func _on_loop_button_toggled(value: bool):
  emit_signal("refine_loop_toggled", value)

# --- receive from building ---
func _on_current_refine_changed(data) -> void:
  if !!data:
    progress_bar.max_value = data.time

func _on_refine_progress_changed(value) -> void:
  progress_bar.value = value

func _on_player_entered_owned_building(building) -> void:
  _initialize(building)
