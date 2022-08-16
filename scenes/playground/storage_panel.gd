extends Panel

const stackable_item_scene: PackedScene = preload('res://entities/stackable_store_item/stackable_store_item.tscn')

onready var gold_label: Label = $GoldIcon/GoldLabel
onready var stackables_container: GridContainer = $StackablesContainer
onready var equipable_lines_container: VBoxContainer = $EquipablesContainer/LinesContainer
onready var equipable_items_grid: GridContainer = $EquipablesContainer/MarginContainer/ItemsGrid

var stackable_items = {}

signal equipable_storage_requested(_name)
signal stackable_storage_requested(_name)
signal stackable_withdrawal_requested(_name)
signal stackable_buy_requested(_name, customer)


func _initialize(building):
  for child in stackables_container.get_children():
    child.queue_free()
  for item_name in building.building_data.storable_stackables:
    var new_stackable_item = stackable_item_scene.instance()
    stackables_container.add_child(new_stackable_item)
    new_stackable_item._initialize(item_name, building)
    new_stackable_item.connect('storage_requested', self, '_on_store_request_from_stackable_item')
    new_stackable_item.connect('withdraw_requested', self, '_on_withdraw_request_from_stackable_item')
    new_stackable_item.connect('buy_requested', self, '_on_buy_request_from_stackable_item')
    stackable_items[item_name] = new_stackable_item

func _on_inventory_changed(_inventory):
  var resource_names = Dictionaries.resource_names.keys()
  var item_names = _inventory.get_item_names()
  
  for item_name in stackable_items.keys():
    var quantity = 0
    if item_name in resource_names:
      quantity = _inventory.resources[item_name]
    else:
      var index = item_names.find(item_name)
      if index != -1:
        quantity = _inventory.items[index].stack
    stackable_items[item_name].store_button.disabled = (quantity == 0)


func _on_stackable_storage_changed(stackable_storage):
  for item_name in stackable_storage.keys():
    stackable_items[item_name].quantity = stackable_storage[item_name]


func _on_store_request_from_equipable_item(item_name):
  emit_signal("equipable_storage_requested", item_name)

func _on_store_request_from_stackable_item(item_name):
  emit_signal("stackable_storage_requested", item_name)

func _on_withdraw_request_from_stackable_item(item_name):
  emit_signal("stackable_withdrawal_requested", item_name)

func _on_buy_request_from_stackable_item(item_name, customer) -> void:
  emit_signal("stackable_buy_requested", item_name, customer)
