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
  # paiement du coût, si n'est pas gratuit par lancement indirect (objet, ... ):
  if not is_free:
    caster.health -= tech_data.cost["health"]
    caster.stamina -= tech_data.cost["stamina"]
    caster.mana -= tech_data.cost["mana"]

  
