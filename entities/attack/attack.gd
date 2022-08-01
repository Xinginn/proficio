extends AnimatedSprite

var caster: Actor

func _on_animation_finished():
  queue_free()

func _on_body_entered(body):
  print("attack entered")
  
func launch(_caster: Actor) -> void:
  caster = _caster
  # initialisation 
  frame = 0
  playing = true
  
