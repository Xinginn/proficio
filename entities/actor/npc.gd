extends Actor

const building_scene: PackedScene = preload('res://entities/building/building.tscn')

const IA_DECISION_INTERVAL = 8.0

onready var buildings_holder = get_node('../BuildingsHolder')

var ia_clock = 0.0

func load_npc_model(model_name: String) -> void:

  var model = Data.npc_models[model_name]
  for attr_name in model["attributes"].keys():
    attributes[attr_name].level = model["attributes"][attr_name]
  self.sprite_path = model_name
  max_health = model["max_health"]
  max_mana = model["max_mana"]
  max_stamina = model["max_stamina"]
  move_speed = model["move_speed"]
  
func take_decision():
  ia_clock -= IA_DECISION_INTERVAL
#  if !!target_position:
#    print ('already doing something')
#    return
##  go_to_nearest_resource('herb')
  if has_resources(Data.buildings[0].resources):
    place_building(0)
  else:
    print('not enough')
   
func place_building(id):
  var cost = Data.buildings[id].resources
  for key in cost.keys():
    remove_resource(key, cost[key])
  var new_building = building_scene.instance()
  new_building.connect('occupied_space_overlapped', self, '_on_building_overlap' )
  new_building.connect('ended_spawning', self, '_on_spawning_ended')
  buildings_holder.add_child(new_building)
  var random_pos = get_random_building_position()
  new_building._initialize(self, Data.buildings[id], random_pos)
  new_building.is_spawning = true
  get_tree().get_root().get_node('Playground').connect_building(new_building)
  new_building.stackable_storage["herb"] = 15 # pour test

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

func _on_ready():
  ._on_ready()
  load_npc_model("chicken")
