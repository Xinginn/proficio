extends TextureRect

var queue_index

signal queue_button_cancel_pressed(index)

func _on_pressed():
  emit_signal('queue_button_cancel_pressed', queue_index)
