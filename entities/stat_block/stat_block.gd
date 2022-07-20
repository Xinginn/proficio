extends HBoxContainer

onready var name_label: Label = $NameLabel
onready var level_label: Label = $LevelLabel
onready var progress_label: Label = $ProgressLabel

var player

# Called when the node enters the scene tree for the first time.
func update_display(attribute_name: String) -> void:
  var player = GameManager.player_actor
  name_label.text = Dictionaries.attribute_names[attribute_name]
  level_label.text = str(player.get(attribute_name))
  var current = player.get(attribute_name + "_xp")
  var next = player.get_needed_xp_for_level_up(attribute_name)
  progress_label.text = "%.0f%%" % (current*100 / next)
