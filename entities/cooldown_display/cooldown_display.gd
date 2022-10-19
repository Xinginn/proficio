extends TextureRect

onready var cooldown_label: Label = $Label

var cooldown: float = 0.0 setget _set_cooldown 
var index: int = 0

func _set_cooldown(value) -> void:
  cooldown = max(value, 0.0)
  cooldown_label.visible = cooldown > 0.0
  cooldown_label.text = '%.1f' % cooldown


# TODO gestion cooldown circulaire 

func _on_button_down():
  print('a')
