extends AnimatedSprite

var caster: Actor
var tech_data: ProjectileData

var normalized_direction: Vector2
var elapsed_time: float = 0

 #func _on_animation_finished():
 #  queue_free()

#func _on_body_entered(body):
#  if body != caster:
#    if body is Actor:
#      body.health -= 5.0


func launch(_caster: Actor) -> void:
  caster = _caster
  # initialisation 
  frame = 0
  playing = true
  # paiement du coût:
  caster.health -= tech_data.cost["health"]
  caster.stamina -= tech_data.cost["stamina"]
  caster.mana -= tech_data.cost["mana"]
  
func _process(delta):
  global_position += normalized_direction * tech_data.velocity * delta
  elapsed_time += delta
  if elapsed_time >= tech_data.lifespan:
    queue_free()
  
