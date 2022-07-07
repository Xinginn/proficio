extends Panel

const recipe_button_scene: PackedScene = preload('res://entities/recipe_button/recipe_button.tscn')

onready var recipe_container: VBoxContainer = $CraftListScroll/RecipeContainer
onready var current_craft_icon: TextureRect = $CurrentCraftIcon
onready var current_craft_progress_bar: TextureProgress = $CurrentCraftIcon/TextureProgress
onready var queue_container: GridContainer = $QueueContainer

signal recipe_button_pressed(index)
signal cancel_craft_button_pressed(index)


func _on_craft_progress_changed(value):
  current_craft_progress_bar.value = value

func _on_player_entered_owned_building(building_data):
  print("should display")
  # cleanup
  for child in recipe_container.get_children():
    child.queue_free()
  for id in building_data.craft_ids:
    var new_button = recipe_button_scene.instance()
    recipe_container.add_child(new_button)
    new_button._initialize(Data.crafts[id])
  # TODO affichage liste craft_datas, queue et progress laissé en plan
  show()
    
func _on_player_exited_owned_building(building_data):
  hide()

func _on_queue_changed(queue: Array):
  # signal in
  print("should sort queue display")
  # display du premier élement en 'current' + gestion max_value de la barre + value à 0 (normalement)

func _on_queue_button_cancel_pressed(index):
  # signal out 
  print("should update remove index %d from craft_queue" % index)
