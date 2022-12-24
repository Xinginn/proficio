extends TextureButton

var tech_data: TechData # renseignée à null si le bouton sert à vider

signal available_tech_display_pressed(tech_data)

func initialize(_data):
  tech_data = _data
  if !!tech_data:
    var sprite_name = tech_data._name
    var sprite = load('res://assets/icons/tech_%s.png' % sprite_name)
    if !!sprite:
      texture_normal = sprite


func _on_pressed() -> void:
  emit_signal('available_tech_display_pressed', tech_data)

func _on_mouse_entered():
  if !!tech_data:
    print('should display tooltip for ', tech_data._name)

func _on_mouse_exited():
  if !!tech_data:
    print('should remove tooltip for ', tech_data._name)
