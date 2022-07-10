extends Panel

onready var gold_label: Label = $GoldIcon/Label 

func _on_gold_changed(value):
  gold_label.text = str(value)

func _ready():
  pass # Replace with function body.
