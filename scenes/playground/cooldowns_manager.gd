extends HBoxContainer

const cooldown_display_scene: PackedScene = preload('res://entities/cooldown_display/cooldown_display.tscn')

var displays = []

func _on_tech_list_changed(techs):
  for child in get_children():
    child.queue_free()
  for tech in techs:
    print(tech._name)
    var new_display = cooldown_display_scene.instance()
    add_child(new_display)

func _on_player_cooldowns_changed(cooldowns):
  displays = get_children() # temp
  for key in cooldowns.size():
    displays[key].cooldown = cooldowns[key]

func ready():
  displays = get_children()
