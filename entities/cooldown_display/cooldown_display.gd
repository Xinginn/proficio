extends TextureButton

onready var cooldown_label: Label = $Label

var cooldown: float = 0.0 setget _set_cooldown 
var index: int = 0
var sprite_name = ""
var is_hovered = false

signal hotkey_entered(i)
signal hotkey_exited(i)

signal hotkey_pressed(i)

func initialize(_index):
  index = _index
  var tech = GameManager.player_actor.techs[index]
  if !!tech:
    sprite_name = GameManager.player_actor.techs[index]._name
    var sprite = load('res://assets/icons/tech_%s.png' % sprite_name)
    if !!sprite:
      texture_normal = sprite

func _set_cooldown(value) -> void:
  cooldown = max(value, 0.0)
  cooldown_label.visible = cooldown > 0.0
  cooldown_label.text = '%.1f' % cooldown

func _on_pressed():
  emit_signal("hotkey_pressed", index)


# TODO gestion cooldown circulaire 


func _on_mouse_entered():
 emit_signal("hotkey_entered", index)

func _on_mouse_exited():
 emit_signal("hotkey_exited", index)
