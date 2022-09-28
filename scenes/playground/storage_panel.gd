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
  stackable_items = {}
  gold_label.text = "%s" % building.gold_storage
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
  check_for_affordable_items(GameManager.player_actor.gold)
    
func check_for_affordable_items(player_gold):
  var resource_names = Dictionaries.resource_names.keys()
  var player_bartering_level = GameManager.player_actor.get_total_attribute("bartering")
  var expected_price = 0
  for item_name in stackable_items.keys():
    if item_name in resource_names:
      expected_price = Dictionaries.resource_prices[item_name] / (0.99 + 0.01 * player_bartering_level)
    else:
      var new_item = load('res://classes/item/consumable/%s.gd' % item_name).new()
      expected_price = new_item.base_price / (0.99 + 0.01 * player_bartering_level)
    stackable_items[item_name].buy_button.disabled = (expected_price > player_gold)

func _on_inventory_changed(_inventory):
  print(stackable_items)
  var resource_names = Dictionaries.resource_names.keys()
  var item_names = _inventory.get_item_names()
  
  for item_name in stackable_items.keys():
    print(item_name)
    var quantity = 0
    if item_name in resource_names:
      quantity = _inventory.resources[item_name]
    else:
      var index = item_names.find(item_name)
      if index != -1:
        quantity = _inventory.items[index].stack
    stackable_items[item_name].store_button.disabled = (quantity == 0)

# TODO checker aussi lors du changement de bartering_level
func _on_gold_changed(player_gold):
  check_for_affordable_items(player_gold)
  
func _on_building_gold_changed(building_gold):
  gold_label.text = str(building_gold)
      
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
