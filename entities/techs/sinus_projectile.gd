extends AnimatedSprite

var caster: Actor
var tech_data: ProjectileData

var is_disabled: bool = false
var normalized_direction: Vector2 = Vector2(0.0, 0.0)
var elapsed_time: float = 0

var sinus_vector = Vector2(0.0, 0.0)
var sinus_frequency = 15
var sinus_amplitude = 3

func die() -> void:
  is_disabled = true
  queue_free() 

func _on_body_entered(body):
  if is_disabled: 
    return
  if body != caster:
    if body is Actor:
      body.health -= 5.0
      die()

func launch(_caster: Actor) -> void:
  caster = _caster
  # initialisation 
  frame = 0
  playing = true
  
  
func _process(delta):
  elapsed_time += delta
  if elapsed_time >= tech_data.lifespan:
    die()
  if not is_disabled:
    sinus_vector.y = cos(elapsed_time * sinus_frequency) * sinus_amplitude
    
    global_position += (normalized_direction * tech_data.velocity * delta) + sinus_vector.rotated(rotation) # <- en radians
