extends Panel

const recipe_button_scene: PackedScene = preload('res://entities/recipe_button/recipe_button.tscn')
const queue_button_scene: PackedScene = preload('res://entities/queue_button/queue_button.tscn')

onready var recipe_container: VBoxContainer = $CraftListScroll/RecipeContainer
onready var current_craft_icon: TextureRect = $CurrentCraftIcon
onready var current_craft_progress_bar: TextureProgress = $CurrentCraftIcon/TextureProgress
onready var queue_container: GridContainer = $QueueContainer

var queue_buttons: Array = []

signal recipe_requested(data)
signal cancel_requested(index)


func _on_player_entered_owned_building(building_data) -> void:
  # cleanup
  for child in recipe_container.get_children():
    child.queue_free()
  for id in building_data.craft_ids:
    var new_button = recipe_button_scene.instance()
    recipe_container.add_child(new_button)
    new_button._initialize(Data.crafts[id])
    new_button.connect('recipe_button_pressed', self, '_on_recipe_button_pressed')
  # TODO affichage liste craft_datas, queue et progress laissé en plan
  show()
    
func _on_player_exited_owned_building(building_data) -> void:
  hide()

func _on_craft_progress_changed(value) -> void:
  current_craft_progress_bar.value = value
  
func _on_craft_queue_changed(queue: Array) -> void:
  # signal in
  var queue_size = queue.size()
  if queue_size == 0:
    # ici, queue vide donc on nettoie tout
    current_craft_icon.texture = null
    current_craft_progress_bar.value = 0
    current_craft_progress_bar.hide()
    for child in queue_container.get_children():
      child.hide()
  else:
    current_craft_icon.show()
    current_craft_icon.texture = load('res://assets/icons/' + queue[0].product_name + ".png")
    current_craft_progress_bar.show()
    current_craft_progress_bar.max_value = queue[0].needed_progress
    # gestion de boutons (queue en plus du premier slot)
    for i in range(1, queue_size):
      queue_buttons[i-1].texture = load('res://assets/icons/' + queue[i].product_name + ".png")
      queue_buttons[i-1].show()
    for i in range(queue_size, 9):
      queue_buttons[i-1].hide()

func _on_queue_button_cancel_pressed(index) -> void:
  emit_signal('cancel_requested', index)
  
func _on_recipe_button_pressed(craft_data) -> void:
  emit_signal('recipe_requested', craft_data)

func _ready() -> void:
  
  for i in range(1, 9):
    current_craft_progress_bar.hide()
    var new_button = queue_button_scene.instance()
    queue_container.add_child(new_button)
    queue_buttons.append(new_button)
    new_button.queue_index = i
    new_button.connect('queue_button_cancel_pressed', self, '_on_queue_button_cancel_pressed')
    new_button.hide()
