extends Panel

const stackable_item_scene: PackedScene = preload('res://entities/stackable_store_item/stackable_store_item.tscn')

onready var gold_label: Label = $GoldIcon/GoldLabel
onready var stackables_container: GridContainer = $StackablesContainer
onready var equipable_lines_container: VBoxContainer = $EquipablesContainer/LinesContainer
onready var equipable_items_grid: GridContainer = $EquipablesContainer/MarginContainer/ItemsGrid

var stackable_items = {}


func _initialize(building):
  for child in stackables_container.get_children():
    child.queue_free()
  for item_name in building.building_data.storable_stackables:
    var new_stackable_item = stackable_item_scene.instance()
    stackables_container.add_child(new_stackable_item)
    new_stackable_item._initialize(item_name, building)

func _ready():
  pass # Replace with function body.
