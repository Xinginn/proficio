extends TextureButton

var refine_data: RefineData

signal refine_button_pressed(data)


func _initialize(_data: RefineData):
  refine_data = _data
  print(_data)
  $Label.text = refine_data._name
  # TODO $InputIcon.texture = load('res://assets/icons/%s.png' % refine_data.outputs)

func _on_pressed():
  emit_signal("refine_button_pressed", refine_data)
