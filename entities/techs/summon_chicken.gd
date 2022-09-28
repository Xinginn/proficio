extends AnimatedSprite

var caster: Actor
var tech_data: SpotTargetedData

#func _on_animation_finished():
#  queue_free()

#func _on_body_entered(body):
#  if body is Actor:
#    body.health -= 2.0

func launch(_caster: Actor) -> void:
  scale *= tech_data.area_multiplier
  caster = _caster
  # initialisation 
  frame = 0
  playing = true
  # paiement du coût:
  caster.health -= tech_data.cost["health"]
  caster.stamina -= tech_data.cost["stamina"]
  caster.mana -= tech_data.cost["mana"]
  # create chicken
  var new_npc: Npc = load('res://entities/actor/npc.tscn').instance()
  get_tree().get_root().get_node('Playground/World').add_child(new_npc)
  new_npc.load_npc_model("chicken")
  new_npc.global_position = global_position
  
  queue_free()

  
