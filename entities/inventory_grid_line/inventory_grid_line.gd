extends TextureButton

signal line_clicked

func _on_pressed():
  emit_signal('line_clicked')
