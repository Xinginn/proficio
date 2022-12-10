extends Panel

const stackable_item_scene: PackedScene = preload('res://entities/stackable_store_item/stackable_store_item.tscn')

onready var gold_label: Label = $GoldIcon/GoldLabel
onready var stackables_grid: GridContainer = $StackablesContainer/StackableGrid
onready var equipable_lines_container: VBoxContainer = $EquipablesContainer/LinesContainer
onready var equipable_items_grid: GridContainer = $EquipablesContainer/MarginContainer/ItemsGrid

var stackable_items = {}
var building: Building = null

signal equipable_storage_requested(_name)
signal stackable_storage_requested(_name)
signal stackable_withdrawal_requested(_name)
signal stackable_buy_requested(_name, customer)
signal stackable_sell_requested(_name, seller)

func _initialize(_building):
  building = _building
  stackable_items = {}
  gold_label.text = "%s" % _building.gold_storage
  for child in stackables_grid.get_children():
    child.queue_free()
  for item_name in _building.building_data.storable_stackables:
    var new_stackable_item = stackable_item_scene.instance()
    stackables_grid.add_child(new_stackable_item)
    new_stackable_item._initialize(item_name, _building)
    new_stackable_item.connect('storage_requested', self, '_on_store_request_from_stackable_item')
    new_stackable_item.connect('withdraw_requested', self, '_on_withdraw_request_from_stackable_item')
    new_stackable_item.connect('buy_requested', self, '_on_buy_request_from_stackable_item')
    new_stackable_item.connect('sell_requested', self, '_on_sell_request_from_stackable_item')
    stackable_items[item_name] = new_stackable_item
  check_for_affordable_items()
  check_for_player_sellable_items()
    
func check_for_affordable_items():
  var player_gold = GameManager.player_actor.gold
  var resource_names = Dictionaries.resource_names.keys()
  var barter_level = GameManager.player_actor.get_total_attribute("bartering")
  var expected_price = 0
  var base_price = 0
  for item_name in stackable_items.keys():
    if item_name in resource_names:
      base_price = Dictionaries.resource_prices[item_name]
    else:
      # item temporaire pour avoir le prix
      var new_item = load('res://classes/item/consumable/%s.gd' % item_name).new()
      base_price = new_item.base_price
      new_item.destroy() # penser à destroy, l'objet étant orphelin il n'est pas detruit tout seul
    expected_price = int(round( (base_price / (0.99 + 0.01 * barter_level) ) ))
    stackable_items[item_name].is_affordable = expected_price <= player_gold
    
func check_for_player_sellable_items():
  if building == null:
    return
  var barter_level = GameManager.player_actor.get_total_attribute("bartering")
  var base_price = 0
  for item_name in stackable_items.keys():
    if item_name in Dictionaries.resource_names.keys():
      base_price = Dictionaries.resource_prices[item_name]
    else:
      # item temporaire pour avoir le prix
      var new_item = load('res://classes/item/consumable/%s.gd' % item_name).new()
      base_price = new_item.base_price
      new_item.destroy() # penser à destroy, l'objet étant orphelin il n'est pas detruit tout seul
    var no_quantity = false
    if item_name in Dictionaries.resource_names:
      no_quantity = GameManager.player_actor.inventory.resources[item_name] == 0
    else:
      no_quantity = GameManager.player_actor.inventory.get_item_names().has(item_name)
    var cannot_afford = building.gold_storage < int(round(base_price / 2.0 ))
    stackable_items[item_name].sell_button.disabled = no_quantity || cannot_afford

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
  check_for_player_sellable_items()

# TODO checker aussi lors du changement de bartering_level
func _on_gold_changed(player_gold):
  check_for_affordable_items()
  
func _on_building_gold_changed(building_gold):
  gold_label.text = str(building_gold)
  check_for_player_sellable_items()
      
func _on_stackable_storage_changed(stackable_storage):
  for item_name in stackable_storage.keys():
    stackable_items[item_name].quantity = stackable_storage[item_name]
  check_for_affordable_items()

func _on_store_request_from_equipable_item(item_name):
  emit_signal("equipable_storage_requested", item_name)

func _on_store_request_from_stackable_item(item_name):
  emit_signal("stackable_storage_requested", item_name)

func _on_withdraw_request_from_stackable_item(item_name):
  emit_signal("stackable_withdrawal_requested", item_name)

func _on_buy_request_from_stackable_item(item_name, customer) -> void:
  emit_signal("stackable_buy_requested", item_name, customer)

func _on_sell_request_from_stackable_item(item_name, seller) -> void:
  emit_signal("stackable_sell_requested", item_name, seller)
