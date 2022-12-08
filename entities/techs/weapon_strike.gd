extends AnimatedSprite

var caster: Actor
var tech_data: TechData

func _on_animation_finished():
  queue_free()

func _on_body_entered(body):
  if body != caster:
    if body is Actor:
      body.health -= 5.0
  
func launch(_caster: Actor) -> void:
  caster = _caster
  # initialisation 
  frame = 0
  playing = true
