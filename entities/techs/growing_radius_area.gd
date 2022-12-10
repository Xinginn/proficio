extends AnimatedSprite

onready var area_holder = $AreaHolder

var caster: Actor
var tech_data: SelfCenteredData

var scale_ratio = 1.0 setget _set_scale_ration

func _set_scale_ration(value) -> void:
  scale_ratio = value
  if scale_ratio <= 0.0:
    queue_free()
  area_holder.scale = Vector2(scale_ratio, scale_ratio)
  
func _on_animation_finished():
  queue_free()

func _on_body_entered(body):
  if body is Actor:
    if body != caster:
      body.health -= 5.0

func launch(_caster: Actor) -> void:
  scale *= tech_data.area_multiplier
  caster = _caster
  # initialisation 
  frame = 0
  playing = true

func _process(delta):
  self.scale_ratio += delta / 2.0
  
