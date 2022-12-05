extends Node2D

const MIN_SPAWN_POS = 30
const MAX_SPAWN_POS = 482

onready var resources_holder: Node2D = $ResourcesHolder

var land_data: LandData

signal resource_placed

func _initialize(land_code: String):
	var path = "res://assets/lands/"
	land_data = Data.lands[int(land_code[0])]
	var orientation =int(land_code[1])
	path += land_data.land_name
	if orientation == 0:
		path += ".png"
	elif orientation % 2 == 0:
		path += "_border.png"
	else:
		path += "_corner.png"
	
	$Sprite.texture = load(path)

	# calcul rotation selon orientation
	if orientation > 0:
		$Sprite.rotation_degrees = ( (int((orientation +1) /2) * 90) % 360 ) - 90
	
	for _i in range(land_data.max_spots):
		add_resource_spot()
		yield(self, 'resource_placed')

func add_resource_spot():
	var random_int = GameManager.rng.randi_range(0, land_data.resources_lottery.size()-1)
	var resource_name: String = land_data.resources_lottery[random_int]
	var new_spot = load('res://entities/resource_spot/%s_spot/%s_spot.tscn' % [resource_name, resource_name]).instance()
	new_spot.connect('occupied_space_overlapped', self, '_on_resource_spot_overlap')
	new_spot.connect('ended_spawning', self, '_on_spawning_ended')
	resources_holder.add_child(new_spot)
	new_spot.position = get_random_spawn_position()
	new_spot.is_spawning = true
	
func get_random_spawn_position() -> Vector2:
	var randX = GameManager.rng.randi_range(MIN_SPAWN_POS, MAX_SPAWN_POS)
	var randY = GameManager.rng.randi_range(MIN_SPAWN_POS, MAX_SPAWN_POS) 
	return Vector2(randX, randY)

func _on_resource_spot_overlap(spot):
	spot.frames_since_no_overlap = 0
	spot.position = get_random_spawn_position()
	
func _on_spawning_ended(spot):
	spot.is_spawning = false
	spot.frames_since_no_overlap = 0
	spot.disconnect('occupied_space_overlapped', self, '_on_resource_spot_overlap')
	spot.disconnect('ended_spawning', self, '_on_spawning_ended')
	emit_signal('resource_placed')
