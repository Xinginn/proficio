extends AnimatedSprite

var caster: Actor
var tech_data: TechData

func _on_animation_finished():
  queue_free()

func _on_body_entered(body):
  if body != caster:
    if body is Actor:
      if body.team != caster.team and not body.is_dead:
        body.health -= 5.0
        caster.gain_xp(['atk_lvl'], 2)
  
func launch(_caster: Actor) -> void:
  caster = _caster
  # initialisation 
  rotation = 0 # doit toujours être vertical pour animation de hache
  frame = 0
  playing = true
