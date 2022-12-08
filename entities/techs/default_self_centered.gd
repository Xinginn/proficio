extends AnimatedSprite

var caster: Actor
var tech_data: SelfCenteredData

func _on_animation_finished():
  queue_free()

func _on_body_entered(body):
  if body is Actor:
    body.health += 5.0

func launch(_caster: Actor, is_free: bool = false) -> void:
  scale *= tech_data.area_multiplier
  caster = _caster
  # initialisation 
  frame = 0
  playing = true
