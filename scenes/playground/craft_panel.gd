extends Panel

const recipe_button_scene: PackedScene = preload('res://entities/recipe_button/recipe_button.tscn')

onready var recipe_container: VBoxContainer = $CraftListScroll/RecipeContainer
onready var current_craft_icon: TextureRect = $CurrentCraftIcon
onready var current_craft_progress_bar: TextureProgress = $CurrentCraftIcon/TextureProgress
onready var queue_container: GridContainer = $QueueContainer

signal recipe_added_to_queue(index)
signal recipe_removed_from_queue(index)

func show():
  .show()
  # TODO affichage liste craft_datas, queue et progress laissé en plan

func _on_craft_progress_changed(value):
  current_craft_progress_bar.value = value

func _on_player_entered_own_building():
  # signal in
  print("should display ")

func _on_queue_changed(queue: Array):
  # signal in
  print("should sort queue display")
  # display du premier élement en 'current' + gestion max_value de la barre + value à 0 (normalement)

func _on_queue_button_cancel_pressed(index):
  # signal out 
  print("should update remove index %d from craft_queue" % index)
