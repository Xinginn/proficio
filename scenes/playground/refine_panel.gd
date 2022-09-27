extends Panel

const refine_button_scene: PackedScene = preload('res://entities/refine_recipe_button/refine_recipe_button.tscn')

onready var recipe_container: VBoxContainer = $RefineRecipeContainer

signal refine_requested(data)

func _initialize(building):
  for child in recipe_container.get_children():
    child.queue_free()
  for _data in building.building_data.refine_ids:
    print('in for')
    print(_data)
    var new_refine_button = refine_button_scene.instance()
    recipe_container.add_child(new_refine_button)
    new_refine_button._initialize(Data.refines[_data])
    new_refine_button.connect("refine_button_pressed", self, "_on_refine_button_pressed")
#    new_stackable_item.connect('storage_requested', self, '_on_store_request_from_stackable_item')
#    new_stackable_item.connect('withdraw_requested', self, '_on_withdraw_request_from_stackable_item')
#    new_stackable_item.connect('buy_requested', self, '_on_buy_request_from_stackable_item')
#    stackable_items[item_name] = new_stackable_item
#  check_for_affordable_items(GameManager.player_actor.gold)


func _on_refine_button_pressed(data) -> void:
  emit_signal('refine_requested', data)

func _on_current_refine_changed(data) -> void:
  print('panel receive change refine from building', data)

func _on_refine_progress_changed(value) -> void:
  pass

func _ready():
  pass # Replace with function body.
