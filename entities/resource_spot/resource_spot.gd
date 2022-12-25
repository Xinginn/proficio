extends Sprite

class_name ResourceSpot

onready var occupied_space = $OccupiedSpaceArea

# variables necessaires pour le physics_process afin de verifier les overlap au spawn
var is_spawning = false
var frames_since_no_overlap = 0

var stamina_loss_while_harvesting = 1.0
var skill: String
var xp_gain: int
var duration: float
var remaining_harvests: int
# TODO changement de sprite selon harvest restantes
var required_tools: Array = []

signal occupied_space_overlapped(spot)
signal ended_spawning(spot)

# destiné à être surchargé
func harvest(harvester) -> void:
  harvester.gain_xp([skill], xp_gain)
  remaining_harvests -= 1
  if remaining_harvests == 0:
    queue_free()

func _on_body_entered(body):
  if body is Actor:
    if body.is_dead:
      return
    body.stop_moving()
    if required_tools == [] || required_tools.has(body.inventory.gear['main_hand']._name):
      body.start_harvesting(self)

func _on_body_exited(body):
  if body is Actor:
    body.stop_harvesting()

func _ready():
  modulate = Color(1.0, 1.0, 1.0, 0.0)

# necessaire pour la gestion des overlap au spawn
# la methode get_overlapping_areas ne donne des résultats cohérents qu'après
# qu'une frame physique ait été calculée
func _physics_process(_delta):
  if !is_spawning:
    pass
  else:
    if occupied_space.get_overlapping_areas():
      emit_signal('occupied_space_overlapped', self)
    else:
      frames_since_no_overlap += 1
      if frames_since_no_overlap >= 3:
        modulate = Color(1.0, 1.0, 1.0, 1.0)
        emit_signal('ended_spawning', self)
  
