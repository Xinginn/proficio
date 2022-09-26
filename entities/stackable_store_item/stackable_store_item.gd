extends HBoxContainer

onready var quantity_label: Label = $QuantityLabel
onready var icon: TextureRect = $Icon
onready var buy_button: TextureButton = $BuyButton
onready var store_button: TextureButton = $StoreButton
onready var withdraw_button: TextureButton = $WithdrawButton
onready var price_display: MarginContainer = $PriceDisplay
onready var price_label: Label = $PriceDisplay/HBoxContainer/PriceLabel

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
    price_display.hide()
  else:
    store_button.hide()
    withdraw_button.hide()
  var base_price = Dictionaries.resource_prices[item_name]
  var barter_level = GameManager.player_actor.get_total_attribute("bartering")
  var final_price = int(round( (base_price / (0.99 + 0.01 * barter_level) ) ))
  price_label.text = "%s x" % final_price

func _on_store_button_pressed():
  emit_signal('storage_requested', item_name)
  
func _on_withdraw_button_pressed():
  emit_signal('withdraw_requested', item_name)

# argument GameManager.player_actor pour préciser l'acheteur
func _on_buy_button_pressed():
  emit_signal('buy_requested', item_name, GameManager.player_actor)

func _on_mouse_entered():
  print('enter')
