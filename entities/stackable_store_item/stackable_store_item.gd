extends HBoxContainer

onready var quantity_label: Label = $QuantityLabel
onready var icon: TextureRect = $Icon
onready var buy_button: TextureButton = $BuyButton
onready var store_button: TextureButton = $StoreButton
onready var withdraw_button: TextureButton = $WithdrawButton

var item_name: String = ""
var quantity: int = 0 setget _set_quantity

signal buy_requested(_name, buyer)
signal storage_requested(_name)
signal withdraw_requested(_name)

func _set_quantity(value: int):
  quantity = value
  quantity_label.text = str(quantity)
  buy_button.disabled = (quantity == 0)
  withdraw_button.disabled = (quantity == 0)
  
func _initialize(_item_name: String, _building):
  item_name = _item_name
  icon.texture = load('res://assets/icons/%s.png' % item_name)
  if _item_name in _building.stackable_storage:
    self.quantity = _building.stackable_storage[_item_name]
  else:
    self.quantity = 0
  if _building.building_owner == GameManager.player_actor:
    buy_button.hide()
  else:
    store_button.hide()

func _on_store_button_pressed():
  emit_signal('storage_requested', item_name)
  
func _on_withdraw_button_pressed():
  emit_signal('withdraw_requested', item_name)

# argument GameManager.player_actor pour préciser l'acheteur
func _on_buy_button_pressed():
  emit_signal('buy_requested', item_name, GameManager.player_actor)

