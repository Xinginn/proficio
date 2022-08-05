extends HBoxContainer

onready var stat_name_label = $StatName
onready var level_label = $Level

func _initialize(data: Dictionary):
  stat_name_label.text = Dictionaries.attribute_names[data["attribute_name"]]
  level_label.text = str(data["level"])
