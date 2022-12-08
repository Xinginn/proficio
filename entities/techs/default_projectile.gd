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
      body.health -= 5.0
      die()

func launch(_caster: Actor, is_free: bool = false) -> void:
  caster = _caster
  # initialisation 
  frame = 0
  playing = true
  # paiement du coût, si n'est pas gratuit par lancement indirect (objet, ... ):
  if not is_free:
    caster.health -= tech_data.cost["health"]
    caster.stamina -= tech_data.cost["stamina"]
    caster.mana -= tech_data.cost["mana"]
  
  
func _process(delta):
  elapsed_time += delta
  if elapsed_time >= tech_data.lifespan:
    die()
  if not is_disabled:
    global_position += normalized_direction * tech_data.velocity * delta
