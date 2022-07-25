extends HBoxContainer

onready var name_label: Label = $NameLabel
onready var level_label: Label = $LevelLabel
onready var progress_label: Label = $ProgressLabel


# Called when the node enters the scene tree for the first time.
func update_display(attribute_name: String) -> void:
  var attribute = GameManager.player_actor.attributes[attribute_name]
  name_label.text = Dictionaries.attribute_names[attribute.attribute_name]
  level_label.text = str(attribute.level)
  progress_label.text = "%.0f%%" % (attribute.xp*100 / attribute.needed_xp)
