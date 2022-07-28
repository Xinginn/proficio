extends Actor

const building_scene: PackedScene = preload('res://entities/building/building.tscn')

const IA_DECISION_INTERVAL = 16.0

onready var buildings_holder = get_node('../BuildingsHolder')

var ia_clock = 15.0

func take_decision():
  ia_clock -= IA_DECISION_INTERVAL
  if !!target_position:
    print ('already doing something')
    return
#  go_to_nearest_resource('herb')
  place_building(0)
   
func place_building(id):
  var new_building = building_scene.instance()
  new_building.connect('occupied_space_overlapped', self, '_on_building_overlap' )
  new_building.connect('ended_spawning', self, '_on_spawning_ended')
  buildings_holder.add_child(new_building)
  var random_pos = get_random_building_position()
  new_building._initialize(self, Data.buildings[id], random_pos)
  new_building.is_spawning = true

func _on_building_overlap(building):
  building.frames_since_no_overlap = 0
  building.global_position = get_random_building_position()
  
func _on_spawning_ended(building):
  building.is_spawning = false
  building.frames_since_no_overlap = 0
  building.disconnect('occupied_space_overlapped', self, '_on_resource_spot_overlap')
  building.disconnect('ended_spawning', self, '_on_spawning_ended')
  move_to(building.global_position)

func get_random_building_position() -> Vector2:
  var randX = GameManager.rng.randi_range(-400, 400)
  var randY = GameManager.rng.randi_range(-400, 400) 
  return global_position + Vector2(randX, randY)

func _process(delta):
  ia_clock += delta
  if ia_clock >= IA_DECISION_INTERVAL:
    take_decision()


