extends AnimatedSprite

var caster: Actor
var tech_data: ProjectileData

var is_disabled: bool = false
var normalized_direction: Vector2 = Vector2(0.0, 0.0)
var elapsed_time: float = 0


func die() -> void:
  is_disabled = true
  queue_free() 

func _on_body_entered(body):
  if is_disabled: 
    return
  if body != caster:
    if body is Actor:
      if body.team != caster.team and not body.is_dead:
        body.health -= 5.0
        caster.gain_xp(['atk_lvl'], 4)
        die()

func launch(_caster: Actor) -> void:
  caster = _caster
  # initialisation 
  frame = 0
#  playing = true
  
  
func _process(delta):
  elapsed_time += delta
  if elapsed_time >= tech_data.lifespan:
    die()
  if not is_disabled:
    global_position += normalized_direction * tech_data.velocity * delta
