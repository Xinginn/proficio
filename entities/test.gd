extends Node2D

onready var spot_scene = preload('res://entities/resource_spot/pebbles_spot/pebble_spot.tscn')

var coordinates = [
  Vector2(72, 120),
  Vector2(34, 87),
  Vector2(310, 40),
  Vector2(176, 230),
  Vector2(389, 113),
 ]

func _ready():
  place_new_spot(coordinates[1])

func place_new_spot(coords: Vector2):
  var new_spot = spot_scene.instance()
  new_spot.connect('occupied_space_overlapped', self, '_on_resource_spot_overlap')
  new_spot.connect('ended_spawning', self, '_on_spawning_ended')
  
  add_child(new_spot)
  new_spot.is_spawning = true
  new_spot.position = coords
  
func _on_spawning_ended(spot):
  spot.disconnect('occupied_space_overlapped', self, '_on_resource_spot_overlap')
  spot.disconnect('ended_spawning', self, '_on_spawning_ended')

func _on_resource_spot_overlap(spot):
  spot.frames_since_no_overlap = 0
  var randX = GameManager.rng.randi_range(0,300)
  var randY = GameManager.rng.randi_range(0,300) 
  var vec = Vector2(randX, randY)
  spot.position = vec


