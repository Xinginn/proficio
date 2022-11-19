extends Panel

onready var instant_resurrection_stock_label: Label = $InstantButton/ResurrectionStockLabel

func _on_instant_resurrection_stock_changed(value):
  instant_resurrection_stock_label.text = "Stock: %d" % value
  

func _ready():
  pass # Replace with function body.
