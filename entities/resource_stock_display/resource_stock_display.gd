extends TextureRect

onready var stock_label: Label = $StockLabel

var stock: int setget _set_stock

func _set_stock(value):
  stock_label.text = str(value)
