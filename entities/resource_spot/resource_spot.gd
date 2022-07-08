extends Sprite

class_name ResourceSpot

var skill: String
var xp_gain: int
var duration: int
var remaining_harvests: int
# TODO changement de sprite selon harvest restantes
var required_tools: Array = []

# destiné à être surchargé
func harvest(harvester) -> void:
  harvester.gain_xp(skill, xp_gain)
  remaining_harvests -= 1
  if remaining_harvests == 0:
    queue_free()

func _on_body_entered(body):
  if body is Actor:
    body.stop_moving()
    if required_tools == [] || required_tools.has(body.inventory.gear['main_hand']._name):
      body.start_harvesting(self)

func _on_body_exited(body):
  if body is Actor:
    body.stop_harvesting()
